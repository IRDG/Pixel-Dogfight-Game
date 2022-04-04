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

ENTITY BulletsPosition IS
	
	GENERIC(
				BlltCounterSize: INTEGER := 18
			 );
	
	PORT	 (
				Player1P   : IN  STD_LOGIC;
				Player2P   : IN  STD_LOGIC;
				Ship1      : IN  Object;
				Ship2      : IN  Object;
				BulletSpd  : IN  STD_LOGIC_VECTOR(BlltCounterSize-1 DOWNTO 0);
				Clk        : IN  STD_LOGIC;
				Reset      : IN  STD_LOGIC;
				GameRst    : IN  STD_LOGIC;
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
				BasicDmgP1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
				BasicDmgP2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
				EnaBullet  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
			 );
	
END ENTITY BulletsPosition;

ARCHITECTURE BulletsPositionArch OF BulletsPosition IS

CONSTANT ZeroCount       : STD_LOGIC_VECTOR(BlltCounterSize - 1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   ResetG          : STD_LOGIC;
SIGNAL   EnableMove      : STD_LOGIC;

SIGNAL   Ship1UpLim      : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL   Ship1DwLim      : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL   Ship2UpLim      : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL   Ship2DwLim      : STD_LOGIC_VECTOR(N DOWNTO 0);

SIGNAL   ActiveBulletP1  : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   ActiveBulletP2  : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   DisableBulletP1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   DisableBulletP2 : STD_LOGIC_VECTOR(4 DOWNTO 0);

SIGNAL   ActiveBullet01  : STD_LOGIC;
SIGNAL   PrevBullet01    : Object;
SIGNAL   NextBullet01    : Object;
SIGNAL   StateBlt01      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt01        : Object;
SIGNAL   MovBlt01        : Object;
SIGNAL   Blt01Out        : STD_LOGIC;
SIGNAL   Blt01Hit        : STD_LOGIC;
SIGNAL   Blt01HardHit    : STD_LOGIC;
SIGNAL   Blt01SoftHit    : STD_LOGIC;
SIGNAL   Blt01Null06     : STD_LOGIC;
SIGNAL   Blt01Null07     : STD_LOGIC;
SIGNAL   Blt01Null08     : STD_LOGIC;
SIGNAL   Blt01Null09     : STD_LOGIC;
SIGNAL   Blt01Null10     : STD_LOGIC;
SIGNAL   Blt01Null       : STD_LOGIC;
SIGNAL   Collision01     : STD_LOGIC;
SIGNAL   Collision01E1   : STD_LOGIC;
SIGNAL   Collision01E2   : STD_LOGIC;
SIGNAL   Collision01F    : STD_LOGIC;
SIGNAL   Bullet01T       : Object;

SIGNAL   ActiveBullet02  : STD_LOGIC;
SIGNAL   PrevBullet02    : Object;
SIGNAL   NextBullet02    : Object;
SIGNAL   StateBlt02      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt02        : Object;
SIGNAL   MovBlt02        : Object;
SIGNAL   Blt02Out        : STD_LOGIC;
SIGNAL   Blt02Hit        : STD_LOGIC;
SIGNAL   Blt02HardHit    : STD_LOGIC;
SIGNAL   Blt02SoftHit    : STD_LOGIC;
SIGNAL   Blt02Null06     : STD_LOGIC;
SIGNAL   Blt02Null07     : STD_LOGIC;
SIGNAL   Blt02Null08     : STD_LOGIC;
SIGNAL   Blt02Null09     : STD_LOGIC;
SIGNAL   Blt02Null10     : STD_LOGIC;
SIGNAL   Blt02Null       : STD_LOGIC;
SIGNAL   Collision02     : STD_LOGIC;
SIGNAL   Collision02E1   : STD_LOGIC;
SIGNAL   Collision02E2   : STD_LOGIC;
SIGNAL   Collision02F    : STD_LOGIC;
SIGNAL   Bullet02T       : Object;

SIGNAL   ActiveBullet03  : STD_LOGIC;
SIGNAL   PrevBullet03    : Object;
SIGNAL   NextBullet03    : Object;
SIGNAL   StateBlt03      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt03        : Object;
SIGNAL   MovBlt03        : Object;
SIGNAL   Blt03Out        : STD_LOGIC;
SIGNAL   Blt03Hit        : STD_LOGIC;
SIGNAL   Blt03HardHit    : STD_LOGIC;
SIGNAL   Blt03SoftHit    : STD_LOGIC;
SIGNAL   Blt03Null06     : STD_LOGIC;
SIGNAL   Blt03Null07     : STD_LOGIC;
SIGNAL   Blt03Null08     : STD_LOGIC;
SIGNAL   Blt03Null09     : STD_LOGIC;
SIGNAL   Blt03Null10     : STD_LOGIC;
SIGNAL   Blt03Null       : STD_LOGIC;
SIGNAL   Collision03     : STD_LOGIC;
SIGNAL   Collision03E1   : STD_LOGIC;
SIGNAL   Collision03E2   : STD_LOGIC;
SIGNAL   Collision03F    : STD_LOGIC;
SIGNAL   Bullet03T       : Object;

SIGNAL   ActiveBullet04  : STD_LOGIC;
SIGNAL   PrevBullet04    : Object;
SIGNAL   NextBullet04    : Object;
SIGNAL   StateBlt04      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt04        : Object;
SIGNAL   MovBlt04        : Object;
SIGNAL   Blt04Out        : STD_LOGIC;
SIGNAL   Blt04Hit        : STD_LOGIC;
SIGNAL   Blt04HardHit    : STD_LOGIC;
SIGNAL   Blt04SoftHit    : STD_LOGIC;
SIGNAL   Blt04Null06     : STD_LOGIC;
SIGNAL   Blt04Null07     : STD_LOGIC;
SIGNAL   Blt04Null08     : STD_LOGIC;
SIGNAL   Blt04Null09     : STD_LOGIC;
SIGNAL   Blt04Null10     : STD_LOGIC;
SIGNAL   Blt04Null       : STD_LOGIC;
SIGNAL   Collision04     : STD_LOGIC;
SIGNAL   Collision04E1   : STD_LOGIC;
SIGNAL   Collision04E2   : STD_LOGIC;
SIGNAL   Collision04F    : STD_LOGIC;
SIGNAL   Bullet04T       : Object;

SIGNAL   ActiveBullet05  : STD_LOGIC;
SIGNAL   PrevBullet05    : Object;
SIGNAL   NextBullet05    : Object;
SIGNAL   StateBlt05      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt05        : Object;
SIGNAL   MovBlt05        : Object;
SIGNAL   Blt05Out        : STD_LOGIC;
SIGNAL   Blt05Hit        : STD_LOGIC;
SIGNAL   Blt05HardHit    : STD_LOGIC;
SIGNAL   Blt05SoftHit    : STD_LOGIC;
SIGNAL   Blt05Null06     : STD_LOGIC;
SIGNAL   Blt05Null07     : STD_LOGIC;
SIGNAL   Blt05Null08     : STD_LOGIC;
SIGNAL   Blt05Null09     : STD_LOGIC;
SIGNAL   Blt05Null10     : STD_LOGIC;
SIGNAL   Blt05Null       : STD_LOGIC;
SIGNAL   Collision05     : STD_LOGIC;
SIGNAL   Collision05E1   : STD_LOGIC;
SIGNAL   Collision05E2   : STD_LOGIC;
SIGNAL   Collision05F    : STD_LOGIC;
SIGNAL   Bullet05T       : Object;

SIGNAL   ActiveBullet06  : STD_LOGIC;
SIGNAL   PrevBullet06    : Object;
SIGNAL   NextBullet06    : Object;
SIGNAL   StateBlt06      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt06        : Object;
SIGNAL   MovBlt06        : Object;
SIGNAL   Blt06Out        : STD_LOGIC;
SIGNAL   Blt06Hit        : STD_LOGIC;
SIGNAL   Blt06Null01     : STD_LOGIC;
SIGNAL   Blt06Null02     : STD_LOGIC;
SIGNAL   Blt06Null03     : STD_LOGIC;
SIGNAL   Blt06Null04     : STD_LOGIC;
SIGNAL   Blt06Null05     : STD_LOGIC;
SIGNAL   Blt06Null       : STD_LOGIC;
SIGNAL   Blt06HardHit    : STD_LOGIC;
SIGNAL   Blt06SoftHit    : STD_LOGIC;
SIGNAL   Collision06     : STD_LOGIC;
SIGNAL   Collision06E1   : STD_LOGIC;
SIGNAL   Collision06E2   : STD_LOGIC;
SIGNAL   Collision06F    : STD_LOGIC;
SIGNAL   Bullet06T       : Object;

SIGNAL   ActiveBullet07  : STD_LOGIC;
SIGNAL   PrevBullet07    : Object;
SIGNAL   NextBullet07    : Object;
SIGNAL   StateBlt07      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt07        : Object;
SIGNAL   MovBlt07        : Object;
SIGNAL   Blt07Out        : STD_LOGIC;
SIGNAL   Blt07Hit        : STD_LOGIC;
SIGNAL   Blt07Null01     : STD_LOGIC;
SIGNAL   Blt07Null02     : STD_LOGIC;
SIGNAL   Blt07Null03     : STD_LOGIC;
SIGNAL   Blt07Null04     : STD_LOGIC;
SIGNAL   Blt07Null05     : STD_LOGIC;
SIGNAL   Blt07Null       : STD_LOGIC;
SIGNAL   Blt07HardHit    : STD_LOGIC;
SIGNAL   Blt07SoftHit    : STD_LOGIC;
SIGNAL   Collision07     : STD_LOGIC;
SIGNAL   Collision07E1   : STD_LOGIC;
SIGNAL   Collision07E2   : STD_LOGIC;
SIGNAL   Collision07F    : STD_LOGIC;
SIGNAL   Bullet07T       : Object;

SIGNAL   ActiveBullet08  : STD_LOGIC;
SIGNAL   PrevBullet08    : Object;
SIGNAL   NextBullet08    : Object;
SIGNAL   StateBlt08      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt08        : Object;
SIGNAL   MovBlt08        : Object;
SIGNAL   Blt08Out        : STD_LOGIC;
SIGNAL   Blt08Hit        : STD_LOGIC;
SIGNAL   Blt08Null01     : STD_LOGIC;
SIGNAL   Blt08Null02     : STD_LOGIC;
SIGNAL   Blt08Null03     : STD_LOGIC;
SIGNAL   Blt08Null04     : STD_LOGIC;
SIGNAL   Blt08Null05     : STD_LOGIC;
SIGNAL   Blt08Null       : STD_LOGIC;
SIGNAL   Blt08HardHit    : STD_LOGIC;
SIGNAL   Blt08SoftHit    : STD_LOGIC;
SIGNAL   Collision08     : STD_LOGIC;
SIGNAL   Collision08E1   : STD_LOGIC;
SIGNAL   Collision08E2   : STD_LOGIC;
SIGNAL   Collision08F    : STD_LOGIC;
SIGNAL   Bullet08T       : Object;

SIGNAL   ActiveBullet09  : STD_LOGIC;
SIGNAL   PrevBullet09    : Object;
SIGNAL   NextBullet09    : Object;
SIGNAL   StateBlt09      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt09        : Object;
SIGNAL   MovBlt09        : Object;
SIGNAL   Blt09Out        : STD_LOGIC;
SIGNAL   Blt09Hit        : STD_LOGIC;
SIGNAL   Blt09Null01     : STD_LOGIC;
SIGNAL   Blt09Null02     : STD_LOGIC;
SIGNAL   Blt09Null03     : STD_LOGIC;
SIGNAL   Blt09Null04     : STD_LOGIC;
SIGNAL   Blt09Null05     : STD_LOGIC;
SIGNAL   Blt09Null       : STD_LOGIC;
SIGNAL   Blt09HardHit    : STD_LOGIC;
SIGNAL   Blt09SoftHit    : STD_LOGIC;
SIGNAL   Collision09     : STD_LOGIC;
SIGNAL   Collision09E1   : STD_LOGIC;
SIGNAL   Collision09E2   : STD_LOGIC;
SIGNAL   Collision09F    : STD_LOGIC;
SIGNAL   Bullet09T       : Object;

SIGNAL   ActiveBullet10  : STD_LOGIC;
SIGNAL   PrevBullet10    : Object;
SIGNAL   NextBullet10    : Object;
SIGNAL   StateBlt10      : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   NewBlt10        : Object;
SIGNAL   MovBlt10        : Object;
SIGNAL   Blt10Out        : STD_LOGIC;
SIGNAL   Blt10Hit        : STD_LOGIC;
SIGNAL   Blt10Null01     : STD_LOGIC;
SIGNAL   Blt10Null02     : STD_LOGIC;
SIGNAL   Blt10Null03     : STD_LOGIC;
SIGNAL   Blt10Null04     : STD_LOGIC;
SIGNAL   Blt10Null05     : STD_LOGIC;
SIGNAL   Blt10Null       : STD_LOGIC;
SIGNAL   Blt10HardHit    : STD_LOGIC;
SIGNAL   Blt10SoftHit    : STD_LOGIC;
SIGNAL   Collision10     : STD_LOGIC;
SIGNAL   Collision10E1   : STD_LOGIC;
SIGNAL   Collision10E2   : STD_LOGIC;
SIGNAL   Collision10F    : STD_LOGIC;
SIGNAL   Bullet10T       : Object;

SIGNAL   HardHitToP1     : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   HardHitToP2     : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   SoftHitToP1     : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   SoftHitToP2     : STD_LOGIC_VECTOR(4 DOWNTO 0);

SIGNAL   HardDmgP1       : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL   HardDmgP2       : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL   SoftDmgP1       : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL   SoftDmgP2       : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

ResetG       <= Reset OR GameRst;

Ship1UpLim <= Int2StdVector(StdVector2Int(Ship1.StartY) + 13,NpO);
Ship1DwLim <= Int2StdVector(StdVector2Int(Ship1.EndY  ) - 13,NpO);
Ship2UpLim <= Int2StdVector(StdVector2Int(Ship2.StartY) + 13,NpO);
Ship2DwLim <= Int2StdVector(StdVector2Int(Ship2.EndY  ) - 13,NpO);

--******************************************************--
-- 
-- Bullet 01 position and state Information
-- 
--******************************************************--

NewBlt01.StartX <= Int2StdVector(StdVector2Int(Ship1.EndX     ) +           1,11);
NewBlt01.StartY <= Int2StdVector(StdVector2Int(Ship1.StartY   ) +          18,11);
NewBlt01.EndX   <= Int2StdVector(StdVector2Int(NewBlt01.StartX) + BulletSizeX,11);
NewBlt01.EndY   <= Int2StdVector(StdVector2Int(NewBlt01.StartY) + BulletSizeY,11);

MovBlt01.StartX <= Int2StdVector(StdVector2Int(PrevBullet01.StartX) +       1,11);
MovBlt01.StartY <= PrevBullet01.StartY;
MovBlt01.EndX   <= Int2StdVector(StdVector2Int(PrevBullet01.EndX  ) +       1,11);
MovBlt01.EndY   <= PrevBullet01.EndY;

Blt01Out        <= IsInRange(Display.MaxLimX,MovBlt01.StartX,Display.MaxLimX);

Blt01Null06     <=  IsInRange(Bullet06T.StartX,MovBlt01.EndX  ,Bullet06T.EndX) AND
						 (IsInRange(Bullet06T.StartY,MovBlt01.StartY,Bullet06T.EndY) OR
						  IsInRange(Bullet06T.StartY,MovBlt01.EndY  ,Bullet06T.EndY));

Blt01Null07     <=  IsInRange(Bullet07T.StartX,MovBlt01.EndX  ,Bullet07T.EndX) AND
						 (IsInRange(Bullet07T.StartY,MovBlt01.StartY,Bullet07T.EndY) OR
						  IsInRange(Bullet07T.StartY,MovBlt01.EndY  ,Bullet07T.EndY));

Blt01Null08     <=  IsInRange(Bullet08T.StartX,MovBlt01.EndX  ,Bullet08T.EndX) AND
						 (IsInRange(Bullet08T.StartY,MovBlt01.StartY,Bullet08T.EndY) OR
						  IsInRange(Bullet08T.StartY,MovBlt01.EndY  ,Bullet08T.EndY));

Blt01Null09     <=  IsInRange(Bullet09T.StartX,MovBlt01.EndX  ,Bullet09T.EndX) AND
						 (IsInRange(Bullet09T.StartY,MovBlt01.StartY,Bullet09T.EndY) OR
						  IsInRange(Bullet09T.StartY,MovBlt01.EndY  ,Bullet09T.EndY));

Blt01Null10     <=  IsInRange(Bullet10T.StartX,MovBlt01.EndX  ,Bullet10T.EndX) AND
						 (IsInRange(Bullet10T.StartY,MovBlt01.StartY,Bullet10T.EndY) OR
						  IsInRange(Bullet10T.StartY,MovBlt01.EndY  ,Bullet10T.EndY));

Blt01Null       <= Blt01Null06 OR
						 Blt01Null07 OR
						 Blt01Null08 OR
						 Blt01Null09 OR
						 Blt01Null10 ;

Blt01Hit        <=  IsInRange(Ship2.StartX,MovBlt01.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2.StartY,MovBlt01.StartY,Ship2.EndY) OR
						  IsInRange(Ship2.StartY,MovBlt01.EndY  ,Ship2.EndY));

Blt01HardHit    <=  IsInRange(Ship2.StartX,MovBlt01.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2UpLim  ,MovBlt01.StartY,Ship2DwLim) OR
						  IsInRange(Ship2UpLim  ,MovBlt01.EndY  ,Ship2DwLim));

Blt01SoftHit    <=   IsInRange(Ship2.StartX,MovBlt01.EndX  ,Ship2.EndX) AND
						 ((IsInRange(Ship2.StartY,MovBlt01.StartY,Ship2UpLim)  OR
						   IsInRange(Ship2.StartY,MovBlt01.EndY  ,Ship2UpLim)) OR
						  (IsInRange(Ship2DwLim  ,MovBlt01.StartY,Ship2.EndY)  OR
						   IsInRange(Ship2DwLim  ,MovBlt01.EndY  ,Ship2.EndY)));

Collision01     <= Blt01Out    OR Blt01Hit      OR Blt01Null;
Collision01F    <= Collision01 OR Collision01E1 OR Collision01E2;

ActiveBullet01  <= ActiveBulletP1(0) AND (NOT Collision01F);

Fsm01: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet01,
				EnableMove => EnableMove,
				Collision  => Collision01F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt01(0),
				Move       => StateBlt01(1),
				Waiting    => StateBlt01(2),
				Disabling  => StateBlt01(3)
			  );

WITH StateBlt01 SELECT
NextBullet01 <= InitialBullet01 WHEN "0000",
					 NewBlt01        WHEN "0001",
					 MovBlt01        WHEN "0010",
					 PrevBullet01    WHEN "0100",
					 InitialBullet01 WHEN "1000",
					 PrevBullet01    WHEN OTHERS;

Bullet01     <= PrevBullet01;
Bullet01T    <= PrevBullet01;

--******************************************************--
-- 
-- Bullet 02 position and state Information
-- 
--******************************************************--

NewBlt02.StartX <= Int2StdVector(StdVector2Int(Ship1.EndX     ) +           1,11);
NewBlt02.StartY <= Int2StdVector(StdVector2Int(Ship1.StartY   ) +          18,11);
NewBlt02.EndX   <= Int2StdVector(StdVector2Int(NewBlt02.StartX) + BulletSizeX,11);
NewBlt02.EndY   <= Int2StdVector(StdVector2Int(NewBlt02.StartY) + BulletSizeY,11);

MovBlt02.StartX <= Int2StdVector(StdVector2Int(PrevBullet02.StartX) +       1,11);
MovBlt02.StartY <= PrevBullet02.StartY;
MovBlt02.EndX   <= Int2StdVector(StdVector2Int(PrevBullet02.EndX  ) +       1,11);
MovBlt02.EndY   <= PrevBullet02.EndY;

Blt02Out        <= IsInRange(Display.MaxLimX,MovBlt02.StartX,Display.MaxLimX);

Blt02Null06     <=  IsInRange(Bullet06T.StartX,MovBlt02.EndX  ,Bullet06T.EndX) AND
						 (IsInRange(Bullet06T.StartY,MovBlt02.StartY,Bullet06T.EndY) OR
						  IsInRange(Bullet06T.StartY,MovBlt02.EndY  ,Bullet06T.EndY));

Blt02Null07     <=  IsInRange(Bullet07T.StartX,MovBlt02.EndX  ,Bullet07T.EndX) AND
						 (IsInRange(Bullet07T.StartY,MovBlt02.StartY,Bullet07T.EndY) OR
						  IsInRange(Bullet07T.StartY,MovBlt02.EndY  ,Bullet07T.EndY));

Blt02Null08     <=  IsInRange(Bullet08T.StartX,MovBlt02.EndX  ,Bullet08T.EndX) AND
						 (IsInRange(Bullet08T.StartY,MovBlt02.StartY,Bullet08T.EndY) OR
						  IsInRange(Bullet08T.StartY,MovBlt02.EndY  ,Bullet08T.EndY));

Blt02Null09     <=  IsInRange(Bullet09T.StartX,MovBlt02.EndX  ,Bullet09T.EndX) AND
						 (IsInRange(Bullet09T.StartY,MovBlt02.StartY,Bullet09T.EndY) OR
						  IsInRange(Bullet09T.StartY,MovBlt02.EndY  ,Bullet09T.EndY));

Blt02Null10     <=  IsInRange(Bullet10T.StartX,MovBlt02.EndX  ,Bullet10T.EndX) AND
						 (IsInRange(Bullet10T.StartY,MovBlt02.StartY,Bullet10T.EndY) OR
						  IsInRange(Bullet10T.StartY,MovBlt02.EndY  ,Bullet10T.EndY));

Blt02Null       <= Blt02Null06 OR
						 Blt02Null07 OR
						 Blt02Null08 OR
						 Blt02Null09 OR
						 Blt02Null10 ;

Blt02Hit        <=  IsInRange(Ship2.StartX,MovBlt02.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2.StartY,MovBlt02.StartY,Ship2.EndY) OR
						  IsInRange(Ship2.StartY,MovBlt02.EndY  ,Ship2.EndY));

Blt02HardHit    <=  IsInRange(Ship2.StartX,MovBlt02.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2UpLim  ,MovBlt02.StartY,Ship2DwLim) OR
						  IsInRange(Ship2UpLim  ,MovBlt02.EndY  ,Ship2DwLim));

Blt02SoftHit    <=   IsInRange(Ship2.StartX,MovBlt02.EndX  ,Ship2.EndX) AND
						 ((IsInRange(Ship2.StartY,MovBlt02.StartY,Ship2UpLim)  OR
						   IsInRange(Ship2.StartY,MovBlt02.EndY  ,Ship2UpLim)) OR
						  (IsInRange(Ship2DwLim  ,MovBlt02.StartY,Ship2.EndY)  OR
						   IsInRange(Ship2DwLim  ,MovBlt02.EndY  ,Ship2.EndY)));

Collision02     <= Blt02Out    OR Blt02Hit      OR Blt02Null;
Collision02F    <= Collision02 OR Collision02E1 OR Collision02E2;

ActiveBullet02  <= ActiveBulletP1(1) AND (NOT Collision02F);

Fsm02: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet02,
				EnableMove => EnableMove,
				Collision  => Collision02F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt02(0),
				Move       => StateBlt02(1),
				Waiting    => StateBlt02(2),
				Disabling  => StateBlt02(3)
			  );

WITH StateBlt02 SELECT
NextBullet02 <= InitialBullet02 WHEN "0000",
					 NewBlt02        WHEN "0001",
					 MovBlt02        WHEN "0010",
					 PrevBullet02    WHEN "0100",
					 InitialBullet02 WHEN "1000",
					 PrevBullet02    WHEN OTHERS;

Bullet02     <= PrevBullet02;
Bullet02T    <= PrevBullet02;

--******************************************************--
-- 
-- Bullet 03 position and state Information
-- 
--******************************************************--

NewBlt03.StartX <= Int2StdVector(StdVector2Int(Ship1.EndX     ) +           1,11);
NewBlt03.StartY <= Int2StdVector(StdVector2Int(Ship1.StartY   ) +          18,11);
NewBlt03.EndX   <= Int2StdVector(StdVector2Int(NewBlt03.StartX) + BulletSizeX,11);
NewBlt03.EndY   <= Int2StdVector(StdVector2Int(NewBlt03.StartY) + BulletSizeY,11);

MovBlt03.StartX <= Int2StdVector(StdVector2Int(PrevBullet03.StartX) +       1,11);
MovBlt03.StartY <= PrevBullet03.StartY;
MovBlt03.EndX   <= Int2StdVector(StdVector2Int(PrevBullet03.EndX  ) +       1,11);
MovBlt03.EndY   <= PrevBullet03.EndY;

Blt03Out        <= IsInRange(Display.MaxLimX,MovBlt03.StartX,Display.MaxLimX);

Blt03Null06     <=  IsInRange(Bullet06T.StartX,MovBlt03.EndX  ,Bullet06T.EndX) AND
						 (IsInRange(Bullet06T.StartY,MovBlt03.StartY,Bullet06T.EndY) OR
						  IsInRange(Bullet06T.StartY,MovBlt03.EndY  ,Bullet06T.EndY));

Blt03Null07     <=  IsInRange(Bullet07T.StartX,MovBlt03.EndX  ,Bullet07T.EndX) AND
						 (IsInRange(Bullet07T.StartY,MovBlt03.StartY,Bullet07T.EndY) OR
						  IsInRange(Bullet07T.StartY,MovBlt03.EndY  ,Bullet07T.EndY));

Blt03Null08     <=  IsInRange(Bullet08T.StartX,MovBlt03.EndX  ,Bullet08T.EndX) AND
						 (IsInRange(Bullet08T.StartY,MovBlt03.StartY,Bullet08T.EndY) OR
						  IsInRange(Bullet08T.StartY,MovBlt03.EndY  ,Bullet08T.EndY));

Blt03Null09     <=  IsInRange(Bullet09T.StartX,MovBlt03.EndX  ,Bullet09T.EndX) AND
						 (IsInRange(Bullet09T.StartY,MovBlt03.StartY,Bullet09T.EndY) OR
						  IsInRange(Bullet09T.StartY,MovBlt03.EndY  ,Bullet09T.EndY));

Blt03Null10     <=  IsInRange(Bullet10T.StartX,MovBlt03.EndX  ,Bullet10T.EndX) AND
						 (IsInRange(Bullet10T.StartY,MovBlt03.StartY,Bullet10T.EndY) OR
						  IsInRange(Bullet10T.StartY,MovBlt03.EndY  ,Bullet10T.EndY));

Blt03Null       <= Blt03Null06 OR
						 Blt03Null07 OR
						 Blt03Null08 OR
						 Blt03Null09 OR
						 Blt03Null10 ;

Blt03Hit        <=  IsInRange(Ship2.StartX,MovBlt03.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2.StartY,MovBlt03.StartY,Ship2.EndY) OR
						  IsInRange(Ship2.StartY,MovBlt03.EndY  ,Ship2.EndY));

Blt03HardHit    <=  IsInRange(Ship2.StartX,MovBlt03.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2UpLim  ,MovBlt03.StartY,Ship2DwLim) OR
						  IsInRange(Ship2UpLim  ,MovBlt03.EndY  ,Ship2DwLim));

Blt03SoftHit    <=   IsInRange(Ship2.StartX,MovBlt03.EndX  ,Ship2.EndX) AND
						 ((IsInRange(Ship2.StartY,MovBlt03.StartY,Ship2UpLim)  OR
						   IsInRange(Ship2.StartY,MovBlt03.EndY  ,Ship2UpLim)) OR
						  (IsInRange(Ship2DwLim  ,MovBlt03.StartY,Ship2.EndY)  OR
						   IsInRange(Ship2DwLim  ,MovBlt03.EndY  ,Ship2.EndY)));

Collision03     <= Blt03Out    OR Blt03Hit      OR Blt03Null;
Collision03F    <= Collision03 OR Collision03E1 OR Collision03E2;

ActiveBullet03  <= ActiveBulletP1(2) AND (NOT Collision03F);

Fsm03: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet03,
				EnableMove => EnableMove,
				Collision  => Collision03F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt03(0),
				Move       => StateBlt03(1),
				Waiting    => StateBlt03(2),
				Disabling  => StateBlt03(3)
			  );

WITH StateBlt03 SELECT
NextBullet03 <= InitialBullet03 WHEN "0000",
					 NewBlt03        WHEN "0001",
					 MovBlt03        WHEN "0010",
					 PrevBullet03    WHEN "0100",
					 InitialBullet03 WHEN "1000",
					 PrevBullet03    WHEN OTHERS;

Bullet03     <= PrevBullet03;
Bullet03T    <= PrevBullet03;

--******************************************************--
-- 
-- Bullet 04 position and state Information
-- 
--******************************************************--

NewBlt04.StartX <= Int2StdVector(StdVector2Int(Ship1.EndX     ) +           1,11);
NewBlt04.StartY <= Int2StdVector(StdVector2Int(Ship1.StartY   ) +          18,11);
NewBlt04.EndX   <= Int2StdVector(StdVector2Int(NewBlt04.StartX) + BulletSizeX,11);
NewBlt04.EndY   <= Int2StdVector(StdVector2Int(NewBlt04.StartY) + BulletSizeY,11);

MovBlt04.StartX <= Int2StdVector(StdVector2Int(PrevBullet04.StartX) +       1,11);
MovBlt04.StartY <= PrevBullet04.StartY;
MovBlt04.EndX   <= Int2StdVector(StdVector2Int(PrevBullet04.EndX  ) +       1,11);
MovBlt04.EndY   <= PrevBullet04.EndY;

Blt04Out        <= IsInRange(Display.MaxLimX,MovBlt04.StartX,Display.MaxLimX);

Blt04Null06     <=  IsInRange(Bullet06T.StartX,MovBlt04.EndX  ,Bullet06T.EndX) AND
						 (IsInRange(Bullet06T.StartY,MovBlt04.StartY,Bullet06T.EndY) OR
						  IsInRange(Bullet06T.StartY,MovBlt04.EndY  ,Bullet06T.EndY));

Blt04Null07     <=  IsInRange(Bullet07T.StartX,MovBlt04.EndX  ,Bullet07T.EndX) AND
						 (IsInRange(Bullet07T.StartY,MovBlt04.StartY,Bullet07T.EndY) OR
						  IsInRange(Bullet07T.StartY,MovBlt04.EndY  ,Bullet07T.EndY));

Blt04Null08     <=  IsInRange(Bullet08T.StartX,MovBlt04.EndX  ,Bullet08T.EndX) AND
						 (IsInRange(Bullet08T.StartY,MovBlt04.StartY,Bullet08T.EndY) OR
						  IsInRange(Bullet08T.StartY,MovBlt04.EndY  ,Bullet08T.EndY));

Blt04Null09     <=  IsInRange(Bullet09T.StartX,MovBlt04.EndX  ,Bullet09T.EndX) AND
						 (IsInRange(Bullet09T.StartY,MovBlt04.StartY,Bullet09T.EndY) OR
						  IsInRange(Bullet09T.StartY,MovBlt04.EndY  ,Bullet09T.EndY));

Blt04Null10     <=  IsInRange(Bullet10T.StartX,MovBlt04.EndX  ,Bullet10T.EndX) AND
						 (IsInRange(Bullet10T.StartY,MovBlt04.StartY,Bullet10T.EndY) OR
						  IsInRange(Bullet10T.StartY,MovBlt04.EndY  ,Bullet10T.EndY));

Blt04Null       <= Blt04Null06 OR
						 Blt04Null07 OR
						 Blt04Null08 OR
						 Blt04Null09 OR
						 Blt04Null10 ;

Blt04HardHit    <=  IsInRange(Ship2.StartX,MovBlt04.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2UpLim  ,MovBlt04.StartY,Ship2DwLim) OR
						  IsInRange(Ship2UpLim  ,MovBlt04.EndY  ,Ship2DwLim));

Blt04SoftHit    <=   IsInRange(Ship2.StartX,MovBlt04.EndX  ,Ship2.EndX) AND
						 ((IsInRange(Ship2.StartY,MovBlt04.StartY,Ship2UpLim)  OR
						   IsInRange(Ship2.StartY,MovBlt04.EndY  ,Ship2UpLim)) OR
						  (IsInRange(Ship2DwLim  ,MovBlt04.StartY,Ship2.EndY)  OR
						   IsInRange(Ship2DwLim  ,MovBlt04.EndY  ,Ship2.EndY)));

Blt04Hit        <=  IsInRange(Ship2.StartX,MovBlt04.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2.StartY,MovBlt04.StartY,Ship2.EndY) OR
						  IsInRange(Ship2.StartY,MovBlt04.EndY  ,Ship2.EndY));

Collision04     <= Blt04Out    OR Blt04Hit      OR Blt04Null;
Collision04F    <= Collision04 OR Collision04E1 OR Collision04E2;

ActiveBullet04  <= ActiveBulletP1(3) AND (NOT Collision04F);

Fsm04: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet04,
				EnableMove => EnableMove,
				Collision  => Collision04F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt04(0),
				Move       => StateBlt04(1),
				Waiting    => StateBlt04(2),
				Disabling  => StateBlt04(3)
			  );

WITH StateBlt04 SELECT
NextBullet04 <= InitialBullet04 WHEN "0000",
					 NewBlt04        WHEN "0001",
					 MovBlt04        WHEN "0010",
					 PrevBullet04    WHEN "0100",
					 InitialBullet04 WHEN "1000",
					 PrevBullet04    WHEN OTHERS;

Bullet04     <= PrevBullet04;
Bullet04T    <= PrevBullet04;

--******************************************************--
-- 
-- Bullet 05 position and state Information
-- 
--******************************************************--

NewBlt05.StartX <= Int2StdVector(StdVector2Int(Ship1.EndX     ) +           1,11);
NewBlt05.StartY <= Int2StdVector(StdVector2Int(Ship1.StartY   ) +          18,11);
NewBlt05.EndX   <= Int2StdVector(StdVector2Int(NewBlt05.StartX) + BulletSizeX,11);
NewBlt05.EndY   <= Int2StdVector(StdVector2Int(NewBlt05.StartY) + BulletSizeY,11);

MovBlt05.StartX <= Int2StdVector(StdVector2Int(PrevBullet05.StartX) +       1,11);
MovBlt05.StartY <= PrevBullet05.StartY;
MovBlt05.EndX   <= Int2StdVector(StdVector2Int(PrevBullet05.EndX  ) +       1,11);
MovBlt05.EndY   <= PrevBullet05.EndY;

Blt05Out        <= IsInRange(Display.MaxLimX,MovBlt05.StartX,Display.MaxLimX);

Blt05Null06     <=  IsInRange(Bullet06T.StartX,MovBlt05.EndX  ,Bullet06T.EndX) AND
						 (IsInRange(Bullet06T.StartY,MovBlt05.StartY,Bullet06T.EndY) OR
						  IsInRange(Bullet06T.StartY,MovBlt05.EndY  ,Bullet06T.EndY));

Blt05Null07     <=  IsInRange(Bullet07T.StartX,MovBlt05.EndX  ,Bullet07T.EndX) AND
						 (IsInRange(Bullet07T.StartY,MovBlt05.StartY,Bullet07T.EndY) OR
						  IsInRange(Bullet07T.StartY,MovBlt05.EndY  ,Bullet07T.EndY));

Blt05Null08     <=  IsInRange(Bullet08T.StartX,MovBlt05.EndX  ,Bullet08T.EndX) AND
						 (IsInRange(Bullet08T.StartY,MovBlt05.StartY,Bullet08T.EndY) OR
						  IsInRange(Bullet08T.StartY,MovBlt05.EndY  ,Bullet08T.EndY));

Blt05Null09     <=  IsInRange(Bullet09T.StartX,MovBlt05.EndX  ,Bullet09T.EndX) AND
						 (IsInRange(Bullet09T.StartY,MovBlt05.StartY,Bullet09T.EndY) OR
						  IsInRange(Bullet09T.StartY,MovBlt05.EndY  ,Bullet09T.EndY));

Blt05Null10     <=  IsInRange(Bullet10T.StartX,MovBlt05.EndX  ,Bullet10T.EndX) AND
						 (IsInRange(Bullet10T.StartY,MovBlt05.StartY,Bullet10T.EndY) OR
						  IsInRange(Bullet10T.StartY,MovBlt05.EndY  ,Bullet10T.EndY));

Blt05Null       <= Blt05Null06 OR
						 Blt05Null07 OR
						 Blt05Null08 OR
						 Blt05Null09 OR
						 Blt05Null10 ;

Blt05Hit        <=  IsInRange(Ship2.StartX,MovBlt05.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2.StartY,MovBlt05.StartY,Ship2.EndY) OR
						  IsInRange(Ship2.StartY,MovBlt05.EndY  ,Ship2.EndY));

Blt05HardHit    <=  IsInRange(Ship2.StartX,MovBlt05.EndX  ,Ship2.EndX) AND
						 (IsInRange(Ship2UpLim  ,MovBlt05.StartY,Ship2DwLim) OR
						  IsInRange(Ship2UpLim  ,MovBlt05.EndY  ,Ship2DwLim));

Blt05SoftHit    <=   IsInRange(Ship2.StartX,MovBlt05.EndX  ,Ship2.EndX) AND
						 ((IsInRange(Ship2.StartY,MovBlt05.StartY,Ship2UpLim)  OR
						   IsInRange(Ship2.StartY,MovBlt05.EndY  ,Ship2UpLim)) OR
						  (IsInRange(Ship2DwLim  ,MovBlt05.StartY,Ship2.EndY)  OR
						   IsInRange(Ship2DwLim  ,MovBlt05.EndY  ,Ship2.EndY)));

Collision05     <= Blt05Out    OR Blt05Hit      OR Blt05Null;
Collision05F    <= Collision05 OR Collision05E1 OR Collision05E2;

ActiveBullet05  <= ActiveBulletP1(4) AND (NOT Collision05F);

Fsm05: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet05,
				EnableMove => EnableMove,
				Collision  => Collision05F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt05(0),
				Move       => StateBlt05(1),
				Waiting    => StateBlt05(2),
				Disabling  => StateBlt05(3)
			  );

WITH StateBlt05 SELECT
NextBullet05 <= InitialBullet05 WHEN "0000",
					 NewBlt05        WHEN "0001",
					 MovBlt05        WHEN "0010",
					 PrevBullet05    WHEN "0100",
					 InitialBullet05 WHEN "1000",
					 PrevBullet05    WHEN OTHERS;

Bullet05     <= PrevBullet05;
Bullet05T    <= PrevBullet05;

--******************************************************--
-- 
-- Bullet 06 position and state Information
-- 
--******************************************************--

NewBlt06.StartX <= Int2StdVector(StdVector2Int(NewBlt06.EndX  ) - BulletSizeX,11);
NewBlt06.StartY <= Int2StdVector(StdVector2Int(Ship2.StartY   ) +          18,11);
NewBlt06.EndX   <= Int2StdVector(StdVector2Int(Ship2.StartX   ) -           1,11);
NewBlt06.EndY   <= Int2StdVector(StdVector2Int(NewBlt06.StartY) + BulletSizeY,11);

MovBlt06.StartX <= Int2StdVector(StdVector2Int(PrevBullet06.StartX) -       1,11);
MovBlt06.StartY <= PrevBullet06.StartY;
MovBlt06.EndX   <= Int2StdVector(StdVector2Int(PrevBullet06.EndX  ) -       1,11);
MovBlt06.EndY   <= PrevBullet06.EndY;

Blt06Out        <= IsInRange(Display.MinLimX,MovBlt06.EndX,Display.MinLimX);

Blt06Null01     <=  IsInRange(Bullet01T.StartX,MovBlt06.StartX,Bullet01T.EndX) AND
						 (IsInRange(Bullet01T.StartY,MovBlt06.EndY  ,Bullet01T.EndY) OR
						  IsInRange(Bullet01T.StartY,MovBlt06.StartY,Bullet01T.EndY));

Blt06Null02     <=  IsInRange(Bullet02T.StartX,MovBlt06.StartX,Bullet02T.EndX) AND
						 (IsInRange(Bullet02T.StartY,MovBlt06.EndY  ,Bullet02T.EndY) OR
						  IsInRange(Bullet02T.StartY,MovBlt06.StartY,Bullet02T.EndY));

Blt06Null03     <=  IsInRange(Bullet03T.StartX,MovBlt06.StartX,Bullet03T.EndX) AND
						 (IsInRange(Bullet03T.StartY,MovBlt06.EndY  ,Bullet03T.EndY) OR
						  IsInRange(Bullet03T.StartY,MovBlt06.StartY,Bullet03T.EndY));

Blt06Null04     <=  IsInRange(Bullet04T.StartX,MovBlt06.StartX,Bullet04T.EndX) AND
						 (IsInRange(Bullet04T.StartY,MovBlt06.EndY  ,Bullet04T.EndY) OR
						  IsInRange(Bullet04T.StartY,MovBlt06.StartY,Bullet04T.EndY));

Blt06Null05     <=  IsInRange(Bullet05T.StartX,MovBlt06.StartX,Bullet05T.EndX) AND
						 (IsInRange(Bullet05T.StartY,MovBlt06.EndY  ,Bullet05T.EndY) OR
						  IsInRange(Bullet05T.StartY,MovBlt06.StartY,Bullet05T.EndY));

Blt06Null       <= Blt06Null01 OR
						 Blt06Null02 OR
						 Blt06Null03 OR
						 Blt06Null04 OR
						 Blt06Null05 ;

Blt06Hit        <=  IsInRange(Ship1.StartX,MovBlt06.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1.StartY,MovBlt06.EndY  ,Ship1.EndY) OR
						  IsInRange(Ship1.StartY,MovBlt06.StartY,Ship1.EndY));

Blt06HardHit    <=  IsInRange(Ship1.StartX,MovBlt06.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1UpLim  ,MovBlt06.EndY  ,Ship1DwLim) OR
						  IsInRange(Ship1UpLim  ,MovBlt06.StartY,Ship1DwLim));

Blt06SoftHit    <=   IsInRange(Ship1.StartX,MovBlt06.StartX,Ship1.EndX) AND
						 ((IsInRange(Ship1.StartY,MovBlt06.EndY  ,Ship1UpLim)  OR
						   IsInRange(Ship1.StartY,MovBlt06.StartY,Ship1UpLim)) OR
						  (IsInRange(Ship1DwLim  ,MovBlt06.EndY  ,Ship1.EndY)  OR
						   IsInRange(Ship1DwLim  ,MovBlt06.StartY,Ship1.EndY)));

Collision06     <= Blt06Out    OR Blt06Hit      OR Blt06Null;
Collision06F    <= Collision06 OR Collision06E1 OR Collision06E2;

ActiveBullet06  <= ActiveBulletP2(0) AND (NOT Collision06F);

Fsm06: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet06,
				EnableMove => EnableMove,
				Collision  => Collision06F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt06(0),
				Move       => StateBlt06(1),
				Waiting    => StateBlt06(2),
				Disabling  => StateBlt06(3)
			  );

WITH StateBlt06 SELECT
NextBullet06 <= InitialBullet06 WHEN "0000",
					 NewBlt06        WHEN "0001",
					 MovBlt06        WHEN "0010",
					 PrevBullet06    WHEN "0100",
					 InitialBullet06 WHEN "1000",
					 PrevBullet06    WHEN OTHERS;

Bullet06     <= PrevBullet06;
Bullet06T    <= PrevBullet06;

--******************************************************--
-- 
-- Bullet 07 position and state Information
-- 
--******************************************************--

NewBlt07.StartX <= Int2StdVector(StdVector2Int(NewBlt07.EndX  ) - BulletSizeX,11);
NewBlt07.StartY <= Int2StdVector(StdVector2Int(Ship2.StartY   ) +          18,11);
NewBlt07.EndX   <= Int2StdVector(StdVector2Int(Ship2.StartX   ) -           1,11);
NewBlt07.EndY   <= Int2StdVector(StdVector2Int(NewBlt07.StartY) + BulletSizeY,11);

MovBlt07.StartX <= Int2StdVector(StdVector2Int(PrevBullet07.StartX) -       1,11);
MovBlt07.StartY <= PrevBullet07.StartY;
MovBlt07.EndX   <= Int2StdVector(StdVector2Int(PrevBullet07.EndX  ) -       1,11);
MovBlt07.EndY   <= PrevBullet07.EndY;

Blt07Out        <= IsInRange(Display.MinLimX,MovBlt07.EndX,Display.MinLimX);

Blt07Null01     <=  IsInRange(Bullet01T.StartX,MovBlt07.StartX,Bullet01T.EndX) AND
						 (IsInRange(Bullet01T.StartY,MovBlt07.EndY  ,Bullet01T.EndY) OR
						  IsInRange(Bullet01T.StartY,MovBlt07.StartY,Bullet01T.EndY));

Blt07Null02     <=  IsInRange(Bullet02T.StartX,MovBlt07.StartX,Bullet02T.EndX) AND
						 (IsInRange(Bullet02T.StartY,MovBlt07.EndY  ,Bullet02T.EndY) OR
						  IsInRange(Bullet02T.StartY,MovBlt07.StartY,Bullet02T.EndY));

Blt07Null03     <=  IsInRange(Bullet03T.StartX,MovBlt07.StartX,Bullet03T.EndX) AND
						 (IsInRange(Bullet03T.StartY,MovBlt07.EndY  ,Bullet03T.EndY) OR
						  IsInRange(Bullet03T.StartY,MovBlt07.StartY,Bullet03T.EndY));

Blt07Null04     <=  IsInRange(Bullet04T.StartX,MovBlt07.StartX,Bullet04T.EndX) AND
						 (IsInRange(Bullet04T.StartY,MovBlt07.EndY  ,Bullet04T.EndY) OR
						  IsInRange(Bullet04T.StartY,MovBlt07.StartY,Bullet04T.EndY));

Blt07Null05     <=  IsInRange(Bullet05T.StartX,MovBlt07.StartX,Bullet05T.EndX) AND
						 (IsInRange(Bullet05T.StartY,MovBlt07.EndY  ,Bullet05T.EndY) OR
						  IsInRange(Bullet05T.StartY,MovBlt07.StartY,Bullet05T.EndY));

Blt07Null       <= Blt07Null01 OR
						 Blt07Null02 OR
						 Blt07Null03 OR
						 Blt07Null04 OR
						 Blt07Null05 ;

Blt07Hit        <=  IsInRange(Ship1.StartX,MovBlt07.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1.StartY,MovBlt07.EndY  ,Ship1.EndY) OR
						  IsInRange(Ship1.StartY,MovBlt07.StartY,Ship1.EndY));

Blt07HardHit    <=  IsInRange(Ship1.StartX,MovBlt07.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1UpLim  ,MovBlt07.EndY  ,Ship1DwLim) OR
						  IsInRange(Ship1UpLim  ,MovBlt07.StartY,Ship1DwLim));

Blt07SoftHit    <=   IsInRange(Ship1.StartX,MovBlt07.StartX,Ship1.EndX) AND
						 ((IsInRange(Ship1.StartY,MovBlt07.EndY  ,Ship1UpLim)  OR
						   IsInRange(Ship1.StartY,MovBlt07.StartY,Ship1UpLim)) OR
						  (IsInRange(Ship1DwLim  ,MovBlt07.EndY  ,Ship1.EndY)  OR
						   IsInRange(Ship1DwLim  ,MovBlt07.StartY,Ship1.EndY)));

Collision07     <= Blt07Out    OR Blt07Hit      OR Blt07Null;
Collision07F    <= Collision07 OR Collision07E1 OR Collision07E2;

ActiveBullet07  <= ActiveBulletP2(1) AND (NOT Collision07F);

Fsm07: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet07,
				EnableMove => EnableMove,
				Collision  => Collision07F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt07(0),
				Move       => StateBlt07(1),
				Waiting    => StateBlt07(2),
				Disabling  => StateBlt07(3)
			  );

WITH StateBlt07 SELECT
NextBullet07 <= InitialBullet07 WHEN "0000",
					 NewBlt07        WHEN "0001",
					 MovBlt07        WHEN "0010",
					 PrevBullet07    WHEN "0100",
					 InitialBullet07 WHEN "1000",
					 PrevBullet07    WHEN OTHERS;

Bullet07     <= PrevBullet07;
Bullet07T    <= PrevBullet07;

--******************************************************--
-- 
-- Bullet 08 position and state Information
-- 
--******************************************************--

NewBlt08.StartX <= Int2StdVector(StdVector2Int(NewBlt08.EndX  ) - BulletSizeX,11);
NewBlt08.StartY <= Int2StdVector(StdVector2Int(Ship2.StartY   ) +          18,11);
NewBlt08.EndX   <= Int2StdVector(StdVector2Int(Ship2.StartX   ) -           1,11);
NewBlt08.EndY   <= Int2StdVector(StdVector2Int(NewBlt08.StartY) + BulletSizeY,11);

MovBlt08.StartX <= Int2StdVector(StdVector2Int(PrevBullet08.StartX) -       1,11);
MovBlt08.StartY <= PrevBullet08.StartY;
MovBlt08.EndX   <= Int2StdVector(StdVector2Int(PrevBullet08.EndX  ) -       1,11);
MovBlt08.EndY   <= PrevBullet08.EndY;

Blt08Out        <= IsInRange(Display.MinLimX,MovBlt08.EndX,Display.MinLimX);

Blt08Null01     <=  IsInRange(Bullet01T.StartX,MovBlt08.StartX,Bullet01T.EndX) AND
						 (IsInRange(Bullet01T.StartY,MovBlt08.EndY  ,Bullet01T.EndY) OR
						  IsInRange(Bullet01T.StartY,MovBlt08.StartY,Bullet01T.EndY));

Blt08Null02     <=  IsInRange(Bullet02T.StartX,MovBlt08.StartX,Bullet02T.EndX) AND
						 (IsInRange(Bullet02T.StartY,MovBlt08.EndY  ,Bullet02T.EndY) OR
						  IsInRange(Bullet02T.StartY,MovBlt08.StartY,Bullet02T.EndY));

Blt08Null03     <=  IsInRange(Bullet03T.StartX,MovBlt08.StartX,Bullet03T.EndX) AND
						 (IsInRange(Bullet03T.StartY,MovBlt08.EndY  ,Bullet03T.EndY) OR
						  IsInRange(Bullet03T.StartY,MovBlt08.StartY,Bullet03T.EndY));

Blt08Null04     <=  IsInRange(Bullet04T.StartX,MovBlt08.StartX,Bullet04T.EndX) AND
						 (IsInRange(Bullet04T.StartY,MovBlt08.EndY  ,Bullet04T.EndY) OR
						  IsInRange(Bullet04T.StartY,MovBlt08.StartY,Bullet04T.EndY));

Blt08Null05     <=  IsInRange(Bullet05T.StartX,MovBlt08.StartX,Bullet05T.EndX) AND
						 (IsInRange(Bullet05T.StartY,MovBlt08.EndY  ,Bullet05T.EndY) OR
						  IsInRange(Bullet05T.StartY,MovBlt08.StartY,Bullet05T.EndY));

Blt08Null       <= Blt08Null01 OR
						 Blt08Null02 OR
						 Blt08Null03 OR
						 Blt08Null04 OR
						 Blt08Null05 ;

Blt08Hit        <=  IsInRange(Ship1.StartX,MovBlt08.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1.StartY,MovBlt08.EndY  ,Ship1.EndY) OR
						  IsInRange(Ship1.StartY,MovBlt08.StartY,Ship1.EndY));

Blt08HardHit    <=  IsInRange(Ship1.StartX,MovBlt08.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1UpLim  ,MovBlt08.EndY  ,Ship1DwLim) OR
						  IsInRange(Ship1UpLim  ,MovBlt08.StartY,Ship1DwLim));

Blt08SoftHit    <=   IsInRange(Ship1.StartX,MovBlt08.StartX,Ship1.EndX) AND
						 ((IsInRange(Ship1.StartY,MovBlt08.EndY  ,Ship1UpLim)  OR
						   IsInRange(Ship1.StartY,MovBlt08.StartY,Ship1UpLim)) OR
						  (IsInRange(Ship1DwLim  ,MovBlt08.EndY  ,Ship1.EndY)  OR
						   IsInRange(Ship1DwLim  ,MovBlt08.StartY,Ship1.EndY)));

Collision08     <= Blt08Out    OR Blt08Hit      OR Blt08Null;
Collision08F    <= Collision08 OR Collision08E1 OR Collision08E2;

ActiveBullet08  <= ActiveBulletP2(2) AND (NOT Collision08F);

Fsm08: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet08,
				EnableMove => EnableMove,
				Collision  => Collision08F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt08(0),
				Move       => StateBlt08(1),
				Waiting    => StateBlt08(2),
				Disabling  => StateBlt08(3)
			  );

WITH StateBlt08 SELECT
NextBullet08 <= InitialBullet08 WHEN "0000",
					 NewBlt08        WHEN "0001",
					 MovBlt08        WHEN "0010",
					 PrevBullet08    WHEN "0100",
					 InitialBullet08 WHEN "1000",
					 PrevBullet08    WHEN OTHERS;

Bullet08     <= PrevBullet08;
Bullet08T    <= PrevBullet08;

--******************************************************--
-- 
-- Bullet 09 position and state Information
-- 
--******************************************************--

NewBlt09.StartX <= Int2StdVector(StdVector2Int(NewBlt09.EndX  ) - BulletSizeX,11);
NewBlt09.StartY <= Int2StdVector(StdVector2Int(Ship2.StartY   ) +          18,11);
NewBlt09.EndX   <= Int2StdVector(StdVector2Int(Ship2.StartX   ) -           1,11);
NewBlt09.EndY   <= Int2StdVector(StdVector2Int(NewBlt09.StartY) + BulletSizeY,11);

MovBlt09.StartX <= Int2StdVector(StdVector2Int(PrevBullet09.StartX) -       1,11);
MovBlt09.StartY <= PrevBullet09.StartY;
MovBlt09.EndX   <= Int2StdVector(StdVector2Int(PrevBullet09.EndX  ) -       1,11);
MovBlt09.EndY   <= PrevBullet09.EndY;

Blt09Out        <= IsInRange(Display.MinLimX,MovBlt09.EndX,Display.MinLimX);

Blt09Null01     <=  IsInRange(Bullet01T.StartX,MovBlt09.StartX,Bullet01T.EndX) AND
						 (IsInRange(Bullet01T.StartY,MovBlt09.EndY  ,Bullet01T.EndY) OR
						  IsInRange(Bullet01T.StartY,MovBlt09.StartY,Bullet01T.EndY));

Blt09Null02     <=  IsInRange(Bullet02T.StartX,MovBlt09.StartX,Bullet02T.EndX) AND
						 (IsInRange(Bullet02T.StartY,MovBlt09.EndY  ,Bullet02T.EndY) OR
						  IsInRange(Bullet02T.StartY,MovBlt09.StartY,Bullet02T.EndY));

Blt09Null03     <=  IsInRange(Bullet03T.StartX,MovBlt09.StartX,Bullet03T.EndX) AND
						 (IsInRange(Bullet03T.StartY,MovBlt09.EndY  ,Bullet03T.EndY) OR
						  IsInRange(Bullet03T.StartY,MovBlt09.StartY,Bullet03T.EndY));

Blt09Null04     <=  IsInRange(Bullet04T.StartX,MovBlt09.StartX,Bullet04T.EndX) AND
						 (IsInRange(Bullet04T.StartY,MovBlt09.EndY  ,Bullet04T.EndY) OR
						  IsInRange(Bullet04T.StartY,MovBlt09.StartY,Bullet04T.EndY));

Blt09Null05     <=  IsInRange(Bullet05T.StartX,MovBlt09.StartX,Bullet05T.EndX) AND
						 (IsInRange(Bullet05T.StartY,MovBlt09.EndY  ,Bullet05T.EndY) OR
						  IsInRange(Bullet05T.StartY,MovBlt09.StartY,Bullet05T.EndY));

Blt09Null       <= Blt09Null01 OR
						 Blt09Null02 OR
						 Blt09Null03 OR
						 Blt09Null04 OR
						 Blt09Null05 ;

Blt09Hit        <=  IsInRange(Ship1.StartX,MovBlt09.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1.StartY,MovBlt09.EndY  ,Ship1.EndY) OR
						  IsInRange(Ship1.StartY,MovBlt09.StartY,Ship1.EndY));

Blt09HardHit    <=  IsInRange(Ship1.StartX,MovBlt09.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1UpLim  ,MovBlt09.EndY  ,Ship1DwLim) OR
						  IsInRange(Ship1UpLim  ,MovBlt09.StartY,Ship1DwLim));

Blt09SoftHit    <=   IsInRange(Ship1.StartX,MovBlt09.StartX,Ship1.EndX) AND
						 ((IsInRange(Ship1.StartY,MovBlt09.EndY  ,Ship1UpLim)  OR
						   IsInRange(Ship1.StartY,MovBlt09.StartY,Ship1UpLim)) OR
						  (IsInRange(Ship1DwLim  ,MovBlt09.EndY  ,Ship1.EndY)  OR
						   IsInRange(Ship1DwLim  ,MovBlt09.StartY,Ship1.EndY)));

Collision09     <= Blt09Out    OR Blt09Hit      OR Blt09Null;
Collision09F    <= Collision09 OR Collision09E1 OR Collision09E2;

ActiveBullet09  <= ActiveBulletP2(3) AND (NOT Collision09F);

Fsm09: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet09,
				EnableMove => EnableMove,
				Collision  => Collision09F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt09(0),
				Move       => StateBlt09(1),
				Waiting    => StateBlt09(2),
				Disabling  => StateBlt09(3)
			  );

WITH StateBlt09 SELECT
NextBullet09 <= InitialBullet09 WHEN "0000",
					 NewBlt09        WHEN "0001",
					 MovBlt09        WHEN "0010",
					 PrevBullet09    WHEN "0100",
					 InitialBullet09 WHEN "1000",
					 PrevBullet09    WHEN OTHERS;

Bullet09     <= PrevBullet09;
Bullet09T    <= PrevBullet09;

--******************************************************--
-- 
-- Bullet 10 position and state Information
-- 
--******************************************************--

NewBlt10.StartX <= Int2StdVector(StdVector2Int(NewBlt10.EndX  ) - BulletSizeX,11);
NewBlt10.StartY <= Int2StdVector(StdVector2Int(Ship2.StartY   ) +          18,11);
NewBlt10.EndX   <= Int2StdVector(StdVector2Int(Ship2.StartX   ) -           1,11);
NewBlt10.EndY   <= Int2StdVector(StdVector2Int(NewBlt10.StartY) + BulletSizeY,11);

MovBlt10.StartX <= Int2StdVector(StdVector2Int(PrevBullet10.StartX) -       1,11);
MovBlt10.StartY <= PrevBullet10.StartY;
MovBlt10.EndX   <= Int2StdVector(StdVector2Int(PrevBullet10.EndX  ) -       1,11);
MovBlt10.EndY   <= PrevBullet10.EndY;

Blt10Out        <= IsInRange(Display.MinLimX,MovBlt10.EndX,Display.MinLimX);

Blt10Null01     <=  IsInRange(Bullet01T.StartX,MovBlt10.StartX,Bullet01T.EndX) AND
						 (IsInRange(Bullet01T.StartY,MovBlt10.EndY  ,Bullet01T.EndY) OR
						  IsInRange(Bullet01T.StartY,MovBlt10.StartY,Bullet01T.EndY));

Blt10Null02     <=  IsInRange(Bullet02T.StartX,MovBlt10.StartX,Bullet02T.EndX) AND
						 (IsInRange(Bullet02T.StartY,MovBlt10.EndY  ,Bullet02T.EndY) OR
						  IsInRange(Bullet02T.StartY,MovBlt10.StartY,Bullet02T.EndY));

Blt10Null03     <=  IsInRange(Bullet03T.StartX,MovBlt10.StartX,Bullet03T.EndX) AND
						 (IsInRange(Bullet03T.StartY,MovBlt10.EndY  ,Bullet03T.EndY) OR
						  IsInRange(Bullet03T.StartY,MovBlt10.StartY,Bullet03T.EndY));

Blt10Null04     <=  IsInRange(Bullet04T.StartX,MovBlt10.StartX,Bullet04T.EndX) AND
						 (IsInRange(Bullet04T.StartY,MovBlt10.EndY  ,Bullet04T.EndY) OR
						  IsInRange(Bullet04T.StartY,MovBlt10.StartY,Bullet04T.EndY));

Blt10Null05     <=  IsInRange(Bullet05T.StartX,MovBlt10.StartX,Bullet05T.EndX) AND
						 (IsInRange(Bullet05T.StartY,MovBlt10.EndY  ,Bullet05T.EndY) OR
						  IsInRange(Bullet05T.StartY,MovBlt10.StartY,Bullet05T.EndY));

Blt10Null       <= Blt10Null01 OR
						 Blt10Null02 OR
						 Blt10Null03 OR
						 Blt10Null04 OR
						 Blt10Null05 ;

Blt10Hit        <=  IsInRange(Ship1.StartX,MovBlt10.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1.StartY,MovBlt10.EndY  ,Ship1.EndY) OR
						  IsInRange(Ship1.StartY,MovBlt10.StartY,Ship1.EndY));

Blt10HardHit    <=  IsInRange(Ship1.StartX,MovBlt10.StartX,Ship1.EndX) AND
						 (IsInRange(Ship1UpLim  ,MovBlt10.EndY  ,Ship1DwLim) OR
						  IsInRange(Ship1UpLim  ,MovBlt10.StartY,Ship1DwLim));

Blt10SoftHit    <=   IsInRange(Ship1.StartX,MovBlt10.StartX,Ship1.EndX) AND
						 ((IsInRange(Ship1.StartY,MovBlt10.EndY  ,Ship1UpLim)  OR
						   IsInRange(Ship1.StartY,MovBlt10.StartY,Ship1UpLim)) OR
						  (IsInRange(Ship1DwLim  ,MovBlt10.EndY  ,Ship1.EndY)  OR
						   IsInRange(Ship1DwLim  ,MovBlt10.StartY,Ship1.EndY)));

Collision10     <= Blt10Out    OR Blt10Hit      OR Blt10Null;
Collision10F    <= Collision10 OR Collision10E1 OR Collision10E2;

ActiveBullet10  <= ActiveBulletP2(4) AND (NOT Collision10F);

Fsm10: ENTITY WORK.BulletFsm 
PORT MAP	  (Pulse      => ActiveBullet10,
				EnableMove => EnableMove,
				Collision  => Collision10F,
				Reset      => ResetG,
				Clk        => Clk,
				Standby    => StateBlt10(0),
				Move       => StateBlt10(1),
				Waiting    => StateBlt10(2),
				Disabling  => StateBlt10(3)
			  );

WITH StateBlt10 SELECT
NextBullet10 <= InitialBullet10 WHEN "0000",
					 NewBlt10        WHEN "0001",
					 MovBlt10        WHEN "0010",
					 PrevBullet10    WHEN "0100",
					 InitialBullet10 WHEN "1000",
					 PrevBullet10    WHEN OTHERS;

Bullet10     <= PrevBullet10;
Bullet10T    <= PrevBullet10;

--******************************************************--
-- 
-- Bullet 10 position and state Information
-- 
--******************************************************--

HardHitToP2 <= (Blt01HardHit) &
					(Blt02HardHit) &
					(Blt03HardHit) &
					(Blt04HardHit) &
					(Blt05HardHit) ;

HardHitToP1 <= (Blt06HardHit) &
					(Blt07HardHit) &
					(Blt08HardHit) &
					(Blt09HardHit) &
					(Blt10HardHit) ;

WITH HardHitToP1 SELECT
HardDmgP1  <= "01" WHEN "00001",
				  "01" WHEN "00010",
				  "10" WHEN "00011",
				  "10" WHEN "00100",
				  "10" WHEN "00101",
				  "10" WHEN "00110",
				  "11" WHEN "00111",
				  "01" WHEN "01000",
				  "10" WHEN "01001",
				  "10" WHEN "01010",
				  "11" WHEN "01011",
				  "10" WHEN "01100",
				  "11" WHEN "01101",
				  "11" WHEN "01110",
				  "11" WHEN "01111",
				  "01" WHEN "10000",
				  "10" WHEN "10001",
				  "10" WHEN "10010",
				  "11" WHEN "10011",
				  "10" WHEN "10100",
				  "11" WHEN "10101",
				  "11" WHEN "10110",
				  "11" WHEN "10111",
				  "10" WHEN "11000",
				  "11" WHEN "11001",
				  "11" WHEN "11010",
				  "11" WHEN "11011",
				  "11" WHEN "11100",
				  "11" WHEN "11101",
				  "11" WHEN "11110",
				  "11" WHEN "11111",
				  "00" WHEN OTHERS;

WITH HardHitToP2 SELECT
HardDmgP2  <= "01" WHEN "00001",
				  "01" WHEN "00010",
				  "10" WHEN "00011",
				  "10" WHEN "00100",
				  "10" WHEN "00101",
				  "10" WHEN "00110",
				  "11" WHEN "00111",
				  "01" WHEN "01000",
				  "10" WHEN "01001",
				  "10" WHEN "01010",
				  "11" WHEN "01011",
				  "10" WHEN "01100",
				  "11" WHEN "01101",
				  "11" WHEN "01110",
				  "11" WHEN "01111",
				  "01" WHEN "10000",
				  "10" WHEN "10001",
				  "10" WHEN "10010",
				  "11" WHEN "10011",
				  "10" WHEN "10100",
				  "11" WHEN "10101",
				  "11" WHEN "10110",
				  "11" WHEN "10111",
				  "10" WHEN "11000",
				  "11" WHEN "11001",
				  "11" WHEN "11010",
				  "11" WHEN "11011",
				  "11" WHEN "11100",
				  "11" WHEN "11101",
				  "11" WHEN "11110",
				  "11" WHEN "11111",
				  "00" WHEN OTHERS;

SoftHitToP2 <= (Blt01SoftHit) &
					(Blt02SoftHit) &
					(Blt03SoftHit) &
					(Blt04SoftHit) &
					(Blt05SoftHit) ;

SoftHitToP1 <= (Blt06SoftHit) &
					(Blt07SoftHit) &
					(Blt08SoftHit) &
					(Blt09SoftHit) &
					(Blt10SoftHit) ;

WITH SoftHitToP1 SELECT
SoftDmgP1  <= "01" WHEN "00001",
				  "01" WHEN "00010",
				  "10" WHEN "00011",
				  "10" WHEN "00100",
				  "10" WHEN "00101",
				  "10" WHEN "00110",
				  "11" WHEN "00111",
				  "01" WHEN "01000",
				  "10" WHEN "01001",
				  "10" WHEN "01010",
				  "11" WHEN "01011",
				  "10" WHEN "01100",
				  "11" WHEN "01101",
				  "11" WHEN "01110",
				  "11" WHEN "01111",
				  "01" WHEN "10000",
				  "10" WHEN "10001",
				  "10" WHEN "10010",
				  "11" WHEN "10011",
				  "10" WHEN "10100",
				  "11" WHEN "10101",
				  "11" WHEN "10110",
				  "11" WHEN "10111",
				  "10" WHEN "11000",
				  "11" WHEN "11001",
				  "11" WHEN "11010",
				  "11" WHEN "11011",
				  "11" WHEN "11100",
				  "11" WHEN "11101",
				  "11" WHEN "11110",
				  "11" WHEN "11111",
				  "00" WHEN OTHERS;

WITH SoftHitToP2 SELECT
SoftDmgP2  <= "01" WHEN "00001",
				  "01" WHEN "00010",
				  "10" WHEN "00011",
				  "10" WHEN "00100",
				  "10" WHEN "00101",
				  "10" WHEN "00110",
				  "11" WHEN "00111",
				  "01" WHEN "01000",
				  "10" WHEN "01001",
				  "10" WHEN "01010",
				  "11" WHEN "01011",
				  "10" WHEN "01100",
				  "11" WHEN "01101",
				  "11" WHEN "01110",
				  "11" WHEN "01111",
				  "01" WHEN "10000",
				  "10" WHEN "10001",
				  "10" WHEN "10010",
				  "11" WHEN "10011",
				  "10" WHEN "10100",
				  "11" WHEN "10101",
				  "11" WHEN "10110",
				  "11" WHEN "10111",
				  "10" WHEN "11000",
				  "11" WHEN "11001",
				  "11" WHEN "11010",
				  "11" WHEN "11011",
				  "11" WHEN "11100",
				  "11" WHEN "11101",
				  "11" WHEN "11110",
				  "11" WHEN "11111",
				  "00" WHEN OTHERS;


BasicDmgP1 <= HardDmgP1 & SoftDmgP1;
BasicDmgP2 <= HardDmgP2 & SoftDmgP2;

--******************************************************--
-- 
-- Bullets Control
-- 
--******************************************************--

DisableBulletP1    <= Collision05F & Collision04F & Collision03F & Collision02F & Collision01F;
DisableBulletP2    <= Collision10F & Collision09F & Collision08F & Collision07F & Collision06F;

EnaBullet          <= (NOT StateBlt10(3)) &
							 (NOT StateBlt09(3)) &
							 (NOT StateBlt08(3)) &
							 (NOT StateBlt07(3)) &
							 (NOT StateBlt06(3)) &
							 (NOT StateBlt05(3)) &
							 (NOT StateBlt04(3)) &
							 (NOT StateBlt03(3)) &
							 (NOT StateBlt02(3)) &
							 (NOT StateBlt01(3)) ;

BcP1: ENTITY WORK.BulletControl 
PORT MAP	  (PlayerP => Player1P,
				DisB    => DisableBulletP1,
				Reset   => ResetG,
				Clk     => Clk,
				ActiveB => ActiveBulletP1
			  );

BcP2: ENTITY WORK.BulletControl 
PORT MAP	  (PlayerP => Player2P,
				DisB    => DisableBulletP2,
				Reset   => ResetG,
				Clk     => Clk,
				ActiveB => ActiveBulletP2
			  );

--******************************************************--
-- 
-- Bullet speed counter
-- 
--******************************************************--

BulletSpeedCounter: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => BlltCounterSize
			  )
PORT MAP	  (Data     => ZeroCount,
				Clk      => Clk,
				MR       => Reset,
				SR       => '0',
				Ena      => '1',
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => BulletSpd,
				MaxCount => EnableMove,
				MinCount => OPEN,
				Count    => OPEN
			  );

--******************************************************--
-- 
-- Bullet object memory
--
-- Collision and Collision Echoes memories
-- 
--******************************************************--

PROCESS(Clk, ResetG, NextBullet01)

BEGIN
	
	IF(ResetG='1')THEN
		
		Collision01E1 <= '0';
		Collision01E2 <= '0';
		Collision02E1 <= '0';
		Collision02E2 <= '0';
		Collision03E1 <= '0';
		Collision03E2 <= '0';
		Collision04E1 <= '0';
		Collision04E2 <= '0';
		Collision05E1 <= '0';
		Collision05E2 <= '0';
		Collision06E1 <= '0';
		Collision06E2 <= '0';
		Collision07E1 <= '0';
		Collision07E2 <= '0';
		Collision08E1 <= '0';
		Collision08E2 <= '0';
		Collision09E1 <= '0';
		Collision09E2 <= '0';
		Collision10E1 <= '0';
		Collision10E2 <= '0';
		PrevBullet01  <= InitialBullet01;
		PrevBullet02  <= InitialBullet02;
		PrevBullet03  <= InitialBullet03;
		PrevBullet04  <= InitialBullet04;
		PrevBullet05  <= InitialBullet05;
		PrevBullet06  <= InitialBullet06;
		PrevBullet07  <= InitialBullet07;
		PrevBullet08  <= InitialBullet08;
		PrevBullet09  <= InitialBullet09;
		PrevBullet10  <= InitialBullet10;
		
	ELSIF(Rising_Edge(Clk))THEN
		
		Collision01E1 <= Collision01;
		Collision01E2 <= Collision01E1;
		Collision02E1 <= Collision02;
		Collision02E2 <= Collision02E1;
		Collision03E1 <= Collision03;
		Collision03E2 <= Collision03E1;
		Collision04E1 <= Collision04;
		Collision04E2 <= Collision04E1;
		Collision05E1 <= Collision05;
		Collision05E2 <= Collision05E1;
		Collision06E1 <= Collision06;
		Collision06E2 <= Collision06E1;
		Collision07E1 <= Collision07;
		Collision07E2 <= Collision07E1;
		Collision08E1 <= Collision08;
		Collision08E2 <= Collision08E1;
		Collision09E1 <= Collision09;
		Collision09E2 <= Collision09E1;
		Collision10E1 <= Collision10;
		Collision10E2 <= Collision10E1;
		PrevBullet01  <= NextBullet01;
		PrevBullet02  <= NextBullet02;
		PrevBullet03  <= NextBullet03;
		PrevBullet04  <= NextBullet04;
		PrevBullet05  <= NextBullet05;
		PrevBullet06  <= NextBullet06;
		PrevBullet07  <= NextBullet07;
		PrevBullet08  <= NextBullet08;
		PrevBullet09  <= NextBullet09;
		PrevBullet10  <= NextBullet10;
		
	END IF;
	
END PROCESS;


--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.BulletsPosition 
--GENERIC MAP(BlltCounterSize => #
--			  )
--PORT MAP	  (Player1P   => SLV,
--				Player2P   => SLV,
--				Ship1      => SLV,
--				Ship2      => SLV,
--				BulletSpd  => SLV,
--				Clk        => SLV,
--				Reset      => SLV,
--				GameRst    => SLV,
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
--				BasicDmgP1 => SLV,
--				BasicDmgP2 => SLV,
--				EnaBullet  => SLV
--			  );
--******************************************************--

END BulletsPositionArch;