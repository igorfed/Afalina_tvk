-- регистры защелкивания параметров управления ICX285 / затвор / усиление / уровень черного
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity aduc_reg is
	port(
		CLK 			: in std_logic;
		RESET 			: in std_logic;
		DATA_REG		: in std_logic_vector(7 downto 0);
		ADUC_ADDR		: in std_logic_vector(7 downto 0);
		WR				: in std_logic;
		SHUTTER			: out std_logic_vector(15 downto 0);
		GAIN			: out std_logic_vector(15 downto 0);
		CLAMP			: out std_logic_vector(7 downto 0);
		TV				: out std_logic_vector(7 downto 0);
		SHP_SHIFT		: out std_logic_vector(7 downto 0);
		SHD_SHIFT		: out std_logic_vector(7 downto 0);
		CLK_SHIFT		: out std_logic_vector(7 downto 0);
		RG_SHIFT		: out std_logic_vector(7 downto 0);
		CROSS			: out std_logic_vector(7 downto 0);
		MEM_A_INC   	: out std_logic_vector(15 downto 0);
		RS485_MEM_DATA 	: out std_logic_vector(7 downto 0);
		RD_MEM_D		: out std_logic_vector(7 downto 0);
		MEM_DEFINE		: out std_logic_vector(7 downto 0);
		MEM_A			: out std_logic_vector(15 downto 0);
		COM_PORT_DATA	: out std_logic_vector(7 downto 0);

		
		
		MPU_D		: out std_logic_vector(7 downto 0)
		

		);
end aduc_reg;
architecture aduc_reg of aduc_reg is	  	  

constant ONES 			: std_logic_vector(31 downto 0) := X"FFFFFFFF";
constant ZEROS 			: std_logic_vector(31 downto 0) := X"00000000";

constant A_GAIN_H 		: std_logic_vector(7 downto 0) := X"2f"; -- адресс gain 10
constant A_GAIN_L 		: std_logic_vector(7 downto 0) := X"2e"; -- адресс gain 11

constant A_SHUTTER_H 	: std_logic_vector(7 downto 0) := X"2b"; -- адресс shutter aw06 12
constant A_SHUTTER_L 	: std_logic_vector(7 downto 0) := X"2a"; -- адресс shutter aw06 13

constant A_CLAMP 		: std_logic_vector(7 downto 0) := X"2c";-- адресс clamp aw05 14

constant A_TV			: std_logic_vector(7 downto 0) := X"20";-- выбор камеры  aw20 ТВ1 10/11/ ТВ2 20/21

constant A_SHP			: std_logic_vector(7 downto 0) := X"70";-- подвижка SHP
constant A_SHD			: std_logic_vector(7 downto 0) := X"71";-- подвижка SHD
constant A_DATACLK		: std_logic_vector(7 downto 0) := X"72";-- подвижка DATACLK
constant A_RG			: std_logic_vector(7 downto 0) := X"73";-- подвижка RG
constant A_CROSS		: std_logic_vector(7 downto 0) := X"74";-- включение рамки в полнокадровом режиме


constant A_MEM_A_INC_L	: std_logic_vector(7 downto 0) := X"10"; -- 
constant A_MEM_A_INC_H	: std_logic_vector(7 downto 0) := X"11"; -- 
constant A_RS485_MEM_DATA: std_logic_vector(7 downto 0) := X"12"; -- 
constant A_RD_MEM		: std_logic_vector(7 downto 0) := X"13"; -- 
constant A_MEM_DEFINE	: std_logic_vector(7 downto 0) := X"14"; -- 
constant A_MEM_A_L		: std_logic_vector(7 downto 0) := X"16"; -- 
constant A_MEM_A_H		: std_logic_vector(7 downto 0) := X"17"; -- 


constant A_COM_PORT_DATA: std_logic_vector(7 downto 0) := X"40"; -- 



signal Gain_strobe, clamp_strobe : std_logic;
signal DATA_SHUTTER		: std_logic_vector(15 downto 0); 
signal DATA_GAIN		: std_logic_vector(15 downto 0); 
signal DATA_CLAMP		: std_logic_vector(7 downto 0); 
signal DATA_TV			: std_logic_vector(7 downto 0); 
signal DATA_SHP			: std_logic_vector(7 downto 0); 
signal DATA_SHD			: std_logic_vector(7 downto 0); 
signal DATA_ADCLK		: std_logic_vector(7 downto 0); 
signal DATA_RG			: std_logic_vector(7 downto 0); 
signal DATA_CROSS		: std_logic_vector(7 downto 0); 


signal DATA_MEM_A_INC	: std_logic_vector(15 downto 0); 
signal DATA_RS485_MEM_DATA	: std_logic_vector(7 downto 0); 
signal DATA_RD_MEM_D	: std_logic_vector(7 downto 0); 
signal DATA_MEM_DEFINE	: std_logic_vector(7 downto 0); 
signal DATA_MEM_A		: std_logic_vector(15 downto 0); 
signal DATA_COM_PORT_DATA: std_logic_vector(7 downto 0); 
begin
--управление матрицой 
reg:process(CLK) 

	variable cnt, cnt2 : std_logic_vector(1 downto 0);
	begin 
		if rising_edge(CLK) then 
			if RESET ='1' then 
				DATA_GAIN 		<= (others=>'0'); 
				DATA_CLAMP		<= (others =>'0');
				DATA_SHUTTER 	<= (others =>'0');
				DATA_TV			<= (others=>'0'); 
				DATA_SHP		<= X"02"; 
				DATA_SHD		<= X"02"; 
				DATA_ADCLK		<= X"01"; 
				DATA_RG			<= X"00"; 			  
				DATA_CROSS		<= (others=>'0'); 
				
--								GAIN_STROBE <= '0';
--								CLAMP_STROBE <= '0';
--								cnt := "00";
--								cnt2 := "00";
			else
				-----------------------Усиление
				if (WR ='1' and ADUC_ADDR = A_GAIN_L)  then
					for i in 0 to 7 loop 
						DATA_GAIN(i) <= DATA_REG(i);
					end loop;

					--A <= CMD(12 downto 10);
--					GAIN_STROBE <= '1';
--					cnt := "00";	
--				elsif cnt = 3 then GAIN_STROBE <= '0';
--				else cnt := cnt + 1;
				end if;				

				if (WR ='1' and ADUC_ADDR = A_GAIN_H)  then
					for i in 8 to 15 loop 
						DATA_GAIN(i) <= DATA_REG(i-8);
					end loop;
				end if;
				
				----------------------Уровень черного
				if (WR ='1' and ADUC_ADDR = A_CLAMP)  then 
					for i in 0 to 7 loop 
						DATA_CLAMP(i) <= DATA_REG(i);
					end loop;
					--A <= CMD(12 downto 10);
--					CLAMP_STROBE <= '1';
--					cnt2 := "00";
--				elsif cnt2 = 3 then CLAMP_STROBE <= '0';
--				else 
--					cnt2 := cnt2 + 1;
				end if;
				------------------------Затвор
				if (WR ='1' and ADUC_ADDR = A_SHUTTER_L)  then 
					for i in 0 to 7 loop 
						DATA_SHUTTER(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_SHUTTER_H)  then 
					for i in 8 to 15 loop 
						DATA_SHUTTER(i) <= DATA_REG(i-8);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_TV)  then 
					for i in 0 to 7 loop 
						DATA_TV(i) <= DATA_REG(i);
					end loop;
				end if;			   

				if (WR ='1' and ADUC_ADDR = A_SHP)  then 
					for i in 0 to 7 loop 
						DATA_SHP(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_SHD)  then 
					for i in 0 to 7 loop 
						DATA_SHD(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_DATACLK)  then 
					for i in 0 to 7 loop 
						DATA_ADCLK(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_RG)  then 
					for i in 0 to 7 loop 
						DATA_RG(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_CROSS)  then 
					for i in 0 to 7 loop 
						DATA_CROSS(i) <= DATA_REG(i);
					end loop;
				end if;			   
-------------------------------------------------------
--constant A_MEM_A_INC_L	: std_logic_vector(7 downto 0) := X"10"; -- 
--constant A_MEM_A_INC_H	: std_logic_vector(7 downto 0) := X"11"; -- 
--constant A_RS485_MEM_DATA: std_logic_vector(7 downto 0) := X"12"; -- 
--constant A_RD_MEM_D		: std_logic_vector(7 downto 0) := X"13"; -- 
--constant A_MEM_DEFINE	: std_logic_vector(7 downto 0) := X"14"; -- 
--constant A_MEM_A_L		: std_logic_vector(7 downto 0) := X"16"; -- 
--constant A_MEM_A_H		: std_logic_vector(7 downto 0) := X"17"; -- 


--constant A_COM_PORT_DATA: std_logic_vector(7 downto 0) := X"40"; -- 

--signal DATA_MEM_A_INC	: std_logic_vector(15 downto 0); 
--signal DATA_RS485_MEM_DATA	: std_logic_vector(7 downto 0); 
--signal DATA_RD_MEM_D	: std_logic_vector(7 downto 0); 
--signal DATA_MEM_DEFINE	: std_logic_vector(7 downto 0); 
--signal DATA_MEM_A		: std_logic_vector(15 downto 0); 
--signal DATA_COM_PORT_DATA: std_logic_vector(7 downto 0); 

-------------------------------------------------------
				if (WR ='1' and ADUC_ADDR = A_MEM_A_INC_L)  then 
					for i in 0 to 7 loop 
						DATA_MEM_A_INC(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_MEM_A_INC_H)  then 
					for i in 8 to 15 loop 
						DATA_MEM_A_INC(i) <= DATA_REG(i-8);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_RS485_MEM_DATA)  then 
					for i in 0 to 7 loop 
						DATA_RS485_MEM_DATA(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_RD_MEM)  then 
					for i in 0 to 7 loop 
						DATA_RD_MEM_D(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_MEM_DEFINE)  then 
					for i in 0 to 7 loop 
						DATA_MEM_DEFINE(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_MEM_A_L)  then 
					for i in 0 to 7 loop 
						DATA_MEM_A(i) <= DATA_REG(i);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_MEM_A_H)  then 
					for i in 8 to 15 loop 
						DATA_MEM_A(i) <= DATA_REG(i-8);
					end loop;
				end if;			   
				if (WR ='1' and ADUC_ADDR = A_COM_PORT_DATA)  then 
					for i in 0 to 7 loop 
						DATA_COM_PORT_DATA(i) <= DATA_REG(i);
					end loop;
				end if;			   


				
			end if;
		end if;
end process;
MEM_A_INC   <= DATA_MEM_A_INC;
RS485_MEM_DATA <= DATA_RS485_MEM_DATA;
RD_MEM_D	<= DATA_RD_MEM_D;
MEM_DEFINE	<= DATA_MEM_DEFINE;
MEM_A		<= DATA_MEM_A;
COM_PORT_DATA<= DATA_COM_PORT_DATA;
GAIN		<= DATA_GAIN;
CLAMP		<= DATA_CLAMP;
SHUTTER		<= DATA_SHUTTER;
TV			<= DATA_TV;
SHP_SHIFT 	<= DATA_SHP;
SHD_SHIFT 	<= DATA_SHD;
CLK_SHIFT	<= DATA_ADCLK;
RG_SHIFT	<= DATA_RG;
CROSS		<= DATA_CROSS;
--constant A_RD_MEM_D		: std_logic_vector(7 downto 0) := X"13"; -- 
--constant A_MEM_DEFINE	: std_logic_vector(7 downto 0) := X"14"; -- 
--constant A_MEM_A_L		: std_logic_vector(7 downto 0) := X"16"; -- 
--constant A_MEM_A_H		: std_logic_vector(7 downto 0) := X"17"; -- 
--constant A_COM_PORT_DATA: std_logic_vector(7 downto 0) := X"40"; -- 

mux:process(CLK)
	begin
		if rising_edge(CLK) then 
			if RESET ='1' then MPU_D <= (others => '0');
				else
				case ADUC_ADDR is
					when A_TV 				=> MPU_D <= DATA_TV(7 downto 0);
					when A_GAIN_H 			=> MPU_D <= DATA_GAIN(15 downto 8);
					when A_GAIN_L 			=> MPU_D <= DATA_GAIN(7 downto 0);					
					when A_SHUTTER_H 		=> MPU_D <= DATA_SHUTTER(15 downto 8);
					when A_SHUTTER_L 		=> MPU_D <= DATA_SHUTTER(7 downto 0);					
					when A_CLAMP 			=> MPU_D <= DATA_CLAMP(7 downto 0);					
					when A_SHP	 			=> MPU_D <= DATA_SHP(7 downto 0);					
					when A_SHD	 			=> MPU_D <= DATA_SHD(7 downto 0);					
					when A_DATACLK 			=> MPU_D <= DATA_ADCLK(7 downto 0);										
					when A_RG	 			=> MPU_D <= DATA_RG(7 downto 0);										
					when A_CROSS 			=> MPU_D <= DATA_CROSS(7 downto 0);	
					when A_MEM_A_INC_L		=> MPU_D <= DATA_MEM_A_INC(7 downto 0);
					when A_MEM_A_INC_H		=> MPU_D <= DATA_MEM_A_INC(15 downto 8);														
					when A_RS485_MEM_DATA	=> MPU_D <= DATA_RS485_MEM_DATA(7 downto 0);
					when A_RD_MEM			=> MPU_D <= DATA_RD_MEM_D(7 downto 0);
					when A_MEM_A_L			=> MPU_D <= DATA_MEM_A(7 downto 0);
					when A_MEM_A_H			=> MPU_D <= DATA_MEM_A(15 downto 8);
					when A_COM_PORT_DATA    => MPU_D <= DATA_COM_PORT_DATA(7 downto 0);
					when others 			=> MPU_D <= (others =>'0');
				end case;
			end if;
		end if;
	end process;
					

end aduc_reg;
--ADC_GAIN <= GAIN;
--ADC_CLAMP <= CLAMP;						
--ADC <=A;
