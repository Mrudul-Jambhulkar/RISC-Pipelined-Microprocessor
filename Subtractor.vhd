library ieee;
use ieee.std_logic_1164.all;

entity sub16 is 
port( inp1 : in std_logic_vector(15 downto 0);
      inp2 : in std_logic_vector(15 downto 0);
		sum : out std_logic_vector(15 downto 0);
    cout : out std_logic
	 );
end entity sub16;

architecture desc of sub16 is

component Full_Adder  is
  port ( a, b, cin : in std_logic;
			sum, cout: out std_logic);
end component Full_Adder;

Component notg is
  port( a : in std_logic;
        b : out std_logic);
end component notg;		  
		  

signal c , d : std_logic_vector(15 downto 0) ;
signal signal0 , signal1 : std_logic ;


begin

signal0 <= '0';
signal1 <= '1' ;
n1 : notg port map(inp2(0) , d(0));
n2 : notg port map(inp2(1) , d(1));
n3 : notg port map(inp2(2) , d(2));
n4 : notg port map(inp2(3) , d(3));
n5 : notg port map(inp2(4) , d(4));
n6 : notg port map(inp2(5) , d(5));
n7 : notg port map(inp2(6) , d(6));
n8 : notg port map(inp2(7) , d(7));
n9 : notg port map(inp2(8) , d(8));
n10 : notg port map(inp2(9) , d(9));
n11 : notg port map(inp2(10) , d(10));
n12 : notg port map(inp2(11) , d(11));
n13 : notg port map(inp2(12) , d(12));
n14 : notg port map(inp2(13) , d(13));
n15 : notg port map(inp2(14) , d(14));
n16 : notg port map(inp2(15) , d(15));


a1: Full_Adder
port map(inp1(0),d(0),signal0,sum(0),signal1);
a2: Full_Adder
port map(inp1(1),d(1),c(0),sum(1),c(1));
a3: Full_Adder
port map(inp1(2),d(2),c(1),sum(2),c(2));
a4: Full_Adder
port map(inp1(3),d(3),c(2),sum(3),c(3));
a5: Full_Adder
port map(inp1(4),d(4),c(3),sum(4),c(4));
a6: Full_Adder
port map(inp1(5),d(5),c(4),sum(5),c(5));
a7: Full_Adder
port map(inp1(6),d(6),c(5),sum(6),c(6));
a8: Full_Adder
port map(inp1(7),d(7),c(6),sum(7),c(7));
a9: Full_Adder
port map(inp1(8),d(8),c(7),sum(8),c(8));
a10: Full_Adder
port map(inp1(9),d(9),c(8),sum(9),c(9));
a11: Full_Adder
port map(inp1(10),d(10),c(9),sum(10),c(10));
a12: Full_Adder
port map(inp1(11),d(11),c(10),sum(11),c(11));
a13: Full_Adder
port map(inp1(12),d(12),c(11),sum(12),c(12));
a14: Full_Adder
port map(inp1(13),d(13),c(12),sum(13),c(13));
a15: Full_Adder
port map(inp1(14),d(14),c(13),sum(14),c(14));
a16: Full_Adder
port map(inp1(15),d(15),c(14),sum(15),c(15));

cout <= c(15);

end architecture;