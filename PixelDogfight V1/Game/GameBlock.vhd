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
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.ALL;

USE WORK.MyGamePackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY GameBlock IS
	
	GENERIC(
				ShipCounterSize : INTEGER := 20;
				BlltCounterSize : INTEGER := 18;
				ShieldSize      : INTEGER := 28
			 );
	PORT	 (
				GoUp1      : IN  STD_LOGIC;
				GoDown1    : IN  STD_LOGIC;
				GoLeft1    : IN  STD_LOGIC;
				GoRight1   : IN  STD_LOGIC;
				GoUp2      : IN  STD_LOGIC;
				GoDown2    : IN  STD_LOGIC;
				GoLeft2    : IN  STD_LOGIC;
				GoRight2   : IN  STD_LOGIC;
				Player1P   : IN  STD_LOGIC;
				Player2P   : IN  STD_LOGIC;
				Ship1Spd   : IN  STD_LOGIC_VECTOR(ShipCounterSize-1 DOWNTO 0);
				Ship2Spd   : IN  STD_LOGIC_VECTOR(ShipCounterSize-1 DOWNTO 0);
				BulletSpd  : IN  STD_LOGIC_VECTOR(BlltCounterSize-1 DOWNTO 0);
				HullP1     : IN  STD_LOGIC_VECTOR(HullSize       -1 DOWNTO 0);
				HullP2     : IN  STD_LOGIC_VECTOR(HullSize       -1 DOWNTO 0);
				CritHitP1  : IN  STD_LOGIC_VECTOR(                1 DOWNTO 0);
				CritHitP2  : IN  STD_LOGIC_VECTOR(                1 DOWNTO 0);
				ShieldP1   : IN  STD_LOGIC_VECTOR(ShieldSize     -1 DOWNTO 0);
				ShieldP2   : IN  STD_LOGIC_VECTOR(ShieldSize     -1 DOWNTO 0);
				MaxPoints  : IN  STD_LOGIC_VECTOR(                3 DOWNTO 0);
				Reset      : IN  STD_LOGIC;
				Clk        : IN  STD_LOGIC;
				Ship1      : OUT Object;
				Ship2      : OUT Object;
				Bullet01   : OUT Object;
				Bullet02   : OUT Object;
				Bullet03   : OUT Object;
				Bullet04   : OUT Object;
				Bullet05   : OUT Object;
				Bullet06   : OUT Object;
				Bullet07   : OUT Object;
				Bullet08   : OUT Object;
				Bullet09   : OUT Object;
				Bullet10   : OUT Object;
				EnaBullet  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
				ScoreAndHP : OUT DecimalValue;
				Winner     : OUT STD_LOGIC_VECTOR(                1 DOWNTO 0)
			 );
	
END ENTITY GameBlock;

ARCHITECTURE GameBlockArch OF GameBlock IS

SIGNAL   GameRst    : STD_LOGIC;

SIGNAL   Ship1T     : Object;
SIGNAL   Ship2T     : Object;

SIGNAL   U1         : STD_LOGIC;
SIGNAL   D1         : STD_LOGIC;
SIGNAL   R1         : STD_LOGIC;
SIGNAL   L1         : STD_LOGIC;
SIGNAL   U2         : STD_LOGIC;
SIGNAL   D2         : STD_LOGIC;
SIGNAL   R2         : STD_LOGIC;
SIGNAL   L2         : STD_LOGIC;

SIGNAL   BasicDmgP1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   BasicDmgP2 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Ship1 <= Ship1T;
Ship2 <= Ship2T;

BlockN: ENTITY WORK.ScoreAndHitPoints 
GENERIC MAP(ShieldSize => ShieldSize
			  )
PORT MAP	  (BasicDmgP1 => BasicDmgP1,
				BasicDmgP2 => BasicDmgP2,
				HullP1     => HullP1,
				HullP2     => HullP2,
				CritHitP1  => CritHitP1,
				CritHitP2  => CritHitP2,
				ShieldP1   => ShieldP1,
				ShieldP2   => ShieldP2,
				MaxPoints  => MaxPoints,
				Reset      => Reset,
				Clk        => Clk,
				ScoreAndHP => ScoreAndHP,
				GameReset  => GameRst,
				Winner     => Winner
			  );

Bullets: ENTITY WORK.BulletsPosition 
GENERIC MAP(BlltCounterSize => BlltCounterSize
			  )
PORT MAP	  (Player1P   => Player1P,
				Player2P   => Player2P,
				Ship1      => Ship1T,
				Ship2      => Ship2T,
				BulletSpd  => BulletSpd,
				Clk        => Clk,
				Reset      => Reset,
				GameRst    => GameRst,
				Bullet01   => Bullet01,
				Bullet02   => Bullet02,
				Bullet03   => Bullet03,
				Bullet04   => Bullet04,
				Bullet05   => Bullet05,
				Bullet06   => Bullet06,
				Bullet07   => Bullet07,
				Bullet08   => Bullet08,
				Bullet09   => Bullet09,
				Bullet10   => Bullet10,
				BasicDmgP1 => BasicDmgP1,
				BasicDmgP2 => BasicDmgP2,
				EnaBullet  => EnaBullet
			  );

Ship1Ctrl: ENTITY WORK.ShipControl 
GENERIC MAP(CounterSize => ShipCounterSize
			  )
PORT MAP	  (GoUp      => GoUp1,
				GoDown    => GoDown1,
				GoRight   => GoRight1,
				GoLeft    => GoLeft1,
				ShipSpeed => Ship1Spd,
				Reset     => Reset,
				Clk       => Clk,
				U         => U1,
				D         => D1,
				R         => R1,
				L         => L1
			  );

Ship2Ctrl: ENTITY WORK.ShipControl 
GENERIC MAP(CounterSize => ShipCounterSize
			  )
PORT MAP	  (GoUp      => GoUp2,
				GoDown    => GoDown2,
				GoRight   => GoRight2,
				GoLeft    => GoLeft2,
				ShipSpeed => Ship2Spd,
				Reset     => Reset,
				Clk       => Clk,
				U         => U2,
				D         => D2,
				R         => R2,
				L         => L2
			  );

CalculatePosition: ENTITY WORK.ShipPosition 
PORT MAP	  (U1      => U1,
				D1      => D1,
				R1      => R1,
				L1      => L1,
				U2      => U2,
				D2      => D2,
				R2      => R2,
				L2      => L2,
				Reset   => Reset,
				GameRst => GameRst,
				Clk     => Clk,
				Ship1   => Ship1T,
				Ship2   => Ship2T
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.GameBlock 
--GENERIC MAP(ShipCounterSize => #,
--				BlltCounterSize => #,
--				ShieldSize      => #
--			  )
--PORT MAP	  (GoUp1      => SLV,
--				GoDown1    => SLV,
--				GoRight1   => SLV,
--				GoLeft1    => SLV,
--				GoUp2      => SLV,
--				GoDown2    => SLV,
--				GoRight2   => SLV,
--				GoLeft2    => SLV,
--				Player1P   => SLV,
--				Player2P   => SLV,
--				Ship1Spd   => SLV,
--				Ship2Spd   => SLV,
--				BulletSpd  => SLV,
--				HullP1     => SLV,
--				HullP2     => SLV,
--				CritHitP1  => SLV,
--				CritHitP2  => SLV,
--				ShieldP1   => SLV,
--				ShieldP2   => SLV,
--				MaxPoints  => SLV,
--				Reset      => SLV,
--				Clk        => SLV,
--				Ship1      => SLV,
--				Ship2      => SLV,
--				Bullet01   => SLV,
--				Bullet02   => SLV,
--				Bullet03   => SLV,
--				Bullet04   => SLV,
--				Bullet05   => SLV,
--				Bullet06   => SLV,
--				Bullet07   => SLV,
--				Bullet08   => SLV,
--				Bullet09   => SLV,
--				Bullet10   => SLV,
--				EnaBullet  => SLV,
--				ScoreAndHP => SLV,
--				Winner     => SLV
--			  );
--******************************************************--

END GameBlockArch;