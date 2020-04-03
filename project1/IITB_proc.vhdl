library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity IITB_proc is
  port (reset,clock : in std_logic;
  output: out std_logic_vector(15 downto 0)) ;
end IITB_proc;

architecture Form of IITB_proc is
	component adder16 is
        port (
              in_a : in std_logic_vector (15 downto 0);
              in_b : in std_logic_vector (15 downto 0);
              sum : out std_logic_vector (16 downto 0));
    end component adder16;

    component Mux3_2_1 is
        port( A, B : in std_logic_vector(2 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(2 downto 0) );
    end component;	 
	 
	 component Mux8_2_1 is 
		port( A, B : in std_logic_vector(7 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(7 downto 0) );
	 end component;
	 
    component Mux16_2_1 is
        port( A, B : in std_logic_vector(15 downto 0);
		S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) );
    end component;
	 
	 component Mux16_4_1 is
        port( A, B, C, D : in std_logic_vector(15 downto 0);
					S1, S0 : in std_logic;
					y : out std_logic_vector(15 downto 0) );
    end component;
	 
	 component Mux16_8_1 is
			port( A, B, C, D, E, F, G, H : in std_logic_vector(15 downto 0);
		S2, S1, S0 : in std_logic;
		y : out std_logic_vector(15 downto 0) );
	 end component;

    component Register16 is
        port (	Reg_datain: in std_logic_vector(15 downto 0); 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout: out std_logic_vector(15 downto 0));
    end component;
	 
	 component Register8 is
		port (	Reg_datain: in std_logic_vector(7 downto 0); 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout: out std_logic_vector(7 downto 0)); 
	 end component;
	 
	 component Register1 is
	port (	Reg_datain: in std_logic; 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout: out std_logic);
    end component;
	 
    component Memory_asyncread_syncwrite is
        port (address,Mem_datain: in std_logic_vector(15 downto 0);
              clk,Mem_wrbar: in std_logic;
              Mem_dataout: out std_logic_vector(15 downto 0));
    end component;
	 
	 component MemCode is 
	 	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
	 end component;
	 
	 component alu is
		port (A,B :in std_logic_vector(15 downto 0) ;
		op,beq : in std_logic;
		C : out std_logic_vector(15 downto 0);
		Z ,Cout: out std_logic);
	 end component;
	 
	 component fsm_if is
		  port (instruction: in std_logic_vector(15 downto 0 );
			 lmsm,beq,clk,r,check7: in std_logic;
			 --pc_mux,pc_en,ifid_ir_en,ifid_pc_en,nop_detect: out std_logic);
			 pc_mux,pc_en,ifid_en,nop_detect: out std_logic);
	 end component;
	 
	 component fsm_id is
			port ( instruction: in std_logic_vector(15 downto 0);
					lmsm,beq,clk,r,nop_check,check7: in std_logic;
					--idmuxa,idmuxb,idrr_ir_en,idrr_pc_en,nop_detect,sgh69_en: out std_logic);
					idm11,idm10,idrr_en,nop_detect: out std_logic);
	 end component;
	 
	 component fsm_rr is
			   port ( instruction,instruction2: in std_logic_vector(15 downto 0);
							beq,clk,r,nop_check,check7: in std_logic;
--idm20,idm21,idm50,idm51,idm3,idm40,idm41,idm42,rrex_d3_en,rrex_d2_en,rrex_d1_en,rrex_addr_en,rrex_ir_en,nop_detect: out std_logic);
							idm20,idm21,idm50,idm3,idm40,idm41,idm42,rrex_en,nop_detect,rrbyte_select: out std_logic);
	 end component;
	 
	 component fsm_ex is
  port ( instruction,instruction2: in std_logic_vector(15 downto 0);
beq,clk,r,nop_check,carry,zero: in std_logic;
ex10,ex11,ex20,ex21,ex30,ex40,ex50,ex60,ex61,ex70,ex71,ex72,exmem_en,nop_detect,carryflag_en,zeroflag_en,beq_op: out std_logic);
	 end component;
    
	 component fsm_mem is
		port ( instruction,instruction2: in std_logic_vector(15 downto 0);
	clk,r,nop_check,beq: in std_logic;
	--memwb1,memwb0,memwb_addr_en,memwb_val_en,nop_detect,wr_mem,sw_mem: out std_logic);
	  memwb1,memwb0,memwb_en,nop_detect,wr_mem,mem_access,pc_mem_en: out std_logic);
	 end component;
	 
	 component fsm_wb is 
			   port ( instruction,instruction2: in std_logic_vector(15 downto 0);
clk,r,nop_check: in std_logic;
rf_wr, wbdone_en: out std_logic);
	 end component;
	 
	 component pri_enc is
			port(in_a: in std_logic_vector(7 downto 0);
		  out_a: out std_logic_vector(7 downto 0));
	 end component;
	 
	 component bin_enc is
	 	port(in_a: in std_logic_vector(7 downto 0);
		  out_a: out std_logic_vector(2 downto 0));
	 end component;
	 
	 component Register_File is 
			port (	address1, address2,	address3: in std_logic_vector(2 downto 0);
			Reg_datain3, r7_datain: in std_logic_vector(15 downto 0); 
			clk, Reg_wrbar: in std_logic;
			Reg_dataout1, Reg_dataout2: out std_logic_vector(15 downto 0));
	 end component;
	 
	 component forwarding_logic is
	 	port (	ifm1_out, rrex_ir, exmem_ir, memwb_ir, wbdone_ir: in std_logic_vector(15 downto 0);
				exmem_addr, memwb_addr, wbdone_addr: in std_logic_vector(2 downto 0);
				fwd_mux1, fwd_mux2: out std_logic_vector(2 downto 0)
				);
	 end component forwarding_logic;

    --signal lmsm_out, beq_out, nop_detect;
    signal alu1_out,pc_out,memc_out,ifm1_out: std_logic_vector(15 downto 0);
    signal ifid_pc_out,ifid_ir_out,ifid_pcn_out: std_logic_vector(15 downto 0);
    signal pc_en,waste1,ifm10,ifid_en,nop_if: std_logic;
	 
	 signal se9,sh7,se6,idm1_out: std_logic_vector(15 downto 0);
	 signal idrr_pc_out, idrr_ir_out,idrr_pcn_out,idrr_sgh69_out: std_logic_vector(15 downto 0);
	 signal idm11,idm10,idrr_en,nop_id: std_logic;
	 
	 signal rrex_ir_out, rrex_pcn_out, rrex_d1_out, rrex_d2_out, rrex_d3_out, rrm3x_out, rrm2x_out ,rrex_addr_out: std_logic_vector(15 downto 0);
    signal rrm2_out, rrm3_out, rrm4_out, rrir53,rrir86,rrir119,rrirbepad: std_logic_vector(15 downto 0);
	 signal rrm5_out, be_out: std_logic_vector(2 downto 0);
	 signal rrm6_out, rrt1_out, rrpe_out, rrt1_in,rrpe2_out,rrt2_in: std_logic_vector(7 downto 0);
	 signal rrex_en,nop_rr,rrm21,rrm20, rrm30,rrm42,rrm41,rrm40,rrm50,rrm60,check7,check6, rrm2x0,rrm3x0: std_logic;
    
	 signal exm1_out, exm2_out, exm3_out, exm4_out, exm5_out, exm6_out, exm7_out, alu2_out, alu3_out: std_logic_vector(15 downto 0);
	 signal exmem_addr1_out, exmem_addr2_out,exmem_val_out,exmem_pcn_out, exmem_ir_out: std_logic_vector(15 downto 0);
	 signal waste2,exm11,exm10,exm21,exm20,exm30,exm40,exm50,exm61,exm60,exm72,exm71,exm70,exmem_en,op, Z_in, C_in,Z_en, C_en,nop_ex,Z_out, C_out,C_fsm,Z_fsm,beq_op: std_logic;
    
	 signal memm1_out, memd_out,mem_acess_mout: std_logic_vector(15 downto 0);
	 signal memwb_ir_out, memwb_pcn_out, memwb_val_out, memwb_addr_out: std_logic_vector(15 downto 0);
	 signal memd_wrbar, memm11, memm10, memwb_en, nop_mem,mem_access: std_logic;
	 
	 constant O1: std_logic_vector(15 downto 0) := (0 => '1',others => '0');
    constant Z16: std_logic_vector(15 downto 0) := (others => '0');
	 constant Z7: std_logic_vector(6 downto 0) := (others => '0');
	 constant Z13: std_logic_vector(12 downto 0) := (others => '0');
	 
	 signal tse9: std_logic_vector(6 downto 0);
	 signal tse6: std_logic_vector(9 downto 0);
	 signal waste3,beq_out,lmsm_out: std_logic;
	 signal tpe1,tidlmsm: std_logic_vector(7 downto 0);
	 
	 signal rf_d2,rf_d1,rf_d3: std_logic_vector(15 downto 0);
	 signal rf_wrbar, wbdone_en: std_logic;

	 signal pc_en_in,pc_mem_en: std_logic;

	 signal fwd_mux1_wire, fwd_mux2_wire: std_logic_vector(2 downto 0);
	 signal rrex_d1_fwd_mux1, rrex_d2_fwd_mux2, wbdone_val_out, wbdone_addr_out, wbdone_ir_out: std_logic_vector(15 downto 0);
	signal t1,t2,t3: std_logic;
begin
	
	rf: Register_file port map(address1 => idrr_ir_out(11 downto 9), address2 => rrm5_out,
	address3 => memwb_addr_out(2 downto 0), Reg_datain3 => memwb_val_out,r7_datain => memwb_pcn_out,
	clk => clock, Reg_wrbar => rf_wrbar, Reg_dataout1 => rf_d1, Reg_dataout2 => rf_d2);
	
	pc_en_in <= pc_en and pc_mem_en;
	ifm1: Mux16_2_1 port map(A => alu1_out, B => exmem_val_out, S0 => ifm10, y => ifm1_out);
   pc: Register16 port map(Reg_datain => ifm1_out, clk => clock, Reg_wrbar => pc_en_in, Reg_dataout => pc_out);
   alu1: adder16 port map(in_a => pc_out, in_b => O1, sum(15 downto 0) => alu1_out, sum(16) => waste1);
   memc: MemCode port map(address => pc_out, Mem_datain => Z16, clk => clock,
	Mem_wrbar => '1', Mem_dataout => memc_out);
   ifid_pc: Register16 port map(Reg_datain => pc_out, clk => clock, Reg_wrbar => ifid_en,
	Reg_dataout => ifid_pc_out);
   ifid_ir: Register16 port map(Reg_datain => memc_out, clk => clock, Reg_wrbar => ifid_en,
	Reg_dataout => ifid_ir_out);
   ifid_pcn: Register16 port map(Reg_datain => alu1_out, clk => clock, Reg_wrbar => ifid_en,
	Reg_dataout => ifid_pcn_out);
   fsm_if_ins: fsm_if port map(instruction => memc_out, lmsm => lmsm_out, beq => beq_out, clk => clock,
	r => reset, pc_mux => ifm10, pc_en => pc_en, ifid_en => ifid_en, nop_detect => nop_if,check7 => check6);
	
	tse9 <= (others => ifid_ir_out(8));
	tse6 <= (others => ifid_ir_out(5));
	se9 <= tse9 & ifid_ir_out(8 downto 0);
	sh7 <= ifid_ir_out(8 downto 0) & Z7;
	se6 <= tse6 & ifid_ir_out(5 downto 0);
	idm1: Mux16_4_1 port map(A => se9, B => sh7,
	C => se6, D => Z16, S1 => idm11, S0 => idm10, y => idm1_out);
	idrr_sgh69: Register16 port map(Reg_datain => idm1_out, clk => clock, Reg_wrbar => idrr_en,
	Reg_dataout => idrr_sgh69_out);
	idrr_pc: Register16 port map(Reg_datain => ifid_pc_out, clk => clock, Reg_wrbar => idrr_en,
	Reg_dataout => idrr_pc_out);
	idrr_ir: Register16 port map(Reg_datain => ifid_ir_out, clk => clock, Reg_wrbar => idrr_en,
	Reg_dataout => idrr_ir_out);
	idrr_pcn: Register16 port map(Reg_datain => ifid_pcn_out, clk => clock, Reg_wrbar => idrr_en,
	Reg_dataout => idrr_pcn_out);
	fsm_id_ins:fsm_id port map(instruction => ifid_ir_out, lmsm => lmsm_out, beq => beq_out, clk => clock,
	r => reset, nop_check => nop_if, idm11 => idm11, idm10 => idm10, idrr_en => idrr_en, nop_detect => nop_id,check7 => check6);
	pe1: pri_enc port map(in_a => ifid_ir_out(7 downto 0), out_a => tpe1);
	tidlmsm <= ifid_ir_out(7 downto 0) and not tpe1;
	lmsm_out <= '0' when (ifid_ir_out(15 downto 13) = "011" and tidlmsm = "00000000") else '1' when (ifid_ir_out(15 downto 13) = "011" and (idrr_en = '0')) else '0';
	
	rrex_ir: Register16 port map(Reg_datain => idrr_ir_out, clk => clock, Reg_wrbar => rrex_en,
	Reg_dataout => rrex_ir_out);
	rrex_pcn: Register16 port map(Reg_datain => idrr_pcn_out, clk => clock, Reg_wrbar => rrex_en,
	Reg_dataout => rrex_pcn_out);
	rrm2: Mux16_4_1 port map(A => rrm2x_out, B => idrr_pc_out, C => alu3_out, D => Z16,
	S1 => rrm21, S0 => rrm20, y => rrm2_out);
	rrm2x0 <= rrir119(2) and rrir119(1) and rrir119(0);
	rrm3x0 <= rrm5_out(2) and rrm5_out(1) and rrm5_out(0);
	rrm2x: Mux16_2_1 port map(A => rf_d1, B => idrr_pc_out, S0=> rrm2x0, y => rrm2x_out);
	rrm3x: Mux16_2_1 port map(A => rf_d2, B => idrr_pc_out, S0=> rrm3x0, y => rrm3x_out);
	rrex_d1: Register16 port map(Reg_datain => rrm2_out, clk => clock, Reg_wrbar => rrex_en, 
	Reg_dataout => rrex_d1_fwd_mux1);
	rrm3: Mux16_2_1 port map(A => rrm3x_out, B => rrir119, S0 => rrm30, y=> rrm3_out);
	rrex_d2: Register16 port map(Reg_datain => rrm3_out, clk => clock, Reg_wrbar => rrex_en,
	Reg_dataout => rrex_d2_fwd_mux2);
	rrir53 <= Z13 & idrr_ir_out(5 downto 3);
	rrir86 <= Z13 & idrr_ir_out(8 downto 6);
	rrir119 <= Z13 & idrr_ir_out(11 downto 9);
	rrirbepad <= Z13 & be_out;
	rrm4: Mux16_8_1 port map(A => rrir53, B => rrir86,
	C => rrir119, D => idrr_pc_out, E => rrirbepad, F => rrirbepad,
	G => Z16, H => Z16, S2 => rrm42, S1 => rrm41, S0 => rrm40, y => rrm4_out);
	rrex_d3: Register16 port map(Reg_datain => idrr_sgh69_out, clk => clock, Reg_wrbar => rrex_en,
	Reg_dataout => rrex_d3_out);
	rrex_addr: Register16 port map(Reg_datain => rrm4_out, clk => clock, Reg_wrbar => rrex_en,
	Reg_dataout => rrex_addr_out);
	rrm5: Mux3_2_1 port map( A => be_out, B => idrr_ir_out(8 downto 6), S0 =>  rrm50, y => rrm5_out);
	rrm6: Mux8_2_1 port map(A => idrr_ir_out(7 downto 0), B => rrt1_out, S0 => rrm60, y =>  rrm6_out);
	rrt1: Register8 port map(Reg_datain => rrt1_in, clk => clock, Reg_wrbar => '0', Reg_dataout => rrt1_out);
	rrpe: pri_enc port map(in_a => rrm6_out, out_a => rrpe_out);
	rrpe2: pri_enc port map(in_a => rrt1_in,out_a => rrpe2_out);
	rrbe: bin_enc port map(in_a => rrpe_out, out_a => be_out);
	rrt1_in <= rrm6_out and not rrpe_out;
	rrt2_in <= rrt1_in and not rrpe2_out;
	t1 <= '0' when (rrt1_in = "00000000") else '1';
	t2 <= '1' when idrr_ir_out(15 downto 13) = "011" else '0' ;
	t3 <= rrex_en;
	check7 <= '0' when (t1  = '1' ) and (t2 = '1') else '1';
	check6 <= '0' when ((not (rrt2_in = "00000000")) and (idrr_ir_out(15 downto 13) = "011" and rrex_en = '0') ) else '1';
	fsm_rr_ins: fsm_rr port map(instruction => idrr_ir_out,instruction2 => ifid_ir_out, beq => beq_out,clk => clock, r => reset, 
	nop_check => nop_id,check7 => check7, idm20 => rrm20,idm21 => rrm21, idm50 => rrm50, idm3 => rrm30,
	idm40 => rrm40, idm41 => rrm41, idm42 => rrm42, rrex_en => rrex_en, nop_detect => nop_rr,
	rrbyte_select => rrm60);
	
	
	waste3 <= '1' when (rrex_ir_out(15 downto 12) = "1100") else '0';
	exm1: Mux16_4_1 port map(A => rrex_addr_out, B => rrex_d2_out, C => rrex_d1_out, D => Z16,
	S1 => exm11, S0 => exm10, y => exm1_out);
	exm2: Mux16_4_1 port map(A => O1, B => rrex_d3_out, C => rrex_d2_out, D => Z16,
	S1 => exm21, S0 => exm20, y => exm2_out);
	exm3: Mux16_2_1 port map(A => rrex_d1_out, B => rrex_addr_out, S0 => exm30, y => exm3_out);
	exm4: Mux16_2_1 port map(A => rrex_d3_out, B => O1, S0 => exm40, y => exm4_out);
	op <= '1' when (rrex_ir_out(15 downto 12) = "0010") else '0';	
	alu2: alu port map(A => exm1_out, B => exm2_out, op => op, beq=> beq_op, C => alu2_out, Z => Z_in, Cout =>  C_in);
	beq_out <= ((Z_in and waste3) or (rrex_ir_out(15) and not(rrex_ir_out(14)))) and (not exmem_en);
	Zflag: Register1 port map(Reg_datain => Z_in, clk => clock, Reg_wrbar => Z_en, Reg_dataout => Z_out);
	Cflag: Register1 port map(Reg_datain => C_in, clk => clock, Reg_wrbar => C_en, Reg_dataout => C_out);
	alu3: adder16 port map(in_a => exm3_out, in_b => exm4_out, sum(15 downto 0) => alu3_out, sum(16) => waste2);
	exm5: Mux16_2_1 port map(A => rrex_d2_out, B => rrex_addr_out, S0 => exm50, y => exm5_out);
	exm6: Mux16_4_1 port map(A => rrex_d1_out, B => alu2_out, C => rrex_addr_out, D => Z16, S1 => exm61,
	S0 => exm60, y => exm6_out);
	exm7: Mux16_8_1 port map(A => rrex_d1_out, B => alu2_out, C => rrex_d2_out, D => rrex_d3_out,
	E => alu3_out, F => Z16, G => Z16, H => Z16, S2 => exm72, S1 => exm71, S0 => exm70, y => exm7_out);
	exmem_ir: Register16 port map(Reg_datain => rrex_ir_out, clk => clock, Reg_wrbar => exmem_en,
	Reg_dataout => exmem_ir_out);
	exmem_pcn: Register16 port map(Reg_datain => rrex_pcn_out, clk => clock, Reg_wrbar => exmem_en,
	Reg_dataout => exmem_pcn_out);
	exmem_addr1: Register16 port map(Reg_datain => exm5_out, clk => clock,  Reg_wrbar => exmem_en,
	Reg_dataout => exmem_addr1_out);
	exmem_addr2: Register16 port map(Reg_datain => exm6_out, clk => clock, Reg_wrbar => exmem_en,
	Reg_dataout => exmem_addr2_out);
	exmem_val: Register16 port map(Reg_datain => exm7_out, clk => clock, Reg_wrbar => exmem_en,
	Reg_dataout => exmem_val_out);
	C_fsm <= (C_out and C_en) or (C_in and (not C_en));
	Z_fsm <= (Z_out and Z_en) or (Z_in and (not Z_en))  ;
	fsm_ex_ins: fsm_ex port map(instruction => rrex_ir_out,instruction2 => idrr_ir_out, beq => beq_out, clk => clock,
	r => reset, nop_check => nop_rr,carry => C_fsm, zero => Z_fsm, ex10 =>exm10, ex11 =>exm11, ex20 => exm20,
	ex21 => exm21, ex30 => exm30, ex40 => exm40,  ex50 => exm50, ex60 => exm60, ex61 => exm61, ex70 => exm70,
	ex71 => exm71, ex72 => exm72, exmem_en => exmem_en, nop_detect => nop_ex, carryflag_en => C_en, zeroflag_en => Z_en,beq_op => beq_op);
	
	memwb_addr: Register16 port map(Reg_datain => exmem_addr1_out, clk => clock, Reg_wrbar => memwb_en,
	Reg_dataout => memwb_addr_out);
	memwb_ir: Register16 port map(Reg_datain => exmem_ir_out, clk => clock, Reg_wrbar => memwb_en,
	Reg_dataout => memwb_ir_out);
	memwb_pcn: Register16 port map(Reg_datain => exmem_pcn_out, clk => clock, Reg_wrbar => memwb_en,
	Reg_dataout => memwb_pcn_out);
	memd: Memory_asyncread_syncwrite port map(address => mem_acess_mout, Mem_datain => exmem_val_out,
	clk => clock, Mem_wrbar => memd_wrbar, Mem_dataout => memd_out);
	memm1: Mux16_4_1 port map(A => memd_out, B => exmem_addr2_out, C => exmem_val_out, D => Z16,
	S1 => memm11, S0 => memm10, y => memm1_out);
	mem_acess_m: Mux16_2_1 port map(A => Z16, B => exmem_addr2_out, S0 => mem_access, y => mem_acess_mout);
	memwb_val: Register16 port map(Reg_datain => memm1_out, clk => clock, Reg_wrbar => memwb_en,
	Reg_dataout => memwb_val_out);
	fsm_mem_ins: fsm_mem port map(instruction => exmem_ir_out, clk => clock, r => reset,																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																		
	nop_check => nop_ex, beq => beq_out, memwb1 => memm11, memwb0 => memm10,
	memwb_en => memwb_en,nop_detect => nop_mem,wr_mem => memd_wrbar,mem_access => mem_access,pc_mem_en =>  pc_mem_en,instruction2 => rrex_ir_out);
	
	fsm_wb_ins: fsm_wb port map(instruction => memwb_ir_out, clk => clock, r => reset, nop_check =>  nop_mem,
	rf_wr => rf_wrbar, wbdone_en => wbdone_en,instruction2 => exmem_ir_out);
	
	output <= memwb_val_out;																																																																																																																										
	
	wbdone_ir: Register16 port map (
		Reg_datain => memwb_ir_out,
		Reg_dataout => wbdone_ir_out,
		clk => clock,
		Reg_wrbar => wbdone_en
	);

	wbdone_val: Register16 port map (
		Reg_datain => memwb_val_out,
		Reg_dataout => wbdone_val_out,
		clk => clock,
		Reg_wrbar => wbdone_en
	);

	wbdone_addr: Register16 port map (
		Reg_datain => memwb_addr_out,
		Reg_dataout => wbdone_addr_out,
		clk => clock,
		Reg_wrbar => wbdone_en
	);

	forwarding_block: forwarding_logic port map (
		rrex_ir =>	rrex_ir_out,
		exmem_ir =>	exmem_ir_out,
		memwb_ir =>	memwb_ir_out,
		wbdone_ir =>	wbdone_ir_out,
		ifm1_out => ifm1_out,
		exmem_addr =>	exmem_addr1_out(2 downto 0),
		memwb_addr =>	memwb_addr_out(2 downto 0),
		wbdone_addr =>	wbdone_addr_out(2 downto 0),
		fwd_mux1 =>	fwd_mux1_wire,
		fwd_mux2 =>	fwd_mux2_wire
	); 

	fwd_mux1_block: Mux16_8_1 port map (
		A =>	rrex_d1_fwd_mux1,
		B =>	exmem_val_out,
		C =>	memwb_val_out,
		D =>	wbdone_val_out,
		E =>	memm1_out,
		F =>	Z16,
		G =>	Z16,
		H =>	Z16,
		S2 =>	fwd_mux1_wire(2),
		S1 =>	fwd_mux1_wire(1),
		S0 =>	fwd_mux1_wire(0),
		y =>	rrex_d1_out
	);

	fwd_mux2_block: Mux16_8_1 port map (
		A =>	rrex_d2_fwd_mux2,
		B =>	exmem_val_out,
		C =>	memwb_val_out,
		D =>	wbdone_val_out,
		E =>	memm1_out,
		F =>	Z16,
		G =>	Z16,
		H =>	Z16,
		S2 =>	fwd_mux2_wire(2),
		S1 =>	fwd_mux2_wire(1),
		S0 =>	fwd_mux2_wire(0),
		y =>	rrex_d2_out
	);

end Form;