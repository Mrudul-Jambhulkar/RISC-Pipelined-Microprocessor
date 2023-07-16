library ieee;
use ieee.std_logic_1164.all;

entity CONT_REG_RF_ID_RR is
  port(inp : in std_logic;
       clk : in std_logic;
       op  : out std_logic);
end entity;

architecture desc of CONT_REG_RF_ID_RR is
begin
process(clk)
begin
if rising_edge(clk) then
  op <= inp;
end if;
end process;
end architecture;
