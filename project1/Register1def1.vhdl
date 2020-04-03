library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity Register1def1 is 
	port (	Reg_datain: in std_logic; 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout: out std_logic);
end entity;

architecture Form of Register1def1 is 
--type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
--signal Register: regarray:=(1 => x"0000",2 => x"0000",3 => x"0000",4 => x"0000",5 => x"0000",6 => x"0000",7 => x"0000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
signal R: std_logic := '1';

begin
Reg_dataout <= R;
Reg_write:
process (Reg_wrbar,Reg_datain,clk)
	begin
	if(Reg_wrbar = '0') then
		if(rising_edge(clk)) then
			R <= Reg_datain;
		end if;
	end if;
	end process;

end Form;
