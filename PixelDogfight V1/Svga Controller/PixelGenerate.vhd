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
USE IEEE.NUMERIC_STD.ALL;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.ALL;

USE WORK.MyGamePackage.ALL;
USE WORK.MyGraphs     .ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY PixelGenerate IS
	
	PORT	 (
				PosX      : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
				PosY      : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
				VideoOn   : IN  STD_LOGIC;
				Bullet01  : IN  Object;
				Bullet02  : IN  Object;
				Bullet03  : IN  Object;
				Bullet04  : IN  Object;
				Bullet05  : IN  Object;
				Bullet06  : IN  Object;
				Bullet07  : IN  Object;
				Bullet08  : IN  Object;
				Bullet09  : IN  Object;
				Bullet10  : IN  Object;
				Score1    : IN  Object;
				Score2    : IN  Object;
				HP11      : IN  Object;
				HP12      : IN  Object;
				HP13      : IN  Object;
				HP21      : IN  Object;
				HP22      : IN  Object;
				HP23      : IN  Object;
				Ship1     : IN  Object;
				Ship2     : IN  Object;
				EnaBullet : IN  STD_LOGIC_VECTOR( 9 DOWNTO 0);
				NumValues : IN  DecimalValue;
				R         : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
				G         : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
				B         : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)
			 );
	
END ENTITY PixelGenerate;

ARCHITECTURE PixelGenerateArch OF PixelGenerate IS

CONSTANT Obj            : INTEGER                        := (20 - 1);
CONSTANT PureBlack      : STD_LOGIC_VECTOR(  7 DOWNTO 0) := "0000"&"0000";
SIGNAL   Background     : Color;

SIGNAL   Separator      : STD_LOGIC;

SIGNAL   FigureBullet01 : Color;
SIGNAL   TBullet01      : Color;
SIGNAL   FBullet01      : Color;

SIGNAL   FigureBullet02 : Color;
SIGNAL   TBullet02      : Color;
SIGNAL   FBullet02      : Color;

SIGNAL   FigureBullet03 : Color;
SIGNAL   TBullet03      : Color;
SIGNAL   FBullet03      : Color;

SIGNAL   FigureBullet04 : Color;
SIGNAL   TBullet04      : Color;
SIGNAL   FBullet04      : Color;

SIGNAL   FigureBullet05 : Color;
SIGNAL   TBullet05      : Color;
SIGNAL   FBullet05      : Color;

SIGNAL   FigureBullet06 : Color;
SIGNAL   TBullet06      : Color;
SIGNAL   FBullet06      : Color;

SIGNAL   FigureBullet07 : Color;
SIGNAL   TBullet07      : Color;
SIGNAL   FBullet07      : Color;

SIGNAL   FigureBullet08 : Color;
SIGNAL   TBullet08      : Color;
SIGNAL   FBullet08      : Color;

SIGNAL   FigureBullet09 : Color;
SIGNAL   TBullet09      : Color;
SIGNAL   FBullet09      : Color;

SIGNAL   FigureBullet10 : Color;
SIGNAL   TBullet10      : Color;
SIGNAL   FBullet10      : Color;

SIGNAL   FigureScore1   : Color;
SIGNAL   FScore1        : Color;

SIGNAL   FigureScore2   : Color;
SIGNAL   FScore2        : Color;

SIGNAL   FigureHP11     : Color;
SIGNAL   FHP11          : Color;

SIGNAL   FigureHP12     : Color;
SIGNAL   FHP12          : Color;

SIGNAL   FigureHP13     : Color;
SIGNAL   FHP13          : Color;

SIGNAL   FigureHP21     : Color;
SIGNAL   FHP21          : Color;

SIGNAL   FigureHP22     : Color;
SIGNAL   FHP22          : Color;

SIGNAL   FigureHP23     : Color;
SIGNAL   FHP23          : Color;

SIGNAL   FigureShip1    : Color;
SIGNAL   FShip1         : Color;

SIGNAL   FigureShip2    : Color;
SIGNAL   FShip2         : Color;

SIGNAL   IsNull         : STD_LOGIC_VECTOR(Obj DOWNTO 0);
SIGNAL   PrintObject    : STD_LOGIC_VECTOR(Obj DOWNTO 0);

SIGNAL   RScreen        : STD_LOGIC_VECTOR(  7 DOWNTO 0);
SIGNAL   GScreen        : STD_LOGIC_VECTOR(  7 DOWNTO 0);
SIGNAL   BScreen        : STD_LOGIC_VECTOR(  7 DOWNTO 0);

BEGIN

--*************************************************************************************--
-- 
-- 
-- 
--*************************************************************************************--

Separator <= IsInRange(Display.GameZoneY,PosY,Display.GameZoneY);

WITH Separator SELECT
Background       <= BackgroundSpaceColor WHEN '0',
						  NumbersColor         WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 1st Bullet
-- 
--*************************************************************************************--

PrintObject(0)   <= IsInRange(Bullet01.StartX,PosX,Bullet01.EndX) AND 
					     IsInRange(Bullet01.StartY,PosY,Bullet01.EndY);

FigureBullet01.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet01.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet01.StartX));

FigureBullet01.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet01.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet01.StartX));

FigureBullet01.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet01.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet01.StartX));

IsNull(0)        <= IsTransparent(FigureBullet01);

WITH IsNull(0) SELECT
TBullet01 <= FigureBullet01 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(0) SELECT
FBullet01 <= TBullet01      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 2nd Bullet
-- 
--*************************************************************************************--

PrintObject(1)   <= IsInRange(Bullet02.StartX,PosX,Bullet02.EndX) AND 
					     IsInRange(Bullet02.StartY,PosY,Bullet02.EndY);

FigureBullet02.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet02.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet02.StartX));

FigureBullet02.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet02.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet02.StartX));

FigureBullet02.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet02.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet02.StartX));

IsNull(1)        <= IsTransparent(FigureBullet02);

WITH IsNull(1) SELECT
TBullet02 <= FigureBullet02 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(1) SELECT
FBullet02 <= TBullet02      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 3th Bullet
-- 
--*************************************************************************************--

PrintObject(2)   <= IsInRange(Bullet03.StartX,PosX,Bullet03.EndX) AND 
					     IsInRange(Bullet03.StartY,PosY,Bullet03.EndY);

FigureBullet03.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet03.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet03.StartX));

FigureBullet03.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet03.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet03.StartX));

FigureBullet03.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet03.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet03.StartX));

IsNull(2)        <= IsTransparent(FigureBullet03);

WITH IsNull(2) SELECT
TBullet03 <= FigureBullet03 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(2) SELECT
FBullet03 <= TBullet03      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 4th Bullet
-- 
--*************************************************************************************--

PrintObject(3)   <= IsInRange(Bullet04.StartX,PosX,Bullet04.EndX) AND 
					     IsInRange(Bullet04.StartY,PosY,Bullet04.EndY);

FigureBullet04.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet04.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet04.StartX));

FigureBullet04.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet04.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet04.StartX));

FigureBullet04.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet04.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet04.StartX));

IsNull(3)        <= IsTransparent(FigureBullet04);

WITH IsNull(3) SELECT
TBullet04 <= FigureBullet04 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(3) SELECT
FBullet04 <= TBullet04      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 5th Bullet
-- 
--*************************************************************************************--

PrintObject(4)   <= IsInRange(Bullet05.StartX,PosX,Bullet05.EndX) AND 
					     IsInRange(Bullet05.StartY,PosY,Bullet05.EndY);

FigureBullet05.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet05.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet05.StartX));

FigureBullet05.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet05.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet05.StartX));

FigureBullet05.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet05.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet05.StartX));

IsNull(4)        <= IsTransparent(FigureBullet05);

WITH IsNull(4) SELECT
TBullet05 <= FigureBullet05 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(4) SELECT
FBullet05 <= TBullet05      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 6th Bullet
-- 
--*************************************************************************************--

PrintObject(5)   <= IsInRange(Bullet06.StartX,PosX,Bullet06.EndX) AND 
					     IsInRange(Bullet06.StartY,PosY,Bullet06.EndY);

FigureBullet06.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet06.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet06.StartX));

FigureBullet06.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet06.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet06.StartX));

FigureBullet06.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet06.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet06.StartX));

IsNull(5)        <= IsTransparent(FigureBullet06);

WITH IsNull(5) SELECT
TBullet06 <= FigureBullet06 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(5) SELECT
FBullet06 <= TBullet06      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 7th Bullet
-- 
--*************************************************************************************--

PrintObject(6)   <= IsInRange(Bullet07.StartX,PosX,Bullet07.EndX) AND 
					     IsInRange(Bullet07.StartY,PosY,Bullet07.EndY);

FigureBullet07.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet07.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet07.StartX));

FigureBullet07.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet07.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet07.StartX));

FigureBullet07.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet07.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet07.StartX));

IsNull(6)        <= IsTransparent(FigureBullet07);

WITH IsNull(6) SELECT
TBullet07 <= FigureBullet07 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(6) SELECT
FBullet07 <= TBullet07      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 8th Bullet
-- 
--*************************************************************************************--

PrintObject(7)   <= IsInRange(Bullet08.StartX,PosX,Bullet08.EndX) AND 
					     IsInRange(Bullet08.StartY,PosY,Bullet08.EndY);

FigureBullet08.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet08.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet08.StartX));

FigureBullet08.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet08.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet08.StartX));

FigureBullet08.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet08.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet08.StartX));

IsNull(7)        <= IsTransparent(FigureBullet08);

WITH IsNull(7) SELECT
TBullet08 <= FigureBullet08 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(7) SELECT
FBullet08 <= TBullet08      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 9th Bullet
-- 
--*************************************************************************************--

PrintObject(8)   <= IsInRange(Bullet09.StartX,PosX,Bullet09.EndX) AND 
					     IsInRange(Bullet09.StartY,PosY,Bullet09.EndY);

FigureBullet09.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet09.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet09.StartX));

FigureBullet09.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet09.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet09.StartX));

FigureBullet09.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet09.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet09.StartX));

IsNull(8)        <= IsTransparent(FigureBullet09);

WITH IsNull(8) SELECT
TBullet09 <= FigureBullet09 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(8) SELECT
FBullet09 <= TBullet09      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the 10th Bullet
-- 
--*************************************************************************************--

PrintObject(9)   <= IsInRange(Bullet10.StartX,PosX,Bullet10.EndX) AND 
					     IsInRange(Bullet10.StartY,PosY,Bullet10.EndY);

FigureBullet10.R <= FigureBulletR(StdVector2Int(PosY) - StdVector2Int(Bullet10.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet10.StartX));

FigureBullet10.G <= FigureBulletG(StdVector2Int(PosY) - StdVector2Int(Bullet10.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet10.StartX));

FigureBullet10.B <= FigureBulletB(StdVector2Int(PosY) - StdVector2Int(Bullet10.StartY),
										    StdVector2Int(PosX) - StdVector2Int(Bullet10.StartX));

IsNull(9)        <= IsTransparent(FigureBullet10);

WITH IsNull(9) SELECT
TBullet10 <= FigureBullet10 WHEN '0',
			    Background     WHEN OTHERS;

WITH EnaBullet(9) SELECT
FBullet10 <= TBullet10      WHEN '1',
				 Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Score for player 1
-- 
--*************************************************************************************--

PrintObject(10)  <= IsInRange(Score1.StartX,PosX,Score1.EndX) AND 
					     IsInRange(Score1.StartY,PosY,Score1.EndY);

WITH NumValues.ScoreP1 SELECT
FigureScore1.R   <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN OTHERS;

WITH NumValues.ScoreP1 SELECT
FigureScore1.G   <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN OTHERS;

WITH NumValues.ScoreP1 SELECT
FigureScore1.B   <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Score1.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score1.StartX)) WHEN OTHERS;

IsNull(10)        <= IsTransparent(FigureScore1);

WITH IsNull(10) SELECT
FScore1   <= FigureScore1 WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Score for player 2
-- 
--*************************************************************************************--


PrintObject(11)  <= IsInRange(Score2.StartX,PosX,Score2.EndX) AND 
					     IsInRange(Score2.StartY,PosY,Score2.EndY);

WITH NumValues.ScoreP2 SELECT
FigureScore2.R   <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN OTHERS;

WITH NumValues.ScoreP2 SELECT
FigureScore2.G   <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN OTHERS;

WITH NumValues.ScoreP2 SELECT
FigureScore2.B   <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Score2.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Score2.StartX)) WHEN OTHERS;

IsNull(11)        <= IsTransparent(FigureScore2);

WITH IsNull(11) SELECT
FScore2   <= FigureScore2 WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Hit points (Units   ) for player 1
-- 
--*************************************************************************************--

PrintObject(12)  <= IsInRange(Hp11.StartX,PosX,Hp11.EndX) AND 
					     IsInRange(Hp11.StartY,PosY,Hp11.EndY);

WITH NumValues.HpP1(0) SELECT
FigureHp11.R     <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN OTHERS;

WITH NumValues.HpP1(0) SELECT
FigureHp11.G     <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN OTHERS;

WITH NumValues.HpP1(0) SELECT
FigureHp11.B     <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Hp11.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp11.StartX)) WHEN OTHERS;

IsNull(12)       <= IsTransparent(FigureHp11);

WITH IsNull(12) SELECT
FHp11     <= FigureHp11     WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Hit points (Tens    ) for player 1
-- 
--*************************************************************************************--


PrintObject(13)  <= IsInRange(Hp12.StartX,PosX,Hp12.EndX) AND 
					     IsInRange(Hp12.StartY,PosY,Hp12.EndY);

WITH NumValues.HpP1(1) SELECT
FigureHp12.R     <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN OTHERS;

WITH NumValues.HpP1(1) SELECT
FigureHp12.G     <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN OTHERS;

WITH NumValues.HpP1(1) SELECT
FigureHp12.B     <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Hp12.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp12.StartX)) WHEN OTHERS;

IsNull(13)       <= IsTransparent(FigureHp12);

WITH IsNull(13) SELECT
FHp12     <= FigureHp12     WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Hit points (Hundreds) for player 1
-- 
--*************************************************************************************--


PrintObject(14)  <= IsInRange(Hp13.StartX,PosX,Hp13.EndX) AND 
					     IsInRange(Hp13.StartY,PosY,Hp13.EndY);

WITH NumValues.HpP1(2) SELECT
FigureHp13.R     <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN OTHERS;

WITH NumValues.HpP1(2) SELECT
FigureHp13.G     <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN OTHERS;

WITH NumValues.HpP1(2) SELECT
FigureHp13.B     <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Hp13.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp13.StartX)) WHEN OTHERS;

IsNull(14)       <= IsTransparent(FigureHp13);

WITH IsNull(14) SELECT
FHp13     <= FigureHp13     WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Hit points (Units   ) for player 2
-- 
--*************************************************************************************--


PrintObject(15)  <= IsInRange(Hp21.StartX,PosX,Hp21.EndX) AND 
					     IsInRange(Hp21.StartY,PosY,Hp21.EndY);

WITH NumValues.HpP2(0) SELECT
FigureHp21.R     <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN OTHERS;

WITH NumValues.HpP2(0) SELECT
FigureHp21.G     <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN OTHERS;

WITH NumValues.HpP2(0) SELECT
FigureHp21.B     <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Hp21.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp21.StartX)) WHEN OTHERS;

IsNull(15)       <= IsTransparent(FigureHp21);

WITH IsNull(15) SELECT
FHp21     <= FigureHp21     WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Hit points (Tens    ) for player 2
-- 
--*************************************************************************************--


PrintObject(16)  <= IsInRange(Hp22.StartX,PosX,Hp22.EndX) AND 
					     IsInRange(Hp22.StartY,PosY,Hp22.EndY);

WITH NumValues.HpP2(1) SELECT
FigureHp22.R     <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN OTHERS;

WITH NumValues.HpP2(1) SELECT
FigureHp22.G     <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN OTHERS;

WITH NumValues.HpP2(1) SELECT
FigureHp22.B     <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Hp22.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp22.StartX)) WHEN OTHERS;

IsNull(16)       <= IsTransparent(FigureHp22);

WITH IsNull(16) SELECT
FHp22     <= FigureHp22     WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Hit points (Hundreds) for player 2
-- 
--*************************************************************************************--


PrintObject(17)  <= IsInRange(Hp23.StartX,PosX,Hp23.EndX) AND 
					     IsInRange(Hp23.StartY,PosY,Hp23.EndY);

WITH NumValues.HpP2(2) SELECT
FigureHp23.R     <= FigureNum1R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0001",
						  FigureNum2R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0010",
						  FigureNum3R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0011",
						  FigureNum4R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0100",
						  FigureNum5R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0101",
						  FigureNum6R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0110",
						  FigureNum7R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0111",
						  FigureNum8R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "1000",
						  FigureNum9R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "1001",
						  FigureNum0R(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN OTHERS;

WITH NumValues.HpP2(2) SELECT
FigureHp23.G     <= FigureNum1G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0001",
						  FigureNum2G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0010",
						  FigureNum3G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0011",
						  FigureNum4G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0100",
						  FigureNum5G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0101",
						  FigureNum6G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0110",
						  FigureNum7G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0111",
						  FigureNum8G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "1000",
						  FigureNum9G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "1001",
						  FigureNum0G(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN OTHERS;

WITH NumValues.HpP2(2) SELECT
FigureHp23.B     <= FigureNum1B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0001",
						  FigureNum2B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0010",
						  FigureNum3B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0011",
						  FigureNum4B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0100",
						  FigureNum5B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0101",
						  FigureNum6B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0110",
						  FigureNum7B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "0111",
						  FigureNum8B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "1000",
						  FigureNum9B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN "1001",
						  FigureNum0B(StdVector2Int(PosY) - StdVector2Int(Hp23.StartY),
										  StdVector2Int(PosX) - StdVector2Int(Hp23.StartX)) WHEN OTHERS;

IsNull(17)       <= IsTransparent(FigureHp23);

WITH IsNull(17) SELECT
FHp23     <= FigureHp23     WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Ship used by the player 1
-- 
--*************************************************************************************--

PrintObject(18)  <= IsInRange(Ship1.StartX,PosX,Ship1.EndX) AND 
					     IsInRange(Ship1.StartY,PosY,Ship1.EndY);

FigureShip1.R    <= FigureShip1R(StdVector2Int(PosY) - StdVector2Int(Ship1.StartY),
										   StdVector2Int(PosX) - StdVector2Int(Ship1.StartX));

FigureShip1.G    <= FigureShip1G(StdVector2Int(PosY) - StdVector2Int(Ship1.StartY),
										   StdVector2Int(PosX) - StdVector2Int(Ship1.StartX));

FigureShip1.B    <= FigureShip1B(StdVector2Int(PosY) - StdVector2Int(Ship1.StartY),
										   StdVector2Int(PosX) - StdVector2Int(Ship1.StartX));

IsNull(18)       <= IsTransparent(FigureShip1);

WITH IsNull(18) SELECT
FShip1    <= FigureShip1    WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the Ship used by the player 2 
-- 
--*************************************************************************************--

PrintObject(19)  <= IsInRange(Ship2.StartX,PosX,Ship2.EndX) AND 
					     IsInRange(Ship2.StartY,PosY,Ship2.EndY);

FigureShip2.R    <= FigureShip2R(StdVector2Int(PosY) - StdVector2Int(Ship2.StartY),
										   StdVector2Int(PosX) - StdVector2Int(Ship2.StartX));

FigureShip2.G    <= FigureShip2G(StdVector2Int(PosY) - StdVector2Int(Ship2.StartY),
										   StdVector2Int(PosX) - StdVector2Int(Ship2.StartX));

FigureShip2.B    <= FigureShip2B(StdVector2Int(PosY) - StdVector2Int(Ship2.StartY),
										   StdVector2Int(PosX) - StdVector2Int(Ship2.StartX));

IsNull(19)       <= IsTransparent(FigureShip2);

WITH IsNull(19) SELECT
FShip2    <= FigureShip2    WHEN '0',
			    Background     WHEN OTHERS;

--*************************************************************************************--
-- 
-- Process to print the pixel that we want based on PosX and PosY
-- 
--*************************************************************************************--

WITH PrintObject SELECT
RScreen <= FBullet01.R  WHEN "00000000000000000001",
			  FBullet02.R  WHEN "00000000000000000010",
			  FBullet03.R  WHEN "00000000000000000100",
			  FBullet04.R  WHEN "00000000000000001000",
			  FBullet05.R  WHEN "00000000000000010000",
			  FBullet06.R  WHEN "00000000000000100000",
			  FBullet07.R  WHEN "00000000000001000000",
			  FBullet08.R  WHEN "00000000000010000000",
			  FBullet09.R  WHEN "00000000000100000000",
			  FBullet10.R  WHEN "00000000001000000000",
			  FScore1.R    WHEN "00000000010000000000",
			  FScore2.R    WHEN "00000000100000000000",
			  FHp11.R      WHEN "00000001000000000000",
			  FHp12.R      WHEN "00000010000000000000",
			  FHp13.R      WHEN "00000100000000000000",
			  FHp21.R      WHEN "00001000000000000000",
			  FHp22.R      WHEN "00010000000000000000",
			  FHp23.R      WHEN "00100000000000000000",
			  FShip1.R     WHEN "01000000000000000000",
			  FSHip2.R     WHEN "10000000000000000000",
			  Background.R WHEN OTHERS;

WITH PrintObject SELECT
GScreen <= FBullet01.G  WHEN "00000000000000000001",
			  FBullet02.G  WHEN "00000000000000000010",
			  FBullet03.G  WHEN "00000000000000000100",
			  FBullet04.G  WHEN "00000000000000001000",
			  FBullet05.G  WHEN "00000000000000010000",
			  FBullet06.G  WHEN "00000000000000100000",
			  FBullet07.G  WHEN "00000000000001000000",
			  FBullet08.G  WHEN "00000000000010000000",
			  FBullet09.G  WHEN "00000000000100000000",
			  FBullet10.G  WHEN "00000000001000000000",
			  FScore1.G    WHEN "00000000010000000000",
			  FScore2.G    WHEN "00000000100000000000",
			  FHp11.G      WHEN "00000001000000000000",
			  FHp12.G      WHEN "00000010000000000000",
			  FHp13.G      WHEN "00000100000000000000",
			  FHp21.G      WHEN "00001000000000000000",
			  FHp22.G      WHEN "00010000000000000000",
			  FHp23.G      WHEN "00100000000000000000",
			  FShip1.G     WHEN "01000000000000000000",
			  FSHip2.G     WHEN "10000000000000000000",
			  Background.G WHEN OTHERS;

WITH PrintObject SELECT
BScreen <= FBullet01.B  WHEN "00000000000000000001",
			  FBullet02.B  WHEN "00000000000000000010",
			  FBullet03.B  WHEN "00000000000000000100",
			  FBullet04.B  WHEN "00000000000000001000",
			  FBullet05.B  WHEN "00000000000000010000",
			  FBullet06.B  WHEN "00000000000000100000",
			  FBullet07.B  WHEN "00000000000001000000",
			  FBullet08.B  WHEN "00000000000010000000",
			  FBullet09.B  WHEN "00000000000100000000",
			  FBullet10.B  WHEN "00000000001000000000",
			  FScore1.B    WHEN "00000000010000000000",
			  FScore2.B    WHEN "00000000100000000000",
			  FHp11.B      WHEN "00000001000000000000",
			  FHp12.B      WHEN "00000010000000000000",
			  FHp13.B      WHEN "00000100000000000000",
			  FHp21.B      WHEN "00001000000000000000",
			  FHp22.B      WHEN "00010000000000000000",
			  FHp23.B      WHEN "00100000000000000000",
			  FShip1.B     WHEN "01000000000000000000",
			  FSHip2.B     WHEN "10000000000000000000",
			  Background.B WHEN OTHERS;

WITH VideoOn SELECT
R <= Rscreen   WHEN '1',
	  PureBlack WHEN OTHERS;

WITH VideoOn SELECT
G <= GScreen   WHEN '1',
	  PureBlack WHEN OTHERS;

WITH VideoOn SELECT
B <= BScreen   WHEN '1',
	  PureBlack WHEN OTHERS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.PixelGenerate 
--PORT MAP	  (PosX      => SLV,
--				PosY      => SLV,
--				VideoOn   => SLV,
--				Bullet01  => SLV,
--				Bullet02  => SLV,
--				Bullet03  => SLV,
--				Bullet04  => SLV,
--				Bullet05  => SLV,
--				Bullet06  => SLV,
--				Bullet07  => SLV,
--				Bullet08  => SLV,
--				Bullet09  => SLV,
--				Bullet10  => SLV,
--				Score1    => SLV,
--				Score2    => SLV,
--				HP11      => SLV,
--				HP12      => SLV,
--				HP13      => SLV,
--				HP21      => SLV,
--				HP22      => SLV,
--				HP23      => SLV,
--				Ship1     => SLV,
--				Ship2     => SLV,
--				EnaBullet => SLV,
--				NumValues => SLV,
--				R         => SLV,
--				G         => SLV,
--				B         => SLV
--			  );
--******************************************************--

END PixelGenerateArch;