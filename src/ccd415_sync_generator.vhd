library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.Afalina_tvk_pkg.all;
entity ccd415_sync_generator is
	port
	(
		CLK			: IN STD_LOGIC; -- CLK_PIX * 4 = 118 ћ√ц
		CNT_EN		: IN STD_LOGIC; 
		RESET 		: IN STD_LOGIC; 
		SHUTTER		: IN STD_LOGIC_VECTOR(11 downto 0);--грубый затвор
		GAIN		: IN STD_LOGIC_VECTOR(9 downto 0);--усиление
		GAIN_STROBE	: IN STD_LOGIC;
		CLAMP		: IN STD_LOGIC_VECTOR(7 downto 0);--прив€зка к уровню черного		
		CLAMP_STROBE: IN STD_LOGIC;
		MODE_CCD	: IN STD_LOGIC;	-- выбор режима полоса 0 либо full 1
		WIND_CCD	: IN STD_LOGIC; -- 0 стационарное окно 1 - перемещающеес€ 
		
		-- ”правление регистрами CCD 415
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
		SL 			: OUT STD_LOGIC:='0';
		SCK 		: OUT STD_LOGIC:='0';
		SDATA 		: OUT STD_LOGIC:='0';
		SHD 		: OUT STD_LOGIC;
		SHP 		: OUT STD_LOGIC;
		VD	 		: OUT STD_LOGIC;  
		HD	 		: OUT STD_LOGIC;
		PBLK 		: OUT STD_LOGIC;	
		CLPDM 		: OUT STD_LOGIC;
		CLPOB 		: OUT STD_LOGIC;
		X			: OUT STD_LOGIC_VECTOR(11 downto 0);--горизонтальный счетчик
		Y			: OUT STD_LOGIC_VECTOR(11 downto 0);--вертикальный счетчик
		LINE        : OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC;
		DATE_EN		: OUT STD_LOGIC
		
	);
end ccd415_sync_generator;	 
architecture syn of ccd415_sync_generator is 
signal cntX			: std_logic_vector(11 downto 0);
signal cntY			: std_logic_vector(11 downto 0);

begin
	-- в прогрессивном режиме - 50 √ц - 625 строк
	-- в режиме полоса 200 √ц - 156 строк
	cntXY: ccd_counters
	generic map
		(
		MODULEY		=> 156, --X"6FE",--/ 1790 ;
		
		MODULEY_FULL=> 625,
		MODULEX		=> 944 --/ -- режим работы полоса 80 
		)

	port map
		(
		CLK			=> CLK,--global CLK 2/1	 
		CNT_EN		=> CNT_EN,
		RESET 		=> RESET,--__|--|__
		MODE_CCD	=> MODE_CCD,
		X			=> cntX,
		Y			=> cntY
		);		
X <= cntX;
Y <= cntY;
xvform: xvform_415
	port map
		(
		CLK			=> CLK,
		CNT_EN		=> CNT_EN,
		RESET		=> RESET,
		C_SHUTTER 	=> SHUTTER,
		F_SHUTTER 	=> (others =>'0'),
		MODE_CCD	=> MODE_CCD,
		WIND_CCD	=> WIND_CCD,
		
		--NUM_F_LINE	=> NUM_F_LINE,--от 6 до 56 
		X			=> cntX,
		Y			=> cntY,
		-- управление вертикальными регистрами icx285al
		XV1 		=> XV1,
		XV2 		=> XV2,
		XV3 		=> XV3,
		SG 			=> SG,
		XSUB 		=> XSUB,
		H1			=> H1,
		H2			=> H2,
		RG			=> RG,
		LINE		=> LINE,
		FRAME		=> FRAME
		
		);			
ADC: AD9845  
	generic	map	  --89 строк - 823 элемента
		(
		VD_EDGE				=> 7,
		HD_EDGE				=> 102,
		PBLK_RISING_EDGE_Y 	=> 36,
		PBLK_FALLING_EDGE_Y	=> 124,
		PBLK_RISING_EDGE_X 	=> 163,
		PBLK_FALLING_EDGE_X	=> 42,
		CLP_RISING_EDGE_X	=> 40,
		CLP_FALLING_EDGE_X	=> 4
		)
	 port map (
		CLK			=> CLK,
		CNT_EN		=> CNT_EN,
		RESET 		=> RESET,
		ADC_GAIN 	=> GAIN,
		ADC_CLAMP	=> CLAMP,
		GAIN_STROBE	=> GAIN_STROBE,
		CLAMP_STROBE=> CLAMP_STROBE,
		X			=> cntX,
		Y			=> cntY,
		MODE_CCD	=> MODE_CCD,
		VD			=> VD,
		HD			=> HD,
        DATACLK 	=> DATACLK,
		SHD 		=> SHD,
		SHP 		=> SHP,
		PBLK 		=> PBLK,
		CLPDM 		=> CLPDM,
		CLPOB 		=> CLPOB,
		AD_SDATA	=> SDATA,
		AD_SL		=> SL,
		AD_SCK		=> SCK
	    );


end;