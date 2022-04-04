
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

ENTITY SubtractIfGreater IS
	
	GENERIC(
				Size: INTEGER := 8
			 );
	PORT	 (
				Data : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Num  : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Used : OUT STD_LOGIC;
				Dout : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
			 );
	
END ENTITY SubtractIfGreater;

ARCHITECTURE SubtractIfGreaterArch OF SubtractIfGreater IS

SIGNAL Result : STD_LOGIC;
SIGNAL NwData : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Used <= NOT Result;

XgtY: ENTITY WORK.BasicXinGreaterThanYin 
GENERIC MAP(Size => Size
			  )
PORT MAP	  (Xin => Num,
				Yin => Data,
				XgY => Result
			  );

AoS: ENTITY WORK.SysAddOrSubtract 
GENERIC MAP(Size => Size
			  )
PORT MAP	  (Ain => Data,
				Bin => Num,
				Sa  => '0',
				Sb  => '1',
				S   => NwData,
				Sc  => OPEN,
				So  => OPEN
			  );

Mux: ENTITY WORK.MuxSelector2to1
GENERIC MAP(SizeIn => Size
			  )
PORT MAP	  (InA      => NwData,
				InB      => Data,
				Selector => Result,
				Choice   => Dout
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SubtractIfGreater 
--GENERIC MAP(Size => #
--			 	 )
--PORT MAP	  (Data => SLV,
--				Num => SLV,
--				Used => SLV,
--				Dout => SLV
--			  );
--******************************************************--

end SubtractIfGreaterArch;