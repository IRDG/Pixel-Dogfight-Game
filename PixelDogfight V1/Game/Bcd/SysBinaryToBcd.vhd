
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
USE ieee.numeric_std.all;

LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY SysBinaryToBcd IS
	
	GENERIC(
				Size  : INTEGER := 10;
				NoDw  : INTEGER := 4;
				Inter : INTEGER := 4
			 );
	PORT	 (
				Number : IN  STD_LOGIC_VECTOR(  Size-1   DOWNTO 0);
				Digits : OUT STD_LOGIC_VECTOR((4*NoDw)-1 DOWNTO 0)
			 );
	
END ENTITY SysBinaryToBcd;

ARCHITECTURE SysBinaryToBcdArch OF SysBinaryToBcd IS
 
TYPE MatrixSizex4  IS ARRAY (0 TO Size-1)     OF STD_LOGIC_VECTOR(   3   DOWNTO 0);
TYPE Matrix4SxSP2  IS ARRAY (0 TO (Size+1)*4) OF STD_LOGIC_VECTOR(Size+2 DOWNTO 0);

SIGNAL Data  : MatrixSizex4 := (OTHERS =>"0000");
SIGNAL NumIn : Matrix4SxSP2;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

NumIn(0)(Size+2 DOWNTO 0) <="000" & Number;

DigitExtraction:FOR K in Inter-1 DOWNTO 1 GENERATE
	
	BlockN4: ENTITY WORK.SubtractIfGreater 
	GENERIC MAP(Size => Size+3
				  )
	PORT MAP	  (Data => NumIn(((Inter-K-1)*4)+0)(Size+2 DOWNTO 0),
					Num  => std_logic_vector(to_unsigned(4*(10**K), Size+3)),
					Used => Data(K-1)(3),
					Dout => NumIn(((Inter-K-1)*4)+1)(Size+2 DOWNTO 0)
				  );
	
	BlockN3: ENTITY WORK.SubtractIfGreater 
	GENERIC MAP(Size => Size+3
				  )
	PORT MAP	  (Data => NumIn(((Inter-K-1)*4)+1)(Size+2 DOWNTO 0),
					Num  => std_logic_vector(to_unsigned(3*(10**K), Size+3)),
					Used => Data(K-1)(2),
					Dout => NumIn(((Inter-K-1)*4)+2)(Size+2 DOWNTO 0)
				  );
	
	BlockN2: ENTITY WORK.SubtractIfGreater 
	GENERIC MAP(Size => Size+3
				  )
	PORT MAP	  (Data => NumIn(((Inter-K-1)*4)+2)(Size+2 DOWNTO 0),
					Num  => std_logic_vector(to_unsigned(2*(10**K), Size+3)),
					Used => Data(K-1)(1),
					Dout => NumIn(((Inter-K-1)*4)+3)(Size+2 DOWNTO 0)
				  );
	
	BlockN1: ENTITY WORK.SubtractIfGreater 
	GENERIC MAP(Size => Size+3
				  )
	PORT MAP	  (Data => NumIn(((Inter-K-1)*4)+3)(Size+2 DOWNTO 0),
					Num  => std_logic_vector(to_unsigned(1*(10**K), Size+3)),
					Used => Data(K-1)(0),
					Dout => NumIn(((Inter-K-0)*4)+0)(Size+2 DOWNTO 0)
				  );
	
END GENERATE DigitExtraction;

Digits(3 DOWNTO 0) <=NumIn(((Inter-1-0)*4)+0)(3 DOWNTO 0);

DigitCreation : FOR J IN 2 TO NoDw GENERATE
	
	WITH Data(J-2)(3 DOWNTO 0) SELECT
	Digits((4*J)-1 DOWNTO ((4*(J-1))  )) <= "0000" WHEN "0000", -- 00
														 "0001" WHEN "0001", -- 01
														 "0010" WHEN "0010", -- 02
														 "0011" WHEN "0011", -- 03
														 "0011" WHEN "0100", -- 03
														 "0100" WHEN "0101", -- 04
														 "0101" WHEN "0110", -- 05
														 "0110" WHEN "0111", -- 06
														 "0100" WHEN "1000", -- 04
														 "0101" WHEN "1001", -- 05
														 "0110" WHEN "1010", -- 06
														 "0111" WHEN "1011", -- 07
														 "0111" WHEN "1100", -- 07
														 "1000" WHEN "1101", -- 08
														 "1001" WHEN "1110", -- 09
														 "1010" WHEN OTHERS; -- 10
	
END GENERATE DigitCreation;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SysBinaryToBcd 
--GENERIC MAP(Size  => #,
--			   NoDw  => #,
--				Inter => #
--			  )
--PORT MAP	  (Number => SLV,
--				Digits => SLV
--			  );
--******************************************************--

end SysBinaryToBcdArch;