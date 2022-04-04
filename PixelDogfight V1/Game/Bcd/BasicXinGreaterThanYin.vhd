
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
USE IEEE.std_logic_unsigned.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY BasicXinGreaterThanYin IS
	GENERIC(
				Size : INTEGER :=4
			 );
	PORT	 (
				Xin : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Yin : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				XgY : OUT STD_LOGIC
			 );
	
END ENTITY BasicXinGreaterThanYin;
	
ARCHITECTURE BasicXinGreaterThanYinArch OF BasicXinGreaterThanYin IS

BEGIN

--******************************************************--
-- X > Y => 1
-- X < Y => 0
--******************************************************--

XgY <= '1' WHEN Xin > Yin ELSE '0';

end BasicXinGreaterThanYinArch;