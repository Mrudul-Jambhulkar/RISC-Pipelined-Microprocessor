library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
port (data_mem_d : in std_logic_vector(15 downto 0);
      data_mem_a : in std_logic_vector(15 downto 0);
		rd_en: in std_logic;
		wr_en: in std_logic;
		clk : in std_logic;
		data_mem_out : out std_logic_vector(15 downto 0));
end entity data_mem;

architecture desc of data_mem is
type data_memarr is array(0 to 40) of std_logic_vector(15 downto 0);
signal RAM : data_memarr := ("0000000000000000" ,  others => X"0000");
signal addr : std_logic_vector(15 downto 0);

begin
addr <= data_mem_a(15 downto 0);

process(rd_en,wr_en,clk,addr)
begin
  if rd_en = '1' then
  data_mem_out <= RAM(to_integer(unsigned(addr)));
  elsif rising_edge(clk) then
    if wr_en ='1' then
	 RAM(to_integer(unsigned(addr))) <= data_mem_d;
	 data_mem_out <= (others => '0');
	 end if;
  end if;
end process;
end architecture;