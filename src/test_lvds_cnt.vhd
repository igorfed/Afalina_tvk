LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
entity test_lvds_cnt is
	port
		(
		CLK			: in std_logic;--global CLK 2/1	 
		CNT_EN		: in std_logic;-- 
		RESET 		: in std_logic;--__|--|__ 
		CHOICE_CCD	: in std_logic; -- выбор камеры 0 - ТВ1 / 1 - ТВ2
		MODE_CCD	: in std_logic; -- 0 полоса / 1 полнокадровый
		X			: in std_logic_vector(11 downto 0);
		Y			: in std_logic_vector(11 downto 0);
		test		: out std_logic_vector(11 downto 0)
		);		
end test_lvds_cnt;	  
architecture syn of test_lvds_cnt is				  
signal test_lvds 	: std_logic_vector(11 downto 0);
signal cnt			: std_logic_vector(10 downto 0); 
signal cnta 		: std_logic_vector(11 downto 0);
begin			   
	
	process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then cnt <= (others => '0');
			elsif CNT_EN  = '1' then 									
				if Y = 1 then cnt <= cnt + 1; 
				else cnt <= cnt;
				end if;		  
				if cnt<=1 and Y = 1 then cnta <= cnta + 1;
				else cnta <= cnta;
				end if;		  
				
			end if;
		end if;
				
	end process;
	
	process(CLK) 
	
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then test_lvds <= (others => '0');
			elsif CNT_EN  = '1' then 																	   
				if MODE_CCD = '0' then
					if CHOICE_CCD = '0' then
						if Y > 25 and Y <57 then test_lvds <= (X(9 downto 0) & "00") + (Y(9 downto 0) & "00" + cnta);
							else test_lvds <= (others => '0');
						end if;
					else 
						if Y > 36 and Y <124 then test_lvds <= (X(9 downto 9) & "00") + (Y(9 downto 0) & "00" + cnta );
							else test_lvds <= (others => '0');
						end if;
					end if;
				elsif MODE_CCD = '1' then
					if CHOICE_CCD = '0' then
						if Y > 5 and Y <1055 then test_lvds <= (X(9 downto 0) & "00") + (Y(9 downto 0) & "00" + cnta);
							else test_lvds <= (others => '0');
						end if;
					else 					
						-- для ТВ2 тест не отлажен
						if Y > 5 and Y <1055 then test_lvds <= (X(9 downto 9) & "00") + (Y(9 downto 0) & "00" + cnta );
							else test_lvds <= (others => '0');
						end if;
					end if;
				end if;
					
			end if;
		end if;
	end process; 
	test <= test_lvds;
end;
	