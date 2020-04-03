library ieee;
use ieee.std_logic_1164.all;

entity fsm_wb is
   port ( instruction,instruction2: in std_logic_vector(15 downto 0);
clk,r,nop_check: in std_logic;
rf_wr, wbdone_en: out std_logic);
end entity;

architecture Behave of fsm_wb is

  type StateSymbol  is (S1,S0);
  signal fsm_state_symbol: StateSymbol;
-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
process(r,clk,fsm_state_symbol,nop_check,instruction,instruction2)
     variable nq_var : StateSymbol;
	    variable rf_wr_var, wbdone_en_var: std_logic;

  begin

nq_var := fsm_state_symbol; 
rf_wr_var := '0';
wbdone_en_var := '0';

     -- compute next-state, output
     case fsm_state_symbol is
	  	    when s0 =>
	 if (nop_check = '1') then
						 nq_var := s1;
					 else
						 nq_var := s0;
					end if;	 
	if(instruction(15 downto 12) = "0101" or instruction(15 downto 12) = "0111"  or instruction(15 downto 12) = "1100") then
			rf_wr_var := '1';
	end if;		
	    when s1 =>
				rf_wr_var := '1';
        wbdone_en_var := '1';
  
	 if (nop_check = '1' or instruction2(15 downto 12) = "0101" or instruction2(15 downto 12) = "0111" or instruction2(15 downto 12) = "1100") then
             nq_var := s1;
	
          else
             nq_var := s0;
					
			end if;
       when others => null;

     end case;
	  

	  

  
     -- y(k)

rf_wr <= rf_wr_var;
wbdone_en <= wbdone_en_var;

     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <= s1;
          else
             fsm_state_symbol <= nq_var;
          end if;
     end if;

  end process;

end Behave;