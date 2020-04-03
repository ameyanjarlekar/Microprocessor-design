library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
-- Begin entity
entity Mux16_8_1 is
port( A, B, C, D, E, F, G, H : in std_logic_vector(15 downto 0);
		S2, S1, S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) );
end Mux16_8_1;


-- Begin architecture
architecture behave of Mux16_8_1 is
-- Define components
component Mux1_8_1 is 
	port( A, B, C, D, E, F, G, H, S2, S1, S0 : in std_logic;
			y : out std_logic );
end component;
begin 
	muxg4: for i in 15 downto 0 generate
        mx: Mux1_8_1 port map(A => A(i),B => B(i),C => C(i),D => D(i),
         E => E(i), F => F(i) , G => G(i), H => H(i), S2 => S2, S0 => S0,S1 => S1,y => y(i));
	end generate muxg4;
end behave;



