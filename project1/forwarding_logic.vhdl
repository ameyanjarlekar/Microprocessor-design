library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity forwarding_logic is
	port (ifm1_out, rrex_ir, exmem_ir, memwb_ir, wbdone_ir: in std_logic_vector(15 downto 0);
		exmem_addr, memwb_addr, wbdone_addr: in std_logic_vector(2 downto 0);
		fwd_mux1, fwd_mux2: out std_logic_vector(2 downto 0)
	);
end entity forwarding_logic;

architecture struct of forwarding_logic is

alias rrex_op : std_logic_vector(3 downto 0) is rrex_ir(15 downto 12); 
alias rrex_a : std_logic_vector(2 downto 0) is rrex_ir(11 downto 9);
alias rrex_b : std_logic_vector(2 downto 0) is rrex_ir(8 downto 6);
alias rrex_c : std_logic_vector(2 downto 0) is rrex_ir(5 downto 3); 
--alias rr_type : std_logic_vector(1 downto 0) is idrr_ir(1 downto 0);

alias exmem_op : std_logic_vector(3 downto 0) is exmem_ir(15 downto 12); 
alias exmem_a : std_logic_vector(2 downto 0) is exmem_ir(11 downto 9);
alias exmem_b : std_logic_vector(2 downto 0) is exmem_ir(8 downto 6);
alias exmem_c : std_logic_vector(2 downto 0) is exmem_ir(5 downto 3); 
--alias ex_type : std_logic_vector(1 downto 0) is rrex_ir(1 downto 0);

alias memwb_op : std_logic_vector(3 downto 0) is memwb_ir(15 downto 12); 
alias memwb_a : std_logic_vector(2 downto 0) is memwb_ir(11 downto 9);
alias memwb_b : std_logic_vector(2 downto 0) is memwb_ir(8 downto 6);
alias memwb_c : std_logic_vector(2 downto 0) is memwb_ir(5 downto 3); 
--alias mem_type : std_logic_vector(1 downto 0) is exmem_ir(1 downto 0);

alias wbdone_op : std_logic_vector(3 downto 0) is wbdone_ir(15 downto 12); 
alias wbdone_a : std_logic_vector(2 downto 0) is wbdone_ir(11 downto 9);
alias wbdone_b : std_logic_vector(2 downto 0) is wbdone_ir(8 downto 6);
alias wbdone_c : std_logic_vector(2 downto 0) is wbdone_ir(5 downto 3); 
--alias wb_type : std_logic_vector(1 downto 0) is memwb_ir(1 downto 0);

constant add : std_logic_vector(3 downto 0) := "0000";
constant ndu : std_logic_vector(3 downto 0) := "0010"; 

constant adi : std_logic_vector(3 downto 0) := "0001"; 
constant lw : std_logic_vector(3 downto 0) := "0100"; 
constant sw : std_logic_vector(3 downto 0) := "0101"; 
constant beq : std_logic_vector(3 downto 0) := "1100"; 
constant jlr : std_logic_vector(3 downto 0) := "1001"; 

constant lhi : std_logic_vector(3 downto 0) := "0011"; 
constant lm : std_logic_vector(3 downto 0) := "0110"; 
constant sm : std_logic_vector(3 downto 0) := "0111"; 
constant jal : std_logic_vector(3 downto 0) := "1000"; 

--constant carry : std_logic_vector(1 downto 0) := "10"; 
--constant zero : std_logic_vector(1 downto 0) := "01";

constant actual : std_logic_vector(2 downto 0) := "000"; 
constant ex : std_logic_vector(2 downto 0) := "001"; 
constant mem : std_logic_vector(2 downto 0) := "010"; 
constant wb : std_logic_vector(2 downto 0) := "011"; 
constant spl : std_logic_vector(2 downto 0) := "100"; 

begin
	
	fwd_mux1 <= ex when( not(ifm1_out = x"0004") and (
						   ((exmem_op = add or exmem_op = ndu) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and exmem_c = rrex_a) 
						
						or ((exmem_op = adi) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and exmem_b = rrex_a)
						
						or ((exmem_op = jlr or exmem_op = lhi or exmem_op = jal) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and exmem_a = rrex_a)	
					))else
				
				mem when( (not(ifm1_out = x"0004") and not(ifm1_out = x"0005")) and (
						   ((memwb_op = add or memwb_op = ndu) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and memwb_c = rrex_a) 
						
						or ((memwb_op = adi) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and memwb_b = rrex_a)
						
						or ((memwb_op = jlr or memwb_op = lw or memwb_op = lhi or memwb_op = jal) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and memwb_a = rrex_a)
						
						or ((memwb_op = lm) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = sm) 
						   	and memwb_addr = rrex_a) 
					))else
				
				wb when( (not(ifm1_out = x"0004") and not(ifm1_out = x"0005") and not(ifm1_out = x"0006")) and (
						   ((wbdone_op = add or wbdone_op = ndu) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and wbdone_c = rrex_a) 
						
						or ((wbdone_op = adi) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and wbdone_b = rrex_a)
						
						or ((wbdone_op = jlr or wbdone_op = lw or wbdone_op = lhi or wbdone_op = jal) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and wbdone_a = rrex_a)
						
						or ((wbdone_op = lm) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = sm) 
						   	and wbdone_addr = rrex_a)
					))else

				spl when(
						   ((exmem_op = lw) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = lm or rrex_op = sm) 
						   	and exmem_a = rrex_a)
						
						or ((exmem_op = lm) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = adi or rrex_op = sw or rrex_op = beq or rrex_op = sm) 
						   	and exmem_addr = rrex_a)	
					)else

				actual;

	fwd_mux2 <= ex when( not(ifm1_out = x"0004") and (
						   ((exmem_op = add or exmem_op = ndu) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and exmem_c = rrex_b) 
						
						or ((exmem_op = adi) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and exmem_b = rrex_b)
						
						or ((exmem_op = jlr or exmem_op = lhi or exmem_op = jal) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and exmem_a = rrex_b)	
					))else
				
				mem when( (not(ifm1_out = x"0004") and not(ifm1_out = x"0005")) and (
						   ((memwb_op = add or memwb_op = ndu) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and memwb_c = rrex_b) 
						
						or ((memwb_op = adi) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and memwb_b = rrex_b)
						
						or ((memwb_op = jlr or memwb_op = lw or memwb_op = lhi or memwb_op = jal) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and memwb_a = rrex_b)
						
						or ((memwb_op = lm) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and memwb_addr = rrex_b) 
					))else
				
				wb when( (not(ifm1_out = x"0004") and not(ifm1_out = x"0005") and not(ifm1_out = x"0006")) and (
						   ((wbdone_op = add or wbdone_op = ndu) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and wbdone_c = rrex_b) 
						
						or ((wbdone_op = adi) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and wbdone_b = rrex_b)
						
						or ((wbdone_op = jlr or wbdone_op = lw or wbdone_op = lhi or wbdone_op = jal) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and wbdone_a = rrex_b)
						
						or ((wbdone_op = lm) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and wbdone_addr = rrex_b)
					))else

				spl when(
						   ((exmem_op = lw) 
						   	and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and exmem_a = rrex_b)
						
						or ((exmem_op = lm) 
							and (rrex_op = add or rrex_op = ndu or rrex_op = jlr or rrex_op = lw or rrex_op = sw or rrex_op = beq) 
						   	and exmem_addr = rrex_b)	
					)else

				actual;

end architecture struct;