LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

entity xvform_285 is
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
		XV4 		: OUT STD_LOGIC;
		SG2A 		: OUT STD_LOGIC;
		SG2B 		: OUT STD_LOGIC;
		XSUB 		: OUT STD_LOGIC;
		H1			: OUT STD_LOGIC;
		H2			: OUT STD_LOGIC;
		RG			: OUT STD_LOGIC;
		LINE		: OUT STD_LOGIC;
		FRAME		: OUT STD_LOGIC
		);		
end xvform_285;	   

architecture syn of xvform_285 is	 
Type tOperate is( a_Sector, b_Sector, d_Sector, ActiveLine, Empty);
signal xtran	: std_logic_vector(11 downto 0);
signal vtran	: std_logic_vector(11 downto 0); 
signal cntBSector:std_logic_vector(11 downto 0);
signal ActiveSector:std_logic_vector(11 downto 0);
signal bSector   :std_logic_vector(11 downto 0);
signal cntDSector:std_logic_vector(11 downto 0);
signal dSector   :std_logic_vector(11 downto 0);
signal V1		: std_logic;
signal V2		: std_logic;
signal V3		: std_logic;
signal V4		: std_logic;
signal SG		: std_logic;		  
signal CMD		: std_logic;				 
signal C_SHR	: std_logic_vector(11 downto 0);
signal SUB		: std_logic;
signal cnt 		: std_logic_vector(1 downto 0);	  
signal StartActiveLine : std_logic_vector (11 downto 0);
--constant NumLine : std_logic_vector(11 downto 0):=X"1F4";--500
--количество строк b сектора
signal Operate : tOperate;										
signal NumLine : std_logic_vector(11 downto 0);
constant v1_left_ftont :std_logic_vector(11 downto 0):=X"04c";--76	  
constant v2_left_ftont :std_logic_vector(11 downto 0):=X"042";--66	  
constant v3_left_ftont :std_logic_vector(11 downto 0):=X"056";--86	  
constant v4_left_ftont :std_logic_vector(11 downto 0):=X"038";--86	  

--перенос в областях b и d
constant v1_left_ftont_fast :std_logic_vector(11 downto 0):=X"026";	  
constant v2_left_ftont_fast :std_logic_vector(11 downto 0):=X"021";
constant v3_left_ftont_fast :std_logic_vector(11 downto 0):=X"02B";
constant v4_left_ftont_fast :std_logic_vector(11 downto 0):=X"01C";

signal 	 wind_cnt	   : std_logic_vector(11 downto 0);
signal 	Fr		: std_logic;
signal SHUTTER_CCD: std_logic_vector(11 downto 0);
begin  
	--				  
	WINDOW_COUNTER : process(CLK) 		 --1208 x 768
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then NUMLine <= X"08D";			 --05
			elsif CNT_EN  = '1' then 
				if WIND_CCD = '0' then NUMLine <= X"1F4";--500	5 - 1055
				elsif WIND_CCD = '1' then
					if NUMLine = 908 and (Y = 1 and X = 1) then NUMLine <= X"08D";--05--1030
					elsif (Y = 1 and X = 1)	then NUMLine <= NUMLine + 1;				   
					end if;
				end if;
			end if;
		end if;
	
					
	
	end process;
	   --NUMLine <= 1000;
	
	Vert_transfer : process(CLK) 
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then 
				xtran 			<= (others => '0'); 
				cntBSector 		<= (others => '0'); 
				BSector 		<= (others => '0');--счетчик области вертикального переноса "B"
				Operate 		<= Empty;--Тип выполняемой операции  			
				StartActiveLine <=(Others=>'0'); ---??????
				ActiveSector 	<= (others => '0');	-- Счетчик центральной области матрицы
			elsif CNT_EN  = '1' then 
				--------------------------
				-- Область Frame Shift "b"
				if Y = 1 then xtran <= X"000";
					elsif Y > 1 and (xtran = 40) then xtran <= X"001"; -- уменьшить в 2 раз
					else  xtran <= xtran +1;
				end if;	 
				
				if Y =1 then cntBSector <= X"000";
					elsif xtran = 1 then cntBSector <= cntBSector + 1;
				end if;
				
				if cntBSector > 0 and cntBSector <= NumLine then BSector <= cntBSector;
					--Operate <= b_Sector;
				else BSector <= (others =>'0');
				end if;
				-- Область Frame Shift "b"
				----------------------
				-- Старт активной части--
				if BSector = NumLine then StartActiveLine <= Y+1;
					
				end if;
				
				
				if X = 1 then
					if (Y >= StartActiveLine and Y < StartActiveLine +15 ) then --30
						ActiveSector<= ActiveSector +1;
--						Operate <= ActiveLine;
					else ActiveSector<= (others=>'0');
					end if;
				end if;
--				if Y = 1 then Operate <= a_Sector;
--				end if;
				if Y >= StartActiveLine +15 then --30
					if xtran = 1 then DSector <= DSector + 1;--Operate <= d_Sector;
					end if;
				else DSector <= (others => '0');
				end if;
				
				if BSector /= 0 then Operate <= b_Sector;
				elsif ActiveSector /= 0 then Operate <= ActiveLine;
				elsif DSector /= 0 then Operate <= d_Sector;
				elsif Y = 1 then Operate <= a_Sector;	
				else Operate <= Empty;
				end if;
				
				
			end if;
		end if;
	end process; 

	icxV1: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V1 <= '0';
			elsif CNT_EN  = '1' then
				--if vtran >1 and vtran <= 21 then 
					if MODE_CCD = '0' then 
						if (Operate = a_Sector) then
							if (X > v1_left_ftont and X <= v1_left_ftont +50) or 
								(X > v1_left_ftont+80 and X <= v1_left_ftont +130) or
								(X > v1_left_ftont+160 and X <= v1_left_ftont +210) or 
								(X > v1_left_ftont+240 and X <= 802) or
								(X > 1006 and X <= 1006+50)
								then V1 <= '1';
							else V1 <= '0';
							end if;		   
--					   		if X > 140 and X <= 802 then V1 <='1';
--								else V1 <= '0';
--							end if;

						elsif (Operate = b_Sector)or (Operate = d_Sector) then 
							if (xtran > 15 )then V1 <= '1';--30
							else V1 <= '0';
							end if;
						elsif (Operate = ActiveLine) then
							if (X > v1_left_ftont and X <= v1_left_ftont +50) or 
								(X > v1_left_ftont+80 and X <= v1_left_ftont +130) or
								(X > v1_left_ftont+160 and X <= v1_left_ftont +210) or 
								(X > v1_left_ftont+240 and X <= v1_left_ftont + 290) 
								then V1 <= '1';
							else V1 <= '0';
							end if;	   
--							if X > 140 and X <= 350 then V1 <='1';
--							else V1 <= '0';
--							end if;

						else V1 <='0'; 
						end if;
					elsif MODE_CCD ='1' then 
						if Y = 1 then 
							if X > 140 and X <= 802 then V1 <='1';
							else V1 <= '0';
							end if;
						else
							if X > 140 and X <= 350 then V1 <='1';
							else V1 <= '0';
							end if;
						end if;							
					end if;
				end if;
			end if;
	end process;

	icxV2: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V2 <= '0';
			elsif CNT_EN  = '1' then 
				if MODE_CCD = '0' then
					if (Operate = a_Sector) then
						if (X > v2_left_ftont and X <= v2_left_ftont +30) or 
							(X > v2_left_ftont+80 and X <= v2_left_ftont +110) or
							(X > v2_left_ftont+160 and X <= v2_left_ftont +190) or 
							(X > v2_left_ftont+240 and X <= v2_left_ftont+270) or
							(X > 996 and X <= 996+30)
							then V2 <= '0';
							else V2 <= '1';
						end if;	 
--						if X > 98 and X <= 224 then V2 <='0';
--							else V2 <= '1';
--						end if;

						elsif (Operate = b_Sector)or (Operate = d_Sector) then 
							if (xtran > 10 and xtran < 25)then V2 <= '0';--20 -- 50
							else V2 <= '1';
							end if;
						elsif (Operate = ActiveLine) then
						if (X > v2_left_ftont and X <= v2_left_ftont +30) or 
							(X > v2_left_ftont+80 and X <= v2_left_ftont +110) or
							(X > v2_left_ftont+160 and X <= v2_left_ftont +190) or 
							(X > v2_left_ftont+240 and X <= v2_left_ftont+270)
								then V2 <= '0';
							else V2 <= '1';
						end if;	  
--						if X > 98 and X <= 224 then V2 <='0';
--							else V2 <= '1';
--						end if;

						else V2 <='1';
					end if;
					
				elsif MODE_CCD ='1' then 
					if X > 98 and X <= 224 then V2 <='0';
						else V2 <= '1';
					end if;
				
				end if;

					
					
			end if;
		end if;
	end process;

	icxV3: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V3 <= '0';
			elsif CNT_EN  = '1' then  
				if MODE_CCD = '0' then
					if (Operate = a_Sector) then
						if (X > v3_left_ftont and X <= v3_left_ftont +30) or 
							(X > v3_left_ftont+80 and X <= v3_left_ftont +110) or
							(X > v3_left_ftont+160 and X <= v3_left_ftont +190) or 
							(X > v3_left_ftont+240 and X <= v3_left_ftont+270) or
							(X > 1016 and X <= 1016+30)
							then V3 <= '0';
							else V3 <= '1';
						end if;			   	
--						if X > 182 and X <= 308 then V3 <='0';
--							else V3 <= '1';
--						end if;

					elsif (Operate = b_Sector)or (Operate = d_Sector) then 
						if (xtran > 20 and xtran < 35)then V3 <= '0';--40--70
							else V3 <= '1';
						end if;
					elsif (Operate = ActiveLine) then
						if (X > v3_left_ftont and X <= v3_left_ftont +30) or 
							(X > v3_left_ftont+80 and X <= v3_left_ftont +110) or
							(X > v3_left_ftont+160 and X <= v3_left_ftont +190) or 
							(X > v3_left_ftont+240 and X <= v3_left_ftont+270)
								then V3 <= '0';
							else V3 <= '1';
						end if;	  
--					if X > 182 and X <= 308 then V3 <='0';
--						else V3 <= '1';
--					end if;

					else V3 <='1';
					end if;
				elsif MODE_CCD = '1' then 
					if X > 182 and X <= 308 then V3 <='0';
						else V3 <= '1';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	icxV4: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then V4 <= '0';
			elsif CNT_EN  = '1' then 
				if MODE_CCD = '0' then 
					if (Operate = a_Sector) then
						if (X > v4_left_ftont and X <= v4_left_ftont +50) or 
							(X > v4_left_ftont+80 and X <= v4_left_ftont +120) or
							(X > v4_left_ftont+150 and X <= v4_left_ftont +200) or 
							(X > v4_left_ftont+230 and X <= v4_left_ftont+280) or
							(X > 986 and X <= 986+50)
							then V4 <= '1';
							else V4 <= '0';
						end if;
--						if X > 56 and X <= 266 then V4 <='1';
--							else V4 <= '0';
--						end if;
	
						elsif (Operate = b_Sector)or (Operate = d_Sector) then 
							if (xtran > 30 or xtran < 5)then V4 <= '0';--60 10
							else V4 <= '1';
							end if;
						elsif (Operate = ActiveLine) then
						if (X > v4_left_ftont and X <= v4_left_ftont +50) or 
							(X > v4_left_ftont+80 and X <= v4_left_ftont +120) or
							(X > v4_left_ftont+150 and X <= v4_left_ftont +200) or 
							(X > v4_left_ftont+230 and X <= v4_left_ftont+280) 
								then V4 <= '1';
							else V4 <= '0';
						end if;
--						if X > 56 and X <= 266 then V4 <='1';
--							else V4 <= '0';
--						end if;

					else V4 <='0';
					end if;	
				elsif MODE_CCD = '1' then
					if X > 56 and X <= 266 then V4 <='1';
						else V4 <= '0';
					end if;
				end if;	
			end if;
		end if;
	end process;
--SG проинвертировано для CXD3400
	icxSG: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then SG <= '0';
			elsif CNT_EN  = '1' then 
				if (Y = 1 and X > 800 and X <= 800 + 100) then SG <= '1';
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
					if MODE_CCD = '0' then 
						if C_SHUTTER >= X"28" then SHUTTER_CCD <= X"028";
						else SHUTTER_CCD <= C_SHUTTER;
						end if;
						C_SHR <= (X"28" - SHUTTER_CCD); 
					elsif MODE_CCD = '1' then 
						if C_SHUTTER >= X"42C" then SHUTTER_CCD <= X"42C";
						else SHUTTER_CCD <= C_SHUTTER;
						end if;
						
						C_SHR <= (X"42C" - SHUTTER_CCD); 
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
					if (Y > 1 and Y <= C_SHR+1) and (X > 161 and X <= 161 + 126) then SUB<= '1';
					else SUB <='0';   
    				end if;
			end if;
		end if;
	end process;  				   

	XV1 <= not V1;
	XV2	<= not V2;
	XV3	<= not V3;
	XV4	<= not V4;
	SG2A <= not SG;
	SG2B <= not SG;
	XSUB <= not SUB;
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
				else
				if MODE_CCD = '0' then
					if(Operate = ActiveLine) then 
						if ((X<=56 or X >392) and (cnt =3 or cnt = 2)) then H1 <= '1';H2 <='0';
						else H1<='0';H2 <='1';
						end if;
					elsif (Operate /= ActiveLine) then 
						if (cnt =3 or cnt = 1) then H1 <= '1';H2 <='0';					 
						else H1<='0';H2 <='1';
				    	end if;    
					end if;
	--if (X<=56 or X >392) and (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';					
		--if (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';					
	--						if  (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';					
				elsif MODE_CCD = '1' then
	if (X<=56 or X >392) and (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';
	--	if (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';
	--				if  (cnt =3 or cnt = 2) then H1 <= '1';H2 <='0';											
					else H1<='0';H2 <='1';
				
					end if;
				end if;
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

	LINE_285: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then LINE <= '0';
			elsif CNT_EN  = '1' then 
--				if X >= 56-40 and X< 412 + 2 then LINE <= '1';	--285 / 180 -- 415 / 102 см Барк. 1392 px
				if X >= 1747 or X< 467 then LINE <= '1';	--285 / 180 -- 415 / 102 см Барк. 1392 px
				else LINE <= '0';
				end if;
			end if;
		end if;
	end process;  

	FRAME_285: process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET = '1' then FRAME <= '0';FR <= '0';
			elsif CNT_EN  = '1' then 
				if MODE_CCD = '0' then 
					if WIND_CCD = '0' then
						if (ActiveSector > 3 and ActiveSector < 15)or (ActiveSector = 15 and X <1747) then 
							if X = 467 then Frame <= '0';
							end if;
						else Frame <= '1';
						end if;
						
--						if  (Y > 15+1 and Y < 25+1) or 	 --26 57
--				   			(Y = 15+1 and X >= 467 ) or  --26
--				   			(Y = 25+1 and X < 467 )		 --57
--				   			then FRAME <= '0';	--285 / 180 -- 415 / 102 см Барк.
--						else FRAME <= '1';
--						end if;				  
					elsif WIND_CCD = '1' then
						if X = 467 then 
							if Operate = ActiveLine then FR <= '0' ;
								else FR <= '1';
							end if;
						end if;	  
						if (ActiveSector > 3 and ActiveSector < 15)or (ActiveSector = 15 and X <1747) then 
							if X = 467 then Frame <= '0';
							end if;
						else Frame <= '1';
						end if;
					end if;						
				elsif MODE_CCD = '1' then
					if  (Y > 5 and Y < 1055) or 
				   		(Y = 5 and X >= 467 ) or 
				   		(Y = 1055 and X < 467 )
				   		then FRAME <= '0';	--1050 строк
					else FRAME <= '1';
					end if;
				end if;
					
					
					
			end if;
		end if;
	end process;  

	
	
end;