library ieee;
use ieee.std_logic_1164.all;

entity nandg16 is
	port ( a: in std_logic_vector(15 downto 0);
          b : in std_logic_vector(15 downto 0);
	c: out std_logic_vector(15 downto 0)); 
end entity;

architecture nota16 of nandg16 is
begin
	c(0) <= a(0) nand b(0);
	c(1) <= a(1) nand b(1);
	c(2) <= a(2) nand b(2);
	c(3) <= a(3) nand b(3);
	c(4) <= a(4) nand b(4);
	c(5) <= a(5) nand b(5);
	c(6) <= a(6) nand b(6);
	c(7) <= a(7) nand b(7);
	c(8) <= a(8) nand b(8);
	c(9) <= a(9) nand b(9);
	c(10) <= a(10) nand b(10);
	c(11) <= a(11) nand b(11);
	c(12) <= a(12) nand b(12);
	c(13) <= a(13) nand b(13);
	c(14) <= a(14) nand b(14);
	c(15) <= a(15) nand b(15);
end architecture;