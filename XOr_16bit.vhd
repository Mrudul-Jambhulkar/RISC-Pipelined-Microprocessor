library ieee;
use ieee.std_logic_1164.all;

entity xorg16 is
	port ( a: in std_logic_vector(15 downto 0);
          b : in std_logic_vector(15 downto 0);
	c: out std_logic_vector(15 downto 0)); 
end entity;

architecture nota16 of xorg16 is
begin
	c(0) <= a(0) xor b(0);
	c(1) <= a(1) xor b(1);
	c(2) <= a(2) xor b(2);
	c(3) <= a(3) xor b(3);
	c(4) <= a(4) xor b(4);
	c(5) <= a(5) xor b(5);
	c(6) <= a(6) xor b(6);
	c(7) <= a(7) xor b(7);
	c(8) <= a(8) xor b(8);
	c(9) <= a(9) xor b(9);
	c(10) <= a(10) xor b(10);
	c(11) <= a(11) xor b(11);
	c(12) <= a(12) xor b(12);
	c(13) <= a(13) xor b(13);
	c(14) <= a(14) xor b(14);
	c(15) <= a(15) xor b(15);
end architecture;