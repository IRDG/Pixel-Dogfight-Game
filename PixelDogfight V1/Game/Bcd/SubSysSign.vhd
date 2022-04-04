
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:2019                         --
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

ENTITY SubSysSign IS
	GENERIC(
				Size: INTEGER := 4
			 );
	PORT	 (
				Ain : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Bin : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Sa  : IN  STD_LOGIC;
				Sb  : IN  STD_LOGIC;
				TsA : OUT STD_LOGIC;
				TsB : OUT STD_LOGIC;
				TsO : OUT STD_LOGIC;
				FsO : OUT STD_LOGIC
			 );
	
END ENTITY SubSysSign;

ARCHITECTURE SubSysSignArch OF SubSysSign IS

SIGNAL AgtB : STD_LOGIC;
SIGNAL BgtA : STD_LOGIC;
SIGNAL TsN  : STD_LOGIC;
SIGNAL TesA : STD_LOGIC;
SIGNAL TesB : STD_LOGIC;

SIGNAL NegA : STD_LOGIC;
SIGNAL NegB : STD_LOGIC;

BEGIN

--******************************************************--
-- Con 1 como negativo y 0 como positivo
-- Signos:
-- A B Tsa TsB Neg
-- 0 0  0   0   0
-- 0 1  0   1   0
-- 1 0  1   0   0
-- 1 1  0   0   1
--******************************************************--

TesA <= Sa AND (Not Sb);
TesB <= Sb AND (Not Sa);
TsN  <= Sa AND Sb;

NegA <= AgtB AND TesA;
NegB <= BgtA AND TesB;
TsO  <= NegA OR NegB OR TsN;
TsA  <= TesA;
TsB  <= TesB;

FsO <= NegA OR NegB;

AgtB1: ENTITY WORK.BasicXinGreaterThanYin
GENERIC MAP(Size => Size
			  )
PORT MAP	  (Xin  => Ain,
				Yin  => Bin,
				XgY => AgtB
			  );

BgtA1: ENTITY WORK.BasicXinGreaterThanYin
GENERIC MAP(Size => Size
			  )
PORT MAP	  (Xin  => Bin,
				Yin  => Ain,
				XgY => BgtA
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SubSysSign 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Ain => SLV,
--				Bin => SLV,
--				Sa  => SLV,
--				Sb  => SLV,
--				TsA => SLV,
--				TsB => SLV,
--				TsO => SLV,
--				FsO => SLV
--			  );
--******************************************************--
			 
end SubSysSignArch;