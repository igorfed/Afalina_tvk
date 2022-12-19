-------------------------------------------------------------------------------
--
-- Title       : Test Bench for rs485_rec_string
-- Design      : Afalina_tvk
-- Author      : igor
-- Company     : cometa
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\rs485_rec_string_TB.vhd
-- Generated   : 29.10.2008, 11:18
-- From        : $DSN\src\rs485_rec_string.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for rs485_rec_string_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity rs485_rec_string_tb is
end rs485_rec_string_tb;

architecture TB_ARCHITECTURE of rs485_rec_string_tb is
	-- Component declaration of the tested unit
	component rs485_rec_string
	port(
		REC_FT : in std_logic;
		RESET : in std_logic;
		REC_DATE : in std_logic_vector(7 downto 0);
		RD_ADDR : in std_logic_vector(7 downto 0);
		REC_ADDR_EN : in std_logic;
		REC_DATE_EN : in std_logic;
		RXDATA : out std_logic_vector(7 downto 0);
		LAST_BYTE	: in std_logic_vector(7 downto 0);	 

		NBYTE : out std_logic_vector(7 downto 0);
		RXD_ERROR : out std_logic;
		RXD_OK : out std_logic;
		SUMM_CTRL : out std_logic_vector(7 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal REC_FT : std_logic;
	signal RESET : std_logic;
	signal REC_DATE : std_logic_vector(7 downto 0);
	signal RD_ADDR : std_logic_vector(7 downto 0);
	signal REC_ADDR_EN : std_logic;
	signal REC_DATE_EN : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal RXDATA : std_logic_vector(7 downto 0);
	signal NBYTE : std_logic_vector(7 downto 0);
	signal LAST_BYTE	: std_logic_vector(7 downto 0);	 

	signal RXD_ERROR : std_logic;
	signal RXD_OK : std_logic;
	signal SUMM_CTRL : std_logic_vector(7 downto 0);
	constant tclk 	:TIME  	:= 0.816 us;

	-- Add your code here ...

begin  
	LAST_BYTE <= X"06";
	process
	begin
		REC_FT <= '1';
		wait for tclk;
		REC_FT <= '0';
		wait for tclk;
		REC_FT <= '1';
	end process;

	process
	begin
		REC_DATE_EN <= '0';
		wait for 1.68 ms;
		REC_DATE_EN <= '1';
		wait for 1.632 us;
		REC_DATE_EN <= '0';
		wait for 285.6 us;
		REC_DATE_EN <= '1';
		wait for 1.632 us;
		REC_DATE_EN <= '0';
		wait for 285.6 us;
		REC_DATE_EN <= '1';
		wait for 1.632 us;
		REC_DATE_EN <= '0';
		wait for 285.6 us;
		REC_DATE_EN <= '1';
		wait for 1.632 us;
		REC_DATE_EN <= '0';
		wait for 285.6 us;
		REC_DATE_EN <= '1';
		wait for 1.632 us;
		REC_DATE_EN <= '0';
		wait for 285.6 us;
		REC_DATE_EN <= '1';
		wait for 1.632 us;
		REC_DATE_EN <= '0';

		wait;		
	end process;
	process
	begin
		REC_ADDR_EN <= '1';
		wait for 1.967 ms;
		REC_ADDR_EN <= '0';
		wait ;
		--REC_ADDR_EN <= '1';
		--wait;
	end process;
	process
	begin
		REC_DATE <= X"00";
		wait for 1.68 ms - 1.632 us;
		REC_DATE <= X"14";
		wait for 287.2312 us;
		REC_DATE <= X"02";
		wait for 287.2312 us;
		REC_DATE <= X"00";
		wait for 287.2312 us;
		REC_DATE <= X"00";
		wait for 287.2312 us;
		REC_DATE <= X"00";
		wait for 287.2312 us;
		REC_DATE <= X"16";
		wait;		
	end process;
	
	process
	begin
		RD_ADDR <= X"06";
		wait for 6.68 ms - 1.632 us;
		RD_ADDR <= X"01";
		wait for 287.2312 us;
		RD_ADDR <= X"02";
		wait for 287.2312 us;
		RD_ADDR <= X"03";
		wait for 287.2312 us;
		RD_ADDR <= X"04";
		wait for 287.2312 us;
		RD_ADDR <= X"05";
		wait for 287.2312 us;
		RD_ADDR <= X"06";
		wait;		
	end process;
	-- Unit Under Test port map
	UUT : rs485_rec_string
		port map (
			REC_FT => REC_FT,
			RESET => RESET,
			REC_DATE => REC_DATE,
			RD_ADDR => RD_ADDR,
			REC_ADDR_EN => REC_ADDR_EN,
			REC_DATE_EN => REC_DATE_EN,
			RXDATA => RXDATA,
			NBYTE => NBYTE,
			LAST_BYTE => LAST_BYTE,	 

			RXD_ERROR => RXD_ERROR,
			RXD_OK => RXD_OK,
			SUMM_CTRL => SUMM_CTRL
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_rs485_rec_string of rs485_rec_string_tb is
	for TB_ARCHITECTURE
		for UUT : rs485_rec_string
			use entity work.rs485_rec_string(syn);
		end for;
	end for;
end TESTBENCH_FOR_rs485_rec_string;

