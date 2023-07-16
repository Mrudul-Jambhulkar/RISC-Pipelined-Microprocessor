library ieee;
use ieee.std_logic_1164.all;

entity MEM_OUT_REG_MA_WB is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end entity MEM_OUT_REG_MA_WB;

architecture desc of MEM_OUT_REG_MA_WB is
begin
process(clk)
begin
if rising_edge(clk) then
  op <= inp;
end if;
end process;
end architecture;