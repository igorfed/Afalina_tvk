	FRAME_285: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then FRAME <= '0';
			elsif CNT_EN  = '1' then 
				if MODE_CCD = '0' then
					if  (cntY > 26 and cntY < 57) or 
				   		(cntY = 26 and cntX >= 412 ) or 
				   		(cntY = 57 and cntX < 412 )
				   		then FRAME <= '0';	--285 / 180 -- 415 / 102 см Барк.
					else FRAME <= '1';
					end if;
				elsif MODE_CCD = '1' then
					if  (cntY > 5 and cntY < 1055) or 
				   		(cntY = 5 and cntX >= 412 ) or 
				   		(cntY = 1055 and cntX < 412 )
				   		then FRAME <= '0';	--1050 строк
					else FRAME <= '1';
					end if;
				end if;
					
					
					
			end if;
		end if;
	end process;  
