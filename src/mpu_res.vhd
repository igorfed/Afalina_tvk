library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity mpu_res is
	port(
		CLK 		: in STD_LOGIC;
		RESET_INT	: out STD_LOGIC;
		CNT_EN		: out STD_LOGIC
	);
end mpu_res;

--}} End of automatically maintained section

architecture syn of mpu_res is

signal cnt : std_logic_vector(9 downto 0):=(others =>'0');
signal delay: std_logic;
signal reset	: std_logic;
signal en	: std_logic_vector(1 downto 0):="00";

begin
		
	process( clk )
	begin
		if clk'event and clk = '1' then
			if cnt(cnt'high) = '0' then
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
	
	reset <= cnt(cnt'high - 1);
	RESET_INT <= reset;
  	process(CLK)
	begin
		if rising_edge(CLK) then 
			--if reset = '1' then en <= (others => '0'); 
			en <= en + 1;
			if en = 3 then CNT_EN <= '1';
				else CNT_EN <= '0';
			end if;
		end if;
	end process;
end syn;
