--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.ALL;

USE WORK.MyGamePackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY ScoreAndHitPoints IS
	
	GENERIC(
				ShieldSize : INTEGER := 7
			 );
	
	PORT	 (
				BasicDmgP1 : IN  STD_LOGIC_VECTOR(             3 DOWNTO 0);
				BasicDmgP2 : IN  STD_LOGIC_VECTOR(             3 DOWNTO 0);
				HullP1     : IN  STD_LOGIC_VECTOR(HullSize   - 1 DOWNTO 0);
				HullP2     : IN  STD_LOGIC_VECTOR(HullSize   - 1 DOWNTO 0);
				CritHitP1  : IN  STD_LOGIC_VECTOR(             1 DOWNTO 0);
				CritHitP2  : IN  STD_LOGIC_VECTOR(             1 DOWNTO 0);
				ShieldP1   : IN  STD_LOGIC_VECTOR(ShieldSize - 1 DOWNTO 0);
				ShieldP2   : IN  STD_LOGIC_VECTOR(ShieldSize - 1 DOWNTO 0);
				MaxPoints  : IN  STD_LOGIC_VECTOR(             3 DOWNTO 0);
				Reset      : IN  STD_LOGIC;
				Clk        : IN  STD_LOGIC;
				ScoreAndHP : OUT DecimalValue;
				GameReset  : OUT STD_LOGIC;
				Winner     : OUT STD_LOGIC_VECTOR(             1 DOWNTO 0)
			 );
	
END ENTITY ScoreAndHitPoints;

ARCHITECTURE ScoreAndHitPointsArch OF ScoreAndHitPoints IS

CONSTANT DeadTimeSize : INTEGER                                     :=  1; 
CONSTANT DeadTimeLim  : STD_LOGIC_VECTOR(DeadTimeSize - 1 DOWNTO 0) := (OTHERS => '1');
CONSTANT ZeroHull     : STD_LOGIC_VECTOR(HullSize     - 1 DOWNTO 0) := (OTHERS => '0');
CONSTANT ZeroShield   : STD_LOGIC_VECTOR(ShieldSize   - 1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   GameRst      : STD_LOGIC;
SIGNAL   GameRstEcho  : STD_LOGIC;

--******************************************************--
-- 
-- Declaration of Signals usad to calculate damage  and score for P1
-- 
--******************************************************--

SIGNAL EnableCritP1  : STD_LOGIC_VECTOR(           2 DOWNTO 0);
SIGNAL RealHardDmgP1 : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL RealSoftDmgP1 : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL RealCritDmgP1 : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL RealDmgP1     : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL DamageInP1    : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL PrevDmgP1     : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL NextDmgP1     : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL NextTempDmgP1 : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL RealHpP1      : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL P1GameOver    : STD_LOGIC;
SIGNAL HpDecmalP1    : STD_LOGIC_VECTOR(          11 DOWNTO 0);
SIGNAL HealP1        : STD_LOGIC_VECTOR(           0 DOWNTO 0);
SIGNAL RealHealP1    : STD_LOGIC_VECTOR(           0 DOWNTO 0);

--******************************************************--
-- 
-- Declaration of Signals usad to calculate damage  and score for P2
-- 
--******************************************************--

SIGNAL EnableCritP2  : STD_LOGIC_VECTOR(           2 DOWNTO 0);
SIGNAL RealHardDmgP2 : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL RealSoftDmgP2 : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL RealCritDmgP2 : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL RealDmgP2     : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL DamageInP2    : STD_LOGIC_VECTOR(           4 DOWNTO 0);
SIGNAL PrevDmgP2     : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL NextDmgP2     : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL NextTempDmgP2 : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL RealHpP2      : STD_LOGIC_VECTOR(HullSize - 1 DOWNTO 0);
SIGNAL P2GameOver    : STD_LOGIC;
SIGNAL HpDecmalP2    : STD_LOGIC_VECTOR(          11 DOWNTO 0);
SIGNAL HealP2        : STD_LOGIC_VECTOR(           0 DOWNTO 0);
SIGNAL RealHealP2    : STD_LOGIC_VECTOR(           0 DOWNTO 0);




SIGNAL GameOver      : STD_LOGIC_VECTOR(           1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 1 HardDmg (3 ... 2) Do  6 Dmg 
-- 
-- 1 SoftDmg (1 ... 0) Do  3 Dmg
-- 
-- 1 CritHit           Do  2 Dmg
-- 
-- 2 CritHit           Do  4 Dmg
-- 
-- 3 CritHit           Do  7 Dmg
-- 
--******************************************************--

--******************************************************--
-- 
-- Create Hard and Soft Damage Values, Enable or disable Crit
-- for player 1
-- 
-- Synthesize That info on RealDmgP1
-- 
--******************************************************--

EnableCritP1 <= (BasicDmgP1(3) OR BasicDmgP1(2) OR 
				     BasicDmgP1(1) OR BasicDmgP1(0)) & CritHitP1;

WITH BasicDmgP1(3 DOWNTO 2) SELECT
RealHardDmgP1 <= ("0"&"0000") WHEN "00",    -- DmgDealt :  0
					  ("0"&"0110") WHEN "01",    -- DmgDealt :  6
					  ("0"&"1100") WHEN "10",    -- DmgDealt : 12
					  ("1"&"0010") WHEN "11",    -- DmgDealt : 18
					  ("0"&"0000") WHEN OTHERS;  -- DmgDealt :  0

WITH BasicDmgP1(1 DOWNTO 0) SELECT
RealSoftDmgP1 <= ("0"&"0000") WHEN "00",    -- DmgDealt :  0
					  ("0"&"0011") WHEN "01",    -- DmgDealt :  2
					  ("0"&"0110") WHEN "10",    -- DmgDealt :  4
					  ("0"&"1001") WHEN "11",    -- DmgDealt :  6
					  ("0"&"0000") WHEN OTHERS;  -- DmgDealt :  0

WITH EnableCritP1         SELECT
RealCritDmgP1 <= ("0"&"0000") WHEN "000",   -- DmgDealt :  0
					  ("0"&"0010") WHEN "101",   -- DmgDealt :  2
					  ("0"&"0100") WHEN "110",   -- DmgDealt :  4
					  ("0"&"0111") WHEN "111",   -- DmgDealt :  7
					  ("0"&"0000") WHEN OTHERS;  -- DmgDealt :  0

RealDmgP1     <= Int2StdVector(StdVector2Int(RealCritDmgP1) +
										 StdVector2Int(RealSoftDmgP1) +
										 StdVector2Int(RealHardDmgP1),5);

--******************************************************--
-- 
-- Clean the DamageValue using a dead time and a FSM 
-- 
-- This is done because we do not have any information
-- about the signal timing got from the bullets Block
-- 
--******************************************************--

DmgDeadTimeP1: ENTITY WORK.DamageFsm 
GENERIC MAP(DeadTimeSize => DeadTimeSize
			  )
PORT MAP	  (DamageIn    => RealDmgP1,
				DeadTimeLim => DeadTimeLim,
				Reset       => Reset,
				Clk         => Clk,
				DamageOut   => DamageInP1
			  );

--******************************************************--
-- 
-- Calculate the damage dealt to the ship 1
-- 
-- This process also take into account the healing 
-- done by the shield system
-- 
--******************************************************--

NextTempDmgP1 <= Int2StdVector(StdVector2Int(PrevDmgP1 ) -
										 StdVector2Int(RealHealP1) +
								       StdVector2Int(DamageInP1),HullSize);

RealHpP1      <= Int2StdVector(StdVector2Int(HullP1    ) -
								       StdVector2Int(PrevDmgP1 ),HullSize);

--******************************************************--
-- 
-- Validate Game Over For player 1 and if the shield is 
-- active
-- 
-- Reset or enable Hull values
-- 
--******************************************************--

RealHealP1 <= HealP1 WHEN PrevDmgP1 >  ZeroHull ELSE 
		        "0";

P1GameOver <= '1' WHEN PrevDmgP1 >= HullP1   ELSE 
		        '0';

WITH GameOver SELECT
NextDmgP1 <= ZeroHull      WHEN "11",
				 ZeroHull      WHEN "10",
				 ZeroHull      WHEN "01",
				 NextTempDmgP1 WHEN OTHERS;

--******************************************************--
-- 
-- Old system used to make the binary2Bcd conversion
-- 
-- The result is sent to the Vga pixel generate
-- 
--******************************************************--

BcdHpP1: ENTITY WORK.SysBinaryToBcd 
GENERIC MAP(Size  => HullSize,
			   NoDw  => 3,
				Inter => 3
			  )
PORT MAP	  (Number => RealHpP1,
				Digits => HpDecmalP1
			  );

ScoreAndHP.HpP1 <= ((HpDecmalP1( 3 DOWNTO 0)),
						  (HpDecmalP1( 7 DOWNTO 4)),
						  (HpDecmalP1(11 DOWNTO 8)));

--******************************************************--
-- 
-- Counters used to get the player 1 Score and Shield 
-- 
-- The Score is increased when the 2nd Ship is destroyed
-- 
-- The Shield gives a 1 every X time determinated by the
-- shield value (Value * 20ns) 
-- 
--******************************************************--

ScorePlayer1: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => 4
			  )
PORT MAP	  (Data     => "0000",
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => P1GameOver,
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => MaxPoints,
				MaxCount => OPEN,
				MinCount => OPEN,
				Count    => ScoreAndHP.ScoreP1
			  );

ShieldPlayer1: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => ShieldSize
			  )
PORT MAP	  (Data     => ZeroShield,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => '1',
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => ShieldP1,
				MaxCount => HealP1(0),
				MinCount => OPEN,
				Count    => OPEN
			  );

--******************************************************--
-- 
-- Create Hard and Soft Damage Values, Enable or disable Crit
-- for player 2
-- 
-- Synthesize That info on RealDmgP1
-- 
--******************************************************--

EnableCritP2 <= (BasicDmgP2(3) OR BasicDmgP2(2) OR 
				     BasicDmgP2(1) OR BasicDmgP2(0)) & CritHitP2;

WITH BasicDmgP2(3 DOWNTO 2) SELECT
RealHardDmgP2 <= ("0"&"0000") WHEN "00",    -- DmgDealt :  0
					  ("0"&"0110") WHEN "01",    -- DmgDealt :  6
					  ("0"&"1100") WHEN "10",    -- DmgDealt : 12
					  ("1"&"0010") WHEN "11",    -- DmgDealt : 18
					  ("0"&"0000") WHEN OTHERS;  -- DmgDealt :  0

WITH BasicDmgP2(1 DOWNTO 0) SELECT
RealSoftDmgP2 <= ("0"&"0000") WHEN "00",    -- DmgDealt :  0
					  ("0"&"0011") WHEN "01",    -- DmgDealt :  2
					  ("0"&"0110") WHEN "10",    -- DmgDealt :  4
					  ("0"&"1001") WHEN "11",    -- DmgDealt :  6
					  ("0"&"0000") WHEN OTHERS;  -- DmgDealt :  0

WITH EnableCritP2           SELECT
RealCritDmgP2 <= ("0"&"0000") WHEN "000",   -- DmgDealt :  0
					  ("0"&"0010") WHEN "101",   -- DmgDealt :  2
					  ("0"&"0100") WHEN "110",   -- DmgDealt :  4
					  ("0"&"0111") WHEN "111",   -- DmgDealt :  7
					  ("0"&"0000") WHEN OTHERS;  -- DmgDealt :  0

RealDmgP2     <= Int2StdVector(StdVector2Int(RealCritDmgP2) +
										 StdVector2Int(RealSoftDmgP2) +
										 StdVector2Int(RealHardDmgP2),5);

--******************************************************--
-- 
-- Clean the DamageValue using a dead time and a FSM 
-- 
-- This is done because we do not have any information
-- about the signal timing got from the bullets Block
-- 
--******************************************************--

DmgDeadTimeP2: ENTITY WORK.DamageFsm 
GENERIC MAP(DeadTimeSize => DeadTimeSize
			  )
PORT MAP	  (DamageIn    => RealDmgP2,
				DeadTimeLim => DeadTimeLim,
				Reset       => Reset,
				Clk         => Clk,
				DamageOut   => DamageInP2
			  );

--******************************************************--
-- 
-- Calculate the damage dealt to the ship 2
-- 
-- This process also take into account the healing 
-- done by the shield system
-- 
--******************************************************--

NextTempDmgP2 <= Int2StdVector(StdVector2Int(PrevDmgP2 ) -
										 StdVector2Int(RealHealP2) +
								       StdVector2Int(DamageInP2),HullSize);

RealHpP2      <= Int2StdVector(StdVector2Int(HullP2    ) -
								       StdVector2Int(PrevDmgP2 ),HullSize);

--******************************************************--
-- 
-- Validate Game Over For player 2 and if the shield is 
-- active
-- 
-- Reset or enable Hull values
-- 
--******************************************************--

RealHealP2 <= HealP2 WHEN PrevDmgP2 >  ZeroHull ELSE 
		        "0";

P2GameOver <= '1' WHEN PrevDmgP2 >= HullP2   ELSE 
		        '0';

WITH GameOver SELECT
NextDmgP2 <= ZeroHull      WHEN "11",
				 ZeroHull      WHEN "10",
				 ZeroHull      WHEN "01",
				 NextTempDmgP2 WHEN OTHERS;

--******************************************************--
-- 
-- Old system used to make the binary2Bcd conversion
-- 
-- The result is sent to the Vga pixel generate
-- 
--******************************************************--

BcdHpP2: ENTITY WORK.SysBinaryToBcd 
GENERIC MAP(Size  => HullSize,
			   NoDw  => 3,
				Inter => 3
			  )
PORT MAP	  (Number => RealHpP2,
				Digits => HpDecmalP2
			  );

ScoreAndHP.HpP2 <= ((HpDecmalP2( 3 DOWNTO 0)),
						  (HpDecmalP2( 7 DOWNTO 4)),
						  (HpDecmalP2(11 DOWNTO 8)));

--******************************************************--
-- 
-- Counters used to get the player 2 Score and Shield 
-- 
-- The Score is increased when the 1st Ship is destroyed
-- 
-- The Shield gives a 1 every X time determinated by the
-- shield value (Value * 20ns) 
-- 
--******************************************************--

ScorePlayer2: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => 4
			  )
PORT MAP	  (Data     => "0000",
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => P2GameOver,
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => MaxPoints,
				MaxCount => OPEN,
				MinCount => OPEN,
				Count    => ScoreAndHP.ScoreP2
			  );

ShieldPlayer2: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => ShieldSize
			  )
PORT MAP	  (Data     => ZeroShield,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => '1',
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => ShieldP2,
				MaxCount => HealP2(0),
				MinCount => OPEN,
				Count    => OPEN
			  );

--******************************************************--
-- 
-- Memory used to store the damage dealt to each ship and
-- have a clean GameReset Signal
-- 
-- Some Signals concerning the game reset and winner are
-- set here
-- 
--******************************************************--

GameOver  <= P2GameOver  & P1GameOver;
GameRst   <= P2GameOver OR P1GameOver;
GameReset <= GameRstEcho;

Winner    <= GameOver;

PROCESS(Clk, Reset, NextDmgP1)

BEGIN
	
	IF(Reset='1')THEN
		
		PrevDmgP1   <= ZeroHull;
		PrevDmgP2   <= ZeroHull;
		GameRstEcho <= '0';
		
	ELSIF(Falling_Edge(Clk))THEN
		
		PrevDmgP1   <= NextDmgP1;
		PrevDmgP2   <= NextDmgP2;
		GameRstEcho <= GameRst;
		
	END IF;
	
END PROCESS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.ScoreAndHitPoints 
--GENERIC MAP(ShieldSize => #
--			  )
--PORT MAP	  (BasicDmgP1 => SLV,
--				BasicDmgP2 => SLV,
--				HullP1     => SLV,
--				HullP2     => SLV,
--				CritHitP1  => SLV,
--				CritHitP2  => SLV,
--				ShieldP1   => SLV,
--				ShieldP2   => SLV,
--				MaxPoints  => SLV,
--				Reset      => SLV,
--				Clk        => SLV,
--				ScoreAndHP => SLV,
--				GameReset  => SLV,
--				Winner     => SLV
--			  );
--******************************************************--

END ScoreAndHitPointsArch;