library ieee;
use ieee.std_logic_1164.all;

entity fsm_id is
   port ( instruction: in std_logic_vector(15 downto 0);
	lmsm,beq,clk,r,nop_check,check7: in std_logic;
	--idmuxa,idmuxb,idrr_ir_en,idrr_pc_en,nop_detect,sgh69_en: out std_logic);
		idm11,idm10,idrr_en,nop_detect: out std_logic);
end entity;

architecture Behave of fsm_id is

  type StateSymbol  is (S1,S0,S2);
  signal fsm_state_symbol: StateSymbol;
-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
process(r,clk,fsm_state_symbol,lmsm,beq,nop_check,instruction,check7)
     variable nq_var : StateSymbol;
	 --variable idmuxa_var,idmuxb_var,idrr_ir_en_var,idrr_pc_en_var,nop_detect_var,sgh69_en_var: std_logic;
	 variable idm11_var,idm10_var,idrr_en_var,nop_detect_var: std_logic;
  begin


	nq_var := fsm_state_symbol; 
	--idmuxa_var := '1';
	 --idmuxb_var := '0';
	 --idrr_ir_en_var := '0';
	 --idrr_pc_en_var := '0';
	 nop_detect_var := '0';
	 --sgh69_en_var := '0';  
	idm11_var := '1';
	 idm10_var := '0';
	 idrr_en_var := '0';
     -- compute next-state, output
     case fsm_state_symbol is
	  	    when s0 =>
			 if (lmsm = '1') then
			    nq_var := s2;
			 elsif(beq = '1' or nop_check = '1')then
				nq_var := s1;
			 else
			    nq_var := s0;
			end if;
          if (instruction(15 downto 12) = "0011" ) then
				 --idmuxa_var := '0';
	          --idmuxb_var := '1';
			  idm11_var := '0';
			  idm10_var := '1';				 
          elsif (instruction(15 downto 12) = "1000" ) then
	          --idmuxa_var := '0';
			  idm11_var := '0';
			 else
				  --idmuxa_var := '1';
				  --idmuxb_var := '0';
				  --idrr_ir_en_var := '0';
				  --idrr_pc_en_var := '0';
				  idm11_var := '1';
				  idm10_var := '0';
				  idrr_en_var := '0';
				  nop_detect_var := '0';
          end if;

	    when s1 =>

			    --idrr_ir_en_var := '1';
		       --idrr_pc_en_var := '1';
		       nop_detect_var := '1';
		       --sgh69_en_var := '1'; 
				 idrr_en_var := '1';
	  
			 if ((nop_check = '0')) then
             nq_var := s0;
	
          else
             nq_var := s1;
					
			end if;
		when s2 => 
			       nop_detect_var := '1';
		       --sgh69_en_var := '1'; 
				 idrr_en_var := '1';
					
			 if ((check7 = '1')) then
             nq_var := s0;
	
          else
             nq_var := s2;
					
			end if;

       when others => null;

     end case;
	  
	  

  
     -- y(k)

     --idmuxa <= idmuxa_var;
--	  idmuxb <= idmuxb_var;
--	  idrr_ir_en <= idrr_ir_en_var;
--	  idrr_pc_en <= idrr_pc_en_var;
nop_detect <= nop_detect_var;
--	  sgh69_en <= sgh69_en_var;  
		idm11 <= idm11_var;
		idm10 <= idm10_var;
		idrr_en <= idrr_en_var;
	  
     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <= s1;
          else
             fsm_state_symbol <= nq_var;
          end if;
     end if;

  end process;

end Behave;