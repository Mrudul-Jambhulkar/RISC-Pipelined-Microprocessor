LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity clock_generator is
  port (
    clk_out : out std_logic
  );
end clock_generator;

architecture behavior of clock_generator is
  constant clk_period : time := 100 ns;
  signal clk_internal : std_logic := '0';
begin
      clk_internal <= not clk_internal after 50 ns ;
      clk_out <= clk_internal;
end behavior;
