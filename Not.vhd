library ieee;
use ieee.std_logic_1164.all;

entity notg is
	port ( a: in std_logic; b: out std_logic); 
end entity;

architecture nota of notg is
begin
	b <= not a;
end architecture;
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
	entity andg is
		port ( x,y: in std_logic; z: out std_logic);
	end entity;

architecture abc of andg is
begin
z <= x and y;
end architecture;
	
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
	
	entity xorg is
		port ( a,b: in std_logic; c: out std_logic);
	end entity;
	
architecture abc of xorg is
begin
c <= a xor b;
end architecture;
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

	entity org is
		port ( x,y: in std_logic; z: out std_logic);
	end entity;	

architecture abc of org is
begin
z <= x or y;
end architecture;	

	
	
	