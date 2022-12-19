-------------------------------------------------------------------------------
--
-- Название    : afalina_tvk
-- Проект      : TB1 & TB2
-- Автор       : Igor Fedorov
--
-------------------------------------------------------------------------------
--
-- File        : afalina_tvk.vhd
-- Generated   : Пт авг 8 2008 11:46:13
-- By          : p2hdl ver. 1.1 (04/12/2007)
--
-------------------------------------------------------------------------------
--
-- Описание :
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
use work.Afalina_tvk_pkg.all;
entity afalina_tvk is
	port
	(
	CLK_2 		: IN STD_LOGIC;--  59 МГц
	CLK_3 		: IN STD_LOGIC;--  57,28 МГц
	CLK_6 		: IN STD_LOGIC;--  57,28 МГц
	CLK_7 		: IN STD_LOGIC;--  59 МГц
	--Канал А	   
	-- Управление регистрами CCD
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
	ADC_A 		: IN STD_LOGIC_VECTOR(11 downto 0); 
	SHDA 		: OUT STD_LOGIC;
	SHPA 		: OUT STD_LOGIC;
	VDA 		: OUT STD_LOGIC;  
	HDA 		: OUT STD_LOGIC;
	PBLKA 		: OUT STD_LOGIC;	
	CLPDMA 		: OUT STD_LOGIC;
	CLPOBA 		: OUT STD_LOGIC;
	--Канал B	   
	-- Управление регистрами CCD
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
	ADC_B 		: IN STD_LOGIC_VECTOR(11 downto 0);
	SHDB 		: OUT STD_LOGIC;
	SHPB 		: OUT STD_LOGIC;
	VDB 		: OUT STD_LOGIC;
	HDB 		: OUT STD_LOGIC;
	PBLKB 		: OUT STD_LOGIC;
	CLPDMB 		: OUT STD_LOGIC;
	CLPOBB 		: OUT STD_LOGIC;
	--Выход LVDS
	LVDS_D 		: OUT STD_LOGIC_VECTOR(27 downto 0):=(others => '0');
	LVDS_CLK 	: OUT STD_LOGIC:='0'; --PLL2_CLKOUTn		
	-- Управление SDRAM
	A 			: OUT STD_LOGIC_VECTOR(12 downto 0);--адрес	  
	DQ 			: INOUT STD_LOGIC_VECTOR(15 downto 0);-- данные	
	BA 			: OUT STD_LOGIC_VECTOR(1 downto 0);	
	WE 			: OUT STD_LOGIC;
	CAS 		: OUT STD_LOGIC;	
	RAS 		: OUT STD_LOGIC;	
	CS 			: OUT STD_LOGIC;	
	UDQM 		: OUT STD_LOGIC;	
	LDQM 		: OUT STD_LOGIC;
	CKE 		: OUT STD_LOGIC;
	CLK_SDRAM 	: OUT STD_LOGIC;
	-- ADuC842
	MPU_MODE 	: IN STD_LOGIC;
	MPU_RESET 	: IN STD_LOGIC;
	MPU_A 		: IN STD_LOGIC_VECTOR(7 downto 0);	
	MPU_D 		: INOUT STD_LOGIC_VECTOR(7 downto 0);	
	MPU_RD 		: IN STD_LOGIC;
	MPU_WR 		: IN STD_LOGIC;
	--
	MPU_INT0 	: OUT STD_LOGIC;
	MPU_INT1 	: OUT STD_LOGIC;
	ALE 		: IN STD_LOGIC;	
	PSEN 		: OUT STD_LOGIC;	
	RESET_842 	: OUT STD_LOGIC;
	-- RS 232 вход - выход
	ADUC_TXD 	: IN STD_LOGIC; 
	ADUC_RXD 	: OUT STD_LOGIC;
	
	RS232_TXD 	: OUT STD_LOGIC;
	RS232_RXD 	: IN STD_LOGIC;
	---------------------------
	--RS-485
	RS485_TXD 	: OUT STD_LOGIC;	
	RS485_RXD 	: IN STD_LOGIC;	
	RS485_MODE 	: OUT STD_LOGIC;	
	RS485_PV 	: OUT STD_LOGIC;	
	-- диафрагма
	BR 			: OUT STD_LOGIC;
	PH 			: OUT STD_LOGIC;
	-- резервные контакты
	RES1 		: INOUT STD_LOGIC;
	RES2 		: INOUT STD_LOGIC;
	--контрольные точки
	KT			: IN STD_LOGIC_VECTOR( 2 downto 1);
	KT_OUT		: OUT STD_LOGIC
	);
end afalina_tvk;

architecture afalina_tvk of afalina_tvk is
component PLLAFA
		PORT
		(
			inclk0	: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			c1		: OUT STD_LOGIC ;
			c2		: OUT STD_LOGIC ;
			c3		: OUT STD_LOGIC 
		);
END component;
component PLL_TV1 
		PORT
		(
			inclk0	: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			c1		: OUT STD_LOGIC ;
			c2		: OUT STD_LOGIC ;
			c3		: OUT STD_LOGIC ;
			c4		: OUT STD_LOGIC 
		);
END component;


signal clk29_5, clk59, clk118 			: std_logic; -- выход PLL (CLK_2)
signal clk14_32, clk28_64, clk57_28, clk114_56 	: std_logic; -- выход PLL (CLK_6)
signal clk0, clk1, clk2,clk2_1, clk3, clk_in				 	: std_logic; -- выход PLL (CLK_6)
signal reset_int						: std_logic; -- внутренний сброс	
signal cnt_en							: std_logic; -- CLK_2 / 2
signal int_HD, int_VD, int_PBLK			: std_logic:='0';
-- управление ccd (from ADuC)
signal shutter			: std_logic_vector(11 downto 0):= X"424";
signal gain				: std_logic_vector(9 downto 0);
signal gain_strobe		: std_logic;
signal clamp			: std_logic_vector(7 downto 0);
signal clamp_strobe		: std_logic;
-- выбор камеры 0 - ТВ1(icx285) 1 - ТВ1 прогрессивный режим	2 - тест ТВ1 / 3 - ТВ2 (icx415 ) 4  5  тест ТВ2 /  
signal choice_ccd 		: std_logic_vector(7 downto 0):="00001000";--"00000100";
--choice_ccd(0) - 0 - ТВ1 		1 ТВ2
--choice_ccd(1) - 0 - ТВ выход 	1 тест
--choice_ccd(2) - 0 - полоса 	1 полнокадровый режим
--choice_ccd(3) - 0 - стационарное окно / 1 перемещающееся окно
--0 - ТВ1 ТВ выход полоса
--1 - ТВ2 ТВ выход полоса
--2 - ТВ1 тест полоса
--3 - ТВ2 тест полоса
--4 - ТВ1 ТВ выход полнокадровый
--5 - ТВ2 ТВ выход полнокадровый
--6 - ТВ1 тест полнокадровый
--7 - ТВ2 тест полнокадровый
signal cntX, cntY		:std_logic_vector(11 downto 0);
-- тест LVDS выхода
signal tst_lvds			: std_logic_vector(11 downto 0):=X"000";	

signal line, frame		: std_logic;--активные строки и кадры 1 - гачящий 0 -активный
signal date_en			: std_logic;
signal channel			: std_logic;

signal tpsen			: std_logic;
signal trst, T			: std_logic;	
signal SHP,SHP_1		: std_logic;
signal SHD,SHD_1		: std_logic;
signal DATACLK			: std_logic;
signal RG				: std_logic;	
signal H1_A,H2_A		: std_logic;
signal SHD_SHIFT		: std_logic_vector(7 downto 0):=X"03";
signal SHP_SHIFT		: std_logic_vector(7 downto 0):=X"03";
signal CLK_SHIFT		: std_logic_vector(7 downto 0):=X"02";
signal RG_SHIFT			: std_logic_vector(7 downto 0):=X"02";
signal CONTROL			: std_logic_vector(7 downto 0);	   
signal clk_d			: std_logic;
signal ADC_DA			: std_logic_vector(11 downto 0);
signal CLPOB_B			: std_logic;
signal EOP_ON			: std_logic;
signal OPEN_VL, CLOSE_VL: std_logic;

signal c				: std_logic_vector(7 downto 0):= (others =>'0');	   	 
begin
	process( clk2 )
	begin
		if clk2'event and clk2 = '1' then
			c <= c + 1;
			
		end if;
	end process;
   clk28_64 <= c(2);
   clk57_28 <= c(1);
   clk114_56 <= c(0);
	PLL_AFAL: PLL_TV1
		PORT map
		(
			inclk0	=> CLK_6,
			c0		=> clk0,--clk28_64,
			c1		=> clk1,--clk57_28,
			c2		=> clk2_1,--clk114_56,
			c3		=> clk2,--clk114_56
			c4 		=> clk3
		);

	
	
	reset_generator : mpu_res
	port map(
		CLK 		=> clk114_56,
		RESET_INT	=> reset_int,
		CNT_EN		=> cnt_en); 
	--синхрогенератор для ICX285 
--clk_in <= not clk28_64;
clk_in <= clk28_64;
	ADC : ADC_REC
	generic map	
		(
		MODULEX		=> 1790
	)
	port map
		(
		CLK_IN		=> clk_in,
		RESET 		=> reset_int,
		ADC_IN		=> ADC_A,
		CLK_OUT		=> clk28_64,
		X			=> cntX,
		ADC_OUT		=> ADC_DA
		);		


	
	ccd: ccd_generator 
	port map
	(
		CLK			=> clk114_56, -- CLK_PIX * 4 = 114_56	
		CNT_EN		=> cnt_en,
		RESET 		=> reset_int, 
		SHUTTER		=> shutter,--грубый затвор
		GAIN		=> GAIN,--gain, --усиление
		GAIN_STROBE	=> gain_strobe,
		CLAMP		=> CLAMP,--clamp,--привязка к уровню черного		
		CLAMP_STROBE=> clamp_strobe,
		CHOICE_CCD	=> choice_ccd(0), -- выбор камеры 0 - ТВ1 / 1 - ТВ2
		MODE_CCD	=> choice_ccd(2), -- выюор режима работы 0 - полоса / 1 - full
		WIND_CCD	=> choice_ccd(3), -- 0 стационарное окно / 1 - перемещающееся 		
		--CCDA
		XV1A 		=> XV1A,
		XV2A 		=> XV2A,
		XV3A 		=> XV3A,
		XV4A 		=> XV4A,
		SG2AA 		=> SG2AA,
		SG2BA 		=> SG2BA,
		XSUBA 		=> XSUBA,
		H1A 		=> H1_A,
		H2A 		=> H2_A,
		RGA 		=> RG,
		--AD9845
		DATACLKA 	=> DATACLK,
		SL 			=> SL,
		SCK 		=> SCK,
		SDATA 		=> SDATA,
		SHDA 		=> SHP,--SHDA
		SHPA 		=> SHD,--SHPA
		VDA 		=> int_VD,
		HDA 		=> int_HD,
		PBLKA 		=> int_PBLK,
		CLPDMA 		=> CLPDMA,
		CLPOBA 		=> CLPOBA,
		
		-- CCDB
		XV1B 		=> XV1B,
		XV2B 		=> XV2B,
		XV3B 		=> XV3B,
		XV4B 		=> XV4B,
		SG2AB 		=> SG2AB,
		SG2BB 		=> SG2BB,
		XSUBB 		=> XSUBB,
		H1B 		=> H1B,
		H2B 		=> H2B,
		RGB 		=> RGB,
		--AD9845
		DATACLKB 	=> DATACLKB,
		SHDB 		=> SHDB,
		SHPB 		=> SHPB,
		VDB 		=> VDB,
		HDB 		=> HDB,
		PBLKB 		=> PBLKB,
		CLPDMB 		=> CLPDMB,
		CLPOBB 		=> CLPOB_B,
		X			=> cntX,
		Y			=> cntY,
		LINE		=> line,
		FRAME		=> frame,
		DATE_EN		=> date_en
	);				
	--  управление положением SHD SHP DATACLK RG
	shpshift: shift
	port map
	(
       CLK 		=> clk2,
       IN_DATA 	=> SHP,
       RESET 	=> reset_int,
       SEL 		=> X"07",--SHP_SHIFT,--for 7.5Hz aw7003
       DATA 	=> SHPA
  	);
	shdshift: shift
	port map
	(
       CLK 		=> clk2,
       IN_DATA 	=> SHD,
       RESET 	=> reset_int,
       SEL 		=> X"07",--SHD_SHIFT,--for 7.5Hz aw7101
       DATA 	=> SHDA
  	);
	dataclk_shift: shift
	port map
	(
       CLK 		=> clk2,
       IN_DATA 	=> DATACLK,
       RESET 	=> reset_int,
       SEL 		=> CLK_SHIFT,--for 7.5Hz aw7200
       DATA 	=> DATACLKA
  	);
	RGshift: shift
	port map
	(
       CLK 		=> clk2,
       IN_DATA 	=> RG,
       RESET 	=> reset_int,
       SEL 		=> X"02",--RG_SHIFT,--for 7.5Hz aw7304
       DATA 	=> RGA
  	);

	H1: shift
	port map
	(
       CLK 		=> clk2,
       IN_DATA 	=> H1_A,
       RESET 	=> reset_int,
       SEL 		=> X"01",
       DATA 	=> H1A
  	);
	
	H2: shift
	port map
	(
       CLK 		=> clk2,
       IN_DATA 	=> H2_A,
       RESET 	=> reset_int,
       SEL 		=> X"01",
       DATA 	=> H2A
  	);
	  

	
	
	--H1A <= RG;
	VDA <='1';--int_VD;
	HDA <= '1';--int_HD;
	PBLKA <= '1';--int_PBLK;
	--WR <= int_HD;
AduC: AduC842 
	port map
	(
		CLK29_5 	=> clk57_28,--clk28_64, --in
		MPU_MODE 	=> MPU_MODE, --in
		MPU_RESET 	=> MPU_RESET,--in
		MPU_WR 		=> MPU_WR,	 --in
		MPU_RD 		=> MPU_RD,	 --in
		HD 			=> int_HD,	 --in
		VD 			=> int_VD,	 --in
		MPU_ADDR 	=> MPU_A,	 --in
		MPU_D 		=> MPU_D,	 --inout
		MPU_INT0 	=> MPU_INT0, --out
		MPU_INT1 	=> MPU_INT1, --out
		ALE 		=> ALE,		 --out
		PSEN 		=> tpsen,	 --out
		RESET_842   => RESET_842,--out

		SHUTTER		=> SHUTTER,--грубый затвор
		GAIN		=> GAIN,--усиление
		GAIN_STROBE	=> GAIN_STROBE,
		CLAMP		=> CLAMP,--привязка к уровню черного		
		CLAMP_STROBE=> CLAMP_STROBE,
		CHOICE_CCD	=> CHOICE_CCD(7 downto 0),
		SHD_SHIFT	=> SHD_SHIFT,
		SHP_SHIFT	=> SHP_SHIFT,
		CLK_SHIFT	=> CLK_SHIFT,
		RG_SHIFT	=> RG_SHIFT,  
		CONTROL		=> CONTROL, -- 
		RS485_TXD 	=> RS485_TXD,
		RS485_RXD 	=> RS485_RXD,
		RS485_MODE 	=> RS485_MODE,
		RS485_PV 	=> RS485_PV
	);		
test_lvds: test_lvds_cnt
	port map
		(
		CLK			=> clk114_56,
		CNT_EN		=> cnt_en,
		RESET 		=> reset_int,
		CHOICE_CCD	=> choice_ccd(0), -- выбор камеры 0 - ТВ1 / 1 - ТВ2
		MODE_CCD	=> choice_ccd(2), -- 0 полоса / 1 - полнокадровый
		X			=> cntX,
		Y			=> cntY,
		test		=> tst_lvds
		);		
	
	LCDS_OUT: process(clk28_64)
	begin 
		if rising_edge(clk28_64) then --clk28_64
			if reset_int = '1' then LVDS_D <= (others => '0');
			elsif choice_ccd(1) = '0' then -- по умолчанию ТВ выход
				LVDS_D(13 downto 0) <= ADC_DA & "00";--ADC_DA
				LVDS_D(14) <= line;
				LVDS_D(15) <= frame;
				LVDS_D(16) <= '1';
				LVDS_D(17) <= '1';
				LVDS_D(27 downto 18) <= (others => '0');
	
			else 						   -- включение теста
				LVDS_D(13 downto 0) <= tst_lvds & "00";
				LVDS_D(14) <= line;
				LVDS_D(15) <= frame;
				LVDS_D(16) <= '1';
				LVDS_D(17) <= '1';
				LVDS_D(27 downto 18) <= (others => '0');
		end if;
		end if;
	end process;
	--PBLKA <= not ( line or frame );  
	LVDS_CLK <=	clk28_64;
	

--	test <=  "0000"&cntY284;
--reg: aduc_reg 
--	port map(
--		CLK 		=> CLK28_64,
--		RESET 		=> reset_int,
--		DATA_REG	=> test,
--		ADUC_ADDR	=> cntX284(7 downto 0),
--		WR			=> WR,
--		SHUTTER		=> SHUTTER,
--		GAIN		=> GAIN,
--		CLAMP		=> CLAMP
--
--		);
	
	RS232_TXD <= ADUC_TXD;
	ADUC_RXD <= RS232_RXD;
--	MPU_INT0 <= '1';
--	MPU_INT1 <= '1';
--	ALE <= '0';
process(MPU_MODE, MPU_RESET)
begin 
	if reset_int = '1' then PSEN <= '0';
	else
	if MPU_MODE = '0' then PSEN <= '0';
	elsif MPU_MODE = '1' then PSEN <= '1';
	end if;
	end if;
end process;
	--PSEN <= MPU_MODE;
	--RESET_842 <= MPU_RESET;
	--KT(3) <= clk_in;
	  CLPOBB <= EOP_ON;
	  CLOSE_VL <= KT(1);
	  OPEN_VL <= KT(2);		
EOP_CTRL : EOP_CONTROL
	port map
		(
		CLK			=> clk114_56,
		RESET 		=> reset_int,
		CONTROL		=> CONTROL,
		OPEN_VL		=> OPEN_VL,
		CLOSE_VL	=> CLOSE_VL,
		EOP_ON		=> EOP_ON,
		BR			=> BR,
		PH			=> PH
		);		

	
--EOP_CTRL: process(CONTROL)	
--	begin
--		if reset_int = '1' then BR <= '0'; PH <= '0';
--		else
--			if CONTROL(2) = '0' then BR <= '1'; PH <= CONTROL(1);
--			elsif CONTROL(2) = '1' then BR <= '0'; PH <= CONTROL(1);
--			end if;
--		end if;
--	end process;
	


	
--маленькая задержка SHP и SHD


end ;
	

--end afalina_tvk;