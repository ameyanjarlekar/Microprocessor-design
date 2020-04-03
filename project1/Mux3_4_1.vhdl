library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
-- Begin entity
entity Mux3_4_1 is
port( A, B, C, D : in std_logic_vector(2 downto 0);
		S1, S0 : in std_logic;
		y : out std_logic_vector(2 downto 0) );
end Mux3_4_1;


-- Begin architecture
architecture behave of Mux3_4_1 is
-- Define components
component Mux1_4_1 is 
	port( A, B, C, D, S1, S0 : in std_logic;
			y : out std_logic );
end component;
begin 
	muxg: for i in 2 downto 0 generate
		mx: Mux1_4_1 port map(A => A(i), B => B(i), C => C(i), D=> D(i), S0 => S0, S1 => S1, y => y(i));
	end generate muxg;
end behave;



