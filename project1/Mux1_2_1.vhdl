library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux1_2_1 is
port( A, B, S0 : in std_logic;
		y : out std_logic );
end Mux1_2_1;

architecture struct of Mux1_2_1 is
begin
	y <= (A and not S0) or (B and S0); 
end struct;
