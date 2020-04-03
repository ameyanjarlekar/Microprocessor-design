library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
entity Full_Adder  is
  port (A, B, Cin: in std_logic; S, Cout: out std_logic);
end Full_Adder;
architecture Struct of Full_Adder is
  signal tC, tS, U, V: std_logic;
begin
  -- component instances
  ha: Half_Adder 
       port map (A => A, B => B, S => tS, C => tC);

  -- propagate carry.
  a1: AND_2 port map (A => tS, B => Cin, Y => V);
  o1: OR_2  port map (A => V, B => tC, Y => Cout);

  -- final sum.
  x1: XOR_2 port map (A => tS, B => Cin, Y => S);
end Struct;

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity adder16Cin is
  port (
		in_a : in std_logic_vector (15 downto 0);
        in_b : in std_logic_vector (15 downto 0);
        cin : in std_logic;
		sum : out std_logic_vector (16 downto 0));
end adder16Cin;

architecture Struct of adder16Cin is

	component Full_Adder is 
		port (A, B, Cin: in std_logic; S, Cout: out std_logic);
	end component Full_Adder;
	signal tC: std_logic_vector(16 downto 0);
   begin
		tC(0)<= cin;
--		a0: fouradder
--		port map (A=>in_a(3 downto 0),B=>in_b(3 downto 0),Ci=>'0',S=>sum(3 downto 0),Co=>t1);
--		a1: fouradder
--		port map (A=>in_a(7 downto 4),B=>in_b(7 downto 4),Ci=>t1,S=>sum(7 downto 4),Co=>t2);
--		a2: fouradder
--		port map (A=>in_a(11 downto 8),B=>in_b(11 downto 8),Ci=>t2,S=>sum(11 downto 8),Co=>t3);
--		a3: fouradder
--		port map (A=>in_a(15 downto 12),B=>in_b(15 downto 12),Ci=>t3,S=>sum(15 downto 12),Co=>sum(16));
--   
		add:for i in 15 downto 0 generate
			ax: full_Adder port map(A => in_a(i), B => in_b(i), Cin => tC(i), S => sum(i), Cout => tC(i+1));
		end generate add;
		sum(16) <= tC(16);
end Struct;