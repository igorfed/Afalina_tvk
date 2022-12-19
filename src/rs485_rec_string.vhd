library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL; 
entity rs485_rec_string is
	 port(
		REC_FT		: in STD_LOGIC;-- тактовая частота
		RESET 		: in STD_LOGIC;
		REC_DATE 	: in STD_LOGIC_VECTOR(7 downto 0);	--//////// 1byte 2byte 3byte 4byte 5byte 6byte/////
		RD_ADDR		: in STD_LOGIC_VECTOR(7 downto 0); 
		REC_ADDR_EN	: in std_logic;						--________|_____|_____|_____|_____|_____|__________ 
		REC_DATE_EN	: in std_logic;						----------------|_______________________|----------
		A7			: in std_logic;
		NA7         : in std_logic;
		RXDATA		: out std_logic_vector(7 downto 0);	 
		-- номер байта
		LAST_BYTE	: in std_logic_vector(7 downto 0);	 
		NBYTE		: out std_logic_vector(7 downto 0); -- номер байта
		RXD_ERROR	: out std_logic;
		RXD_OK		: out std_logic;		
		-- контрольная сумма
		SUMM_CTRL	: out std_logic_vector(7 downto 0)
		);			  
		

end rs485_rec_string;
architecture syn of rs485_rec_string is	 


component RAM2PORTRX
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wraddress	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC  := '1';
		
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;

constant ADDR_BYTE1	: std_logic_vector(7 downto 0):=X"14";--значение первого байта
signal 		wren	: std_logic; 
signal  	cvbeo1_byte1: std_logic;
signal		cvbeo1_byte_end: std_logic;
signal		ena		: std_logic;
signal 		ctrl_summ_ok: std_logic;
signal		sum_ctrl: std_logic_vector(7 downto 0):=(others=>'0'); 
signal		num_byte: std_logic_vector(7 downto 0):=(others=>'0'); 
signal 		dff1, dff2	: std_logic;
signal		wraddress: std_logic_vector(7 downto 0);
signal		rdaddress: std_logic_vector(7 downto 0);
signal 		cvdff2, cvdff1 :std_logic;

begin
	--прием первого байта	
	process(REC_FT)
	begin
		if rising_edge(REC_FT) then 
			if RESET = '1' then cvbeo1_byte1<='0';wren <= '0';
			elsif
				REC_DATE = ADDR_BYTE1 then cvbeo1_byte1 <= '1' and REC_ADDR_EN; 
			else cvbeo1_byte1<='0';
				
	       	end if;				   
			   wren <= REC_DATE_EN;
		end if;
	
	end process;  
	ena <= cvbeo1_byte1 and REC_DATE_EN;
	--Проверка контрольной суммы 
	process(REC_FT)
	begin
		if rising_edge(REC_FT) then 
			if RESET = '1'  then sum_ctrl<= (others=>'0'); ctrl_summ_ok <= '0';
			else
				if ena = '1' then sum_ctrl<= (others=>'0');
				elsif wren = '1' then sum_ctrl <= sum_ctrl xor REC_DATE;
				else sum_ctrl <= sum_ctrl;
				end if;					
				if sum_ctrl = x"00" then ctrl_summ_ok <= '1';
				else ctrl_summ_ok <= '0';
				end if;
			end if;
		end if;
	end process;

	--Подсчет количества принимаемых байтов
	process(REC_FT)
	begin
		if rising_edge(REC_FT) then 
			if RESET = '1'  then num_byte <= (others=>'0');cvbeo1_byte_end <= '0';
			else
				if ena = '1' then num_byte<= (others=>'0');
					elsif  wren = '1' then num_byte <= num_byte + 1;
					else num_byte <= num_byte;
				end if;	
								
				if num_byte = LAST_BYTE then cvbeo1_byte_end <= '1';
					else cvbeo1_byte_end <= '0';
				end if;
			end if;
		end if;
	end process;
	cvdff1 <= cvbeo1_byte_end when rising_edge(REC_FT);
	cvdff2 <= cvdff1 when rising_edge(REC_FT);
	dff1<= wren when rising_edge(REC_FT);
    dff2<= dff1 when rising_edge(REC_FT);
	RXD_OK <= dff2 and cvdff2 and ctrl_summ_ok; 
	
	--запись принятых байтов в регистр
	wraddress <= A7 & num_byte(6 downto 0); 
	rdaddress <= NA7 & RD_ADDR(6 downto 0);
RAM2: RAM2PORTRX
	port map
	(
		clock		=> REC_FT,
		data		=> REC_DATE,
		rdaddress	=> rdaddress,
		wraddress	=> wraddress,
		wren		=> dff2,
		
		q			=> RXDATA
	);

SUMM_CTRL <= sum_ctrl;
NBYTE <= num_byte;
	
end ;