library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inst_mem is
port (
      inst_mem_a : in std_logic_vector(15 downto 0);
		rd_en: in std_logic;
		clk : in std_logic;
		inst_out : out std_logic_vector(15 downto 0));
end entity inst_mem;

architecture desc of inst_mem is
type inst_memarr is array(0 to 40) of std_logic_vector(15 downto 0);
signal ROM : inst_memarr := ("0001000001010000" , X"0000", X"0000",  others => X"0000");  -- r0, r1, r2
signal addr : std_logic_vector(15 downto 0);

begin
addr <= inst_mem_a(15 downto 0);

process(rd_en,clk,addr)
begin
  if rd_en = '1' then
  inst_out <= ROM(to_integer(unsigned(addr)));
  elsif rising_edge(clk) then
   
  end if;
end process;
end architecture;