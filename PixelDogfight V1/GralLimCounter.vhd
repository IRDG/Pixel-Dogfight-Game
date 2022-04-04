
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:2019                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY GralLimCounter IS
	
	GENERIC(
				Size: INTEGER := 8
			 );
	PORT	 (
				Data     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Clk      : IN  STD_LOGIC;
				MR       : IN  STD_LOGIC;
				SR       : IN  STD_LOGIC;
				Ena      : IN  STD_LOGIC;
				PLoad    : IN  STD_LOGIC;
				Up       : IN  STD_LOGIC;
				Dwn      : IN  STD_LOGIC;
				Limit    : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				MaxCount : OUT STD_LOGIC;
				MinCount : OUT STD_LOGIC;
				Count    : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
			 );
	
END ENTITY GralLimCounter;

ARCHITECTURE GralLimCounterArch OF GralLimCounter IS

CONSTANT Ones     : UNSIGNED (Size-1 DOWNTO 0) := (OTHERS=>'1');
CONSTANT Zeros    : UNSIGNED (Size-1 DOWNTO 0) := (OTHERS=>'0');

SIGNAL CountS     : UNSIGNED (Size-1 DOWNTO 0);
SIGNAL CountNext  : UNSIGNED (Size-1 DOWNTO 0);
SIGNAL MaxReached : STD_LOGIC;

SIGNAL NoChng     : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

NoChng     <= Up AND Dwn;
MaxReached <= '1' WHEN Limit = STD_LOGIC_VECTOR(CountS) ELSE '0'; 

CountNext <= (OTHERS=>'0')   WHEN (SR                   = '1') ELSE
				 (OTHERS=>'0')   WHEN (MaxReached           = '1') ELSE
				  UNSIGNED(Data) WHEN (PLoad                = '1') ELSE
				  CountS+1       WHEN (Ena = '1' AND Up     = '1') ELSE
				  CountS-1       WHEN (Ena = '1' AND Dwn    = '1') ELSE
				  CountS         WHEN (Ena = '1' AND NoChng = '1') ELSE
				  CountS;

Counting:Process(Clk,MR)

Variable Temp : UNSIGNED (Size-1 DOWNTO 0);

BEGIN

IF(MR='1') THEN

	Temp := (OTHERS=>'0');
	
ELSIF (rising_edge(Clk)) THEN
	
	IF(Ena='1')THEN
		
		Temp:= CountNext;
		
	END IF;
	
END IF;

Count  <= STD_LOGIC_VECTOR(Temp);
CountS <= Temp;

END PROCESS Counting;

MaxCount <= '1' WHEN CountS=UNSIGNED(Limit) ELSE '0';
MinCount <= '1' WHEN CountS=Zeros ELSE '0';

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.GralLimCounter 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Data     => SLV,
--				Clk      => SLV,
--				MR       => SLV,
--				SR       => SLV,
--				Ena      => SLV,
--				Pload    => SLV,
--				Up       => SLV,
--				Dwn      => SLV,
--				Limit    => SLV,
--				MaxCount => SLV,
--				MinCount => SLV,
--				Count    => SLV
--			  );
--******************************************************--

END GralLimCounterArch;