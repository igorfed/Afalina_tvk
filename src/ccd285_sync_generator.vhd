library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.Afalina_tvk_pkg.all;
entity ccd285_sync_generator is
	port
	(
		CLK			: IN STD_LOGIC; -- CLK_PIX * 4 = 114_56
		CNT_EN		: IN STD_LOGIC; 
		RESET 		: IN STD_LOGIC; 
		SHUTTER		: IN STD_LOGIC_VECTOR(11 downto 0);--������ ������
		GAIN		: IN STD_LOGIC_VECTOR(9 downto 0);--��������
		GAIN_STROBE	: IN STD_LOGIC;
		CLAMP		: IN STD_LOGIC_VECTOR(7 downto 0);--�������� � ������ �������		
		CLAMP_STROBE: IN STD_LOGIC;
		MODE_CCD	: IN STD_LOGIC;	-- ����� ������ ������ 0 ���� full 1
		WIND_CCD	: IN STD_LOGIC; -- 0 ������������ ���� 1 - �������������� 
		-- ���������� ���������� CCD
		XV1 		: OUT STD_LOGIC;
		XV2 		: OUT STD_LOGIC;
		XV3 		: OUT STD_LOGIC;
		XV4			: OUT STD_LOGIC;
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
		X			: OUT STD_LOGIC_VECTOR(11 downto 0);--�������������� �������
		Y			: OUT STD_LOGIC_VECTOR(11 downto 0);--������������ �������
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC;
		DATE_EN		: OUT STD_LOGIC

		
	);
end ccd285_sync_generator;

architecture syn of ccd285_sync_generator is 
signal cntX			: std_logic_vector(11 downto 0);
signal cntY			: std_logic_vector(11 downto 0);
signal NUMLine		: std_logic_vector(11 downto 0);
--signal NUM_F_LINE	: std_logic_vector(11 downto 0):=X"032";

begin
	
cntXY: ccd_counters
	generic map
		(
		MODULEY		=> 40, --/ -- ����� ������ ������ 80 --
		
		MODULEY_FULL=> 1068, --/ -- ����� ������ ������������� 1068  
		MODULEX		=> 1790 --X"6FE",--/ 1790 ;
		)

	port map
		(
		CLK			=> CLK,--global CLK 2/1	 
		CNT_EN		=> CNT_EN,
		RESET 		=> RESET,--__|--|__
		MODE_CCD	=> MODE_CCD, -- 0  ������ 1 ������������� �����
		X			=> cntX,
		Y			=> cntY
		);		
X <= cntX;
Y <= cntY;
xvform: xvform_285
	port map
		(
		CLK			=> CLK,
		CNT_EN		=> CNT_EN,
		RESET		=> RESET,
		C_SHUTTER 	=> SHUTTER,
		F_SHUTTER 	=> (others =>'0'),
		--NUM_F_LINE	=> NUM_F_LINE,--�� 6 �� 56 
		MODE_CCD	=> MODE_CCD, -- 0  ������ 1 ������������� �����
		WIND_CCD	=> WIND_CCD, -- 0 ������������ ���� 1 - �������������� 

		X			=> cntX,
		Y			=> cntY,
		-- ���������� ������������� ���������� icx285al
		XV1 		=> XV1,
		XV2 		=> XV2,
		XV3 		=> XV3,
		XV4 		=> XV4,
		SG2A 		=> SG2A,
		SG2B 		=> SG2B,
		XSUB 		=> XSUB,
		H1			=> H1,
		H2			=> H2,
		RG			=> RG,
		LINE		=> LINE,
		FRAME		=> FRAME
		);			
		
ADC: AD9845  
	generic	map	 --31 ������ --1434 ���������
		(
		VD_EDGE				=> 4,
		HD_EDGE				=> 180,
		PBLK_RISING_EDGE_Y 	=> 26,
		PBLK_FALLING_EDGE_Y	=> 57,
		PBLK_RISING_EDGE_X 	=> 412,
		PBLK_FALLING_EDGE_X	=> 56,
		CLP_RISING_EDGE_X	=> 50,
		CLP_FALLING_EDGE_X	=> 25
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
		MODE_CCD	=> MODE_CCD, -- 0  ������ 1 ������������� �����
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
		


end syn;
