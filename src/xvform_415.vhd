LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

entity xvform_415 is
	port
		(
		CLK			: in std_logic;	 
		CNT_EN		: in std_logic;
		RESET		: in std_logic;
		C_SHUTTER 	: in std_logic_vector(11 downto 0);
		F_SHUTTER 	: in std_logic_vector(11 downto 0);
		MODE_CCD	: in std_logic; -- 0  полоса 1 полнокадровый режим
		WIND_CCD	: in std_logic; -- 0 стационарное окно 1 - перемещающееся 
		
		X			: in std_logic_vector(11 downto 0);
		Y			: in std_logic_vector(11 downto 0);
		-- управление вертикальными регистрами icx285al
		XV1 		: OUT STD_LOGIC;
		XV2 		: OUT STD_LOGIC;
		XV3 		: OUT STD_LOGIC;
		SG	 		: OUT STD_LOGIC;
		XSUB 		: OUT STD_LOGIC;
		H1			: OUT STD_LOGIC;
		H2			: OUT STD_LOGIC;
		RG			: OUT STD_LOGIC;
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC
		
		);		
end xvform_415;	   

architecture syn of xvform_415 is	 
Type tOperate is( a_Sector, b_Sector, d_Sector, ActiveLine, Empty);
signal Operate : tOperate;	
signal cnt_b, cntb1, cntb	: std_logic_vector (11 downto 0);
signal cnt_d, cntd1, cntd	: std_logic_vector (11 downto 0);

signal cntBSector:std_logic_vector(11 downto 0);
signal Active_Line:std_logic_vector(11 downto 0);
signal ActiveSector:std_logic_vector(11 downto 0);
signal ASector   :std_logic_vector(11 downto 0);
signal BSector   :std_logic_vector(11 downto 0);
signal cntDSector:std_logic_vector(11 downto 0);
signal DSector   :std_logic_vector(11 downto 0);

signal V1		: std_logic;
signal V2		: std_logic;
signal V3		: std_logic;
signal CMD		: std_logic;				 
signal C_SHR	: std_logic_vector(11 downto 0);
signal SUB		: std_logic;
signal cnt 		: std_logic_vector(1 downto 0);	  

constant v1_left_ftont : std_logic_vector(11 downto 0):=X"02a";--42  
constant v2_left_ftont : std_logic_vector(11 downto 0):=X"03a";--58	  
constant v3_left_ftont : std_logic_vector(11 downto 0):=X"04a";--74	  
constant sub_left_front: std_logic_vector(11 downto 0):=X"063";--99	  
begin  
 
	
					
	

	
	
	Vert_transfer : process(CLK) 
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then 
				cntb 			<= (others => '0'); 				
				cntb1 			<= X"000";
				cntBSector 		<= (others => '0'); 
				BSector 		<= (others => '0');
				cntd 			<= (others => '0'); 
				cntDSector 		<= (others => '0'); 
				DSector 		<= (others => '0');
				Operate 		<= Empty;
				Active_Line 	<= (others => '0');
				ASector			<= (others => '0');
				cnt_b 			<= (others => '0');
											   
			elsif CNT_EN  = '1' then 
				----------------------------
				-- Область "a" Enlarged-----
				if (Y > 154 or Y < 8)  then 
						if X = 1 then ASector <= ASector + 1;--248 
						end if;
				else ASector <= (others => '0');
				end if;
				-- Область "a" Enlarged-----				
				----------------------------
				-- Область Frame Shift "b"--
				if Y = 1 then BSector <= X"000";cnt_b <= (others => '0');
					elsif ((Y = 8 and X > 40)or ((Y > 8) and (Y <= 7 + 26))) then 
						if cnt_b = 96 then cnt_b <= X"001";
						else  cnt_b <= cnt_b +1;
						end if;
						if cnt_b = 1 then BSector <= BSector + 1;
						end if;	
					else cnt_b <= (others => '0');
				end if;	 
				cntb1 <= cnt_b;
				cntb <= cntb1;

				-- Область Frame Shift "b"	--
				------------------------------
				-- Область Central Scan Mode--
				if Y = 36 then Active_Line <= X"0F8";
					elsif (Y > 36 and Y < 124)  then 
						if X = 1 then Active_Line <= Active_Line + 1;--248 

					end if;
					else Active_Line <= (others => '0');
				end if;
				-- Область Central Scan Mode--				
				------------------------------
				-- Область Frame Shift "b"--
				if Y < 124 then cnt_d <= X"000";DSector <= (others => '0');
					elsif ((Y = 124 and X > 40)or ((Y > 124) and (Y <= 123 + 31))) then 
						if cnt_d = 96 then cnt_d <= X"001";
							else  cnt_d <= cnt_d +1;
						end if;	
						if cnt_d = 1 then DSector <= DSector + 1;
						end if;
					else cnt_d <= (others => '0');
				end if;	 
				cntd1 <= cnt_d;
				cntd <= cntd1;
				
				-- Область Frame Shift "b"--				
				---------------------------- 
				if BSector >0 and BSector <= 254  then Operate <= b_Sector;
				elsif Active_Line /= 0 then Operate <= ActiveLine;
				elsif DSector > 0 and DSector <= 299 then Operate <= d_Sector;
				elsif ASector /= 0 then Operate <= a_Sector;	
				else Operate <= Empty;
				end if;
					
			end if;
		end if;
	end process; 							 
	------------------------- 
	--Вертикальный регистр --
	icxV1: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V1 <= '0';
			elsif CNT_EN  = '1' then

				if MODE_CCD = '0' then 
				--if vtran >1 and vtran <= 21 then 
					if (Operate = a_Sector) then
						if (X > v1_left_ftont and X <= v1_left_ftont +48) then V1 <= '1';
						else V1 <= '0';
						end if;	
					elsif (Operate = ActiveLine) then
						if X > v1_left_ftont and X <= v1_left_ftont +48 then V1 <= '1';
						else V1<= '0';
						end if;
					elsif (Operate = b_Sector) then 
						if (cntb <= 48) then V1 <= '1';
						else V1 <= '0';
						end if;
					elsif (Operate = d_Sector) then 
						if (cntd <= 48) then V1 <= '1';
						else V1 <= '0';
						end if;
					else V1<= '0';
					end if;	
				elsif MODE_CCD ='1' then 
					if X > v1_left_ftont and X <= v1_left_ftont + 48 then V1 <='1';
						else V1 <= '0';
					end if;
				end if;
					
			end if;
		end if;
	end process;
	--Вертикальный регистр --
	------------------------- 	
	--Вертикальный регистр --
	icxV2: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V2 <= '0';
			elsif CNT_EN  = '1' then	
				if MODE_CCD = '0' then				
				--if vtran >1 and vtran <= 21 then 
					if (Operate = a_Sector) then
						if (X > v2_left_ftont and X <= v2_left_ftont +48) then V2 <= '0';
						else V2 <= '1';
						end if;	
					elsif (Operate = ActiveLine) then
						if (X > V2_left_ftont and X <= V2_left_ftont +48) then V2 <= '0';
						else V2<= '1';
						end if;
					elsif (Operate = b_Sector) then 
						if (cntb >16 and cntb <=64 ) then V2 <= '0';
						else V2 <= '1';
						end if;
					elsif (Operate = d_Sector) then 
						if (cntd >16 and cntd <=64 ) then V2 <= '0';
						else V2 <= '1';
						end if;

					else V2<= '1';
						
					end if;	
				elsif MODE_CCD ='1' then 
					if (X > V2_left_ftont and X <= V2_left_ftont +48) then V2 <='0';
						else V2 <= '1';
					end if;
        		end if;
			end if;
		end if;
	end process;
	--Вертикальный регистр --
	------------------------- 	
	--Вертикальный регистр --
	
	icxV3: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V3 <= '0';
			elsif CNT_EN  = '1' then
				if MODE_CCD = '0' then
				--if vtran >1 and vtran <= 21 then 
					if (Operate = a_Sector) then
						if Y = 1 and x > v3_left_ftont and X < 775 then V3 <= '1';
							elsif (Y /= 1 and X > v3_left_ftont and X <= v3_left_ftont +48) then V3 <= '1';
						else V3 <= '0';
						end if;	
					elsif (Operate = ActiveLine) then
						if (X > v3_left_ftont and X <= v3_left_ftont +48) then V3 <= '1';
						else V3<= '0';
						end if;
					elsif (Operate = b_Sector) then 
						if (cntb >32 and cntb <=80 ) then V3 <= '1';
						else V3 <= '0';
						end if;
					elsif (Operate = d_Sector) then 
						if (cntd >32 and cntd <=80 ) then V3 <= '1';
						else V3 <= '0';
						end if;

					else V3<= '0';
						
					end if;
				elsif MODE_CCD = '1' then
					if Y = 1 then 
						if X > v3_left_ftont and X <= 775 then V3 <='1';
						else V3 <= '0';
						end if;
					else
						if X > v3_left_ftont and X <= v3_left_ftont + 48 then V3 <= '1';
						else V3 <= '0';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	--Вертикальный регистр --
	
	icxSG: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then SG <= '0';
			elsif CNT_EN  = '1' then 
				if (Y = 1 and X > 627 and X <= 701) then SG <= '1';
					else SG <='0';
				end if;
			end if;
		end if;
	end process;
	-- задание разрешения вычисления SUB (один раз в кадр)
	process(CLK)
	begin
		if rising_edge(CLK) then
			if RESET = '1' then CMD <= '0';
				elsif Y = 1 and X = 1 then CMD<= '1'; 
				else CMD <= '0';
			end if;
		end if;
	end process;

	process(CLK)
	begin
		if rising_edge(CLK) then
			if RESET = '1' then C_SHR <= (others =>'0');
			else
				if (CMD = '1' ) then 
					if MODE_CCD = '0' then C_SHR <= (X"9C" - C_SHUTTER); 	 -- 156
					elsif MODE_CCD = '1' then C_SHR <= (X"271" - C_SHUTTER); -- 625
					end if;
				end if;							
			end if;
		end if;
	end process;
	icxSUB:process(CLK)
	begin		 
		if rising_edge(CLK) then
			if RESET = '1' then SUB <= '0';
				elsif CNT_EN  = '1' then 
					if (Y > 1 and Y <= C_SHR+1) and (X > sub_left_front and X <= sub_left_front + 23) then SUB<= '1';
					else SUB <='0';   
    				end if;
			end if;
		end if;
	end process;  				   

	XV1 <= V1;
	XV2	<= V2;
	XV3	<= V3;
	XSUB <= SUB;
	process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then cnt <= (others => '0');			
				elsif X = 58 then cnt <= (others => '0');			
				else cnt <= cnt + 1;
					
			end if;
		end if;
	end process;
	
	form_H:	process(CLK)
	begin		
		if rising_edge(CLK) then
			if RESET = '1' then H1 <= '0';H2 <='0'; 
				
			--elsif (X <= v1_left_ftont or X >= v1_left_ftont + 102) and (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';
			elsif (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';
				else H1<='0';H2 <='1';
			end if;
		end if;
	end process; 
	form_RG:process(CLK)
	begin		
		if rising_edge(CLK) then
			if RESET = '1' then RG <= '0'; 
			elsif (cnt = 2) then RG <= '1';
				else RG<='0';
			end if;
		end if;
	end process;
   -----------------------------
   --активная часть строки 782--
	LINE_415: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then LINE <= '0';
			elsif CNT_EN  = '1' then 
				if X > 4 and X <  207 then LINE <= '1';	--782 элемента см Барк.
				else LINE <= '0';
				end if;
			end if;
		end if;
	end process;  				
	--////////////////////////--
	----------------------------
	FRAME_415: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then FRAME <= '0';
			elsif CNT_EN  = '1' then 
				if MODE_CCD = '0' then --0 - полоса
					if WIND_CCD = '0' then
						if  (Y > 26+1 and Y < 57+1) or 
				   			(Y = 26+1 and X >= 412 ) or 
				   			(Y = 57+1 and X < 412 )
				   			then FRAME <= '0';	--285 / 180 -- 415 / 102 см Барк.
						else FRAME <= '1';
						end if;				  
					end if;						
				elsif MODE_CCD = '1' then --1 - полнокадровый режим
					if  (Y > 5 and Y < 1055) or 
				   		(Y = 5 and X >= 412 ) or 
				   		(Y = 1055 and X < 412 )
				   		then FRAME <= '0';	--1050 строк
					else FRAME <= '1';
					end if;

				end if;
					
					
					
			end if;
		end if;
	end process;  

	
end;