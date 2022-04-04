
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

ENTITY MuxSelector2to1 IS
	
	GENERIC(
				SizeIn: INTEGER := 7
			 );
	PORT	 (
				InA      : IN  STD_LOGIC_VECTOR(SizeIn-1 DOWNTO 0);
				InB      : IN  STD_LOGIC_VECTOR(SizeIn-1 DOWNTO 0);
				Selector : IN  STD_LOGIC;
				Choice   : OUT STD_LOGIC_VECTOR(SizeIn-1 DOWNTO 0)
			 );
	
END ENTITY MuxSelector2to1;

ARCHITECTURE MuxSelector2to1Arch OF MuxSelector2to1 IS

BEGIN

--******************************************************--
-- 
--******************************************************--

WITH Selector SELECT
Choice <= InA WHEN '0',
			 InB WHEN OTHERS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.MuxSelector2to1
--GENERIC MAP(SizeIn => #
--			 	 )
--PORT MAP	  (InA      => SLV,
--				InB      => SLV,
--				Selector => SLV,
--				Choice   => SLV
--			  );
--******************************************************--

end MuxSelector2to1Arch;