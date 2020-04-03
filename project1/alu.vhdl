library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
 
entity alu is 
port (A,B :in std_logic_vector(15 downto 0) ;
		op,beq : in std_logic;
		C : out std_logic_vector(15 downto 0);
		Z ,Cout: out std_logic);
end alu;


architecture Struct of alu is 

component adder16Cin is
  port (
		in_a : in std_logic_vector (15 downto 0);
		in_b : in std_logic_vector (15 downto 0);
		cin : in std_logic;
		sum : out std_logic_vector (16 downto 0));
end component adder16Cin;

component nandbit is 
port (A ,B : in std_logic_vector(15 downto 0);
		C: out std_logic_vector(15 downto 0));
end component nandbit;

component two_to_one_mux_16 is
port( a, b : in std_logic_vector(15 downto 0);
 sel : in std_logic;
y : out std_logic_vector(15 downto 0) );
end component two_to_one_mux_16;

component two_to_one_mux is
port( a, b, sel : in std_logic;
y : out std_logic );
end component two_to_one_mux;


signal t1,t2,t3,t7,tB:std_logic_vector(15 downto 0);
signal t4,t5,t6,t8:std_logic ;

begin 
	t8 <= beq;
	tB <= not B when beq = '1' else B;
	c1: adder16Cin port map (in_a => A, in_b=>tB,cin => t8,sum(15 downto 0) => t1 ,sum(16) => t4);
	c2: nandbit port map (A,B,t2);
--c3: two_to_one_mux_16 port map (t1,t2,op,t3); 
	t3 <= (others => op);
	t7 <= (t3 and t2) or (t1 and not t3);

	C <= t7;
--	t5 <= NOT(t1(0) or t1(1) or t1(2) or t1(3) or t1(4) or t1(5) or t1(6) or t1(7) or t1(8) or t1(9)
--				or t1(10) or t1(11) or t1(12) or t1(13) or t1(14) or t1(15));
--
--C4 : two_to_one_mux
--port map (t4,'0',t5,Cout);
	Cout <= t4 and not op;
	t6 <= NOT(t7(0) or t7(1) or t7(2) or t7(3) or t7(4) or t7(5) or t7(6) or t7(7) or t7(8) or t7(9)
					or t7(10) or t7(11) or t7(12) or t7(13) or t7(14) or t7(15));

--C5 : two_to_one_mux
--port map ('0','1',t6,Z);
	Z <= t6;

end Struct;