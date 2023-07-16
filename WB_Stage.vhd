library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WB_State is
	port(
		ir_ma_wb : in std_logic_vector(15 downto 0);
		alu_out_ma_wb : in std_logic_vector(15 downto 0);
		memrd_ma_wb : in std_logic_vector(15 downto 0);
		wb_control_ma_wb :in std_logic;
		------------------------------------------------------------
		alu_hazard_level_3 : out std_logic_vector(15 downto 0); --level 3 
		------------------------------------------------------------	
		data_out: out std_logic_vector(15 downto 0);
		address_out: out std_logic_vector(2 downto 0);  -- 5 downto 3 
		rf_controller: out std_logic
		--testing_data_out_wb : out std_logic_vector(15 downto 0)
		);
end entity;

architecture behav of WB_State is

signal mem_out: std_logic_vector(15 downto 0);

begin

alu_hazard_level_3 <= alu_out_ma_wb;
rf_controller <= wb_control_ma_wb;

process(ir_ma_wb, alu_out_ma_wb)
	begin
	if (ir_ma_wb(15 downto 12) = "0001" or ir_ma_wb(15 downto 12) = "0010" or ir_ma_wb(15 downto 12) = "0000") then
		address_out <= ir_ma_wb(5 downto 3); 
		data_out <= alu_out_ma_wb;
		
	elsif (ir_ma_wb(15 downto 12) = "0011") then --LLI
		address_out <= ir_ma_wb(11 downto 9); 
		data_out <= alu_out_ma_wb;
		
	elsif (ir_ma_wb(15 downto 12) = "0100") then --LW
		address_out <= ir_ma_wb(11 downto 9); 
		data_out <= memrd_ma_wb;
		
	elsif (ir_ma_wb(15 downto 12) = "0110") then --SW
		--NO WB STAGE
		
	elsif (ir_ma_wb(15 downto 12) = "100") then --BEQ
		--NO WB STAGE
		
	elsif (ir_ma_wb(15 downto 12) = "1001") then --BLT
		--NO WB STAGE
		
	elsif (ir_ma_wb(15 downto 12) = "1010") then --BLE
		--NO WB STAGE
	
	elsif (ir_ma_wb(15 downto 12) = "1100") then --JAL
		address_out <= ir_ma_wb(11 downto 9); 
		data_out <= alu_out_ma_wb;
		
	elsif (ir_ma_wb(15 downto 12) = "1101") then --JLR
		address_out <= ir_ma_wb(11 downto 9); 
		data_out <= alu_out_ma_wb;
		
	elsif (ir_ma_wb(15 downto 12) = "1111") then --JRI
		--NO WB STAGE
		
	end if;
end process;

end architecture;