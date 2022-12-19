library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL; 
entity EOP_CONTROL is
	port
		(
		CLK			: in std_logic;--global CLK 2/1	высокая 114,56 
		RESET 		: in std_logic;--__|--|__ -- сброс единицей
		CONTROL		: in std_logic_vector(7 downto 0);
		OPEN_VL		: in std_logic;
		CLOSE_VL	: in std_logic;
		EOP_ON		: out std_logic;
		BR			: out std_logic;
		PH			: out std_logic
		);		
end EOP_CONTROL;	  
architecture syn of EOP_CONTROL is				  
begin
	process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then BR <= '0'; PH <= '0';
			else			 
	--			if OPEN_VL = '0' and CLOSED_VL = '0' then BR <= '0'; 
					
				if CONTROL(1) = '0' then  -- команда ввести шторку
					-- проверка введена ли шторка
					if CLOSE_VL = '1' then BR <= '0'; -- если введена то отменить команду 
						else BR <= '1'; PH <= '0'; -- если выведена то выполнить команду
					end if;
				elsif CONTROL(1) = '1' then -- команда вывести шторку
					if OPEN_VL = '1' then BR <= '0'; -- если введена то отменить команду 
						else BR <= '1'; PH <= '1'; -- если выведена то выполнить команду
					end if;
				end if;	
			end if;
		end if;
	end process;
	
	process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then EOP_ON <= '0';
			else
				if OPEN_Vl = '0'  then EOP_ON <= '0';
				elsif OPEN_VL = '1' then EOP_ON <= CONTROL(0);
				end if;
			end if;
		end if;
	end process;
end;

