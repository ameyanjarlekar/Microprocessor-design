library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity bin_enc is
	port(in_a: in std_logic_vector(7 downto 0);
		  out_a: out std_logic_vector(2 downto 0));
end entity;

architecture Form of bin_enc is
begin
    out_a(2) <= in_a(3) or in_a(2) or in_a(1) or in_a(0);
    out_a(1) <= in_a(5) or in_a(4) or in_a(1) or in_a(0);
    out_a(0) <= in_a(6) or in_a(4) or in_a(2) or in_a(0);
end Form;