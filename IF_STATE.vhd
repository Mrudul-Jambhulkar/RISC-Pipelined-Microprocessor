library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_State is
    port(
        CLK, RST: in std_logic;
        PC_WREN: in std_logic;
		  pc_src: in std_logic;
		  pc_for_jmp: in std_logic_vector(15 downto 0);
		  
		  inst_out : out std_logic_vector(15 downto 0);
		  X_out : out std_logic_vector(15 downto 0)
    );
end entity;
-----------------------------------------------------------------
-----------------------------------------------------------------

architecture behav of IF_State is

component xreg_IF_ID is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;

component IR_IF_ID is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;

component inst_mem is
port ( inst_mem_a : in std_logic_vector(15 downto 0);
		 rd_en: in std_logic;
		 clk : in std_logic;
		 inst_out : out std_logic_vector(15 downto 0));
end component inst_mem;

component PC_reg is
  port(inp : in std_logic_vector(15 downto 0);
       PC_wr_en : in std_logic ;
       clk,rst : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component PC_reg;

component Add16 is 
port( inp1 : in std_logic_vector(15 downto 0);
      inp2 : in std_logic_vector(15 downto 0);
		sum : out std_logic_vector(15 downto 0);
      cout : out std_logic);
end component Add16;

    signal add_out, pc_out, inst_mem_out: std_logic_vector(15 downto 0);
	 signal pc_in : std_logic_vector(15 downto 0);
	 signal xyz  : std_logic;
begin

------------------------------INSTANTIATION-------------------------------------------

    inst_fetch : inst_mem port map(pc_out,  '1'  , CLK  ,inst_mem_out );
	 pc_update : Add16 port map ( PC_out , "0000000000000001" , add_out, xyz );
	 PC_instantiation : PC_reg port map(pc_in , PC_WREN, CLK, RST, PC_out);
	 inst_to_pipeline : IR_IF_ID port map (inst_mem_out , CLK , inst_out);
	 Xreg_update : xreg_IF_ID port map (PC_out , CLK ,X_out );
	 
process(pc_src, pc_for_jmp, add_out)
begin
	if pc_src = '0' then
		pc_in <= add_out;
	elsif pc_src = '1' then
		pc_in <= pc_for_jmp;
	end if;
end process;
    
end;