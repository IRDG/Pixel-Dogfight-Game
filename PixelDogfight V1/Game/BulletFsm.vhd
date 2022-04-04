
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
-- Un gato realizo esta maquina ~ Att copito :3
-- 
--******************************************************--

ENTITY BulletFsm IS
	
	PORT	 (
				Pulse      : IN  STD_LOGIC;
				EnableMove : IN  STD_LOGIC;
				Collision  : IN  STD_LOGIC;
				Reset      : IN  STD_LOGIC;
				Clk        : IN  STD_LOGIC;
				Standby    : OUT STD_LOGIC;
				Move       : OUT STD_LOGIC;
				Waiting    : OUT STD_LOGIC;
				Disabling  : OUT STD_LOGIC
			 );
	
END ENTITY BulletFsm;

ARCHITECTURE BulletFsmArch OF BulletFsm IS

TYPE StateType IS (StandbyS, MoveS, WaitingS, DisablingS);

SIGNAL NextState : StateType;
SIGNAL PrevState : StateType;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

StateMemory: PROCESS (Reset, Clk)
BEGIN
	
	IF (Reset='1')THEN
		
		PrevState <= DisablingS;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		PrevState <= NextState;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState,EnableMove,Collision,Pulse)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN StandbyS =>
			
			Standby   <= '1';
			Move      <= '0';
			Waiting   <= '0';
			Disabling <= '0';
			
			IF   (EnableMove = '1')THEN
				
				NextState <= MoveS;
				
			ELSIF(Collision = '1')THEN
				
				NextState <= DisablingS;
				
			ELSE
				
				NextState <= StandbyS;
				
			END IF;
			
	----------------------------------------------------------
		WHEN MoveS =>
			
			Standby   <= '0';
			Move      <= '1';
			Waiting   <= '0';
			Disabling <= '0';
			
			IF (Collision = '1')THEN
				
				NextState <= DisablingS;
				
			ELSE
				
				NextState <= WaitingS;
				
			END IF;
	----------------------------------------------------------
		WHEN WaitingS =>
			
			Standby   <= '0';
			Move      <= '0';
			Waiting   <= '1';
			Disabling <= '0';
			
			IF   (Collision = '1')THEN
				
				NextState <= DisablingS;
				
			ELSIF(EnableMove = '1')THEN
				
				NextState <= MoveS;
				
			ELSE
				
				NextState <= WaitingS;
				
			END IF;
	----------------------------------------------------------
		WHEN DisablingS =>
			
			Standby   <= '0';
			Move      <= '0';
			Waiting   <= '0';
			Disabling <= '1';
			
			IF (Pulse = '1')THEN
				
				NextState <= StandbyS;
				
			ELSE
				
				NextState <= DisablingS;
				
			END IF;
	----------------------------------------------------------
	END CASE;
	
END PROCESS StateChange;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.BulletFsm 
--PORT MAP	  (Pulse      => SLV,
--				EnableMove => SLV,
--				Collision  => SLV,
--				Reset      => SLV,
--				Clk        => SLV,
--				Standby    => SLV,
--				Move       => SLV,
--				Waiting    => SLV,
--				Disabling  => SLV
--			  );
--******************************************************--

END BulletFsmArch;