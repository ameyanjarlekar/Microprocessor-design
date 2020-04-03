library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux1_4_1 is
port( A, B, C, D, S1, S0 : in std_logic;
		y : out std_logic );
end Mux1_4_1;

architecture struct of Mux1_4_1 is
begin
	y <= (A and (not S1) and (not S0))
			or (B and (not S1) and (S0))
			or (C and (S1) and (not S0))
			or (D and (S1) and (S0));
end struct;
