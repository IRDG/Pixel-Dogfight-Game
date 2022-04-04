--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--
-- 													              --
-------------- Package: MyGamePackage.vhd -----------------
-- 													              --
--******************************************************--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE MyGamePackage IS

--**************************************************************************************************--
-- 
-- Definition of Color type used to store the RGB colors of objects and background
-- 
-- Space Color   : 0x00-10-40
--
-- Star Color    : 0xD1-EB-F7
--
-- Numbers Color : 0xFF-D7-00
--
-- Null Color    : 0xFF-00-66 
--
--**************************************************************************************************--

TYPE Color IS RECORD
	
	R    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	G    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	B    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
END RECORD Color;

CONSTANT BackgroundSpaceColor : Color := ("0000"&"0000",
														"0001"&"0000",
														"0100"&"0000"
												     );

CONSTANT BackgroundStarColor  : Color := ("1101"&"0001",
														"1110"&"1011",
														"1111"&"0111"
												     );

CONSTANT NumbersColor         : Color := ("1111"&"1111",
														"1101"&"0111",
														"0000"&"0000"
												     );

CONSTANT NullColor            : Color := ("1111"&"1111",
														"0000"&"0000",
														"0110"&"0110"
												     );

--**************************************************************************************************--
-- 
-- Definition of Functions used (part 1) ~ part 2 is found right before the package body starts
-- 
------------------------------------------------------------------------------------------------------
--
-- IsInRange is a Pure function that compares the value Var with Max and Min
--           It will give a STD_LOGIC result 
--				 The result will be 1 when Min <= Var <= Max
--				 Otherwise the result will be 0
--
------------------------------------------------------------------------------------------------------
--
-- StdVector2Int is a Pure function that cast a STD_LOGIC_VECTOR input into an integer
--					  It will give an INTEGER result
-- 				  The result is calculated using UNSIGNED() and TO_INTEGER() functions
-- 
------------------------------------------------------------------------------------------------------
--
-- Int2StdVector is a Pure function that cast an INTEGER input into a STD_LOGIC_VECTOR
--               It will give a STD_LOGIC_VECTOR result
--               The result is calculated using TO_UNSIGNED() and STD_LOGIC_VECTOR() functions
--
------------------------------------------------------------------------------------------------------
--
-- ISTransparent is a Pure function that compares if the color selected is transparent
--               It will give a STD_LOGIC_VECTOR result
--               The result will be 1 if the input color is the same as the NullColor
--					  Otherwise the result will be 0
--
--**************************************************************************************************--

PURE FUNCTION IsInRange(Min : STD_LOGIC_VECTOR;
								Var : STD_LOGIC_VECTOR;
								Max : STD_LOGIC_VECTOR)
RETURN STD_LOGIC;

PURE FUNCTION StdVector2Int(Input : STD_LOGIC_VECTOR)
RETURN INTEGER;

PURE FUNCTION Int2StdVector(Input : INTEGER;
									 Size  : INTEGER)
RETURN STD_LOGIC_VECTOR;

PURE FUNCTION IsTransparent(ColorA : Color)
RETURN STD_LOGIC;

--**************************************************************************************************--
-- 
-- Definition constant values N and NplusOne (NpO) 
-- 
-- N is used as the number of bits of the x and y coordinates (N DOWNTO 0)
--
--**************************************************************************************************--

CONSTANT NpO : INTEGER := 11;
CONSTANT N   : INTEGER := NpO-1;

--**************************************************************************************************--
-- 
-- Definition of Constant Vga which will have the time data of front and back porche, retrace time and
-- display time.
--
-- (SVga -> 800 x 600)
-- 
--**************************************************************************************************--

TYPE VgaData IS RECORD
	
	HFront   : INTEGER;
	HBack    : INTEGER;
	HRetrace : INTEGER;
	HDisplay : INTEGER;
	VFront   : INTEGER;
	VBack    : INTEGER;
	VRetrace : INTEGER;
	VDisplay : INTEGER;
	
END RECORD VgaData;

CONSTANT SVga : VgaData := ( 16,
									 160,
									  80,
									 799,
									   1,
									  21,
									   2,
									 599); 


--**************************************************************************************************--
-- 
-- Definition of Constant Times which will have the time data used to compare when will we have
-- video On and H/V sync signals
-- 
--**************************************************************************************************--

TYPE TimeStamp IS RECORD
	
	Display    : STD_LOGIC_VECTOR(N DOWNTO 0);
	FrontPorch : STD_LOGIC_VECTOR(N DOWNTO 0);
	Retrace    : STD_LOGIC_VECTOR(N DOWNTO 0);
	FullScan   : STD_LOGIC_VECTOR(N DOWNTO 0);
	
END RECORD TimeStamp;

CONSTANT HTime : TimeStamp := (Int2StdVector((SVga.HDisplay)                                           ,NpO),
										 Int2StdVector((SVga.HDisplay + SVga.HFront)                             ,NpO),
										 Int2StdVector((SVga.HDisplay + SVga.HFront + SVga.HRetrace)             ,NpO),
										 Int2StdVector((SVga.HDisplay + SVga.HFront + SVga.HRetrace + SVga.HBack),NpO)
										);

CONSTANT VTime : TimeStamp := (Int2StdVector((SVga.VDisplay)                                           ,NpO),
										 Int2StdVector((SVga.VDisplay + SVga.VFront)                             ,NpO),
										 Int2StdVector((SVga.VDisplay + SVga.VFront + SVga.VRetrace)             ,NpO),
										 Int2StdVector((SVga.VDisplay + SVga.VFront + SVga.VRetrace + SVga.VBack),NpO)
										);

--**************************************************************************************************--
-- 
-- Definition of DataType ZoneBorder used to store the max values that can be used for 
-- each region of the game
-- 
-- The game has 3 major zones :
--     -> The Scoreboard
--     -> The Player1 zone
--     -> The Player2 Zone
--
-- Between the Player1 Zone and the Player2Zone is a special zone called the Dead Zone where
-- the players cannot enter (Bullets can cross that space)
--
--**************************************************************************************************--

TYPE ZoneBorder IS RECORD
	
	MinLimX    : STD_LOGIC_VECTOR(N DOWNTO 0);
	MinLimY    : STD_LOGIC_VECTOR(N DOWNTO 0);
	MaxLimX    : STD_LOGIC_VECTOR(N DOWNTO 0);
	MaxLimY    : STD_LOGIC_VECTOR(N DOWNTO 0);
	GameZoneX  : STD_LOGIC_VECTOR(N DOWNTO 0);
	GameZoneY  : STD_LOGIC_VECTOR(N DOWNTO 0);
	DeadZoneXs : STD_LOGIC_VECTOR(N DOWNTO 0);
	DeadZoneXe : STD_LOGIC_VECTOR(N DOWNTO 0);
	DeadZoneYs : STD_LOGIC_VECTOR(N DOWNTO 0);
	DeadZoneYe : STD_LOGIC_VECTOR(N DOWNTO 0);
	
END RECORD ZoneBorder;

CONSTANT Display : ZoneBorder := (Int2StdVector(  0,NpO),  -- MinLimX
											 Int2StdVector(  0,NpO),  -- MinLimY
											 Int2StdVector(799,NpO),  -- MaxLimX
											 Int2StdVector(599,NpO),  -- MaxLimY
											 Int2StdVector(  0,NpO),  -- GameZoneX
											 Int2StdVector( 40,NpO),  -- GameZoneY
											 Int2StdVector(360,NpO),  -- DeadZoneXstart
											 Int2StdVector(439,NpO),  -- DeadZoneXend
											 Int2StdVector( 40,NpO),  -- DeadZoneYstart
											 Int2StdVector(599,NpO)   -- DeadZoneYend
											 );

--**************************************************************************************************--
-- 
-- Creation of DataType Object to manage start and end position of each object in game 
-- 
-- It is considered an object any part of the game that moves
-- 
-- The start coordinates points to the highest right pixel of the object
--
-- The  end  coordinates points to the lowest  left  pixel of the object
-- 
-- The definition of the constant values used to calculate the end Pixel of each object 
-- are here as well
-- 
-- Some objects are created here, those are the initial position of each ship and the fixed 
-- position of the digits that express the Hit Points of the players and the score of each one
--
--**************************************************************************************************--

TYPE Object IS RECORD
	
	StartX   : STD_LOGIC_VECTOR(N DOWNTO 0);
	StartY   : STD_LOGIC_VECTOR(N DOWNTO 0);
	EndX     : STD_LOGIC_VECTOR(N DOWNTO 0);
	EndY     : STD_LOGIC_VECTOR(N DOWNTO 0);
	
END RECORD Object;

CONSTANT ShipSizeX       : INTEGER := 60-1;
CONSTANT ShipSizeY       : INTEGER := 40-1;
CONSTANT BulletSizeX     : INTEGER := 15-1;
CONSTANT BulletSizeY     : INTEGER :=  5-1;
CONSTANT ScoreSizeX      : INTEGER := 35-1;
CONSTANT ScoreSizeY      : INTEGER := 35-1;

CONSTANT UnsgShipSizeX   : STD_LOGIC_VECTOR(N DOWNTO 0) := Int2StdVector(ShipSizeX  ,NpO);
CONSTANT UnsgShipSizeY   : STD_LOGIC_VECTOR(N DOWNTO 0) := Int2StdVector(ShipSizeY  ,NpO);
CONSTANT UnsgBulletSizeX : STD_LOGIC_VECTOR(N DOWNTO 0) := Int2StdVector(BulletSizeX,NpO);
CONSTANT UnsgBulletSizeY : STD_LOGIC_VECTOR(N DOWNTO 0) := Int2StdVector(BulletSizeY,NpO);

--**************************************************************************************************--
--
-- Initial Position of the ships
--
--**************************************************************************************************--

CONSTANT InitialPosShip1 : Object  := (Int2StdVector( 30              ,NpO),
													Int2StdVector(140              ,NpO),
													Int2StdVector( 30 + ShipSizeX  ,NpO),
													Int2StdVector(140 + ShipSizeY  ,NpO)
												  );
CONSTANT InitialPosShip2 : Object  := (Int2StdVector(640              ,NpO),
													Int2StdVector(500              ,NpO),
													Int2StdVector(640 + ShipSizeX  ,NpO),
													Int2StdVector(500 + ShipSizeY  ,NpO)
												  );

--**************************************************************************************************--
--
-- Hit Points and Score object positions for player 1
--
--**************************************************************************************************--

CONSTANT Ship1HitPoints1 : Object  := (Int2StdVector( 66              ,NpO),
													Int2StdVector(  3              ,NpO),
													Int2StdVector( 66 + ScoreSizeX ,NpO),
													Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );
CONSTANT Ship1HitPoints2 : Object  := (Int2StdVector(102              ,NpO),
													Int2StdVector(  3              ,NpO),
													Int2StdVector(102 + ScoreSizeX ,NpO),
													Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );
CONSTANT Ship1HitPoints3 : Object  := (Int2StdVector(138              ,NpO),
													Int2StdVector(  3              ,NpO),
													Int2StdVector(138 + ScoreSizeX ,NpO),
													Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );
CONSTANT ScorePlayer1    : Object  := (Int2StdVector(249              ,NpO),
												   Int2StdVector(  3              ,NpO),
												   Int2StdVector(249 + ScoreSizeX ,NpO),
												   Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );

--**************************************************************************************************--
--
-- Hit Points and Score object positions for player 2
--
--**************************************************************************************************--

CONSTANT Ship2HitPoints1 : Object  := (Int2StdVector(627              ,NpO),
													Int2StdVector(  3              ,NpO),
													Int2StdVector(627 + ScoreSizeX ,NpO),
													Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );
CONSTANT Ship2HitPoints2 : Object  := (Int2StdVector(663              ,NpO),
													Int2StdVector(  3              ,NpO),
													Int2StdVector(663 + ScoreSizeX ,NpO),
													Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );
CONSTANT Ship2HitPoints3 : Object  := (Int2StdVector(699              ,NpO),
													Int2StdVector(  3              ,NpO),
													Int2StdVector(699 + ScoreSizeX ,NpO),
													Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );
CONSTANT ScorePlayer2    : Object  := (Int2StdVector(516              ,NpO),
												   Int2StdVector(  3              ,NpO),
												   Int2StdVector(516 + ScoreSizeX ,NpO),
												   Int2StdVector(  3 + ScoreSizeY ,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 01
--
--**************************************************************************************************--

CONSTANT InitialBullet01 : Object  := (Int2StdVector(380              ,NpO),
												   Int2StdVector(  5              ,NpO),
												   Int2StdVector(380 + BulletSizeX,NpO),
												   Int2StdVector(  5 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 02
--
--**************************************************************************************************--

CONSTANT InitialBullet02 : Object  := (Int2StdVector(400              ,NpO),
												   Int2StdVector(  5              ,NpO),
												   Int2StdVector(400 + BulletSizeX,NpO),
												   Int2StdVector(  5 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 03
--
--**************************************************************************************************--

CONSTANT InitialBullet03 : Object  := (Int2StdVector(420              ,NpO),
												   Int2StdVector(  5              ,NpO),
												   Int2StdVector(420 + BulletSizeX,NpO),
												   Int2StdVector(  5 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 04
--
--**************************************************************************************************--

CONSTANT InitialBullet04 : Object  := (Int2StdVector(380              ,NpO),
												   Int2StdVector( 15              ,NpO),
												   Int2StdVector(380 + BulletSizeX,NpO),
												   Int2StdVector( 15 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 05
--
--**************************************************************************************************--

CONSTANT InitialBullet05 : Object  := (Int2StdVector(400              ,NpO),
												   Int2StdVector( 15              ,NpO),
												   Int2StdVector(400 + BulletSizeX,NpO),
												   Int2StdVector( 15 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 06
--
--**************************************************************************************************--

CONSTANT InitialBullet06 : Object  := (Int2StdVector(420              ,NpO),
												   Int2StdVector( 15              ,NpO),
												   Int2StdVector(420 + BulletSizeX,NpO),
												   Int2StdVector( 15 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 07
--
--**************************************************************************************************--

CONSTANT InitialBullet07 : Object  := (Int2StdVector(380              ,NpO),
												   Int2StdVector( 25              ,NpO),
												   Int2StdVector(380 + BulletSizeX,NpO),
												   Int2StdVector( 25 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 08
--
--**************************************************************************************************--

CONSTANT InitialBullet08 : Object  := (Int2StdVector(400              ,NpO),
												   Int2StdVector( 25              ,NpO),
												   Int2StdVector(400 + BulletSizeX,NpO),
												   Int2StdVector( 25 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 09
--
--**************************************************************************************************--

CONSTANT InitialBullet09 : Object  := (Int2StdVector(420              ,NpO),
												   Int2StdVector( 25              ,NpO),
												   Int2StdVector(420 + BulletSizeX,NpO),
												   Int2StdVector( 25 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
--
-- Store position for bullet 10
--
--**************************************************************************************************--

CONSTANT InitialBullet10 : Object  := (Int2StdVector(400              ,NpO),
												   Int2StdVector( 35              ,NpO),
												   Int2StdVector(400 + BulletSizeX,NpO),
												   Int2StdVector( 35 + BulletSizeY,NpO)
												  );

--**************************************************************************************************--
-- 
-- Creation of DataType Value to manage All values concerning the Scores and hitpoints 
-- 
--**************************************************************************************************--

TYPE HPX IS ARRAY (2 DOWNTO 0) OF STD_LOGIC_VECTOR (3 DOWNTO 0);

TYPE DecimalValue IS RECORD
	
	ScoreP1   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	ScoreP2   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	HpP1      : HPX;
	HpP2      : HPX;
	
END RECORD DecimalValue;

--**************************************************************************************************--
-- 
-- Creation constant HullSize to have a limit value for player Hp
-- 
-- The values of this constant should be between 9 bits to 1 bit (511 to 1)
-- 
-- The common value for this constant should be 7, to express 100
-- 
--**************************************************************************************************--

CONSTANT HullSize : INTEGER := 7;

--**************************************************************************************************--
-- 
-- Definition of Functions used (part 2) ~ part 1 is found at the start of the package
-- 
------------------------------------------------------------------------------------------------------
--
-- IsInPlayZone1 is a Pure function that compares the Object position to determinate if it is inside 
--					  the game zone used for the player 1
--
--           	  It will give a STD_LOGIC result 
--				 	  The result will be 1 when Tha object is inside the zone
--				 	  Otherwise the result will be 0
--
------------------------------------------------------------------------------------------------------
--
-- IsInPlayZone2 is a Pure function that compares the Object position to determinate if it is inside 
--					  the game zone used for the player 2
--
--           	  It will give a STD_LOGIC result 
--				 	  The result will be 1 when Tha object is inside the zone
--				 	  Otherwise the result will be 0
--
--**************************************************************************************************--

PURE FUNCTION IsInPlayZone1(ObjS  : STD_LOGIC_VECTOR;
									 ObjE  : STD_LOGIC_VECTOR;
									 Xcord : STD_LOGIC;
									 Ycord : STD_LOGIC)
RETURN STD_LOGIC;

PURE FUNCTION IsInPlayZone2(ObjS  : STD_LOGIC_VECTOR;
									 ObjE  : STD_LOGIC_VECTOR;
									 Xcord : STD_LOGIC;
									 Ycord : STD_LOGIC)
RETURN STD_LOGIC;

END PACKAGE MyGamePackage;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

PACKAGE BODY MyGamePackage IS

--**************************************************************************************************--
--
-- Implementation of function IsInRange
--
-- IsInRange is a Pure function that compares the value Var with Max and Min
--           It will give a STD_LOGIC result 
--				 The result will be 1 when Min <= Var <= Max
--				 Otherwise the result will be 0
--
--**************************************************************************************************--

PURE FUNCTION IsInRange(Min : STD_LOGIC_VECTOR;
								Var : STD_LOGIC_VECTOR;
								Max : STD_LOGIC_VECTOR)
RETURN STD_LOGIC IS

BEGIN

	IF((UNSIGNED(Min) <= UNSIGNED(Var)) AND (UNSIGNED(Var) <= UNSIGNED(Max))) THEN
		
		RETURN '1';
		
	ELSE
		
		RETURN '0';
		
	END IF;

END IsInRange;

--**************************************************************************************************--
--
-- Implementation of function StdVector2Int
--
--
-- StdVector2Int is a Pure function that cast a STD_LOGIC_VECTOR input into an integer
--					  It will give an INTEGER result
-- 				  The result is calculated using UNSIGNED() and TO_INTEGER() functions
--
--**************************************************************************************************--

PURE FUNCTION StdVector2Int(Input : STD_LOGIC_VECTOR)
RETURN INTEGER IS

BEGIN
	
	RETURN TO_INTEGER(UNSIGNED(Input));
	
END StdVector2Int;

--**************************************************************************************************--
--
-- Implementation of function Int2StdVector
--
--
-- Int2StdVector is a Pure function that cast an INTEGER input into a STD_LOGIC_VECTOR
--               It will give a STD_LOGIC_VECTOR result
--               The result is calculated using TO_UNSIGNED() and STD_LOGIC_VECTOR() functions
--
--**************************************************************************************************--

PURE FUNCTION Int2StdVector(Input : INTEGER;
									 Size  : INTEGER)
RETURN STD_LOGIC_VECTOR IS

BEGIN
	
	RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(Input,Size));
	
END Int2StdVector;

--**************************************************************************************************--
--
-- Implementation of function IsTransparent
--
--
-- ISTransparent is a Pure function that compares if the color selected is transparent
--               It will give a STD_LOGIC_VECTOR result
--               The result will be 1 if the input color is the same as the NullColor
--					  Otherwise the result will be 0
--
--**************************************************************************************************--

PURE FUNCTION IsTransparent(ColorA : Color)
RETURN STD_LOGIC IS

BEGIN
	
	IF((UNSIGNED(ColorA.R) = UNSIGNED(NullColor.R))   AND
		(UNSIGNED(ColorA.G) = UNSIGNED(NullColor.G))   AND
		(UNSIGNED(ColorA.B) = UNSIGNED(NullColor.B))) THEN
		
		RETURN '1';
		
	ELSE
		
		RETURN '0';
		
	END IF;
	
END IsTransparent;

--**************************************************************************************************--
--
-- Implementation of function IsInPlayZone1
--
--
-- IsInPlayZone1 is a Pure function that compares the Object position to determinate if it is inside 
--					  the game zone used for the player 1
--
--           	  It will give a STD_LOGIC result 
--				 	  The result will be 1 when Tha object is inside the zone
--				 	  Otherwise the result will be 0
--
--**************************************************************************************************--

PURE FUNCTION IsInPlayZone1(ObjS  : STD_LOGIC_VECTOR;
									 ObjE  : STD_LOGIC_VECTOR;
									 Xcord : STD_LOGIC;
									 Ycord : STD_LOGIC)
RETURN STD_LOGIC IS

BEGIN
	
	IF((ObjS > Display.GameZoneX ) AND
		(ObjE < Display.DeadZoneXs) AND  --malm es con end
		(Xcord ='1')AND(Ycord ='0'))THEN
		
		RETURN '1';
		
	ELSIF((ObjS > Display.GameZoneY ) AND
		   (ObjE < Display.DeadZoneYe) AND --mal
			(Ycord ='1')AND(Xcord ='0'))THEN
		
		RETURN '1';
		
	ELSE
		
		RETURN '0';
		
	END IF;
	
END IsInPlayZone1;

--**************************************************************************************************--
--
-- Implementation of function IsInPlayZone1
--
--
-- IsInPlayZone1 is a Pure function that compares the Object position to determinate if it is inside 
--					  the game zone used for the player 1
--
--           	  It will give a STD_LOGIC result 
--				 	  The result will be 1 when Tha object is inside the zone
--				 	  Otherwise the result will be 0
--
--**************************************************************************************************--

PURE FUNCTION IsInPlayZone2(ObjS  : STD_LOGIC_VECTOR;
									 ObjE  : STD_LOGIC_VECTOR;
									 Xcord : STD_LOGIC;
									 Ycord : STD_LOGIC)
RETURN STD_LOGIC IS

BEGIN
	
	IF((ObjS > Display.DeadZoneXe) AND
		(ObjE < Display.MaxLimX   ) AND
		(Xcord ='1')AND(Ycord ='0'))THEN
		
		
		RETURN '1';
		
	ELSIF((ObjS > Display.DeadZoneYs) AND
			(ObjE < Display.MaxLimY   ) AND
			(Ycord ='1')AND(Xcord ='0'))THEN
		
		RETURN '1';
		
	ELSE
		
		RETURN '0';
		
	END IF;
	
END IsInPlayZone2;

END MyGamePackage;