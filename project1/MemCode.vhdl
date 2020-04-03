library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity MemCode is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end entity;

architecture Form of MemCode is 
type regarray is array(140 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal Memory: regarray:=(
--0 => x"3001", 1 => x"60aa", 2 => x"0038", 3 => x"03fa", 4 => x"0079", 5 => x"5f9f", 6 => x"13fb", 7 => x"2038",
--	8 => x"233a", 9 => x"2079", 10 => x"4f86",11 => x"4f9f", 12 => x"c9c2", 13 => x"abcd", 14 => x"8e02", 15 => x"1234", 16 => x"7caa", 17 => x"91c0",
--	128 => x"ffff", 129 => x"0002", 130 => x"0000", 131 => x"0000", 132 => x"0001", 133 => x"0000",
--	others => x"0000"
0 => x"0008", 1 => x"0242", 2 => x"14C1", 3 => x"2650", 4 => x"6874", 5 => x"CB42", 6 => x"0008", 7 => x"0028", 8 => x"2D51", 9 => x"C282",10 => x"1403", 11 => x"0242",12 => x"3D72",13 => x"8602", 14 => x"0008", 15 => x"07A1", 16 => x"4800", 17 => x"5801",18 => x"7AFE",others => x"0000"
-- 1 => x"3000",2 => x"1057",3 => x"4442",4 => x"0458",5 => x"2460",6 => x"2921",7 => x"1111",8 => x"2921",9 => x"58c0",10 => x"7292",11 => x"6e60",12 => x"c040",13 => x"127f",14 => x"c241",16 => x"9440",22 => x"83f5",25 => x"ffed",others => "0000000000000000"
--you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
--	0 => x"4054",
--	1 => x"6000",
--	2 => x"c042",
--	3 => x"0210",
--	4 => x"c4c3",
--	7 => x"13be",
--	8 => x"2128",
--	9 => x"0a32",
--	10 => x"c982",
--	11 => x"212a",
--	12 => x"3caa",
--	13 => x"5044",
--	14 => x"8202",
--	16 => x"91c0",
--	18 => x"7000",
--	19 => x"f000",
--	20 => x"0014",
--	21 => x"0002",
--	23 => x"0016",
--	24 => x"ffff",
--	26 => x"ffff",
--	27 => x"0012",
--	others => x"0000"
);
	

begin
Mem_dataout <= Memory(conv_integer(address));
Mem_write:
process (Mem_wrbar,Mem_datain,address,clk)
	begin
	if(Mem_wrbar = '0') then
		if(rising_edge(clk)) then
			Memory(conv_integer(address)) <= Mem_datain;
		end if;
	end if;
	end process;
end Form;
