
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

ENTITY ShipControl IS
	
	GENERIC(
				CounterSize: INTEGER := 7
			 );
	PORT	 (
				GoUp      : IN  STD_LOGIC;
				GoDown    : IN  STD_LOGIC;
				GoRight   : IN  STD_LOGIC;
				GoLeft    : IN  STD_LOGIC;
				ShipSpeed : IN  STD_LOGIC_VECTOR(CounterSize-1 DOWNTO 0);
				Reset     : IN  STD_LOGIC;
				Clk       : IN  STD_LOGIC;
				U         : OUT STD_LOGIC;
				D         : OUT STD_LOGIC;
				R         : OUT STD_LOGIC;
				L         : OUT STD_LOGIC
			 );
	
END ENTITY ShipControl;

ARCHITECTURE ShipControlArch OF ShipControl IS

CONSTANT ZeroCount   : STD_LOGIC_VECTOR(CounterSize-1 DOWNTO 0) := (OTHERS => '0');

TYPE     StateType IS (PosUp,PosDown,PosLeft,PosUpLeft,PosDownLeft,PosRight,PosUpRight,PosDownRight,HoldPosition);

SIGNAL   NextState   : StateType;
SIGNAL   PrevState   : StateType;

SIGNAL   GoUpSync    : STD_LOGIC;
SIGNAL   GoDownSync  : STD_LOGIC;
SIGNAL   GoRightSync : STD_LOGIC;
SIGNAL   GoLeftSync  : STD_LOGIC;

SIGNAL   SyncPulse   : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

GoUpSync    <= GoUp    AND SyncPulse;
GoDownSync  <= GoDown  AND SyncPulse;
GoRightSync <= GoRight AND SyncPulse;
GoLeftSync  <= GoLeft  AND SyncPulse;

StateMemory: PROCESS (Reset, Clk)
BEGIN
	
	IF (Reset='1')THEN
		
		PrevState <= HoldPosition;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		PrevState <= NextState;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState,GoUpSync,GoDownSync,GoRightSync,GoLeftSync)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN HoldPosition =>
			
			U <= '0';
			D <= '0';
			R <= '0';
			L <= '0';
			
			IF   ((GoUpSync = '1')   AND (GoRightSync = '1'))THEN
				
				NextState <= PosUpRight;
				
			ELSIF((GoUpSync = '1')   AND (GoLeftSync  = '1'))THEN
				
				NextState <= PosUpLeft;
				
			ELSIF((GoDownSync = '1') AND (GoRightSync = '1'))THEN
				
				NextState <= PosDownRight;
				
			ELSIF((GoDownSync = '1') AND (GoLeftSync  = '1'))THEN
				
				NextState <= PosDownLeft;
				
			ELSIF(GoUpSync    = '1')THEN
				
				NextState <= PosUp;
				
			ELSIF(GoDownSync  = '1')THEN
				
				NextState <= PosDown;
				
			ELSIF(GoRightSync = '1')THEN
				
				NextState <= PosRight;
				
			ELSIF(GoLeftSync  = '1')THEN
				
				NextState <= PosLeft;
				
			ELSE
				
				NextState <= HoldPosition;
				
			END IF;
	----------------------------------------------------------
		WHEN PosUp =>
			
			U <= '1';
			D <= '0';
			R <= '0';
			L <= '0';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosDown =>
			
			U <= '0';
			D <= '1';
			R <= '0';
			L <= '0';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosRight =>
			
			U <= '0';
			D <= '0';
			R <= '1';
			L <= '0';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosLeft =>
			
			U <= '0';
			D <= '0';
			R <= '0';
			L <= '1';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosUpLeft =>
			
			U <= '1';
			D <= '0';
			R <= '0';
			L <= '1';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosDownLeft =>
			
			U <= '0';
			D <= '1';
			R <= '0';
			L <= '1';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosUpRight =>
			
			U <= '1';
			D <= '0';
			R <= '1';
			L <= '0';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
		WHEN PosDownRight =>
			
			U <= '0';
			D <= '1';
			R <= '1';
			L <= '0';
			
			NextState <= HoldPosition;
			
	----------------------------------------------------------
	END CASE;
	
END PROCESS StateChange;

SyncCounter: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => CounterSize
			  )
PORT MAP	  (Data     => ZeroCount,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => '1',
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => ShipSpeed,
				MaxCount => SyncPulse,
				MinCount => OPEN,
				Count    => OPEN
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.ShipControl 
--GENERIC MAP(CounterSize => #
--			  )
--PORT MAP	  (GoUp      => SLV,
--				GoDown    => SLV,
--				GoRight   => SLV,
--				GoLeft    => SLV,
--				ShipSpeed => SLV,
--				Reset     => SLV,
--				Clk       => SLV,
--				U         => SLV,
--				D         => SLV,
--				R         => SLV,
--				L         => SLV
--			  );
--******************************************************--

END ShipControlArch;