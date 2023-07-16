LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RR_Stage IS
	PORT (
		CLK, RST: IN STD_LOGIC;
      X_reg_id_rr_input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	   inst_id_rr_input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      alu_control_id_rr_input : in STD_LOGIC_VECTOR(2 DOWNTO 0);
      mem_control_id_rr_input: in std_logic_vector(1 downto 0);
      wb_control_id_rr_input: in std_logic ;
	   ADD_from_WB_a3 : in std_logic_vector(2 downto 0);
   	data_from_WB_d3 : in std_logic_vector(15 downto 0);
		---------------------------------------------------------------------
		hazard_enable: in std_logic_vector(3 downto 0);
		input_from_alu_hazard_level1: in std_logic_vector(15 downto 0); --level 1 
		input_from_alu_hazard_level2: in std_logic_vector(15 downto 0); --level 2
		input_from_alu_hazard_level3: in std_logic_vector(15 downto 0); --level 3
      ---------------------------------------------------------------------
		X_reg_rr_ex_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      inst_rr_ex_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      alu_control_rr_ex_output : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	   mem_control_rr_ex_output : out std_logic_vector(1 downto 0);
	   wb_control_rr_ex_output : out std_logic;	
	   WB_input_from_WB_stage : in std_logic;	 
	   Data_reg_RR_EX_output_1 : out std_logic_vector(15 downto 0);
	   Data_reg_RR_EX_output_2 : out std_logic_vector(15 downto 0)
	   );
END RR_Stage;

ARCHITECTURE behav OF RR_Stage IS


component rf is
port( a1_out_out : in std_logic_vector(2 downto 0);
      a2_out_out : in std_logic_vector(2 downto 0);
		a3_in : in std_logic_vector(2 downto 0);
		d3_in : in std_logic_vector(15 downto 0);
		clk : in std_logic;
		wr_en: in std_logic;
		
		d1_out_out : out std_logic_vector(15 downto 0);
		d2_out_out : out std_logic_vector(15 downto 0)
		);
end component rf;

component CONT_REG_ALU_RR_EX is
  port(inp : in std_logic_vector(2 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(2 downto 0));
end component;

component CONT_REG_MEM_RR_EX is
  port(inp : in std_logic_vector(1 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(1 downto 0));
end component;

component CONT_REG_WB_RR_EX is
  port(inp : in std_logic;
       clk : in std_logic;
       op  : out std_logic);
end component;

component xreg_RR_EX is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;

component IR_RR_EX is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;


component DATA_REG_1_RR_EX is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component DATA_REG_1_RR_EX;


component DATA_REG_2_RR_EX is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component DATA_REG_2_RR_EX;


signal signal_data1_out : std_logic_vector(15 downto 0);
signal signal_data2_out : std_logic_vector(15 downto 0);
signal t1 : std_logic_vector(15 downto 0);
signal t2 : std_logic_vector(15 downto 0);


begin


register_file_instatntiation : rf port map (inst_id_rr_input(11 downto 9 ) , inst_id_rr_input(8 downto 6) , ADD_from_WB_a3 
                                  ,data_from_WB_d3 , CLK , WB_input_from_WB_stage , signal_data1_out , signal_data2_out   );
	
DATA_REG_1 :	DATA_REG_1_RR_EX port map ( t1 , CLK , Data_reg_RR_EX_output_1 );
DATA_REG_2 :   DATA_REG_2_RR_EX port map ( t2 , CLK , Data_reg_RR_EX_output_2 );										 
											 
control_reg_RR_EX_alu : CONT_REG_ALU_RR_EX port map (alu_control_id_rr_input , CLK , alu_control_rr_ex_output );
control_reg_RR_EX_mem : CONT_REG_MEM_RR_EX port map ( mem_control_id_rr_input , CLK , mem_control_rr_ex_output );
control_reg_RR_EX_wb : CONT_REG_WB_RR_EX port map (wb_control_id_rr_input , CLK , wb_control_rr_ex_output );

X_REG_RR_EX : xreg_RR_EX port map (X_reg_id_rr_input , CLK , X_reg_rr_ex_out );
INST_REG_RR_EX : IR_RR_EX port map ( inst_id_rr_input , CLK , inst_rr_ex_out) ;


process(hazard_enable)
	begin
	if(hazard_enable = "0000") then --no hazard or no dependency
		t1 <= signal_data1_out;
		t2 <= signal_data2_out;
		
	elsif(hazard_enable = "0010") then  --level 1 dependecy on Ra 
		t1 <= input_from_alu_hazard_level1;
		t2 <= signal_data2_out;
	
	elsif(hazard_enable = "0011") then  --level 1 dependecy on Rb 
		t1 <= signal_data1_out;
		t2 <= input_from_alu_hazard_level1;
	
	elsif(hazard_enable = "0100") then  --level 2 dependecy on Ra 
		t1 <= input_from_alu_hazard_level2;
		t2 <= signal_data2_out;
	
	elsif(hazard_enable = "0101") then  --level 2 dependecy on Rb 
		t1 <= signal_data1_out;
		t2 <= input_from_alu_hazard_level2;
		
	elsif(hazard_enable = "0110") then  --level 3 dependecy on Ra 
		t1 <= input_from_alu_hazard_level3;
		t2 <= signal_data2_out;
	
	elsif(hazard_enable = "0111") then  --level 3 dependecy on Rb 
		t1 <= signal_data1_out;
		t2 <= input_from_alu_hazard_level3;
	
	end if;
end process;								 

END ARCHITECTURE; 