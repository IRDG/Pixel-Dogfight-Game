
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

ENTITY BasicHalfAadder IS
	
	PORT(
			A    : IN  STD_LOGIC;
			B    : IN  STD_LOGIC;
			S    : OUT STD_LOGIC;
			Cout : OUT STD_LOGIC
		 );
	
END ENTITY BasicHalfAadder;

ARCHITECTURE BasicHalfAadderArch OF BasicHalfAadder IS

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

S    <= (A XOR B);
Cout <= (A AND B);

end BasicHalfAadderArch;