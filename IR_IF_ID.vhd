library ieee;
use ieee.std_logic_1164.all;

entity IR_IF_ID is
  port(inp : in std_logic_vector(15 downto 0);
       clk : in std_logic;
       op  : out std_logic_vector(15 downto 0));
end entity;

architecture desc of IR_IF_ID is
begin
process(clk)
begin
if rising_edge(clk) then
  op <= inp;
end if;
end process;
end architecture;
