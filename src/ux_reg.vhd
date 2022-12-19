LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
entity mux_reg is
	port
		(
		CLK			: in std_logic;--global CLK 2/1	 
		CNT_EN		: in std_logic;-- 
		RESET 		: in std_logic;--__|--|__ 
		READ_10		: in std_logic_vector(7 downto 0);
		READ_11		: in std_logic_vector(7 downto 0);
		READ_12		: in std_logic_vector(7 downto 0);
		READ_13		: in std_logic_vector(7 downto 0);
		READ_14		: in std_logic_vector(7 downto 0);
		
		MUX_OUT		: out std_logic_vector(7 downto 0)
		);
	
