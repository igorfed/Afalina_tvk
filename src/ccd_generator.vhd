library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.Afalina_tvk_pkg.all;
entity ccd_generator is
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
		CHOICE_CCD	: IN STD_LOGIC;-- 0 - ccda = icx285 ccdb - none / 1 - ccda = icx415 ccdb = icx415
		MODE_CCD	: IN STD_LOGIC; -- ����� ������ ������ 0 - ������ / 1 - full
		WIND_CCD	: IN STD_LOGIC; -- 0 ������������ ���� 1 - �������������� 		

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

		X			: OUT STD_LOGIC_VECTOR(11 downto 0);--�������������� �������
		Y			: OUT STD_LOGIC_VECTOR(11 downto 0);--������������ �������	  
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC;
		DATE_EN		: OUT STD_LOGIC
		
	);
end ccd_generator;
architecture syn of ccd_generator is
signal XV1_285 		: std_logic;
signal XV2_285 		: std_logic;
signal XV3_285 		: std_logic;
signal XV4_285 		: std_logic;
signal SG2A_285 	: std_logic;
signal SG2B_285 	: std_logic;
signal XSUB_285 	: std_logic;
signal H1_285 		: std_logic;
signal H2_285 		: std_logic;
signal RG_285 		: std_logic;
signal DATACLK_285 	: std_logic;
signal SL_285 		: std_logic;
signal SCK_285 		: std_logic;
signal SDATA_285 	: std_logic;
signal SHD_285 		: std_logic;
signal SHP_285 		: std_logic;
signal VD_285 		: std_logic;
signal HD_285 		: std_logic;
signal PBLK_285 	: std_logic;
signal CLPDM_285 	: std_logic;
signal CLPOB_285 	: std_logic;
signal cntX_285		: std_logic_vector(11 downto 0);
signal cntY_285		: std_logic_vector(11 downto 0);
signal line_285		: std_logic;
signal frame_285	: std_logic;
signal date_en_285	: std_logic;

signal XV1_415 		: std_logic;
signal XV2_415 		: std_logic;
signal XV3_415 		: std_logic;
signal SG_415 		: std_logic;
signal XSUB_415 	: std_logic;
signal H1_415 		: std_logic;
signal H2_415 		: std_logic;
signal RG_415 		: std_logic;
signal DATACLK_415 	: std_logic;
signal SL_415 		: std_logic;
signal SCK_415 		: std_logic;
signal SDATA_415 	: std_logic;
signal SHD_415 		: std_logic;
signal SHP_415 		: std_logic;
signal VD_415 		: std_logic;
signal HD_415 		: std_logic;
signal PBLK_415 	: std_logic;
signal CLPDM_415 	: std_logic;
signal CLPOB_415 	: std_logic;
signal cntX_415		: std_logic_vector(11 downto 0);
signal cntY_415		: std_logic_vector(11 downto 0);
signal line_415		: std_logic;
signal frame_415	: std_logic;
signal date_en_415	: std_logic;

begin
	ccd285: ccd285_sync_generator 
	port map(

		CLK			=> CLK, -- CLK_PIX * 4 = 114_56	
		CNT_EN		=> CNT_EN, -- ���������� ������� 28_64
		RESET 		=> RESET, 
		SHUTTER		=> SHUTTER,--������ ������
		GAIN		=> GAIN,--gain, --��������
		GAIN_STROBE	=> GAIN_STROBE,
		CLAMP		=> CLAMP,--clamp,--�������� � ������ �������		
		CLAMP_STROBE=> CLAMP_STROBE, 
		MODE_CCD	=> MODE_CCD,
		WIND_CCD	=> WIND_CCD,-- 0 ������������ ���� 1 - �������������� 
		-- ���������� ���������� CCD
		XV1 		=> XV1_285,
		XV2 		=> XV2_285,
		XV3 		=> XV3_285,
		XV4 		=> XV4_285,
		SG2A 		=> SG2A_285,
		SG2B 		=> SG2B_285,
		XSUB 		=> XSUB_285,
		H1	 		=> H1_285,
		H2 			=> H2_285,
		RG	 		=> RG_285,
		--AD9845
		DATACLK 	=> DATACLK_285,
		SL 			=> SL_285,
		SCK 		=> SCK_285,
		SDATA 		=> SDATA_285,
		SHD 		=> SHD_285,
		SHP 		=> SHP_285,
		VD	 		=> VD_285,
		HD	 		=> HD_285,
		PBLK 		=> PBLK_285,
		CLPDM 		=> CLPDM_285,
		CLPOB 		=> CLPOB_285,
		X			=> cntX_285,
		Y			=> cntY_285,
		LINE		=> line_285,
		FRAME		=> frame_285,
		DATE_EN		=> date_en_285
	);	

	ccd415 : ccd415_sync_generator 
	port map
	(
		CLK			=> CLK,
		CNT_EN		=> CNT_EN,
		RESET 		=> RESET,
		SHUTTER		=> SHUTTER,
		GAIN		=> GAIN,
		GAIN_STROBE	=> GAIN_STROBE,
		CLAMP		=> CLAMP,
		CLAMP_STROBE=> CLAMP_STROBE,
		MODE_CCD	=> MODE_CCD,
		WIND_CCD	=> WIND_CCD, -- 0 ������������ ���� 1 - �������������� 		

		-- ���������� ���������� CCD 415
		XV1 		=> XV1_415,
		XV2 		=> XV2_415,
		XV3 		=> XV3_415,
		SG	 		=> SG_415,
		XSUB 		=> XSUB_415,
		H1	 		=> H1_415,
		H2 			=> H2_415,
		RG	 		=> RG_415,
		--AD9845
		DATACLK 	=> DATACLK_415,
		SL 			=> SL_415,
		SCK 		=> SCK_415,
		SDATA 		=> SDATA_415,
		SHD 		=> SHD_415,
		SHP 		=> SHP_415,
		VD	 		=> VD_415,
		HD	 		=> HD_415,
		PBLK 		=> PBLK_415,
		CLPDM 		=> CLPDM_415,
		CLPOB 		=> CLPOB_415,
		X			=> cntX_415,
		Y			=> cntY_415,
		LINE		=> line_415,
		FRAME		=> frame_415,
		DATE_EN		=> date_en_415
	 );
	---------------- ��1 ��� ��2
	--------------------------------------
	--��� �� �� ����� ������� ����������--
	
	mux_ccd:process(CLK)
	begin
	if rising_edge(CLK) then 
		if RESET = '1' then 					
			--CCDA
			XV1A <= '0';		XV2A <= '0'; 	XV3A <= '0'; 	XV4A <= '0';			
			SG2AA <= '0'; 		SG2BA <= '0'; 	XSUBA <= '0'; 	H1A <= '0'; 	H2A <= '0'; 	RGA <= '0';
			DATACLKA <= '0'; 	SL <= '0'; 		SCK <= '0'; 	SDATA <= '0'; 	
			SHDA <= '0';		SHPA <= '0';	VDA <= '0'; 	HDA <= '0'; 	PBLKA <= '0';
			CLPDMA <= '0'; 		CLPOBA <= '0';
			-- CCDB
			XV1B <= '0'; 		XV2B <= '0'; 	XV3B <= '0'; 	XV4B <= '0';
			SG2AB <= '0'; 		SG2BB <= '0'; 	XSUBB <= '0'; 	H1B <= '0'; 	H2B <= '0'; 	RGB <= '0';
			DATACLKB <= '0'; 	
			SHDB <= '0';		SHPB <= '0';	VDB <= '0'; 	HDB <= '0'; 	PBLKB <= '0';
			CLPDMB <= '0'; 		CLPOBB <= '0';
			X <= (others=>'0'); Y <= (others => '0');
			LINE <= '0';		FRAME <= '0'; 	DATE_EN <= '0';
			elsif (CHOICE_CCD = '0') then 
				
				XV1A <= XV1_285; 			XV2A <= XV2_285;		XV3A <= XV3_285;	XV4A <= XV4_285;
				SG2AA <= SG2A_285; 			SG2BA <= SG2B_285; 		XSUBA <= XSUB_285; 	H1A <= H1_285; 		H2A <= H2_285; 		RGA <= RG_285;
				DATACLKA <=  DATACLK_285;	SL <= SL_285; 			SCK <= SCK_285; 	SDATA <= SDATA_285; 	
				SHDA  <=SHD_285;			SHPA <= SHP_285;		VDA <= VD_285; 		HDA <= HD_285; 		PBLKA <= PBLK_285;
				CLPDMA <= CLPDM_285; 		CLPOBA <= CLPOB_285;
				
				XV1B <= '0'; 				XV2B <= '0'; 			XV3B <= '0'; 		XV4B <= '0';
				SG2AB <= '0'; 				SG2BB <= '0'; 			XSUBB <= '0'; 		H1B <= '0'; 		H2B <= '0'; 	RGB <= '0';
				DATACLKB <= '0'; 	
				SHDB <= '0';				SHPB <= '0';			VDB <= '0'; 		HDB <= '0'; 		PBLKB <= '0';
				CLPDMB <= '0'; 				CLPOBB <= '0';
				X <= cntX_285; 				Y <= cntY_285;  		
				LINE <= line_285;			FRAME <= frame_285;		DATE_EN <= date_en_285;
				
			else 
				-- �������� �� ���������� � �.�. ���������� ����� �����--
				XV1A <= XV1_415; 			XV2A <= XV2_415; 		XV3A <= XV3_415; 	XV4A <= '0';
				SG2AA <= SG_415; 			SG2BA <= SG_415; 		XSUBA <= XSUB_415; 	H1A <= H1_415; 		H2A <= H2_415; 	RGA <= RG_415;
				DATACLKA <= DATACLK_415;	SL <= SL_415; 			SCK <= SCK_415; 	SDATA <= SDATA_415; 	
				SHDA <= SHD_415;			SHPA <= SHP_415;		VDA <= VD_415; 		HDA <= HD_415; 		PBLKA <= PBLK_415;
				CLPDMA <= CLPOB_415; 		CLPOBA <= CLPOB_415;
				
				XV1B <= XV1_415; 			XV2B <= XV2_415; 		XV3B <= XV3_415; 	XV4B <= '0';
				SG2AB <= SG_415; 			SG2BB <= SG_415; 		XSUBB <= XSUB_415; 	H1B <= H1_415; 		H2B <= H2_415; 	RGB <= RG_415;
				DATACLKB <= DATACLK_415;	
				SHDB <= SHD_415;			SHPB <= SHP_415;		VDB <= VD_415; 		HDB <= HD_415; 		PBLKB <= PBLK_415;
				CLPDMB <= CLPOB_415; 		CLPOBB <= CLPOB_415;
				X <= cntX_415; 				Y <= cntY_415;
				LINE <= line_415;			FRAME <= frame_415;		DATE_EN <= date_en_415;				
		end if;
	end if;
	end process;
end ;
			
	--------------------------------------
