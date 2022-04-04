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

USE WORK.MyGamePackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY SvgaSync IS
	
	PORT	 (
				Reset    : IN  STD_LOGIC;
				SyncClk  : IN  STD_LOGIC;
				HSync    : OUT STD_LOGIC;
				VSync    : OUT STD_LOGIC;
				VideoOn  : OUT STD_LOGIC;
				VgaBlank : OUT STD_LOGIC;
				VgaClk   : OUT STD_LOGIC;
				VgaSync  : OUT STD_LOGIC;
				PixelX   : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
				PixelY   : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
			 );
	
END ENTITY SvgaSync;

ARCHITECTURE SvgaSyncArch OF SvgaSync IS 

CONSTANT VZeroCount   : STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0');
CONSTANT HZeroCount   : STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0');

SIGNAL   VEnable      : STD_LOGIC;

SIGNAL   HCount       : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL   VCount       : STD_LOGIC_VECTOR(10 DOWNTO 0);

SIGNAL   VideoVon     : STD_LOGIC;
SIGNAL   VideoHOn     : STD_LOGIC;

SIGNAL   TempVideo    : STD_LOGIC;

SIGNAL   TempHs1      : STD_LOGIC;
SIGNAL   TempHs2      : STD_LOGIC;
SIGNAL   TempVs1      : STD_LOGIC;
SIGNAL   TempVs2      : STD_LOGIC;

SIGNAL   ControlH     : STD_LOGIC;
SIGNAL   ControlV     : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

VgaBlank <= '1';

VgaSync  <= '0';

VgaClk <= SyncClk;

TempVideo <= VideoVon AND VideoHOn;
VideoOn   <= TempVideo;

WITH TempVideo SELECT
PixelX    <= HCount     WHEN '1',
				 HZeroCount WHEN OTHERS;

WITH TempVideo SELECT
PixelY    <= VCount     WHEN '1',
				 VZeroCount WHEN OTHERS;



TempHs1   <= '1' WHEN (UNSIGNED(HCount) <= UNSIGNED(HTime.FrontPorch))
					  ELSE '0';
TempHs2   <= '1' WHEN (UNSIGNED(HCount) >  UNSIGNED(HTime.Retrace   ))
					  ELSE '0';

TempVs1   <= '1' WHEN (UNSIGNED(VCount) <= UNSIGNED(VTime.FrontPorch))
					  ELSE '0';
TempVs2   <= '1' WHEN (UNSIGNED(VCount) >  UNSIGNED(VTime.Retrace   ))
					  ELSE '0';

ControlH  <= TempHs1 OR TempHs2;
ControlV  <= TempVs1 OR TempVs2;

HSync     <= '1' WHEN (ControlH = '1')
					  ELSE '0';

VSync     <= '1' WHEN (COntrolV = '1')
					  ELSE '0';

VideoHOn  <= '1' WHEN ( UNSIGNED(HCount) <= UNSIGNED(HTime.Display   ))
					  ELSE  '0';

VideoVOn  <= '1' WHEN ( UNSIGNED(VCount) <= UNSIGNED(VTime.Display   ))
					  ELSE  '0';

HCounter: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => 11
			  )
PORT MAP	  (Data     => HZeroCount,
				Clk      => SyncClk,
				MR       => Reset,
				SR       => '0',
				Ena      => '1',
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => HTime.FullScan,
				MaxCount => VEnable,
				MinCount => OPEN,
				Count    => HCount
			  );

VCounter: ENTITY WORK.GralLimCounter 
GENERIC MAP(Size => 11
			  )
PORT MAP	  (Data     => VZeroCount,
				Clk      => SyncClk,
				MR       => Reset,
				SR       => '0',
				Ena      => VEnable,
				Pload    => '0',
				Up       => '1',
				Dwn      => '0',
				Limit    => VTime.FullScan,
				MaxCount => OPEN,
				MinCount => OPEN,
				Count    => VCount
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SvgaSync 
--PORT MAP	  (Reset    => SLV,
--				SyncClk  => SLV,
--				HSync    => SLV,
--				VSync    => SLV,
--				VideoOn  => SLV,
--				VgaBlank => SLV,
--				VgaClk   => SLV,
--				VgaSync  => SLV,
--				PixelX   => SLV,
--				PixelY   => SLV
--			  );
--******************************************************--

END SvgaSyncArch;