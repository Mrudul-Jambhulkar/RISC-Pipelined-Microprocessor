library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MA_State is
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
end entity;

architecture behav of MA_State is

component data_mem is
 port (data_mem_d : in std_logic_vector(15 downto 0);
       data_mem_a : in std_logic_vector(15 downto 0);
		 rd_en: in std_logic;
       wr_en: in std_logic;
		 clk : in std_logic;
		 data_mem_out : out std_logic_vector(15 downto 0));
end component ;

component IR_MA_WB is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;


component CONT_REG_WB_MA_WB is
  port(inp : in std_logic;  
       clk : in std_logic; 
       op  : out std_logic);
end component;

component ALU_OUT_REG_MA_WB is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;

component MEM_OUT_REG_MA_WB is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;


signal mem_out: std_logic_vector(15 downto 0);

begin

mem_send: data_mem port map( dr2_ex_ma, alu_out_ex_ma , mem_control_ex_ma(1), mem_control_ex_ma(0), clk, mem_out );
pp1: IR_MA_WB port map(inst_ex_ma, CLK, ir_ma_wb_out);
pp2: MEM_OUT_REG_MA_WB port map(mem_out, CLK, memrd_ma_wb);
pp3: ALU_OUT_REG_MA_WB port map(alu_out_ex_ma, CLK, alu_out_ma_wb);
pp4: CONT_REG_WB_MA_WB port map(wb_control_ex_ma, CLK, wb_control_ma_wb);

---------------------------------hazard correction------------------------------------
alu_hazard_level_2 <= alu_out_ex_ma;
--------------------------------------------------------------------------------------

end architecture;