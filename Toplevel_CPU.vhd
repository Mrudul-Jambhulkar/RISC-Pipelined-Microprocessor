library ieee;
use ieee.std_logic_1164.all;

entity CPU is
   port ( RST : in std_logic;
			 testing_data_out_cpu : out std_logic_vector(15 downto 0)
			 );

end entity CPU;


architecture behave_like_this of CPU is

component clock_generator is
    port (clk_out : out std_logic);
end component;

component IF_State is
    port(
        CLK, RST: in std_logic;
        PC_WREN: in std_logic;
		  pc_src: in std_logic;
		  pc_for_jmp: in std_logic_vector(15 downto 0);
		  inst_out : out std_logic_vector(15 downto 0);
		  X_out : out std_logic_vector(15 downto 0)
    );
end component;
	 
component ID_State IS
  PORT (
    CLK, RST: IN STD_LOGIC;
    X_reg_if_id_input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst_if_id_input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    X_reg_id_rr_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst_id_rr_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    alu_control_id_rr: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	 mem_control_id_rr: out std_logic_vector(1 downto 0);
	 wb_control_id_rr: out std_logic 
    ); 
	end component;

component RR_Stage IS
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
end component;


component EX_State IS
  PORT (
    CLK, RST: IN STD_LOGIC;
    X_reg_rr_ex_in : in STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst_rr_ex_in : in STD_LOGIC_VECTOR(15 DOWNTO 0);
    alu_control_rr_ex_in : in STD_LOGIC_VECTOR(2 DOWNTO 0);
	 mem_control_rr_ex_in : in std_logic_vector(1 downto 0);
	 wb_control_rr_ex_in : in std_logic;	
	 Data_reg_RR_EX_in_1 : in std_logic_vector(15 downto 0);
	 Data_reg_RR_EX_in_2 : in std_logic_vector(15 downto 0);
	 ----------------------------------------------------------------------------
	 alu_hazard_level_1 : out std_logic_vector(15 downto 0); --level 1 dependency
	 ----------------------------------------------------------------------------	
	 pc_src : out std_logic;
	 pc_new_ex_ma_out: out std_logic_vector(15 downto 0); 
	 alu_out_ex_ma_out : out std_logic_vector(15 downto 0);
	 Data_reg_ex_ma_output_2 : out std_logic_vector(15 downto 0);
    inst_ex_ma_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	 mem_control_ex_ma: out std_logic_vector(1 downto 0);
	 wb_control_ex_ma: out std_logic
    );
END component EX_State;	
	
	
component MA_State is
   port(
	     CLK, RST: IN STD_LOGIC;
        alu_out_ex_ma: in std_logic_vector(15 downto 0);
		  dr2_ex_ma : in std_logic_vector(15 downto 0);
		  wb_control_ex_ma: in std_logic ;
		  mem_control_ex_ma: in std_logic_vector(1 downto 0);
        inst_ex_ma : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		  ------------------------------------------------------------
		  alu_hazard_level_2 : out std_logic_vector(15 downto 0); --level 2 
		  ------------------------------------------------------------	
		  ir_ma_wb_out : out std_logic_vector(15 downto 0);
		  alu_out_ma_wb : out std_logic_vector(15 downto 0);
		  memrd_ma_wb : out std_logic_vector(15 downto 0);
		  wb_control_ma_wb :out std_logic
		  );
end component;	


component WB_State is
    port (
        ir_ma_wb : in std_logic_vector(15 downto 0);
		  alu_out_ma_wb : in std_logic_vector(15 downto 0);
		  memrd_ma_wb : in std_logic_vector(15 downto 0);
		  wb_control_ma_wb :in std_logic;
		  ------------------------------------------------------------
		  alu_hazard_level_3 : out std_logic_vector(15 downto 0); --level 3 
		  ------------------------------------------------------------	
		  data_out: out std_logic_vector(15 downto 0);
		  address_out: out std_logic_vector(2 downto 0); 
		  rf_controller: out std_logic
		  --testing_data_out_wb : out std_logic_vector(15 downto 0)
		  );
end component;	
	 
signal clock_signal: std_logic;
	 
signal signal_IF_ID1 : std_logic_vector(15 downto 0) ;
signal signal_IF_ID21 : std_logic_vector(15 downto 0) ;

signal signal_X_RR_ID : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_INST_RR_ID : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_CONT_alu_ID_RR : std_logic_vector(2 downto 0);
signal signal_CONT_mem_ID_RR : std_logic_vector(1 downto 0);
signal signal_CONT_wb_ID_RR : std_logic;


signal signal_X_RR_EX : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_INST_RR_EX : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_CONT_alu_RR_EX : std_logic_vector(2 downto 0);
signal signal_CONT_mem_RR_EX : std_logic_vector(1 downto 0);
signal signal_CONT_wb_RR_EX : std_logic;
signal signal_WB_RR_connect : std_logic ;
signal signal_data_reg_output1 :  std_logic_vector(15 downto 0);
signal signal_data_reg_output2 :  std_logic_vector(15 downto 0);
signal signal_ADD_RR_WB_a3 :  std_logic_vector(2 downto 0);
signal signal_Data_RR_WB_a3 :  std_logic_vector(15 downto 0);
----------------------------------------------------------------------
signal signal_X_EX_MA : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_INST_EX_MA : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_alu_out_EX_MA : std_logic_vector(15 downto 0);
signal signal_CONT_mem_EX_MA : std_logic_vector(1 downto 0);
signal signal_CONT_wb_EX_MA : std_logic;
signal signal_data_reg_output2_EX_MA :  std_logic_vector(15 downto 0);

--signal signal_X_EX_MA : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_INST_MA_WB : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal signal_alu_out_MA_WB : std_logic_vector(15 downto 0);
signal signal_mem_out_MA_WB : std_logic_vector(15 downto 0);
signal signal_CONT_wb_MA_WB : std_logic;
--signal signal_data_reg_output2_EX_MA :  std_logic_vector(15 downto 0);

signal signal_pc_src : std_logic;
signal signal_pc_for_jmp: std_logic_vector(15 downto 0);

-------------------hazard correction signals----------------------------
signal signal_hazard_enable: std_logic_vector(3 downto 0);
signal signal_input_from_alu_hazard: std_logic_vector(15 downto 0); --level 1
signal signal_input_from_mem_hazard: std_logic_vector(15 downto 0); --level 2
signal signal_input_from_wb_hazard: std_logic_vector(15 downto 0); --level 3

-----------------------------------------------------------------------------



begin 

clock_instantiation : clock_generator port map(clock_signal);  

---------------------------------------------------------INTANTIATION-----------------------------------------------------------------

IF_STAGE_first : IF_State  port map(clock_signal, RST ,'1', signal_pc_src, signal_pc_for_jmp ,signal_IF_ID1 , signal_IF_ID21 ); --we can make PC zero for hazarad but now it always take '1'
-------------------------------------------------------------------------------------------------------------------------------------

ID_STAGE_second : ID_State port map (clock_signal, RST, signal_IF_ID21 ,signal_IF_ID1,  signal_X_RR_ID , signal_INST_RR_ID  , 
												signal_CONT_alu_ID_RR ,  signal_CONT_mem_ID_RR , signal_CONT_wb_ID_RR );
-------------------------------------------------------------------------------------------------------------------------------------
 
 RR_STAGE_third : RR_Stage port map(  
      clock_signal, RST,
      signal_X_RR_ID ,
      signal_INST_RR_ID,
      signal_CONT_alu_ID_RR ,signal_CONT_mem_ID_RR,
      signal_CONT_wb_ID_RR  ,
	   signal_ADD_RR_WB_a3 , 
      signal_Data_RR_WB_a3,
		---------------------------------
		signal_hazard_enable,
		signal_input_from_alu_hazard,
		signal_input_from_mem_hazard,
		signal_input_from_wb_hazard,
		------------------------------------
      signal_X_RR_EX ,
      signal_INST_RR_EX  ,
		signal_CONT_alu_RR_EX  ,
		signal_CONT_mem_RR_EX  ,
	   signal_CONT_wb_RR_EX  ,
	   signal_WB_RR_connect ,
	   signal_data_reg_output1 ,
	   signal_data_reg_output2);
--------------------------------------------------------------------------------------------------------------------------------------
EX_STAGE_fourth : EX_State port map(
    clock_signal, RST,
    signal_X_RR_EX,
    signal_INST_RR_EX,
    signal_CONT_alu_RR_EX,
	 signal_CONT_mem_RR_EX,
	 signal_CONT_wb_RR_EX,
	 signal_data_reg_output1,
	 signal_data_reg_output2,
	------------------------------------------------
	 signal_input_from_alu_hazard,
	------------------------------------------------
	 signal_pc_src, 
	 signal_pc_for_jmp,
	 signal_alu_out_EX_MA,
	 signal_data_reg_output2_EX_MA,
    signal_INST_EX_MA,
	 signal_CONT_mem_EX_MA,
	 signal_CONT_wb_EX_MA
    );
	
--------------------------------------------------------------------------------------------------------------------------------------
MA_STAGE_Fifth: MA_State port map(
        clock_signal, RST,
        signal_alu_out_EX_MA,
		  signal_data_reg_output2_EX_MA,
		  signal_CONT_wb_EX_MA,
		  signal_CONT_mem_EX_MA,
        signal_INST_EX_MA,
		  ------------------------------------------
		  signal_input_from_mem_hazard,
		  ------------------------------------------
		  signal_INST_MA_WB,
		  signal_alu_out_MA_WB,
		  signal_mem_out_MA_WB,
		  signal_CONT_wb_MA_WB
		  );
		  
--------------------------------------------------------------------------------------------------------------------------------------
WB_STAGE_Sixth: WB_State port map(
        signal_INST_MA_WB,
		  signal_alu_out_MA_WB,
		  signal_mem_out_MA_WB,
		  signal_CONT_wb_MA_WB,
		  -------------------------------------------
		  signal_input_from_wb_hazard,
		  -------------------------------------------
		  signal_Data_RR_WB_a3,
		  signal_ADD_RR_WB_a3,
		  signal_WB_RR_connect
		  --testing_data_out_cpu
		  );
--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------hazard correction----------------------------------------------------------------


process(signal_INST_RR_EX, signal_INST_RR_ID, signal_INST_EX_MA) 
	begin
	--forwarding path for level 1 dpendency for r type instructions i.e. I1 and I2 for arithmetic logical instructions 
	if((signal_INST_RR_EX(15 downto 12) = "0001" or signal_INST_RR_EX(15 downto 12) = "0010") and 
		(signal_INST_RR_ID(15 downto 12) = "0001" or signal_INST_RR_ID(15 downto 12) = "0010")
		 ) then
		
		if(signal_INST_RR_EX(5 downto 3) = signal_INST_RR_ID(8 downto 6)) then  --dependency on Rb
			signal_hazard_enable <= "0011";
		
		elsif ( signal_INST_RR_EX(5 downto 3) = signal_INST_RR_ID(11 downto 9)) then --dependency on Rb
			signal_hazard_enable <= "0010";
		end if;
	
	--forwarding path for level 2 dpendency for r type instructions i.e. I1 and I3 for arithmetic logical instructions 
	elsif((signal_INST_EX_MA(15 downto 12) = "0001" or signal_INST_EX_MA(15 downto 12) = "0010") and 
		(signal_INST_RR_ID(15 downto 12) = "0001" or signal_INST_RR_ID(15 downto 12) = "0010")
		 ) then
		
		if(signal_INST_EX_MA(5 downto 3) = signal_INST_RR_ID(8 downto 6)) then  --dependency on Rb
			signal_hazard_enable <= "0101";
		
		elsif ( signal_INST_EX_MA(5 downto 3) = signal_INST_RR_ID(11 downto 9)) then --dependency on Rb
			signal_hazard_enable <= "0100";
		end if;
		
	--forwarding path for level 3 dpendency for r type instructions i.e. I1 and I4 for arithmetic logical instructions 
	elsif((signal_INST_EX_MA(15 downto 12) = "0001" or signal_INST_EX_MA(15 downto 12) = "0010") and 
		(signal_INST_RR_ID(15 downto 12) = "0001" or signal_INST_RR_ID(15 downto 12) = "0010")
		 ) then
		
		if(signal_INST_EX_MA(5 downto 3) = signal_INST_RR_ID(8 downto 6)) then  --dependency on Rb
			signal_hazard_enable <= "0111";
		
		elsif ( signal_INST_EX_MA(5 downto 3) = signal_INST_RR_ID(11 downto 9)) then --dependency on Rb
			signal_hazard_enable <= "0110";
		end if;
	
	end if;
end process;
		

end behave_like_this ;