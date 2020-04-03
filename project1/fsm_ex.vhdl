library ieee;
use ieee.std_logic_1164.all;

entity fsm_ex is
   port ( instruction,instruction2: in std_logic_vector(15 downto 0);
beq,clk,r,nop_check,carry,zero: in std_logic;
ex10,ex11,ex20,ex21,ex30,ex40,ex50,ex60,ex61,ex70,ex71,ex72,exmem_en,nop_detect,carryflag_en,zeroflag_en,beq_op: out std_logic);
end entity;

architecture Behave of fsm_ex is

  type StateSymbol  is (S0,S1);
  signal fsm_state_symbol: StateSymbol;
-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
process(r,clk,fsm_state_symbol,nop_check,carry,zero,beq ,instruction,instruction2)
     variable nq_var : StateSymbol;
	  --variable nop_detect_var,ex10_var,ex11_var,ex20_var,ex21_var,ex30_var,ex40_var,ex50_var,ex60_var,ex61_var,ex70_var,ex71_var,ex72_var,exmem_addr1_en_var,exmem_addr2_en_var,exmem_val_en_var: std_logic;
	  variable nop_detect_var,ex10_var,ex11_var,ex20_var,ex21_var,ex30_var,ex40_var,ex50_var,ex60_var,ex61_var,ex70_var,ex71_var,ex72_var,exmem_en_var,carryflag_en_var,zeroflag_en_var,beq_op_var: std_logic;

  begin
     nq_var := fsm_state_symbol; 
ex11_var := '1';
ex10_var := '0';
ex21_var := '1';
ex20_var := '0'; 
ex50_var := '1';
ex61_var := '0';
ex60_var := '0';
ex72_var := '0';
ex70_var := '1';
ex71_var := '0';
ex30_var := '0';
ex40_var := '0';
carryflag_en_var := '1';
zeroflag_en_var := '1';
--exmem_addr1_en_var := '0';
--exmem_addr2_en_var := '0';
--exmem_val_en_var := '0';
exmem_en_var := '0';
nop_detect_var := '0';
beq_op_var := '0';
     -- compute next-state, output
     case fsm_state_symbol is
	  	    when s0 =>
	 if (beq = '1' or nop_check = '1' or ((instruction2(15 downto 12) = "0010" or instruction2(15 downto 12) = "0000") and instruction2(1 downto 0) = "10" and carry = '0') or ((instruction2(15 downto 12) = "0010" or instruction2(15 downto 12) = "0000") and instruction2(1 downto 0) = "01" and zero = '0')) then
			    nq_var := s1;
			 else
			    nq_var := s0;
			end if;
			
			if (instruction(15 downto 12) = "0000" ) then
				carryflag_en_var := '0';
				zeroflag_en_var := '0';

			elsif (instruction(15 downto 12) = "0010" ) then
				zeroflag_en_var := '1';

			elsif (instruction(15 downto 12) = "0001" ) then
					ex11_var := '1';
					ex10_var := '0';
					ex21_var := '0';
					ex20_var := '1'; 
					carryflag_en_var := '0';
					zeroflag_en_var := '0';


			elsif (instruction(15 downto 12) = "0011" ) then
               ex71_var := '1';
			elsif (instruction(15 downto 12) = "0100" ) then
					ex11_var := '0';
					ex10_var := '1';
					ex21_var := '0';
					ex20_var := '1'; 
					ex60_var := '1';
			elsif (instruction(15 downto 12) = "0101" ) then
					ex11_var := '0';
					ex10_var := '1';
					ex21_var := '0';
					ex20_var := '1'; 
					ex60_var := '1';
					ex70_var := '0';
			elsif (instruction(15 downto 12) = "0110" ) then
  					ex21_var := '0';
					ex11_var := '0';
					ex40_var := '1';

			elsif (instruction(15 downto 12) = "0111" ) then
  					ex21_var := '0';
					ex11_var := '0';
               ex71_var := '1';
					ex70_var := '0';
					ex40_var := '1';

			elsif (instruction(15 downto 12) = "1100" ) then
					ex70_var := '0';
  					ex72_var := '1';
					ex30_var := '1';
					beq_op_var := '1';

			elsif (instruction(15 downto 12) = "1000" ) then
					ex50_var := '0';
					ex61_var := '1';
					ex30_var := '1';
					ex70_var := '0';
  					ex72_var := '1';
			elsif (instruction(15 downto 12) = "1001" ) then
					ex70_var := '0';
					  ex71_var := '1';
			elsif(instruction(15 downto 12) = "1111") then
				beq_op_var := '1';
			 else
			 	   ex30_var := '0';
					ex40_var := '0';
					ex11_var := '1';
					ex10_var := '0';
					ex21_var := '1';
					ex20_var := '0'; 
					ex50_var := '1';
					ex61_var := '0';
					ex60_var := '0';
					ex72_var := '0';
					ex70_var := '1';
					ex71_var := '0';
					--exmem_addr1_en_var := '0';
					--exmem_addr2_en_var := '0';
					--exmem_val_en_var := '0';
					exmem_en_var := '0';
					nop_detect_var := '0';
          end if;

	    when s1 =>

					--exmem_addr1_en_var := '1';
					--exmem_addr2_en_var := '1';
					--exmem_val_en_var := '1';
					exmem_en_var := '1';
					nop_detect_var := '1';
					beq_op_var := '0';
	  
			 if (nop_check = '0' or ((instruction2(15 downto 12) = "0010" or instruction2(15 downto 12) = "0000") and instruction2(1 downto 0) = "10" and carry = '0') or ((instruction2(15 downto 12) = "0010" or instruction2(15 downto 12) = "0000") and instruction2(1 downto 0) = "01" and zero = '0')) then
             nq_var := s0;
	
          else
             nq_var := s1;
					
			 end if;
       when others => null;

     end case;
	  

	  

  
     -- y(k)
ex11 <= ex11_var;
ex10 <= ex10_var;
ex21 <= ex21_var;
ex20 <= ex20_var; 
ex30 <= ex30_var;
ex40 <= ex40_var;
ex50 <= ex50_var;
ex61 <= ex61_var;
ex60 <= ex60_var;
ex72 <= ex72_var;
ex70 <= ex70_var;
ex71 <= ex71_var;
carryflag_en <= carryflag_en_var;
zeroflag_en <= zeroflag_en_var;
--exmem_addr1_en <= exmem_addr1_en_var;
--exmem_addr2_en <= exmem_addr2_en_var;
--exmem_val_en <= exmem_val_en_var;
exmem_en <= exmem_en_var;
nop_detect <= nop_detect_var;
beq_op <= beq_op_var;
     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <= s1;
          else
             fsm_state_symbol <= nq_var;
          end if;
     end if;

  end process;

end Behave;