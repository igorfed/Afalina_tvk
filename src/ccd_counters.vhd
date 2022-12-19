LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
entity ccd_counters is	
	generic	
		(
		MODULEY		: NATURAL;--1790 пикселей
		MODULEY_FULL: NATURAL; --/ -- режим работы полнокадровый 1068  
		MODULEX		: NATURAL -- 80 строк
	);
	port
		(
		CLK			: in std_logic;--global CLK 2/1	высокая 114,56 
		CNT_EN		: in std_logic;-- 
		RESET 		: in std_logic;--__|--|__ -- сброс единицей
		MODE_CCD	: in std_logic;
		X			: out std_logic_vector(11 downto 0);
		Y			: out std_logic_vector(11 downto 0)
		);		
end ccd_counters;	  
architecture syn of ccd_counters is				  
signal cntX		: std_logic_vector(11 downto 0);
signal cntY		: std_logic_vector(11 downto 0);
begin	
	Horc_counter : process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then cntX <= (others => '0');
			elsif CNT_EN  = '1' then 

					if cntX = MODULEX then cntX <= X"001";
						else cntX <= cntX +1;
					end if;

			end if;	  
		end if;
	end process; 

	Vert_counter: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then cntY <= (others => '0');
			elsif CNT_EN  = '1' then 
				if MODE_CCD = '0' then 
					if cntY = MODULEY and cntX = 1 then cntY <= X"001";
						elsif cntX = 1 then cntY <= cntY +1;
					end if;	   	 
				else 
					if cntY = MODULEY_FULL and cntX = 1 then cntY <= X"001";
						elsif cntX = 1 then cntY <= cntY +1;
					end if;	   	 
				end if;					
			end if;
		end if;
	end process;
	--выравнивание счетчиков
	DFF_reg:process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then X <= (others => '0');
			elsif CNT_EN  = '1' then X <= cntX;
			end if;
		end if;
	end process;
				
Y <= cntY;	  


end syn;