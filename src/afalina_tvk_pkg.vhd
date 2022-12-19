LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

package Afalina_tvk_pkg is

component EOP_CONTROL
	port
		(
		CLK			: in std_logic;
		RESET 		: in std_logic;--__|--|__ -- сброс единицей
		CONTROL		: in std_logic_vector(7 downto 0);
		OPEN_VL		: in std_logic;
		CLOSE_VL	: in std_logic;
		EOP_ON		: out std_logic;
		BR			: out std_logic;
		PH			: out std_logic
		);		
end component;	  

	
	
component mpu_res
	port(
		CLK 		: in STD_LOGIC;
		RESET_INT	: out STD_LOGIC;
		CNT_EN		: out STD_LOGIC
	);
end component;	 

component PLLBM IS
	port
	(
		inclk0	: IN STD_LOGIC  := '0'; --aoia pll 59 eee 57,28
		c0		: OUT STD_LOGIC ;--14
		c1		: OUT STD_LOGIC ;--28
		c2		: OUT STD_LOGIC --28
	);
end component;



component PLL IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC 
	);
END component;


component ccd_generator is
	port
	(
		CLK			: IN STD_LOGIC; -- CLK_PIX * 4 = 114_56
		CNT_EN		: IN STD_LOGIC; 
		RESET 		: IN STD_LOGIC; 
		SHUTTER		: IN STD_LOGIC_VECTOR(11 downto 0);--грубый затвор
		GAIN		: IN STD_LOGIC_VECTOR(9 downto 0);--усиление
		GAIN_STROBE	: IN STD_LOGIC;
		CLAMP		: IN STD_LOGIC_VECTOR(7 downto 0);--привязка к уровню черного		
		CLAMP_STROBE: IN STD_LOGIC;
		CHOICE_CCD	: IN STD_LOGIC;-- 0 - ccda = icx285 ccdb - none / 1 - ccda = icx415 ccdb = icx415
		MODE_CCD	: IN STD_LOGIC;
		WIND_CCD	: IN STD_LOGIC; -- 0 стационарное окно 1 - перемещающееся 		
		--CCDA
		XV1A 		: OUT STD_LOGIC;
		XV2A 		: OUT STD_LOGIC;
		XV3A 		: OUT STD_LOGIC;
		XV4A 		: OUT STD_LOGIC;
		SG2AA 		: OUT STD_LOGIC;
		SG2BA 		: OUT STD_LOGIC;
		XSUBA 		: OUT STD_LOGIC;	
		H1A 		: OUT STD_LOGIC;
		H2A 		: OUT STD_LOGIC;
		RGA 		: OUT STD_LOGIC;	
		--AD9845
		DATACLKA 	: OUT STD_LOGIC;	
		SL 			: OUT STD_LOGIC;
		SCK 		: OUT STD_LOGIC;
		SDATA 		: OUT STD_LOGIC;
		SHDA 		: OUT STD_LOGIC;
		SHPA 		: OUT STD_LOGIC;
		VDA 		: OUT STD_LOGIC;  
		HDA 		: OUT STD_LOGIC;
		PBLKA 		: OUT STD_LOGIC;	
		CLPDMA 		: OUT STD_LOGIC;
		CLPOBA 		: OUT STD_LOGIC;
		
		-- CCDB
		XV1B 		: OUT STD_LOGIC;
		XV2B 		: OUT STD_LOGIC;
		XV3B 		: OUT STD_LOGIC;
		XV4B 		: OUT STD_LOGIC;
		SG2AB 		: OUT STD_LOGIC;		
		SG2BB 		: OUT STD_LOGIC;
		XSUBB 		: OUT STD_LOGIC;
		H1B 		: OUT STD_LOGIC;
		H2B 		: OUT STD_LOGIC;
		RGB 		: OUT STD_LOGIC;
		--AD9845
		DATACLKB 	: OUT STD_LOGIC;
		SHDB 		: OUT STD_LOGIC;
		SHPB 		: OUT STD_LOGIC;
		VDB 		: OUT STD_LOGIC;
		HDB 		: OUT STD_LOGIC;
		PBLKB 		: OUT STD_LOGIC;
		CLPDMB 		: OUT STD_LOGIC;
		CLPOBB 		: OUT STD_LOGIC;

		X			: OUT STD_LOGIC_VECTOR(11 downto 0);--горизонтальный счетчик
		Y			: OUT STD_LOGIC_VECTOR(11 downto 0);--вертикальный счетчик
		
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC;
		DATE_EN		: OUT STD_LOGIC		
		
		
	);
end component;

component ccd285_sync_generator 
	port
	(
		CLK			: IN STD_LOGIC; -- CLK_PIX * 4 = 114_56
		CNT_EN		: IN STD_LOGIC; 
		RESET 		: IN STD_LOGIC; 
		SHUTTER		: IN STD_LOGIC_VECTOR(11 downto 0);--грубый затвор
		GAIN		: IN STD_LOGIC_VECTOR(9 downto 0);--усиление
		GAIN_STROBE	: IN STD_LOGIC;
		CLAMP		: IN STD_LOGIC_VECTOR(7 downto 0);--привязка к уровню черного		
		CLAMP_STROBE: IN STD_LOGIC;		
		MODE_CCD	: IN STD_LOGIC;
		WIND_CCD	: IN STD_LOGIC; -- 0 стационарное окно 1 - перемещающееся 		
		-- Управление регистрами CCD
		XV1 		: OUT STD_LOGIC;
		XV2 		: OUT STD_LOGIC;
		XV3 		: OUT STD_LOGIC;
		XV4 		: OUT STD_LOGIC;
		SG2A 		: OUT STD_LOGIC;
		SG2B 		: OUT STD_LOGIC;
		XSUB 		: OUT STD_LOGIC;	
		H1	 		: OUT STD_LOGIC;
		H2 			: OUT STD_LOGIC;
		RG	 		: OUT STD_LOGIC;	
		--AD9845
		DATACLK 	: OUT STD_LOGIC;	
		SL 			: OUT STD_LOGIC;
		SCK 		: OUT STD_LOGIC;
		SDATA 		: OUT STD_LOGIC;
		SHD 		: OUT STD_LOGIC;
		SHP 		: OUT STD_LOGIC;
		VD	 		: OUT STD_LOGIC;  
		HD	 		: OUT STD_LOGIC;
		PBLK 		: OUT STD_LOGIC;	
		CLPDM 		: OUT STD_LOGIC;
		CLPOB 		: OUT STD_LOGIC;
		X			: OUT STD_LOGIC_VECTOR(11 downto 0);--горизонтальный счетчик
		Y			: OUT STD_LOGIC_VECTOR(11 downto 0);--вертикальный счетчик
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC;
		DATE_EN		: OUT STD_LOGIC

	);
end component;			


component ccd_counters 	
	generic	
		(
		MODULEY		: NATURAL;			  
		MODULEY_FULL: NATURAL; 
		MODULEX		: NATURAL
	);

	port
		(
		CLK			: in std_logic;--global CLK 2/1	 
		CNT_EN		: in std_logic;-- 
		RESET 		: in std_logic;--__|--|__
		MODE_CCD	: in std_logic; -- 0  полоса 1 полнокадровый режим
		X			: out std_logic_vector(11 downto 0);
		Y			: out std_logic_vector(11 downto 0)
		);		
end component;	
component xvform_285
	port
		(
		CLK			: in std_logic;	 
		CNT_EN		: in std_logic;
		RESET		: in std_logic;
		C_SHUTTER 	: in std_logic_vector(11 downto 0);
		F_SHUTTER 	: in std_logic_vector(11 downto 0);
		MODE_CCD	: in std_logic; -- 0  полоса 1 полнокадровый режим
		WIND_CCD	: in std_logic; -- 0 стационарное окно 1 - перемещающееся 
		X			: in std_logic_vector(11 downto 0);
		Y			: in std_logic_vector(11 downto 0);
		--NUM_F_LINE	: in std_logic_vector(11 downto 0);--от 6 до 56 
		-- управление вертикальными регистрами icx285al
		XV1 		: OUT STD_LOGIC;
		XV2 		: OUT STD_LOGIC;
		XV3 		: OUT STD_LOGIC;
		XV4 		: OUT STD_LOGIC;
		SG2A 		: OUT STD_LOGIC;
		SG2B 		: OUT STD_LOGIC;
		XSUB 		: OUT STD_LOGIC;
		H1			: OUT STD_LOGIC;
		H2			: OUT STD_LOGIC;
		RG			: OUT STD_LOGIC;
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC
		

		);		
end component;	   
component AD9845 
	generic	
		(
		VD_EDGE				: NATURAL;
		HD_EDGE				: NATURAL;
		PBLK_RISING_EDGE_Y 	: NATURAL;	 --26 
		PBLK_FALLING_EDGE_Y	: NATURAL;	--57	
		PBLK_RISING_EDGE_X 	: NATURAL;	 --56 
		PBLK_FALLING_EDGE_X	: NATURAL;	--412	
		CLP_RISING_EDGE_X	: NATURAL;
		CLP_FALLING_EDGE_X	: NATURAL

		
		);
		

	 port(
		CLK			: in STD_LOGIC;
		CNT_EN		: in STD_LOGIC;
		RESET 		: in STD_LOGIC;
		ADC_GAIN 	: in STD_LOGIC_VECTOR(9 downto 0);
		ADC_CLAMP	: in STD_LOGIC_VECTOR(7 downto 0); 
		GAIN_STROBE	: in STD_LOGIC;
		CLAMP_STROBE: in STD_LOGIC;
		X			: in STD_LOGIC_VECTOR(11 downto 0);
		Y			: in STD_LOGIC_VECTOR(11 downto 0);
		MODE_CCD	: IN STD_LOGIC;		
		VD			: out STD_LOGIC;
		HD			: out STD_LOGIC;
        DATACLK 	: OUT STD_LOGIC;	
		SHD 		: OUT STD_LOGIC;
		SHP 		: OUT STD_LOGIC;
		PBLK 		: OUT STD_LOGIC;	
		CLPDM 		: OUT STD_LOGIC;
		CLPOB 		: OUT STD_LOGIC;
		AD_SDATA	: out STD_LOGIC;
		AD_SL		: out STD_LOGIC;
		AD_SCK		: out STD_LOGIC
	     );
end component;
component ccd415_sync_generator  
	port
	(
		CLK			: IN STD_LOGIC; -- CLK_PIX * 4 = 118 МГц
		CNT_EN		: IN STD_LOGIC; 
		RESET 		: IN STD_LOGIC; 
		SHUTTER		: IN STD_LOGIC_VECTOR(11 downto 0);--грубый затвор
		GAIN		: IN STD_LOGIC_VECTOR(9 downto 0);--усиление
		GAIN_STROBE	: IN STD_LOGIC;
		CLAMP		: IN STD_LOGIC_VECTOR(7 downto 0);--привязка к уровню черного		
		CLAMP_STROBE: IN STD_LOGIC;
		MODE_CCD	: IN STD_LOGIC;
		WIND_CCD	: IN STD_LOGIC; -- 0 стационарное окно 1 - перемещающееся 		


		-- Управление регистрами CCD 415
		XV1 		: OUT STD_LOGIC;
		XV2 		: OUT STD_LOGIC;
		XV3 		: OUT STD_LOGIC;
		SG	 		: OUT STD_LOGIC;
		XSUB 		: OUT STD_LOGIC;	
		H1	 		: OUT STD_LOGIC;
		H2 			: OUT STD_LOGIC;
		RG	 		: OUT STD_LOGIC;	
		--AD9845
		DATACLK 	: OUT STD_LOGIC;	
		SL 			: OUT STD_LOGIC;
		SCK 		: OUT STD_LOGIC;
		SDATA 		: OUT STD_LOGIC;
		SHD 		: OUT STD_LOGIC;
		SHP 		: OUT STD_LOGIC;
		VD	 		: OUT STD_LOGIC;  
		HD	 		: OUT STD_LOGIC;
		PBLK 		: OUT STD_LOGIC;	
		CLPDM 		: OUT STD_LOGIC;
		CLPOB 		: OUT STD_LOGIC;
		X			: OUT STD_LOGIC_VECTOR(11 downto 0);--горизонтальный счетчик
		Y			: OUT STD_LOGIC_VECTOR(11 downto 0);--вертикальный счетчик
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC;
		DATE_EN		: OUT STD_LOGIC
		
	);
end component;	 

component xvform_415 is
	port
		(
		CLK			: in std_logic;	 
		CNT_EN		: in std_logic;
		RESET		: in std_logic;
		C_SHUTTER 	: in std_logic_vector(11 downto 0);
		F_SHUTTER 	: in std_logic_vector(11 downto 0);
		MODE_CCD	: in std_logic; -- 0  полоса 1 полнокадровый режим
		WIND_CCD	: in std_logic; -- 0 стационарное окно 1 - перемещающееся 
		
		X			: in std_logic_vector(11 downto 0);
		Y			: in std_logic_vector(11 downto 0);
		-- управление вертикальными регистрами icx415al
		XV1 		: OUT STD_LOGIC;
		XV2 		: OUT STD_LOGIC;
		XV3 		: OUT STD_LOGIC;
		SG	 		: OUT STD_LOGIC;
		XSUB 		: OUT STD_LOGIC;
		H1			: OUT STD_LOGIC;
		H2			: OUT STD_LOGIC;
		RG			: OUT STD_LOGIC;
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC
		
		);		
end component;	   


component AduC842 IS 
	port
	(
		CLK29_5 	: IN  STD_LOGIC;
		MPU_MODE 	: IN  STD_LOGIC;
		MPU_RESET 	: IN  STD_LOGIC;
		MPU_WR 		: IN  STD_LOGIC;
		MPU_RD 		: IN  STD_LOGIC;
		HD 			: IN  STD_LOGIC;
		VD 			: IN  STD_LOGIC;
		MPU_ADDR 	: IN  STD_LOGIC_VECTOR(7 downto 0);
		MPU_D 		: INOUT STD_LOGIC_VECTOR(7 downto 0);
		MPU_INT0 	: OUT STD_LOGIC;
		MPU_INT1 	: OUT STD_LOGIC;
		ALE 		: IN  STD_LOGIC;
		RESET_842   : OUT STD_LOGIC;
		PSEN 		: OUT STD_LOGIC;
		SHUTTER		: OUT STD_LOGIC_VECTOR(11 downto 0);
		GAIN		: OUT STD_LOGIC_VECTOR(9 downto 0);
		GAIN_STROBE : OUT STD_LOGIC;
		CLAMP		: OUT STD_LOGIC_VECTOR(7 downto 0);
		CLAMP_STROBE: OUT STD_LOGIC;
		CHOICE_CCD	: OUT STD_LOGIC_VECTOR(7 downto 0);
		SHD_SHIFT	: OUT std_logic_vector(7 downto 0);
		SHP_SHIFT	: OUT std_logic_vector(7 downto 0);
		CLK_SHIFT	: OUT std_logic_vector(7 downto 0);
		RG_SHIFT	: OUT std_logic_vector(7 downto 0);
		CONTROL		: OUT std_logic_vector(7 downto 0);
		RS485_TXD 	: OUT STD_LOGIC;	
		RS485_RXD 	: IN STD_LOGIC;	
		RS485_MODE 	: OUT STD_LOGIC;
		RS485_PV 	: OUT STD_LOGIC	

		

	);
end component;

component aduc_reg is
	port(
		CLK 		: in std_logic;
		RESET 		: in std_logic;
		DATA_REG	: in std_logic_vector(7 downto 0);
		ADUC_ADDR	: in std_logic_vector(7 downto 0);
		WR			: in std_logic;
		SHUTTER		: out std_logic_vector(15 downto 0);
		GAIN		: out std_logic_vector(15 downto 0);
		CLAMP		: out std_logic_vector(7 downto 0);
		MPU_D		: out std_logic_vector(7 downto 0)

		);
end component;		

component test_lvds_cnt is
	port
		(
		CLK			: in std_logic;
		CNT_EN		: in std_logic; 
		RESET 		: in std_logic;
		CHOICE_CCD	: in std_logic; -- выбор камеры 0 - ТВ1 / 1 - ТВ2
		MODE_CCD	: in std_logic; --0 - полоса 1 - полнокадровый
		X			: in std_logic_vector(11 downto 0);
		Y			: in std_logic_vector(11 downto 0);
		test		: out std_logic_vector(11 downto 0)
		);		
end component;	  

component DFF_ig is
	port (
		Q	: out STD_LOGIC ;
        D	: in STD_LOGIC ;
        CLK : in STD_LOGIC ;
        CLRN: in STD_LOGIC := '1';
        PRN : in STD_LOGIC := '1');
end component;			

component shift is
  port(
       CLK 		: in STD_LOGIC;
       IN_DATA 	: in STD_LOGIC;
       RESET 	: in STD_LOGIC;
       SEL 		: in STD_LOGIC_VECTOR(7 downto 0);
       DATA 	: out STD_LOGIC
  );
end component;

component ADC_REC is	
	generic	
		(
		MODULEX		: NATURAL -- 1790 строк
	);
	port
		(
		CLK_IN		: in std_logic;--global CLK 2/1	высокая 114,56 
		RESET 		: in std_logic;--__|--|__ -- сброс единицей
		ADC_IN		: in std_logic_vector(11 downto 0);
		CLK_OUT		: in std_logic;
		X			: in std_logic_vector(11 downto 0);
		ADC_OUT		: out std_logic_vector(11 downto 0)
		);		
end component;	  






	  

end Afalina_tvk_pkg; 

library ieee;
use ieee.std_logic_1164.all;
--use work.icx274_pkg.all;

entity DFF_ig is
	port (
		Q	: out STD_LOGIC ;
        D	: in STD_LOGIC ;
        CLK : in STD_LOGIC ;
        CLRN: in STD_LOGIC := '1';
        PRN : in STD_LOGIC := '1');
end DFF_ig;

architecture beh of DFF_ig is
begin
	ff : process (CLK, CLRN,PRN)
	begin
		if CLRN = '0' and PRN = '0' then
			Q <= 'X';
		elsif CLRN = '0' then
			Q <= '0';
		elsif PRN = '0' then
			Q <= '1';
		elsif rising_edge(CLK) then
			Q <= D;
		end if;
	end process ff;
end beh;
