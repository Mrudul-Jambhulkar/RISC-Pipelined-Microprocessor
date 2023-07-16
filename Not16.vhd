library ieee;
use ieee.std_logic_1164.all;

entity Not16 is
	port ( a: in std_logic_vector(15 downto 0);
          
	c: out std_logic_vector(15 downto 0) ); 
end entity;

architecture not_not16 of Not16 is
begin
	c(0) <= not(a(0)) ;
	c(1) <= not(a(1));
	c(2) <= not(a(2));
	c(3) <= not(a(3));
	c(4) <= not(a(4));
	c(5) <= not(a(5));
	c(6) <= not(a(6));
	c(7) <= not(a(7));
	c(8) <= not(a(8));
	c(9) <= not(a(9));
	c(10) <= not(a(10));
	c(11) <= not(a(11));
	c(12) <= not(a(12));
	c(13) <= not(a(13)) ;
	c(14) <= not(a(14));
	c(15) <= not(a(15));
end architecture;