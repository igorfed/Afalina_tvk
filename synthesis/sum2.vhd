-- MAX+plus II VHDL Example
-- User-Defined Macrofunction
-- Copyright (c) 1994 Altera Corporation
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY sum2 IS
	PORT(
		A		: IN   STD_LOGIC_VECTOR(7 DOWNTO 0);
		B		: IN   STD_LOGIC_VECTOR(7 downto 0);
		C		: OUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
END sum2;

ARCHITECTURE behav OF sum2 IS
SIGNAL C_OUT:STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
--	cxor:PROCESS IS
--	BEGIN
		C_OUT<=A xor B;
--	END PROCESS cxor;
C<=C_OUT;
END BEHAV;