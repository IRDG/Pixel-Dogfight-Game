--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
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

ENTITY BulletControl IS
	
	PORT	 (
				PlayerP : IN  STD_LOGIC;
				DisB    : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				Reset   : IN  STD_LOGIC;
				Clk     : IN  STD_LOGIC;
				ActiveB : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
			 );
	
END ENTITY BulletControl;

ARCHITECTURE BulletControlArch OF BulletControl IS


TYPE   StateType IS (B01,B02,B03,B04,B05,Standby,Dis);

SIGNAL NextState     : StateType;
SIGNAL PrevState     : StateType;

SIGNAL Shoot         : STD_LOGIC;

SIGNAL ActiveBullets : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL NewBullet     : STD_LOGIC_VECTOR(4 DOWNTO 0);

SIGNAL Dis1          : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Dis2          : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Dis3          : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Disable       : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL DisableN      : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL DisableAny    : STD_LOGIC;
SIGNAL GotoDis       : STD_LOGIC;
SIGNAL EnableDis     : STD_LOGIC;
SIGNAL TrueEnable    : STD_LOGIC;

SIGNAL Enable        : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

ActiveB    <= ActiveBullets;


Disable    <= Dis1 OR Dis2 OR Dis3;
DisableN   <= NOT Disable;
DisableAny <= Disable(0) OR Disable(1) OR Disable(2) OR Disable(3) OR Disable(4);
TrueEnable <= EnableDis OR DisableAny;

StateMemory: PROCESS (Reset, Clk)
BEGIN
	
	IF (Reset='1')THEN
		
		PrevState <= Standby;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		PrevState <= NextState;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState, Disable, ActiveBullets, GotoDis, DisableN, Shoot)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN StandBy =>
			
			NewBullet <= "00000";
			EnableDis <= '0';
			Enable    <= '0';
			
			IF   ((Shoot = '1') AND (ActiveBullets(0) = '0'))THEN
				
				NextState <= B01;
				
			ELSIF((Shoot = '1') AND (ActiveBullets(1) = '0') AND (ActiveBullets(0) = '1'))THEN
				
				NextState <= B02;
				
			ELSIF((Shoot = '1') AND (ActiveBullets(2) = '0') AND (ActiveBullets(1) = '1') 
									  AND (ActiveBullets(0) = '1'))THEN
				
				NextState <= B03;
				
			ELSIF((Shoot = '1') AND (ActiveBullets(3) = '0') AND (ActiveBullets(2) = '1') 
									  AND (ActiveBullets(1) = '1') AND (ActiveBullets(0) = '1'))THEN
				
				NextState <= B04;
				
			ELSIF((Shoot = '1') AND (ActiveBullets(4) = '0') AND (ActiveBullets(3) = '1') 
									  AND (ActiveBullets(2) = '1') AND (ActiveBullets(1) = '1') AND (ActiveBullets(0) = '1'))THEN
				
				NextState <= B05;
				
			ELSIF(GotoDis = '1')THEN
				
				NextState <= Dis;
				
			ELSE
				
				NextState <= Standby;
				
			END IF;
	----------------------------------------------------------
		WHEN B01 =>
			
			NewBullet <= "00001" OR ActiveBullets;
			EnableDis <= '0';
			Enable    <= '1';
			
			NextState <= Standby;
			
	----------------------------------------------------------
		WHEN B02 =>
			
			NewBullet <= "00010" OR ActiveBullets;
			EnableDis <= '0';
			Enable    <= '1';
			
			NextState <= Standby;
			
	----------------------------------------------------------
		WHEN B03 =>
			
			NewBullet <= "00100" OR ActiveBullets;
			EnableDis <= '0';
			Enable    <= '1';
			
			NextState <= Standby;
			
	----------------------------------------------------------
		WHEN B04 =>
			
			NewBullet <= "01000" OR ActiveBullets;
			EnableDis <= '0';
			Enable    <= '1';
			
			NextState <= Standby;
			
	----------------------------------------------------------
		WHEN B05 =>
			
			NewBullet <= "10000" OR ActiveBullets;
			EnableDis <= '0';
			Enable    <= '1';
			
			NextState <= Standby;
			
	----------------------------------------------------------
		WHEN Dis =>
			
			NewBullet <= DisableN AND ActiveBullets;
			EnableDis <= '1';
			Enable    <= '1';
			
			NextState <= Standby;
			
	----------------------------------------------------------
	END CASE;

END PROCESS StateChange;

PROCESS(Clk, Reset, NewBullet)

BEGIN
	
	IF(Reset='1')THEN
		
		ActiveBullets <= "00000";
		GotoDis       <= '0';
		
	ELSIF(Rising_Edge(Clk))THEN
		
		IF(Enable = '1')THEN
			
			ActiveBullets <=     NewBullet;
			
		END IF;
		
		IF(TrueEnable = '1')THEN
			
			GotoDis       <= NOT GoToDis;
			
		END IF;
		
		Dis1 <= DisB;
		Dis2 <= Dis1;
		Dis3 <= Dis2;
		
	END IF;
	
END PROCESS;

Player1Debounce: ENTITY WORK.Debouncer 
PORT MAP	  (SerialData => PlayerP,
				Reset      => Reset,
				Clk        => Clk,
				PulseOnes  => OPEN,
				Pulse      => Shoot
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.BulletControl 
--PORT MAP	  (PlayerP => SLV,
--				DisB    => SLV,
--				Reset   => SLV,
--				Clk     => SLV,
--				ActiveB => SLV
--			  );
--******************************************************--

END BulletControlArch;