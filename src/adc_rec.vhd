LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
entity ADC_REC is	
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
end ADC_REC;	  
architecture syn of ADC_REC is	
component RAM_ADC
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress	: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		wrclock		: IN STD_LOGIC ;
		wren		: IN STD_LOGIC  := '1';
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component;

signal WR_ADDR		: std_logic_vector(11 downto 0);

begin	
	WRADDR : process(CLK_IN)
	begin
		if rising_edge(CLK_IN) then 
			if RESET = '1' then WR_ADDR <= (others => '0');
			else

					if WR_ADDR = MODULEX then WR_ADDR <= X"001";
						else WR_ADDR <= WR_ADDR +1;
					end if;

			end if;	  
		end if;
	end process; 

	RAM_1 : RAM_ADC
	PORT MAP
	(
		data		=> ADC_IN,
		rdaddress	=> X,
		rdclock		=> CLK_OUT,
		wraddress	=> WR_ADDR,
		wrclock		=> CLK_IN,
		wren		=> '1',
		q			=> ADC_OUT
	);



end syn;