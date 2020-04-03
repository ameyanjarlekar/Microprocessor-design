library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity RegisterRead is
  port (clock : in std_logic;
        idm21,idm20,idm3_en,idm42,idm41,idm40,idm5_en,LMSM_en,
        rrex_d3_en,rrex_d2_en,rrex_d1_en,rrex_addr_en,rrex_ir_en: in std_logic;
        idrr_sgh69_out,idrr_ir_out,idrr_pc_out,alu3,alu2,rf_d1,rf_d2: in std_logic_vector(15 downto 0);
        rrex_d3_out,rrex_d2_out,rrex_d1_out,rrex_addr_out,rrex_ir_out: out std_logic_vector(15 downto 0) ;
		  LMSM_out : out std_logic;
		  rf_a1,rf_a2: out std_logic_vector(2 downto 0)) ;
end RegisterRead;

architecture Form of RegisterRead is
    component Mux16_4_1 is
        port( A, B, C, D : in std_logic_vector(15 downto 0);
                S1, S0 : in std_logic;
                y : out std_logic_vector(15 downto 0) );
    end component;
    
    component Mux16_2_1 is
        port( A, B : in std_logic_vector(15 downto 0);
                S0 : in std_logic;
                y : out std_logic_vector(15 downto 0));
    end component;

    component Mux16_8_1 is
        port( A, B, C, D, E, F, G, H : in std_logic_vector(15 downto 0);
                S2, S1, S0 : in std_logic;
                y : out std_logic_vector(15 downto 0) );
    end component;
	 
	 component Mux1_2_1 is
		  port(A,B : in std_logic;
					S0: in std_logic;
					y : out std_logic);
	end component;

    component Register16 is
        port (	Reg_datain: in std_logic_vector(15 downto 0); 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout: out std_logic_vector(15 downto 0));
    end component;

    component Register1def1 is 
	    port (	Reg_datain: in std_logic; 
			clk, Reg_wrbar: in std_logic;
            Reg_dataout: out std_logic);
    end component;
        
    
    signal idm2_out,idm3_out,idm4_out : std_logic_vector(15 downto 0);
    constant Z16 : std_logic_vector(15 downto  0) := (others => '0');
    constant Z13 : std_logic_vector(12 downto  0) := (others => '0');
    signal detect,idm5_out,tLMSM_out : std_logic;

begin 
    idm2: Mux16_4_1 port map(A => rf_d1, B => idrr_pc_out, C => ALU3, D => Z16,
    S1 => idm21, S0 => idm20, y => idm2_out);
    idm3: Mux16_2_1 port map(A => rf_d2, B => idrr_ir_out, S0 => idm3_en, y => idm3_out);
    idm4: Mux16_8_1 port map(A => Z13 & idrr_ir_out(5 downto 3),
                             B => Z13 & idrr_ir_out(8 downto 6),
                             C => Z13 & idrr_ir_out(11 downto 9),
                             D => idrr_pc_out,
                             E => Z16, F => alu2, G => Z16, H => Z16,
                             S2 => idm42, S1 => idm41, S0 => idm40, y => idm4_out);
    rrex_d3: Register16 port map(Reg_datain => idrr_sgh69_out, clk => clock,
    Reg_wrbar => rrex_d3_en, Reg_dataout => rrex_d3_out);
    rrex_d1: Register16 port map(Reg_datain => idm2_out, clk => clock,
    Reg_wrbar => rrex_d1_en, Reg_dataout => rrex_d1_out);
    rrex_d2: Register16 port map(Reg_datain => idm3_out, clk => clock,
    Reg_wrbar => rrex_d2_en, Reg_dataout => rrex_d2_out);
    rrex_addr: Register16 port map(Reg_datain => idm4_out, clk => clock,
    Reg_wrbar => rrex_addr_en, Reg_dataout => rrex_addr_out);
    rrex_ir: Register16 port map(Reg_datain => idrr_ir_out, clk => clock,
    Reg_wrbar => rrex_ir_en, Reg_dataout => rrex_ir_out);
    detect <= not((not idrr_ir_out(15)) and idrr_ir_out(14) and idrr_ir_out(13));
    idm5: Mux1_2_1 port map(A => detect, B => alu2(3), S0 => idm5_en, y => idm5_out);
    LMSM: Register1def1 port map(Reg_datain => idm5_out, clk => clock,
    Reg_wrbar => LMSM_en, Reg_dataout => tLMSM_out);
    LMSM_out <= not(tLMSM_out);
	 rf_a1 <= idrr_ir_out(11 downto 9);
	 rf_a2 <= idrr_ir_out(8 downto 6);
	 
end Form ; -- Form
 