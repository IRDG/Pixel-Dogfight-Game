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
-- Entradas
-- 
-- 
--******************************************************--

ENTITY SequenceDetector IS
	
	PORT	 (
				SerialData   : IN  STD_LOGIC;
				SerialEnable : IN  STD_LOGIC;
				Sequence     : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				Enable       : IN  STD_LOGIC;
				Reset        : IN  STD_LOGIC;
				Clk          : IN  STD_LOGIC;
				Result       : OUT STD_LOGIC
			 );
	
END ENTITY SequenceDetector;

ARCHITECTURE SequenceDetectorArch OF SequenceDetector IS

TYPE StateType IS (one,two,three,four,five,six);

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
		
		PrevState <= one;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		IF(Enable = '1')THEN
			
			PrevState <= NextState;
			
		END IF;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState,SerialData,Sequence,SerialEnable)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN One =>
			
			Result <= '0';
			
			IF (((SerialData XNOR Sequence(0)) AND SerialEnable) = '1')THEN
				
				NextState <= Two;
				
			ELSIF(((SerialData XOR Sequence(0)) AND SerialEnable) = '1')THEN
				
				NextState <= One;
				
			ELSE
				
				NextState <= One;
				
			END IF;
	----------------------------------------------------------
		WHEN Two =>
			
			Result <= '0';
			
			IF (((SerialData XNOR Sequence(1)) AND SerialEnable) = '1')THEN
				
				NextState <= Three;
				
			ELSIF(((SerialData XOR Sequence(1)) AND SerialEnable) = '1')THEN
				
				NextState <= One;
				
			ELSE
				
				NextState <= Two;
				
			END IF;
	----------------------------------------------------------
		WHEN Three =>
			
			Result <= '0';
			
			IF (((SerialData XNOR Sequence(2)) AND SerialEnable) = '1')THEN
				
				NextState <= Four;
				
			ELSIF(((SerialData XOR Sequence(2)) AND SerialEnable) = '1')THEN
				
				NextState <= One;
				
			ELSE
				
				NextState <= Three;
				
			END IF;
	----------------------------------------------------------
		WHEN Four =>
			
			Result <= '0';
			
			IF (((SerialData XNOR Sequence(3)) AND SerialEnable) = '1')THEN
				
				NextState <= Five;
				
			ELSIF(((SerialData XOR Sequence(3)) AND SerialEnable) = '1')THEN
				
				NextState <= One;
				
			ELSE
				
				NextState <= Four;
				
			END IF;
	----------------------------------------------------------
		WHEN Five =>
			
			Result <= '0';
			
			IF (((SerialData XNOR Sequence(4)) AND SerialEnable) = '1')THEN
				
				NextState <= Six;
				
			ELSIF(((SerialData XOR Sequence(4)) AND SerialEnable) = '1')THEN
				
				NextState <= One;
				
			ELSE
				
				NextState <= Five;
				
			END IF;
	----------------------------------------------------------
		WHEN Six =>
			
			Result <= '1';
			
			NextState <= One;
			
	----------------------------------------------------------
	END CASE;
	
END PROCESS StateChange;


--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SequenceDetector 
--PORT MAP	  (SerialData   => SLV,
--				SerialEnable => SLV,
--				Sequence     => SLV,
--				Enable       => SLV,
--				Reset        => SLV,
--				Clk          => SLV,
--				Result       => SLV
--			  );
--******************************************************--

END SequenceDetectorArch;