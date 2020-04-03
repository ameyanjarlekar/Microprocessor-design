library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity Register_file is 
	port (	address1, address2,	address3: in std_logic_vector(2 downto 0);
			Reg_datain3, r7_datain: in std_logic_vector(15 downto 0); 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout1, Reg_dataout2: out std_logic_vector(15 downto 0));
end entity;

architecture Form of Register_file is 
type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal RegisterF: regarray:= (0 => x"0000", 1 => x"0001",2 => x"0002",3 => x"FFFF",
4 => x"0004",5 => x"0005",6 => x"0006",7 => x"0000", others => x"0000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin
Reg_dataout1 <= RegisterF(conv_integer(address1));
Reg_dataout2 <= RegisterF(conv_integer(address2));

A:process (Reg_wrbar,Reg_datain3,address3,clk)
	begin

		if(rising_edge(clk)) then
			RegisterF(7) <= r7_datain;
				if(Reg_wrbar = '0') then
			if not(conv_integer(address3) = 7) then
				RegisterF(conv_integer(address3)) <= reg_datain3;
			end if;
		end if;
	end if;
	end process;

end Form;
