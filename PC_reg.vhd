library ieee;
use ieee.std_logic_1164.all;

entity PC_reg is
  port(inp : in std_logic_vector(15 downto 0);
       PC_wr_en : in std_logic ;
       clk, rst : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end entity PC_reg;

architecture desc of PC_reg is
begin
process(clk,rst,PC_wr_en )
begin
if rst ='1' then
	op <= X"0000";
elsif (rising_edge(clk) and PC_wr_en = '1') then
  op <= inp;
end if;
end process;
end architecture;
