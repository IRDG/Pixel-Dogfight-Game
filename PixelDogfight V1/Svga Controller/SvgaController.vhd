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

USE WORK.MyGamePackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY SvgaController IS
	
	PORT	 (
				SyncClk   : IN  STD_LOGIC;
				Reset     : IN  STD_LOGIC;
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
				EnaBullet : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
				NumValues : IN  DecimalValue;
				R         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				G         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				B         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				VgaBlank  : OUT STD_LOGIC;
				VgaClk    : OUT STD_LOGIC;
				VgaSync   : OUT STD_LOGIC;
				Hsync     : OUT STD_LOGIC;
				VSync     : OUT STD_LOGIC
			 );
	
END ENTITY SvgaController;

ARCHITECTURE SvgaControllerArch OF SvgaController IS

SIGNAL PixelX  : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL PixelY  : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL VideoOn : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--



Sync: ENTITY WORK.SvgaSync 
PORT MAP	  (Reset    => Reset,
				SyncClk  => SyncClk,
				HSync    => HSync,
				VSync    => VSync,
				VideoOn  => VideoOn,
				VgaBlank => VgaBlank,
				VgaClk   => VgaClk,
				VgaSync  => VgaSync,
				PixelX   => PixelX,
				PixelY   => PixelY
			  );

Pixel: ENTITY WORK.PixelGenerate 
PORT MAP	  (PosX      => PixelX,
				PosY      => PixelY,
				VideoOn   => VideoOn,
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
				Score1    => Score1,
				Score2    => Score2,
				HP11      => HP11,
				HP12      => HP12,
				HP13      => HP13,
				HP21      => HP21,
				HP22      => HP22,
				HP23      => HP23,
				Ship1     => Ship1,
				Ship2     => Ship2,
				EnaBullet => EnaBullet,
				NumValues => NumValues,
				R         => R,
				G         => G,
				B         => B
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SvgaController 
--PORT MAP	  (SyncClk   => SLV,
--				Reset     => SLV,
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
--				B         => SLV,
--				VgaBlank  => SLV,
--				VgaClk    => SLV,
--				VgaSync   => SLV,
--				HSync     => SLV,
--				VSync     => SLV
--			  );
--******************************************************--

END SvgaControllerArch;