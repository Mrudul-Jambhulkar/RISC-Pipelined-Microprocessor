LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY EX_State IS
  PORT (
    CLK, RST: IN STD_LOGIC;
    X_reg_rr_ex_in : in STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst_rr_ex_in : in STD_LOGIC_VECTOR(15 DOWNTO 0);
    alu_control_rr_ex_in : in STD_LOGIC_VECTOR(2 DOWNTO 0);
	 mem_control_rr_ex_in : in std_logic_vector(1 downto 0);
	 wb_control_rr_ex_in : in std_logic;	
	 Data_reg_RR_EX_in_1 : in std_logic_vector(15 downto 0);
	 Data_reg_RR_EX_in_2 : in std_logic_vector(15 downto 0);
	 ---------------------------------------------------------------------
	 alu_hazard_level_1 : out std_logic_vector(15 downto 0);
	 ---------------------------------------------------------------------
	 pc_src : out std_logic;
	 pc_new_ex_ma_out: out std_logic_vector(15 downto 0); 
	 alu_out_ex_ma_out : out std_logic_vector(15 downto 0);
	 Data_reg_ex_ma_output_2 : out std_logic_vector(15 downto 0);
    inst_ex_ma_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	 mem_control_ex_ma: out std_logic_vector(1 downto 0);
	 wb_control_ex_ma: out std_logic
    );
END entity EX_State;

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

ARCHITECTURE behav OF EX_State IS

component IR_EX_MA is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0)
		 );
end component;

component CONT_REG_MEM_EX_MA is
  port(inp : in std_logic_vector(1 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(1 downto 0));
end component;


component se7 is
port( inp : in std_logic_vector(8 downto 0);
       op : out std_logic_vector(15 downto 0));
end component se7;

component se10 is
port (inp : in std_logic_vector(5 downto 0);
       op : out std_logic_vector(15 downto 0));
end component se10;

component Add16 is 
port( inp1 : in std_logic_vector(15 downto 0);
      inp2 : in std_logic_vector(15 downto 0);
		sum : out std_logic_vector(15 downto 0);
      cout : out std_logic);
end component Add16;

component ALU is
port( alu_a : in std_logic_vector(15 downto 0);
      alu_b : in std_logic_vector(15 downto 0);
		c_in : in std_logic;
		ctrl : in std_logic_vector(2 downto 0);
		alu_out : out std_logic_vector(15 downto 0);
		c_out : out std_logic_vector(15 downto 0);
		z_out : out std_logic_vector(15 downto 0));
end component ALU;

component CONT_REG_WB_EX_MA is
  port(inp : in std_logic;
       clk : in std_logic;
       op  : out std_logic);
end component;

component ALU_OUT_REG_EX_MA is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component ALU_OUT_REG_EX_MA;

component DATA_REG_2_EX_MA is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component DATA_REG_2_EX_MA;

component PC_NEW_EX_MA is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component PC_NEW_EX_MA;



  signal alu_a, alu_b, alu_c, se_10_out, se_7_out, add_16_a, add_16_b, add_16_c: std_logic_vector(15 downto 0);
  --signal alu_control: std_logic_vector(2 downto 0); 
  signal se_10_in: std_logic_vector(5 downto 0);
  signal se_7_in: std_logic_vector(8 downto 0);
  signal alu_carry, alu_zero: std_logic_vector(15 downto 0); 
  signal xyz: std_logic;
  signal alu_out_reg_ex_ma_in, data_reg_ex_ma_2_in,pc_new_in : std_logic_vector(15 downto 0);
  
BEGIN

alu_instantiation :              ALU port map (alu_a, alu_b, alu_carry(0), alu_control_rr_ex_in, alu_c, alu_carry, alu_zero);
sign_extender_instantiation_10 : se10 port map (se_10_in, se_10_out);  
sign_extender_instantiation_7 :  se7 port map (se_7_in, se_7_out);
adder_16_instantiation :         Add16 port map (add_16_a, add_16_b, add_16_c, xyz);
ma_control_instantiation :       CONT_REG_MEM_EX_MA port map (mem_control_rr_ex_in, CLK, mem_control_ex_ma);
wb_control_instantiation :       CONT_REG_WB_EX_MA port map (wb_control_rr_ex_in, CLK, wb_control_ex_ma);
alu_out_ex_ma_instantiation :    ALU_OUT_REG_EX_MA port map (alu_out_reg_ex_ma_in, CLK, alu_out_ex_ma_out);
Data_reg_ex_ma_2_instantiation : DATA_REG_2_EX_MA port map (data_reg_ex_ma_2_in, CLK, Data_reg_ex_ma_output_2);
inst_ex_ma_instantiation :       IR_EX_MA port map (inst_rr_ex_in, CLK, inst_ex_ma_out);
pc_new_ex_ma_instantiation :     PC_NEW_EX_MA port map (add_16_c, CLK,pc_new_ex_ma_out); 

---------------------------------hazard correction------------------------------------
alu_hazard_level_1 <= alu_c;
--------------------------------------------------------------------------------------

process(inst_rr_ex_in, alu_c, Data_reg_RR_EX_in_1, Data_reg_RR_EX_in_2, alu_carry, 
		  se_10_out, se_7_out, x_reg_rr_ex_in, add_16_c, alu_zero)
	begin
	if (inst_rr_ex_in(15 downto 12) = "0001") then
		if (inst_rr_ex_in(2 downto 0) = "000" or inst_rr_ex_in(2 downto 0) = "011" or inst_rr_ex_in(2 downto 0) = "100" or inst_rr_ex_in(2 downto 0) = "111") then  --ADA, AWC, ACA, ACW
			alu_a <= Data_reg_RR_EX_in_1;
			alu_b <= Data_reg_RR_EX_in_2;
			alu_out_reg_ex_ma_in <= alu_c;
			
		elsif (inst_rr_ex_in(2 downto 0) = "010" or inst_rr_ex_in(2 downto 0) = "110") then  --ADC, ACC
			if alu_carry = X"0001" then
				alu_a <= Data_reg_RR_EX_in_1;
				alu_b <= Data_reg_RR_EX_in_2;
				alu_out_reg_ex_ma_in <= alu_c;
			else
				alu_out_reg_ex_ma_in <= Data_reg_RR_EX_in_1;
				data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
			end if;
			
		elsif  (inst_rr_ex_in(2 downto 0) = "001" OR inst_rr_ex_in(2 downto 0) = "101") then  --ADZ, ACZ
			if (alu_zero = X"0001") then
				alu_a <= Data_reg_RR_EX_in_1;
				alu_b <= Data_reg_RR_EX_in_2;
				alu_out_reg_ex_ma_in <= alu_c;
			else
				alu_out_reg_ex_ma_in <= Data_reg_RR_EX_in_1;
				data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
			end if;
		END IF;
	
	 elsif inst_rr_ex_in(6 downto 3) = "0000" then  --ADI
	     se_10_in <= inst_rr_ex_in(5 downto 0);
		  alu_b <= se_10_out;
		  alu_out_reg_ex_ma_in <= alu_c;
	
	 elsif inst_rr_ex_in(6 downto 3) = "0010" then  
	   if (inst_rr_ex_in(2 downto 0) = "000" or inst_rr_ex_in(2 downto 0) = "100" ) then  --NDU, NCU
			alu_a <= Data_reg_RR_EX_in_1;
			alu_b <= Data_reg_RR_EX_in_2;
			alu_out_reg_ex_ma_in <= alu_c;
			
		elsif (inst_rr_ex_in(2 downto 0) = "010" OR inst_rr_ex_in(2 downto 0) = "110") then  --NDC, NCC
			if alu_carry = X"0001" then
				alu_a <= Data_reg_RR_EX_in_1;
				alu_b <= Data_reg_RR_EX_in_2;
				alu_out_reg_ex_ma_in <= alu_c;
			else
				alu_out_reg_ex_ma_in <= Data_reg_RR_EX_in_1;
				data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
			end if;
			
		elsif (inst_rr_ex_in(2 downto 0) = "001" or inst_rr_ex_in(2 downto 0) = "101") then  --NDZ, NCZ
			if (alu_zero = X"0001") then
				alu_a <= Data_reg_RR_EX_in_1;
				alu_b <= Data_reg_RR_EX_in_2;
				alu_out_reg_ex_ma_in <= alu_c;
			else
				alu_out_reg_ex_ma_in <= Data_reg_RR_EX_in_1;
				data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
			end if;
		end if;
		
	elsif inst_rr_ex_in(6 downto 3) = "0011" then  --LLI
		se_7_in <= inst_rr_ex_in(8 downto 0);
		alu_out_reg_ex_ma_in <= se_7_out;
		
	elsif inst_rr_ex_in(6 downto 3) = "0100" then  --LW
		se_10_in <= inst_rr_ex_in(5 downto 0);
		alu_a <= se_10_out;
		alu_b <= Data_reg_RR_EX_in_2;
		alu_out_reg_ex_ma_in <= alu_c;
		
	elsif inst_rr_ex_in(6 downto 3) = "0101" then  --SW
		se_10_in <= inst_rr_ex_in(5 downto 0);
		alu_a <= se_10_out;
		alu_b <= Data_reg_RR_EX_in_2;
		alu_out_reg_ex_ma_in <= alu_c;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_1;
		
	--elsif inst_rr_ex_in(6 downto 3) = "1000" then  --BEQ
		--output := "001000";
		
	--elsif inst_rr_ex_in(6 downto 3) = "1001" then  --BLT
		--output := "110000";
		
	--elsif inst_rr_ex_in(6 downto 3) = "1010" then  --BLE
		--output := "110000";
	
	--elsif inst_rr_ex_in(6 downto 3) = "1100" then  --JAL
		--output := "000001";
		
	--elsif inst_rr_ex_in(6 downto 3) = "1101" then  --JLR
		--output := "000001";
		
	--elsif inst_rr_ex_in(6 downto 3) = "1111" then  --JRI
		--output := "000000";
	
	
	elsif inst_rr_ex_in(6 downto 3) = "1000" then  --BEQ
		alu_a <=Data_reg_RR_EX_in_1;
		alu_b <= Data_reg_RR_EX_in_2;
		alu_out_reg_ex_ma_in  <= alu_c;
		se_10_in <= inst_rr_ex_in(5 downto 0) ;
		add_16_b <= se_10_out;
		add_16_a <= X_reg_rr_ex_in ;
		pc_new_in <= add_16_c ;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
		if (alu_zero = X"0000") then
			pc_src <= '1';
		end if;
	   	
		
	elsif inst_rr_ex_in(6 downto 3) = "1001" then  --BLT
		--output := "110000";
		alu_a <=Data_reg_RR_EX_in_1;
		alu_b <= Data_reg_RR_EX_in_2;
		alu_out_reg_ex_ma_in <= alu_c;
		
		se_10_in <= inst_rr_ex_in(5 downto 0) ;
		add_16_b <= se_10_out;
		add_16_a <= X_reg_rr_ex_in ;
		pc_new_in <= add_16_c ;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
		if (alu_carry = X"0001") then
			pc_src <= '1';
		end if;
		
	elsif inst_rr_ex_in(6 downto 3) = "1010" then  --BLE
		--output := "110000";
		alu_a <=Data_reg_RR_EX_in_1;
		alu_b <= Data_reg_RR_EX_in_2;
		alu_out_reg_ex_ma_in  <= alu_c;		
		se_10_in <= inst_rr_ex_in(5 downto 0) ;
		add_16_b <= se_10_out;
		add_16_a <= X_reg_rr_ex_in ;
		pc_new_in <= add_16_c ;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
		if (alu_carry = X"0001" or alu_zero = X"0000") then
			pc_src <= '1';
		end if;
	
	elsif inst_rr_ex_in(6 downto 3) = "1100" then  --JAL
		--output := "000001";
		alu_a <= X_reg_rr_ex_in;
		add_16_a <= X_reg_rr_ex_in;
	   se_7_in <= inst_rr_ex_in(8 downto 0) ;
		alu_b <= "0000000000000001";
		add_16_b <= se_7_out ;
		pc_new_in <= add_16_c ;
		alu_out_reg_ex_ma_in  <= alu_c;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
		pc_src <= '1';
		
		
	elsif inst_rr_ex_in(6 downto 3) = "1101" then  --JLR
		--output := "000001";
		alu_a <= X_reg_rr_ex_in;
		alu_b <= "0000000000000001";
		alu_out_reg_ex_ma_in  <= alu_c;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
		pc_src <= '1';                  
		
	elsif inst_rr_ex_in(6 downto 3) = "1111" then  --JRI
		--output := "000000";
		add_16_a   <=  Data_reg_RR_EX_in_1;
		se_7_in <= inst_rr_ex_in(8 downto 0) ;
		add_16_b <= se_7_out ;
		pc_new_in <= add_16_c ;
		data_reg_ex_ma_2_in <= Data_reg_RR_EX_in_2;
		pc_src <= '1';
		
	end if;
end process;
	
	
END ARCHITECTURE; -- arch