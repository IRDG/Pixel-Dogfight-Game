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
USE IEEE.numeric_std.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY Debouncer IS
	
	PORT	 (
				SerialData : IN  STD_LOGIC;
				Clk        : IN  STD_LOGIC;
				Reset      : IN  STD_LOGIC;
				PulseOnes  : OUT STD_LOGIC;
				Pulse      : OUT STD_LOGIC
			 );
	
END ENTITY Debouncer;

ARCHITECTURE DebouncerArch OF Debouncer IS

TYPE     StateType IS(One,Zero,PulseOut,PulseHigh);

CONSTANT SoC1          : INTEGER := 17   - 1;
CONSTANT SoC2          : INTEGER := SoC1 - 2;

CONSTANT Max10ms       : STD_LOGIC_VECTOR(SoC1 DOWNTO 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(100000,SoC1 + 1));
CONSTANT Max5ms        : STD_LOGIC_VECTOR(SoC2 DOWNTO 0) := STD_LOGIC_VECTOR(TO_UNSIGNED( 50000,SoC2 + 1));
CONSTANT Zeros20ms     : STD_LOGIC_VECTOR(SoC1 DOWNTO 0) := (OTHERS => '0');
CONSTANT Zeros5ms      : STD_LOGIC_VECTOR(SoC2 DOWNTO 0) := (OTHERS => '0');


SIGNAL   MaxCount10ms  : STD_LOGIC;
SIGNAL   MaxCount5ms   : STD_LOGIC;
SIGNAL   ZerosOk       : STD_LOGIC;
SIGNAL   OnesOk        : STD_LOGIC;

SIGNAL   NextState     : StateType;
SIGNAL   PrevState     : StateType;

SIGNAL   EnableZero    : STD_LOGIC;
SIGNAL   EnableOne     : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

StateMemory: PROCESS (Reset, Clk)
BEGIN
	
	IF (Reset='1')THEN
		
		PrevState <= One;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		PrevState <= NextState;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState,ZerosOk,OnesOk)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN One =>
			
			Pulse      <= '0';
			EnableOne  <= '1';
			EnableZero <= '0';
			PulseOnes  <= '0';
			
			IF (OnesOk = '1')THEN
				
				NextState <= PulseHigh;
				
			ELSE
				
				NextState <= One;
				
			END IF;
	----------------------------------------------------------
	WHEN PulseHigh =>
			
			Pulse      <= '0';
			EnableOne  <= '0';
			EnableZero <= '0';
			PulseOnes  <= '1';
			
			NextState <= Zero;
			
	----------------------------------------------------------
		WHEN Zero =>
			
			Pulse      <= '0';
			EnableOne  <= '0';
			EnableZero <= '1';
			PulseOnes  <= '0';
			
			IF (ZerosOk = '1')THEN
				
				NextState <= PulseOut;
				
			ELSE
				
				NextState <= Zero;
				
			END IF;
	----------------------------------------------------------
	WHEN PulseOut =>
			
			Pulse      <= '1';
			EnableOne  <= '0';
			EnableZero <= '0';
			PulseOnes  <= '0';
			
			NextState <= One;
			
	----------------------------------------------------------
	END CASE;
	
END PROCESS StateChange;

ZerosD: ENTITY WORK.SequenceDetector 
PORT MAP	  (SerialData   => SerialData,
				SerialEnable => MaxCount5ms,
				Sequence     => "00000",
				Enable       => EnableZero,
				Reset        => Reset,
				Clk          => Clk,
				Result       => ZerosOk
			  );

OnesD: ENTITY WORK.SequenceDetector 
PORT MAP	  (SerialData   => SerialData,
				SerialEnable => MaxCount10ms,
				Sequence     => "11111",
				Enable       => EnableOne,
				Reset        => Reset,
				Clk          => Clk,
				Result       => OnesOk
			  );

Counter10ms: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => SoC1+1
			  )
PORT MAP	  (Data     => Zeros20ms,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => EnableOne,
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => Max10ms,
				MaxCount => MaxCount10ms,
				MinCount => OPEN,
				Count    => OPEN
			  );

Counter5ms: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => SoC2+1
			  )
PORT MAP	  (Data     => Zeros5ms,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => EnableZero,
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => Max5ms,
				MaxCount => MaxCount5ms,
				MinCount => OPEN,
				Count    => OPEN
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Debouncer 
--PORT MAP	  (SerialData => SLV,
--				Reset      => SLV,
--				Clk        => SLV,
--				PulseOnes  => SLV,
--				Pulse      => SLV
--			  );
--******************************************************--

END DebouncerArch;