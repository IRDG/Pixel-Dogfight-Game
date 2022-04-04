
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY DamageFsm IS
	
	GENERIC(
				DeadTimeSize : INTEGER := 7
			 );
	PORT	 (
				DamageIn    : IN  STD_LOGIC_VECTOR(             4 DOWNTO 0);
				DeadTimeLim : IN  STD_LOGIC_VECTOR(DeadTimeSize-1 DOWNTO 0);
				Reset       : IN  STD_LOGIC;
				Clk         : IN  STD_LOGIC;
				DamageOut   : OUT STD_LOGIC_VECTOR(             4 DOWNTO 0)
			 );
	
END ENTITY DamageFsm;

ARCHITECTURE DamageFsmArch OF DamageFsm IS

CONSTANT Zero : STD_LOGIC_VECTOR(DeadTimeSize-1 DOWNTO 0) := (Others => '0');

TYPE     StateType IS (EnableDmg,DisableDmg,Waiting);

SIGNAL   NextState    : StateType;
SIGNAL   PrevState    : StateType;
SIGNAL   DeadTimeOver : STD_LOGIC;
SIGNAL   EnaCount     : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

StateMemory: PROCESS (Reset, Clk)
BEGIN
	
	IF (Reset='1')THEN
		
		PrevState <= DisableDmg;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		PrevState <= NextState;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState,DeadTimeOver,DamageIn)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN DisableDmg =>
			
			DamageOut <= ("0"&"0000");
			EnaCount  <= '1';
			
			IF   (DeadTimeOver = '1')THEN
				
				NextState <= Waiting;
				
			ELSE
				
				NextState <= DisableDmg;
				
			END IF;
	----------------------------------------------------------
		WHEN Waiting =>
			
			DamageOut <= ("0"&"0000");
			EnaCount  <= '0';
			
			IF   (DamageIn /= ("0"&"0000"))THEN
				
				NextState <= EnableDmg;
				
			ELSE
				
				NextState <= Waiting;
				
			END IF;
	----------------------------------------------------------
		WHEN EnableDmg =>
			
			DamageOut <= DamageIn;
			EnaCount  <= '0';
			
			NextState <= DisableDmg;
			
	----------------------------------------------------------
	END CASE;
	
END PROCESS StateChange;

DeadTimeCounter: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => DeadTimeSize
			  )
PORT MAP	  (Data     => Zero,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => EnaCount,
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => DeadTimeLim,
				MaxCount => DeadTimeOver,
				MinCount => OPEN,
				Count    => OPEN
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.DamageFsm 
--GENERIC MAP(DeadTimeSize => #
--			  )
--PORT MAP	  (DamageIn    => SLV,
--				DeadTimeLim => SLV,
--				Reset       => SLV,
--				Clk         => SLV,
--				DamageOut   => SLV
--			  );
--******************************************************--

END DamageFsmArch;