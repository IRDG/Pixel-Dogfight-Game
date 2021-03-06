--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.ALL;

USE WORK.MyGamePackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY ShipPosition IS
	
	PORT	 (
				U1      : IN  STD_LOGIC;
				D1      : IN  STD_LOGIC;
				R1      : IN  STD_LOGIC;
				L1      : IN  STD_LOGIC;
				U2      : IN  STD_LOGIC;
				D2      : IN  STD_LOGIC;
				R2      : IN  STD_LOGIC;
				L2      : IN  STD_LOGIC;
				Reset   : IN  STD_LOGIC;
				GameRst : IN  STD_LOGIC;
				Clk     : IN  STD_LOGIC;
				Ship1   : OUT Object;
				Ship2   : OUT Object
			 );
	
END ENTITY ShipPosition;

ARCHITECTURE ShipPositionArch OF ShipPosition IS

SIGNAL U1Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL D1Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL R1Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL L1Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL U2Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL D2Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL R2Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL L2Vect       : STD_LOGIC_VECTOR(0 DOWNTO 0);

SIGNAL PartialU1    : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialD1    : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialR1    : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialL1    : STD_LOGIC_VECTOR(N DOWNTO 0);

SIGNAL PartialU2    : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialD2    : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialR2    : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialL2    : STD_LOGIC_VECTOR(N DOWNTO 0);

SIGNAL PartialU1End : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialD1End : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialR1End : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialL1End : STD_LOGIC_VECTOR(N DOWNTO 0);

SIGNAL PartialU2End : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialD2End : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialR2End : STD_LOGIC_VECTOR(N DOWNTO 0);
SIGNAL PartialL2End : STD_LOGIC_VECTOR(N DOWNTO 0);

SIGNAL EnableUD1    : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL EnableRL1    : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL EnableUD2    : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL EnableRL2    : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL Ship1Pos     : Object;
SIGNAL Ship2Pos     : Object;
SIGNAL Ship1NewPos  : Object;
SIGNAL Ship2NewPos  : Object;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Ship1            <= Ship1Pos;
Ship2            <= Ship2Pos;

U1Vect(0)        <= U1;
D1Vect(0)        <= D1;
R1Vect(0)        <= R1;
L1Vect(0)        <= L1;

U2Vect(0)        <= U2;
D2Vect(0)        <= D2;
R2Vect(0)        <= R2;
L2Vect(0)        <= L2;

PartialU1        <= STD_LOGIC_VECTOR(UNSIGNED(Ship1Pos.StartY) + UNSIGNED(U1Vect));
PartialD1        <= STD_LOGIC_VECTOR(UNSIGNED(Ship1Pos.StartY) - UNSIGNED(D1Vect));
PartialR1        <= STD_LOGIC_VECTOR(UNSIGNED(Ship1Pos.StartX) + UNSIGNED(R1Vect));
PartialL1        <= STD_LOGIC_VECTOR(UNSIGNED(Ship1Pos.StartX) - UNSIGNED(L1Vect));

PartialU2        <= STD_LOGIC_VECTOR(UNSIGNED(Ship2Pos.StartY) + UNSIGNED(U2Vect));
PartialD2        <= STD_LOGIC_VECTOR(UNSIGNED(Ship2Pos.StartY) - UNSIGNED(D2Vect));
PartialR2        <= STD_LOGIC_VECTOR(UNSIGNED(Ship2Pos.StartX) + UNSIGNED(R2Vect));
PartialL2        <= STD_LOGIC_VECTOR(UNSIGNED(Ship2Pos.StartX) - UNSIGNED(L2Vect));

PartialU1End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialU1)       + UNSIGNED(UnsgShipSizeY));
PartialD1End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialD1)       - UNSIGNED(UnsgShipSizeY));
PartialR1End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialR1)       + UNSIGNED(UnsgShipSizeX));
PartialL1End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialL1)       - UNSIGNED(UnsgShipSizeX));

PartialU2End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialU2)       + UNSIGNED(UnsgShipSizeY));
PartialD2End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialD2)       - UNSIGNED(UnsgShipSizeY));
PartialR2End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialR2)       + UNSIGNED(UnsgShipSizeX));
PartialL2End     <= STD_LOGIC_VECTOR(UNSIGNED(PartialL2)       - UNSIGNED(UnsgShipSizeX));

EnableUD1        <= (IsInPlayZone1(PartialU1,PartialU1End,'0','1') AND U1) &
						  (IsInPlayZone1(PartialD1,PartialD1End,'0','1') AND D1);

EnableRL1        <= (IsInPlayZone1(PartialR1,PartialR1End,'1','0') AND R1) &
						  (IsInPlayZone1(PartialL1,PartialL1End,'1','0') AND L1);

EnableUD2        <= (IsInPlayZone2(PartialU2,PartialU2End,'0','1') AND U2) &
						  (IsInPlayZone2(PartialD2,PartialD2End,'0','1') AND D2);

EnableRL2        <= (IsInPlayZone2(PartialR2,PartialR2End,'1','0') AND R2) &
						  (IsInPlayZone2(PartialL2,PartialL2End,'1','0') AND L2);

WITH EnableUD1 SELECT
Ship1NewPos.StartY <= PartialU1       WHEN "10",
					       PartialD1       WHEN "01",
					       Ship1Pos.StartY WHEN OTHERS;

WITH EnableRL1 SELECT
Ship1NewPos.StartX <= PartialR1       WHEN "10",
							 PartialL1       WHEN "01",
							 Ship1Pos.StartX WHEN OTHERS;

WITH EnableUD2 SELECT
Ship2NewPos.StartY <= PartialU2       WHEN "10",
					       PartialD2       WHEN "01",
					       Ship2Pos.StartY WHEN OTHERS;

WITH EnableRL2 SELECT
Ship2NewPos.StartX <= PartialR2       WHEN "10",
							 PartialL2       WHEN "01",
							 Ship2Pos.StartX WHEN OTHERS;

Ship1NewPos.EndX   <= Int2StdVector(StdVector2Int(Ship1NewPos.StartX) + ShipSizeX ,11);
Ship1NewPos.EndY   <= Int2StdVector(StdVector2Int(Ship1NewPos.StartY) + ShipSizeY ,11);

Ship2NewPos.EndX   <= Int2StdVector(StdVector2Int(Ship2NewPos.StartX) + ShipSizeX ,11);
Ship2NewPos.EndY   <= Int2StdVector(StdVector2Int(Ship2NewPos.StartY) + ShipSizeY ,11);

PROCESS(Clk, Reset, GameRst,Ship1NewPos,Ship2NewPos)

BEGIN
	
	IF((Reset OR GameRst) = '1')THEN
		
		Ship1Pos.StartX <= InitialPosShip1.StartX;
		Ship1Pos.StartY <= InitialPosShip1.StartY;
		Ship1Pos.EndX   <= InitialPosShip1.EndX;
		Ship1Pos.EndY   <= InitialPosShip1.EndX;
		
		Ship2Pos.StartX <= InitialPosShip2.StartX;
		Ship2Pos.StartY <= InitialPosShip2.StartY;
		Ship2Pos.EndX   <= InitialPosShip2.EndX;
		Ship2Pos.EndY   <= InitialPosShip2.EndY;
		
	ELSIF(Rising_Edge(Clk))THEN
		
		Ship1Pos.StartX <= Ship1NewPos.StartX;
		Ship1Pos.StartY <= Ship1NewPos.StartY;
		Ship1Pos.EndX   <= Ship1NewPos.EndX;
		Ship1Pos.EndY   <= Ship1NewPos.EndY;
		
		Ship2Pos.StartX <= Ship2NewPos.StartX;
		Ship2Pos.StartY <= Ship2NewPos.StartY;
		Ship2Pos.EndX   <= Ship2NewPos.EndX;
		Ship2Pos.EndY   <= Ship2NewPos.EndY;
		
	END IF;
	
END PROCESS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.ShipPosition 
--PORT MAP	  (U1      => SLV,
--				D1      => SLV,
--				R1      => SLV,
--				L1      => SLV,
--				U2      => SLV,
--				D2      => SLV,
--				R2      => SLV,
--				L2      => SLV,
--				Reset   => SLV,
--				GameRst => SLV,
--				Clk     => SLV,
--				Ship1   => SLV,
--				Ship2   => SLV
--			  );
--******************************************************--

END ShipPositionArch;