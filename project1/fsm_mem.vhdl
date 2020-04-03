library ieee;
use ieee.std_logic_1164.all;

	entity fsm_mem is
		port ( instruction,instruction2: in std_logic_vector(15 downto 0);
	clk,r,nop_check,beq: in std_logic;
	--memwb1,memwb0,memwb_addr_en,memwb_val_en,nop_detect,wr_mem,sw_mem: out std_logic);
	  memwb1,memwb0,memwb_en,nop_detect,wr_mem,mem_access,pc_mem_en: out std_logic);

end entity;

architecture Behave of fsm_mem is

  type StateSymbol  is (S0,S1);
  signal fsm_state_symbol: StateSymbol;
-- constant Z32: std_logic_vector(31 downto 0) := (others => '0');

begin
process(r,clk,fsm_state_symbol,nop_check,beq,instruction,instruction2)
     variable nq_var : StateSymbol;
	 -- variable memwb1_var,memwb0_var,memwb_addr_en_var,memwb_val_en_var,nop_detect_var,wr_mem_var,sw_mem_var: std_logic;
	 variable memwb1_var,memwb0_var,memwb_en_var,nop_detect_var,wr_mem_var,mem_access_var,pc_mem_en_var: std_logic;

  begin
pc_mem_en_var := '1';
nq_var := fsm_state_symbol; 
memwb1_var := '1';
memwb0_var := '0';
--memwb_addr_en_var := '0';
--memwb_val_en_var := '0';
nop_detect_var := '0';
wr_mem_var := '1';
memwb_en_var := '0';
mem_access_var := '0';
--sw_mem_var := '0';

     -- compute next-state, output
     case fsm_state_symbol is
	  	    when s0 =>
	 if (nop_check = '1' or (instruction2(15 downto 12) = "1100" and beq = '0') ) then
						 nq_var := s1;
					 else
						 nq_var := s0;
					end if;	 
				 
			if(instruction(15 downto 12) = "1000" or instruction(15 downto 12) = "1001") then 
				pc_mem_en_var := '0';
			end if;
			if (instruction(15 downto 12) = "0100" or instruction(15 downto 12) = "0110" ) then
					memwb1_var := '0';
					mem_access_var := '1';

			elsif (instruction(15 downto 12) = "0101" or instruction(15 downto 12) = "0111"  ) then
					--memwb_val_en_var := '1';
					wr_mem_var := '0';
					mem_access_var := '1';

					--sw_mem_var := '1';
					
			elsif (instruction(15 downto 12) = "1100" ) then
							pc_mem_en_var := '0';

					--memwb_val_en_var := '0';
					
			elsif (instruction(15 downto 12) = "1000" or instruction(15 downto 12) = "1001" or instruction(15 downto 12) = "1100" ) then
					memwb1_var := '0';
					memwb0_var := '1';
					--mem_access_var := '1';

			 else
					memwb1_var := '1';
					memwb0_var := '0';
					--memwb_addr_en_var := '0';
					--memwb_val_en_var := '0';
					nop_detect_var := '0';
					wr_mem_var := '1';
					mem_access_var := '0';
					--sw_mem_var := '0';
          end if;

	    when s1 =>
					--memwb_addr_en_var := '1';
					--memwb_val_en_var := '1';
					memwb_en_var := '1';
					nop_detect_var := '1';
					wr_mem_var := '1';
					mem_access_var := '0';

--			end if;
	 if (nop_check = '1' or ((instruction2(15 downto 12) = "1100") and (beq = '0')) ) then
             nq_var := s1;
	
          else
             nq_var := s0;
					
			end if;
       when others => null;

     end case;
	  

	  

  
     -- y(k)
pc_mem_en <= pc_mem_en_var;
memwb1 <= memwb1_var;
memwb0 <= memwb0_var;
--memwb_addr_en <= memwb_addr_en_var;
--memwb_val_en <= memwb_val_en_var;
memwb_en <= memwb_en_var;
nop_detect <= nop_detect_var;
wr_mem <= wr_mem_var;
mem_access <= mem_access_var;

--sw_mem <= sw_mem_var;

     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <= s1;
          else
             fsm_state_symbol <= nq_var;
          end if;
     end if;

  end process;

end Behave;