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

ENTITY PixelDogfight IS
	
	GENERIC(
				P1: INTEGER := 7
			 );
	PORT	 (
				Player1Up : IN  STD_LOGIC;
				Player1Dw : IN  STD_LOGIC;
				Player1Rg : IN  STD_LOGIC;
				Player1Lf : IN  STD_LOGIC;
				Player2Up : IN  STD_LOGIC;
				Player2Dw : IN  STD_LOGIC;
				Player2Rg : IN  STD_LOGIC;
				Player2Lf : IN  STD_LOGIC;
				Player1P  : IN  STD_LOGIC;
				Player2P  : IN  STD_LOGIC;
				RstN      : IN  STD_LOGIC;
				Clk       : IN  STD_LOGIC;
				R         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				G         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				B         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				VgaBlank  : OUT STD_LOGIC;
				VgaClk    : OUT STD_LOGIC;
				VgaSync   : OUT STD_LOGIC;
				Hsync     : OUT STD_LOGIC;
				VSync     : OUT STD_LOGIC
			 );
	
END ENTITY PixelDogfight;

ARCHITECTURE PixelDogfightArch OF PixelDogfight IS

CONSTANT ShipCS  : INTEGER := 20;
CONSTANT BlltCS  : INTEGER := 18;
CONSTANT ShldCS  : INTEGER := 28;

SIGNAL Ship1Spd   : STD_LOGIC_VECTOR(ShipCS-1 DOWNTO 0);
SIGNAL Ship2Spd   : STD_LOGIC_VECTOR(ShipCS-1 DOWNTO 0);
SIGNAL BulletSpd  : STD_LOGIC_VECTOR(BlltCS-1 DOWNTO 0);

SIGNAL Bullet01   : Object ;
SIGNAL Bullet02   : Object ;
SIGNAL Bullet03   : Object ;
SIGNAL Bullet04   : Object ;
SIGNAL Bullet05   : Object ;
SIGNAL Bullet06   : Object ;
SIGNAL Bullet07   : Object ;
SIGNAL Bullet08   : Object ;
SIGNAL Bullet09   : Object ;
SIGNAL Bullet10   : Object ;
SIGNAL Ship1      : Object ;
SIGNAL Ship2      : Object ;
SIGNAL EnaBullet  : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL Reset      : STD_LOGIC;
SIGNAL ScoreAndHP : DecimalValue;
SIGNAL Values     : DecimalValue ;




BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Ship1Spd  <= Int2StdVector(1048575,ShipCS);
Ship2Spd  <= Int2StdVector(1048575,ShipCS);
BulletSpd <= Int2StdVector( 262143,BlltCS);

Values.ScoreP1 <= ScoreAndHP.ScoreP2;
Values.ScoreP2 <= ScoreAndHP.ScoreP1;
Values.HpP1    <= ScoreAndHP.HpP1;
Values.HpP2    <= ScoreAndHP.HpP2;

Reset <= NOT RstN;

Svga: ENTITY WORK.SvgaController 
PORT MAP	  (SyncClk   => Clk,
				Reset     => Reset,
				Bullet01  => Bullet01,
				Bullet02  => Bullet02,
				Bullet03  => Bullet03,
				Bullet04  => Bullet04,
				Bullet05  => Bullet05,
				Bullet06  => Bullet06,
				Bullet07  => Bullet07,
				Bullet08  => Bullet08,
				Bullet09  => Bullet09,
				Bullet10  => Bullet10,
				Score1    => ScorePlayer1,
				Score2    => ScorePlayer2,
				HP11      => Ship1HitPoints1,
				HP12      => Ship1HitPoints2,
				HP13      => Ship1HitPoints3,
				HP21      => Ship2HitPoints1,
				HP22      => Ship2HitPoints2,
				HP23      => Ship2HitPoints3,
				Ship1     => Ship1,
				Ship2     => Ship2,
				EnaBullet => EnaBullet,
				NumValues => Values,
				R         => R,
				G         => G,
				B         => B,
				VgaBlank  => VgaBlank,
				VgaClk    => VgaClk,
				VgaSync   => VgaSync,
				HSync     => HSync,
				VSync     => VSync
			  );

Game: ENTITY WORK.GameBlock 
GENERIC MAP(ShipCounterSize => ShipCS,
				BlltCounterSize => BlltCS,
				ShieldSize      => ShldCS
			  )
PORT MAP	  (GoUp1      => Player1Up,
				GoDown1    => Player1Dw,
				GoRight1   => Player1Rg,
				GoLeft1    => Player1Lf,
				GoUp2      => Player2Up,
				GoDown2    => Player2Dw,
				GoRight2   => Player2Rg,
				GoLeft2    => Player2Lf,
				Player1P   => Player1P,
				Player2P   => Player2P,
				Ship1Spd   => Ship2Spd,
				Ship2Spd   => Ship1Spd,
				BulletSpd  => BulletSpd,
				HullP1     => "1100100",
				HullP2     => "1100100",
				CritHitP1  => "00",
				CritHitP2  => "00",
				ShieldP1   => "1111111111111111111111111111",
				ShieldP2   => "1111111111111111111111111111",
				MaxPoints  => "0100",
				Reset      => Reset,
				Clk        => Clk,
				Ship1      => Ship1,
				Ship2      => Ship2,
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
				EnaBullet  => EnaBullet,
				ScoreAndHP => ScoreAndHP,
				Winner     => OPEN
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.PixelDogfight 
--GENERIC MAP(GenericVar => #
--			  )
--PORT MAP	  (Sig => SLV,
--				Sig => SLV,
--				Sig => SLV,
--				Sig => SLV
--			  );
--******************************************************--

END PixelDogfightArch;