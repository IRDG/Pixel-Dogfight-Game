
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

ENTITY SysAddOrSubtract IS
	GENERIC(
				Size: INTEGER := 4
			 );
	PORT	 (
				-- Numeros entrada
				Ain : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Bin : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				-- Signos Entrada
				Sa  : IN  STD_LOGIC;
				Sb  : IN  STD_LOGIC;
				-- Salida Numero (logica positiva) y Overflow
				S   : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Sc  : OUT STD_LOGIC;
				-- Salida Signo
				So  : OUT STD_LOGIC
			 );
	
END ENTITY SysAddOrSubtract;

ARCHITECTURE SysAddOrSubtractArch OF SysAddOrSubtract IS

SIGNAL TsA : STD_LOGIC;
SIGNAL TsB : STD_LOGIC;
SIGNAL TsO : STD_LOGIC;

SIGNAL SumIn  : STD_LOGIC;
SIGNAL SumOut : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL SumOc  : STD_LOGIC;

SIGNAL OAin : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL OBin : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
Signal ScP  : STD_LOGIC;

SIGNAL FinalSign : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

SumIn <= TsA OR TsB;
So    <= TsO;

XorGenerator : For I in Size-1 DOWNTO 0 GENERATE
	
	OAin(I) <= Ain(I) XOR TsA;
	OBin(I) <= Bin(I) XOR TsB;
	
END GENERATE XorGenerator;

SumasStd: ENTITY WORK.SubSysAdd
GENERIC MAP(Size => Size
			  )
PORT MAP	  (Ain => OAin,
				Bin => OBin,
				Cin => SumIn,
				S   => SumOut,
				Sc  => SumOc
			  );

SignStd: ENTITY WORK.SubSysSign
GENERIC MAP(Size => Size
			  )
PORT MAP	  (Ain => Ain,
				Bin => Bin,
				Sa  => Sa,
				Sb  => Sb,
				TsA => TsA,
				TsB => TsB,
				TsO => TsO,
				FsO => FinalSign
			  );

TwosComp: ENTITY WORK.BasicTwosComp
GENERIC MAP(Size => Size+1
			  )
PORT MAP	  (Ain  => SumOut,
				Ac   => SumOc,
				Sign => FinalSign,
				S    => S,
				Sc   => ScP
			  );

WITH SumIn SELECT
Sc <= ScP WHEN '0',
			 '0' WHEN OTHERS;


--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SysAddOrSubtract 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Ain => SLV,
--				Bin => SLV,
--				Sa  => SLV,
--				Sb  => SLV,
--				S   => SLV,
--				Sc  => SLV,
--				So  => SLV
--			  );
--******************************************************--

end SysAddOrSubtractArch;