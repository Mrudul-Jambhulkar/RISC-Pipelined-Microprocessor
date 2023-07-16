LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
  PORT ( input: in std_logic_vector(6 downto 0);
			output: out std_logic_vector(5 downto 0)
        );
END controller;

architecture abcd of controller is
begin
process( input)
	begin
	if input(6 downto 3) = "0001" then
		if input(2 downto 0) = "000" then  --ADA
			output <= "000001";
		elsif  input(2 downto 0) = "010" then  --ADC
			output <= "011001";
		elsif  input(2 downto 0) = "001" then  --ADZ
			output <= "000001";
		elsif  input(2 downto 0) = "011" then  --AWC
			output <= "011001";
		elsif input(2 downto 0) = "100" then  --ACA
			output <= "100001";
		elsif input(2 downto 0) = "110" then  --ACC
			output <= "100001";
		elsif input(2 downto 0) = "101" then  --ACZ
			output <= "100001";
		elsif input(2 downto 0) = "111" then  --ACW
			output <= "111001";
		end if;
	
	 elsif input(6 downto 3) = "0000" then  --ADI
		output <= "000001";
	
	 elsif input(6 downto 3) = "0010" then  
	   if input(2 downto 0) = "000" then  --NDU
			output <= "010001";
		elsif input(2 downto 0) = "010" then  --NDC
			output <= "010001";
		elsif input(2 downto 0) = "001" then  --NDZ
			output <= "010001";
		elsif  input(2 downto 0) = "100" then  --NCU
			output <= "101001";
		elsif input(2 downto 0) = "110" then  --NCC
			output <= "101001";
		elsif input(2 downto 0) = "101" then  --NCZ
			output <= "101001";
		end if;
		
	elsif input(6 downto 3) = "0011" then  --LLI
		output <= "000001";
		
	elsif input(6 downto 3) = "0100" then  --LW
		output <= "000001";
		
	elsif input(6 downto 3) = "0101" then  --SW
		output <= "000010";
		
	elsif input(6 downto 3) = "1000" then  --BEQ
		output <= "001000";
		
	elsif input(6 downto 3) = "1001" then  --BLT
		output <= "110000";
		
	elsif input(6 downto 3) = "1010" then  --BLE
		output <= "110000";
	
	elsif input(6 downto 3) = "1100" then  --JAL
		output <= "000001";
		
	elsif input(6 downto 3) = "1101" then  --JLR
		output <= "000001";
		
	elsif input(6 downto 3) = "1111" then  --JRI
		output <= "000000";
	end if;
end process;
end architecture;



-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ID_State IS
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
END entity ID_State;

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

ARCHITECTURE behav OF ID_State IS

component controller IS
  PORT ( input: in std_logic_vector(6 downto 0);
			output: out std_logic_vector(5 downto 0)
        );
END component;

component IR_ID_RR is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0)
		 );
end component;

component xreg_ID_RR is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end component;

component CONT_REG_ALU_ID_RR is
  port(inp : in std_logic_vector(2 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(2 downto 0));
end component;

component CONT_REG_MEM_ID_RR is
  port(inp : in std_logic_vector(1 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(1 downto 0));
end component;

component CONT_REG_WB_ID_RR is
  port(inp : in std_logic;  
       clk : in std_logic; 
       op  : out std_logic);
end component;


  signal x1: std_logic_vector(15 downto 0);
  signal cnt_sig_in: std_logic_vector(6 downto 0);
  signal cnt_sig_out: std_logic_vector(5 downto 0);
  
  
BEGIN
	x_reg_forwarding_path: xreg_ID_RR port map (X_reg_if_id_input, CLK, X_reg_id_rr_out); 
	controller_instantiation: controller port map (cnt_sig_in, cnt_sig_out);
	instantiaon_with_ALU_control_bits: CONT_REG_ALU_ID_RR port map (cnt_sig_in(5 downto 3), CLK, alu_control_id_rr(2 DOWNTO 0));
	instantiaon_with_wb_control_bits: CONT_REG_WB_ID_RR port map (cnt_sig_in(0), CLK, wb_control_id_rr);
	instantiaon_with_mem_control_bits: CONT_REG_MEM_ID_RR port map (cnt_sig_in(2 downto 1), CLK, mem_control_id_rr);	
	
	
END ARCHITECTURE; -- arch