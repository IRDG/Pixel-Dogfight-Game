
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

ENTITY BasicCompleteAdder IS
	
	PORT(
			A    : IN  STD_LOGIC;
			B    : IN  STD_LOGIC;
			Cin  : IN  STD_LOGIC;
			S    : OUT STD_LOGIC;
			Cout : OUT STD_LOGIC
		 );
	
END ENTITY BasicCompleteAdder;

ARCHITECTURE BasicCompleteAdderArch OF BasicCompleteAdder IS

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

S    <= (A XOR B) XOR Cin;
Cout <= (A AND B)  OR ((A XOR B) AND Cin);

end BasicCompleteAdderArch;