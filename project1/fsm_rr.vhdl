library ieee;
use ieee.std_logic_1164.all;

entity fsm_rr is
   port ( instruction,instruction2: in std_logic_vector(15 downto 0);
beq,clk,r,nop_check,check7: in std_logic;
--idm20,idm21,idm50,idm51,idm3,idm40,idm41,idm42,rrex_d3_en,rrex_d2_en,rrex_d1_en,rrex_addr_en,rrex_ir_en,nop_detect: out std_logic);
idm20,idm21,idm50,idm3,idm40,idm41,idm42,rrex_en,nop_detect,rrbyte_select: out std_logic);

end entity;

architecture Behave of fsm_rr is

  type StateSymbol  is (S0,S1,S2);
  signal fsm_state_symbol: StateSymbol;
-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
process(r,clk,fsm_state_symbol,nop_check,check7,beq,instruction,instruction2)
     variable nq_var : StateSymbol;
	  variable idm50_var,idm51_var,idm20_var,idm21_var,idm3_var,idm40_var,idm41_var,idm42_var,rrex_en_var,nop_detect_var,rrbyte_select_var: std_logic;

  begin

     nq_var := fsm_state_symbol; 
idm20_var := '0';
idm21_var := '0';
idm3_var := '0';
idm40_var := '0'; 
idm41_var := '0';
idm42_var := '0';
idm50_var := '1';
--rrex_d3_en_var := '0';
--rrex_d2_en_var := '0';
--rrex_d1_en_var := '0';
--rrex_addr_en_var := '0';
--rrex_ir_en_var := '0';
rrex_en_var := '0';
nop_detect_var := '0';
rrbyte_select_var := '0';

     -- compute next-state, output
     case fsm_state_symbol is
	  	    when s0 =>
	 if (beq = '1' or nop_check = '1' or (instruction2(7 downto 0) = "00000000" and instruction(15 downto 13) = "011")) then
			    nq_var := s1;
			 else
			    nq_var := s0;
			end if;	 
          if (instruction(15 downto 12) = "0011" or instruction(15 downto 12) = "0100" ) then
					idm41_var := '1';
			elsif  (instruction(15 downto 12) = "0001" ) then
					idm40_var := '1';
			elsif (instruction(15 downto 12) = "0110" ) then
					idm42_var := '1';
					if(check7 = '0') then 
						nq_var := s2;
					end if;
					idm50_var := '0';

			elsif (instruction(15 downto 12) = "0111" ) then
					idm42_var := '1';
					if(check7 = '0')then
					nq_var := s2;
					end if;
					idm50_var := '0';

			elsif (instruction(15 downto 12) = "1100" ) then
					idm40_var := '1';
					idm41_var := '1';
			elsif (instruction(15 downto 12) = "1000" ) then
			      idm3_var := '1';
					idm40_var := '1';
					idm41_var := '1';
			elsif (instruction(15 downto 12) = "1001" ) then
  					idm20_var := '1';
					idm41_var := '1';


			 else
					idm20_var := '0';
					idm21_var := '0';
					idm3_var := '0';
					idm40_var := '0'; 
					idm41_var := '0';
					idm42_var := '0';
					--rrex_d3_en_var := '0';
					--rrex_d2_en_var := '0';
					--rrex_d1_en_var := '0';
					--rrex_addr_en_var := '0';
					rrex_en_var := '0';
					--rrex_ir_en_var := '0';+
					nop_detect_var := '0';
          end if;

	    when s1 =>

					--rrex_d3_en_var := '1';
					--rrex_d2_en_var := '1';
					--rrex_d1_en_var := '1';
					--rrex_addr_en_var := '1';
					--rrex_ir_en_var := '1';
					rrex_en_var := '1';
					nop_detect_var := '1';
	  
			 if (nop_check = '0' and beq = '0' ) then
             nq_var := s0;
	
          else
             nq_var := s1;
					
			end if;
			
	
	    when s2 =>
				idm21_var := '1';
				idm42_var := '1';
				idm40_var := '1';
				idm50_var := '0';
				rrbyte_select_var := '1';

	  
			 if (check7 = '1'  ) then
             nq_var := s0;
	
          else
             nq_var := s2;
					
			end if;
       when others => null;

     end case;
	  

	  

  
     -- y(k)

idm20 <= idm20_var;
idm21 <= idm21_var;
idm3 <= idm3_var;
idm40 <= idm40_var; 
idm41 <= idm41_var;
idm42 <= idm42_var;
idm50 <= idm50_var;
--rrex_d3_en <= rrex_d3_en_var;
--rrex_d2_en <= rrex_d2_en_var;
--rrex_d1_en <= rrex_d1_en_var;
--rrex_addr_en <= rrex_addr_en_var;
--rrex_ir_en <= rre	 if (beq = '1' or nop_check = '1' or ((instruction(15 downto 12) = "0010" or instruction(15 downto 12) = "0000") and instruction(1 downto 0) = "10" and carry = '0') or ((instruction(15 downto 12) = "0010" or instruction(15 downto 12) = "0000") and instruction(1 downto 0) = "01" and zero = '0')) then
--x_ir_en_var;
rrex_en <= rrex_en_var;
nop_detect <= nop_detect_var;
rrbyte_select <= rrbyte_select_var;

     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <= s1;
          else
             fsm_state_symbol <= nq_var;
          end if;
     end if;

  end process;

end Behave;