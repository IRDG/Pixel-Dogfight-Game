
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

ENTITY BasicTwosComp IS
	GENERIC(
				Size: INTEGER := 4
			 );
	PORT	 (
				Ain  : IN  STD_LOGIC_VECTOR(Size-2 DOWNTO 0);
				Ac   : IN  STD_LOGIC;
				Sign : IN  STD_LOGIC;
				S    : OUT STD_LOGIC_VECTOR(Size-2 DOWNTO 0);
				Sc   : OUT STD_LOGIC
			 );
	
END ENTITY BasicTwosComp;

ARCHITECTURE BasicTwosCompArch OF BasicTwosComp IS

SIGNAL Input : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Carry : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Xin   : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

BEGIN

Xin      <= Ac & Ain;
Input(0) <= Xin(0) XOR Sign;

HA1: ENTITY WORK.BasicHalfAadder
PORT MAP(A    => Input(0),
			B    => Sign,
			S    => S    (0),
			Cout => Carry(0) 
		  );

Generator : FOR I in 1 TO Size-2 GENERATE
	
	Input(I) <= Xin(I) XOR Sign;
	
	HAn: ENTITY WORK.BasicHalfAadder
	PORT MAP(A    => Input( I ),
				B    => Carry(I-1),
				S    => S    ( I ),
				Cout => Carry( I )
			  );
	
END GENERATE Generator;

Input(Size-1) <= Xin(Size-1) XOR Sign;

HAf: ENTITY WORK.BasicHalfAadder
PORT MAP(A    => Input(Size-1),
			B    => Carry(Size-2),
			S    => Sc,
			Cout => Carry(Size-1)
 		  );

end BasicTwosCompArch;