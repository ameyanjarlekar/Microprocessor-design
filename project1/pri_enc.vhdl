library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity pri_enc is
	port(in_a: in std_logic_vector(7 downto 0);
		  out_a: out std_logic_vector(7 downto 0));
end entity;

architecture Form of pri_enc is
begin
out_a <= "10000000" when (in_a(7) = '1') else
			"01000000" when (in_a(6) = '1') else
			"00100000" when (in_a(5) = '1') else
			"00010000" when (in_a(4) = '1') else 
			"00001000" when (in_a(3) = '1') else
			"00000100" when (in_a(2) = '1') else
			"00000010" when (in_a(1) = '1') else
			"00000001" when (in_a(0) = '1') else
			"00000000";
end Form;