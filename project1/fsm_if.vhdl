library ieee;
use ieee.std_logic_1164.all;

entity fsm_if is
   port ( instruction: in std_logic_vector(15 downto 0 );
	lmsm,beq,clk,r,check7: in std_logic;
--pc_mux,pc_en,ifid_ir_en,ifid_pc_en,nop_detect: out std_logic);
pc_mux,pc_en,ifid_en,nop_detect: out std_logic);
end entity;

architecture Behave of fsm_if is

  type StateSymbol  is (reset,S1,S0);
  signal fsm_state_symbol: StateSymbol;
-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
process(r,clk,fsm_state_symbol,lmsm,beq,check7,instruction)
     variable nq_var : StateSymbol;
	  --variable pc_mux_var,pc_en_var,ifid_ir_en_var,ifid_pc_en_var,nop_detect_var: std_logic;
     variable pc_mux_var,pc_en_var,ifid_en_var,nop_detect_var: std_logic;

  begin

   nq_var := fsm_state_symbol; 
   pc_mux_var := '0';
   pc_en_var := '0';
   --ifid_ir_en_var := '0';
   --ifid_pc_en_var := '0';
   ifid_en_var := '0';
   nop_detect_var := '0';
	  
     -- compute next-state, output
     case fsm_state_symbol is
	  	  when s0 =>
          if (lmsm = '1' or beq = '1' ) then
             nq_var := s1;

				else
					nq_var := s0;

          end if;
			--if(beq = '1')then
			--	pc_mux_var :='1';
			--end if;

	    when s1 =>
				pc_mux_var := '1';
				pc_en_var := '1';
				--ifid_ir_en_var := '1';
				--ifid_pc_en_var := '1';
				ifid_en_var := '1';
				nop_detect_var := '1';
				if (check7 = '1' and beq = '0') then
					nq_var := s0;
				else
						nq_var := s1;
				end if;
		when reset => 
			nq_var := s0;
			
				pc_mux_var := '1';
				pc_en_var := '1';
				--ifid_ir_en_var := '1';
				--ifid_pc_en_var := '1';
				ifid_en_var := '1';
				nop_detect_var := '1';
       when others => null;

     end case;
	  
	  

  
     -- y(k)

     pc_mux <= pc_mux_var;
     pc_en <= pc_en_var;
     --ifid_ir_en <= ifid_ir_en_var;
     --ifid_pc_en <= ifid_pc_en_var;
     ifid_en <= ifid_en_var;
     nop_detect <= nop_detect_var;
	  
     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <=reset;
          else
             fsm_state_symbol <= nq_var;
          end if;
     end if;

  end process;

end Behave;