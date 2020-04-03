library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux1_8_1 is
port( A, B, C, D, E, F, G, H, S2, S1, S0 : in std_logic;
		y : out std_logic );
end Mux1_8_1;

architecture struct of Mux1_8_1 is
begin
	y <= (A and (not S2) and (not S1) and (not S0))
			or (B and (not S2) and (not S1) and (S0))
			or (C and (not S2) and (S1) and (not S0))
            or (D and (not S2) and (S1) and (S0))
            or (E and (S2) and (not S1) and (not S0))
			or (F and (S2) and (not S1) and (S0))
			or (G and (S2) and (S1) and (not S0))
			or (H and (S2) and (S1) and (S0));
end struct;
