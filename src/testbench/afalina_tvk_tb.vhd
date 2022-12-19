-------------------------------------------------------------------------------
--
-- Title       : Test Bench for afalina_tvk
-- Design      : Afalina_tvk
-- Author      : igor
-- Company     : cometa
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\afalina_tvk_TB.vhd
-- Generated   : 11.08.2008, 11:40
-- From        : $DSN\src\afalina_tvk.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for afalina_tvk_tb
--
-------------------------------------------------------------------------------

library ieee;
use work.afalina_tvk_pkg.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity afalina_tvk_tb is
end afalina_tvk_tb;

architecture TB_ARCHITECTURE of afalina_tvk_tb is
	-- Component declaration of the tested unit
	component afalina_tvk
	port(
		CLK_2 		: in std_logic;
		CLK_3 		: in std_logic;
		CLK_6 		: in std_logic;
		CLK_7 		: in std_logic;
		XV1A 		: out std_logic;
		XV2A 		: out std_logic;
		XV3A 		: out std_logic;
		XV4A 		: out std_logic;
		SG2AA 		: out std_logic;
		SG2BA 		: out std_logic;
		XSUBA 		: out std_logic;
		H1A 		: out std_logic;
		H2A 		: out std_logic;
		RGA 		: out std_logic;
		DATACLKA 	: out std_logic;
		SL 			: out std_logic;
		SCK 		: out std_logic;
		SDATA 		: out std_logic;
		ADC_A 		: in std_logic_vector(11 downto 0);
		SHDA 		: out std_logic;
		SHPA 		: out std_logic;
		VDA 		: out std_logic;
		HDA 		: out std_logic;
		PBLKA 		: out std_logic;
		CLPDMA 		: out std_logic;
		CLPOBA 		: out std_logic;
		XV1B 		: out std_logic;
		XV2B 		: out std_logic;
		XV3B 		: out std_logic;
		XV4B 		: out std_logic;
		SG2AB 		: out std_logic;
		SG2BB 		: out std_logic;
		XSUBB 		: out std_logic;
		H1B 		: out std_logic;
		H2B 		: out std_logic;
		RGB 		: out std_logic;
		DATACLKB 	: out std_logic;
		ADC_B 		: in std_logic_vector(11 downto 0);
		SHDB 		: out std_logic;
		SHPB 		: out std_logic;
		VDB 		: out std_logic;
		HDB 		: out std_logic;
		PBLKB 		: out std_logic;
		CLPDMB 		: out std_logic;
		CLPOBB 		: out std_logic;
		LVDS_D		: out std_logic_vector(27 downto 0);
		LVDS_CLK 	: out std_logic;
		A 			: out std_logic_vector(12 downto 0);
		DQ 			: inout std_logic_vector(15 downto 0);
		BA 			: out std_logic_vector(1 downto 0);
		WE 			: out std_logic;
		CAS 		: out std_logic;
		RAS 		: out std_logic;
		CS 			: out std_logic;
		UDQM 		: out std_logic;
		LDQM 		: out std_logic;
		CKE 		: out std_logic;
		CLK_SDRAM 	: out std_logic;
		MPU_MODE 	: in std_logic;
		MPU_RESET 	: in std_logic;
		MPU_A 		: in std_logic_vector(7 downto 0);
		MPU_D 		: inout std_logic_vector(7 downto 0);
		MPU_RD 		: in std_logic;
		MPU_WR 		: in std_logic;
		MPU_INT0 	: out std_logic;
		MPU_INT1 	: out std_logic;
		ALE 		: in std_logic;
		PSEN 		: out std_logic;
		RESET_842 	: out std_logic;
		ADUC_TXD 	: in std_logic;
		ADUC_RXD 	: out std_logic;
		RS232_TXD 	: out std_logic;
		RS232_RXD 	: in std_logic;
		RS485_TXD 	: out std_logic;
		RS485_RXD 	: in std_logic;
		RS485_MODE 	: out std_logic;
		RS485_PV 	: out std_logic;
		BR 			: out std_logic;
		PH 			: out std_logic;
		RES1 		: inout std_logic;
		RES2 		: inout std_logic; 
		KT			: IN STD_LOGIC_VECTOR( 2 downto 1);
		KT_OUT		: OUT STD_LOGIC

		);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK_2 : std_logic;
	signal CLK_3 : std_logic;
	signal CLK_6 : std_logic;
	signal CLK_7 : std_logic;
	signal ADC_A : std_logic_vector(11 downto 0);
	signal ADC_B : std_logic_vector(11 downto 0);
	signal MPU_MODE : std_logic;
	signal MPU_RESET : std_logic;
	signal MPU_A : std_logic_vector(7 downto 0);
	signal MPU_RD : std_logic;
	signal MPU_WR : std_logic;
	signal ADUC_TXD : std_logic;
	signal RS232_RXD : std_logic;
	signal RS485_RXD : std_logic;
	signal DQ : std_logic_vector(15 downto 0);
	signal MPU_D : std_logic_vector(7 downto 0);
	signal RES1 : std_logic;
	signal RES2 : std_logic;
	signal KT : std_logic_vector(2 downto 1);
	signal KT_OUT : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal XV1A : std_logic;
	signal XV2A : std_logic;
	signal XV3A : std_logic;
	signal XV4A : std_logic;
	signal SG2AA : std_logic;
	signal SG2BA : std_logic;
	signal XSUBA : std_logic;
	signal H1A : std_logic;
	signal H2A : std_logic;
	signal RGA : std_logic;
	signal DATACLKA : std_logic;
	signal SL : std_logic;
	signal SCK : std_logic;
	signal SDATA : std_logic;
	signal SHDA : std_logic;
	signal SHPA : std_logic;
	signal VDA : std_logic;
	signal HDA : std_logic;
	signal PBLKA : std_logic;
	signal CLPDMA : std_logic;
	signal CLPOBA : std_logic;
	signal XV1B : std_logic;
	signal XV2B : std_logic;
	signal XV3B : std_logic;
	signal XV4B : std_logic;
	signal SG2AB : std_logic;
	signal SG2BB : std_logic;
	signal XSUBB : std_logic;
	signal H1B : std_logic;
	signal H2B : std_logic;
	signal RGB : std_logic;
	signal DATACLKB : std_logic;
	signal SHDB : std_logic;
	signal SHPB : std_logic;
	signal VDB : std_logic;
	signal HDB : std_logic;
	signal PBLKB : std_logic;
	signal CLPDMB : std_logic;
	signal CLPOBB : std_logic;
	signal LVDS_D : std_logic_vector(27 downto 0);
	signal LVDS_CLK : std_logic;
	signal A : std_logic_vector(12 downto 0);
	signal BA : std_logic_vector(1 downto 0);
	signal WE : std_logic;
	signal CAS : std_logic;
	signal RAS : std_logic;
	signal CS : std_logic;
	signal UDQM : std_logic;
	signal LDQM : std_logic;
	signal CKE : std_logic;
	signal CLK_SDRAM : std_logic;
	signal MPU_INT0 : std_logic;
	signal MPU_INT1 : std_logic;
	signal ALE : std_logic;
	signal PSEN : std_logic;
	signal RESET_842 : std_logic;
	signal ADUC_RXD : std_logic;
	signal RS232_TXD : std_logic;
	signal RS485_TXD : std_logic;
	signal RS485_MODE : std_logic;
	signal RS485_PV : std_logic;
	signal BR : std_logic;
	signal PH : std_logic;
   	constant tclk 	:TIME  	:= 8.729 ns;
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : afalina_tvk
		port map (
			CLK_2 => CLK_2,
			CLK_3 => CLK_3,
			CLK_6 => CLK_6,
			CLK_7 => CLK_7,
			XV1A => XV1A,
			XV2A => XV2A,
			XV3A => XV3A,
			XV4A => XV4A,
			SG2AA => SG2AA,
			SG2BA => SG2BA,
			XSUBA => XSUBA,
			H1A => H1A,
			H2A => H2A,
			RGA => RGA,
			DATACLKA => DATACLKA,
			SL => SL,
			SCK => SCK,
			SDATA => SDATA,
			ADC_A => ADC_A,
			SHDA => SHDA,
			SHPA => SHPA,
			VDA => VDA,
			HDA => HDA,
			PBLKA => PBLKA,
			CLPDMA => CLPDMA,
			CLPOBA => CLPOBA,
			XV1B => XV1B,
			XV2B => XV2B,
			XV3B => XV3B,
			XV4B => XV4B,
			SG2AB => SG2AB,
			SG2BB => SG2BB,
			XSUBB => XSUBB,
			H1B => H1B,
			H2B => H2B,
			RGB => RGB,
			DATACLKB => DATACLKB,
			ADC_B => ADC_B,
			SHDB => SHDB,
			SHPB => SHPB,
			VDB => VDB,
			HDB => HDB,
			PBLKB => PBLKB,
			CLPDMB => CLPDMB,
			CLPOBB => CLPOBB,
			LVDS_D => LVDS_D,
			LVDS_CLK => LVDS_CLK,
			A => A,
			DQ => DQ,
			BA => BA,
			WE => WE,
			CAS => CAS,
			RAS => RAS,
			CS => CS,
			UDQM => UDQM,
			LDQM => LDQM,
			CKE => CKE,
			CLK_SDRAM => CLK_SDRAM,
			MPU_MODE => MPU_MODE,
			MPU_RESET => MPU_RESET,
			MPU_A => MPU_A,
			MPU_D => MPU_D,
			MPU_RD => MPU_RD,
			MPU_WR => MPU_WR,
			MPU_INT0 => MPU_INT0,
			MPU_INT1 => MPU_INT1,
			ALE => ALE,
			PSEN => PSEN,
			RESET_842 => RESET_842,
			ADUC_TXD => ADUC_TXD,
			ADUC_RXD => ADUC_RXD,
			RS232_TXD => RS232_TXD,
			RS232_RXD => RS232_RXD,
			RS485_TXD => RS485_TXD,
			RS485_RXD => RS485_RXD,
			RS485_MODE => RS485_MODE,
			RS485_PV => RS485_PV,
			BR => BR,
			PH => PH,
			RES1 => RES1,
			RES2 => RES2,
			KT => KT,
			KT_OUT => KT_OUT
		);
process
begin
	CLK_6 <= '1';
	wait for tclk;
	CLK_6 <= '0';
	wait for tclk;
	CLK_6 <= '1';
end process; 
process
begin
	MPU_MODE <= '0';	  
	wait for 10 us;
	MPU_MODE <= '1';
	wait for 10 us;
	MPU_MODE <= '0';
end process;


	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_afalina_tvk of afalina_tvk_tb is
	for TB_ARCHITECTURE
		for UUT : afalina_tvk
			use entity work.afalina_tvk(afalina_tvk);
		end for;
	end for;
end TESTBENCH_FOR_afalina_tvk;

