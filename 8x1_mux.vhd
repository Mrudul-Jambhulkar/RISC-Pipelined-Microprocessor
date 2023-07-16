library ieee;
use ieee.std_logic_1164.all;

entity mux_8x1 is
    port (a : in std_logic_vector(7 downto 0);
          sel : in std_logic_vector(2 downto 0);
          out : out std_logic);
end entity mux_8x1;

architecture behavioral of mux_8x1 is
begin
    out <= a(to_integer(unsigned(sel)));
end architecture behavioral;