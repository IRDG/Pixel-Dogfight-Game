
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

ENTITY SubSysAdd IS
	GENERIC(
				Size : Integer := 4
			 );
	PORT   (
		   	Ain : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Bin : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Cin : IN  STD_LOGIC;
				S   : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Sc  : OUT STD_LOGIC
			 );
	
END ENTITY SubSysAdd;

ARCHITECTURE SubSysAddArch OF SubSysAdd IS

SIGNAL CaO   : STD_LOGIC_VECTOR(Size-2 DOWNTO 0);

SIGNAL PreS  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL PreSc : STD_LOGIC;

BEGIN

--******************************************************--
-- Suma
--******************************************************--

CA1: ENTITY WORK.BasicCompleteAdder
PORT MAP(A    => Ain (0),
			B    => Bin (0),
			Cin  => Cin,
			S    => PreS(0),
			Cout => CaO (0)
		  );

CompleteAddersGenerator: FOR I IN 1 TO  Size-2 GENERATE
	
	CAn: ENTITY WORK.BasicCompleteAdder
	PORT MAP(A    => Ain ( I ),
				B    => Bin ( I ),
				Cin  => CaO (I-1),
				S    => PreS( I ),
				Cout => CaO ( I )
			  );
	
END GENERATE CompleteAddersGenerator;

CAf: ENTITY WORK.BasicCompleteAdder
PORT MAP(A    => Ain (Size-1),
			B    => Bin (Size-1),
			Cin  => CaO (Size-2),
			S    => PreS(Size-1),
			Cout => PreSc
		  );

S  <= PreS;
Sc <= PreSc;

end SubSysAddArch;