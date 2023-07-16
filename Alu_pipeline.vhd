library ieee;
use ieee.numeric_std;
use ieee.std_logic_1164.all;

entity ALU is
port( alu_a : in std_logic_vector(15 downto 0);
      alu_b : in std_logic_vector(15 downto 0);
		c_in : in std_logic;
		ctrl : in std_logic_vector(2 downto 0);
		alu_out : out std_logic_vector(15 downto 0);
		c_out : out std_logic_vector(15 downto 0);
		z_out : out std_logic_vector(15 downto 0)
		);
end entity ALU;

architecture desc of ALU is

component Add16 is 
port( inp1 : in std_logic_vector(15 downto 0);
      inp2 : in std_logic_vector(15 downto 0);
		sum : out std_logic_vector(15 downto 0);
		cout : out std_logic);
end component Add16;

component xorg16 is
	port ( a: in std_logic_vector(15 downto 0);
          b : in std_logic_vector(15 downto 0);
	c: out std_logic_vector(15 downto 0)); 
end component;

component nandg16 is
	port ( a: in std_logic_vector(15 downto 0);
          b : in std_logic_vector(15 downto 0);
	c: out std_logic_vector(15 downto 0)); 
end component;

component sub16 is 
port( inp1 : in std_logic_vector(15 downto 0);
      inp2 : in std_logic_vector(15 downto 0);
		sum : out std_logic_vector(15 downto 0);
    cout : out std_logic
	 );
end component sub16;

component Not16 is
	port ( a: in std_logic_vector(15 downto 0);
          
	c: out std_logic_vector(15 downto 0) ); 
end component;


signal t: std_logic_vector(15 downto 0);
signal t2: std_logic_vector(15 downto 0);
signal t3: std_logic_vector(15 downto 0);
signal t4: std_logic_vector(15 downto 0);
signal t5: std_logic_vector(15 downto 0);
signal t6: std_logic_vector(15 downto 0);
signal t7: std_logic_vector(15 downto 0);
signal t8: std_logic_vector(15 downto 0);
signal t9: std_logic_vector(15 downto 0);
signal carry : std_logic;

begin
	add1: Add16
	port map(alu_a,alu_b, t,carry);
	xor_16 : xorg16 
	port map(alu_a , alu_b , t2 );
	nand_16 : nandg16
	port map(alu_a , alu_b , t3 );
   Not_16 :Not16
   port map(alu_b , t5 );
   add2: Add16
	port map(alu_a,t5 , t6,carry);	
	nand_162 : nandg16
	port map(alu_a , t5 , t7 );
    
	sub: sub16
	port map(alu_a , alu_b , t8 , carry);
	
	add12: Add16 port map(alu_a,t9, t4,carry);
	
	
	process(alu_a,alu_b,ctrl,t,carry,t2,t3,t4,c_in,t6,t7,t8)
		begin
		
			if ctrl = "000" then
				alu_out <= t;
				c_out(0) <= carry;
				c_out(15 downto 1) <= "000000000000000";
				if( t = "0000000000000000" ) then
					z_out <= "0000000000000001";
				else
					z_out <= "0000000000000000";
				end if;

			elsif ctrl = "001" then
				alu_out <= t2;
				
				if(t2 = "0000000000000000" ) then
					z_out <= "0000000000000001";
				else
					z_out <= "0000000000000000";
				end if;
				
			elsif ctrl = "010" then
			
				alu_out <= t3;
				if(t3 = "0000000000000000") then
					z_out <= "0000000000000001";
				else
					z_out <= "0000000000000000";
				end if;
				
					
					elsif ctrl = "011" then
				if( c_in = '1' ) then
				t9 <= "0000000000000001";
				alu_out <= t4;
				else
				alu_out <= t3 ;
				
			   end if;
				
				if(t3 = "1111111111111111" and c_in = '1') then
					z_out <= "0000000000000001";
				elsif(t3 = "0000000000000000" and c_in = '0') then
				   z_out <= "0000000000000001";
				else
			   z_out <= "0000000000000000";	
				end if;
				
				elsif ctrl = "100" then
				alu_out <= t6;
				c_out(0) <= carry;
				if(t6 = "0000000000000000") then
					z_out <= "0000000000000001";
				else
					z_out <= "0000000000000000";
				end if;
				
				
				elsif ctrl = "101" then
				alu_out <= t7;
				if(t7 = "0000000000000000") then
					z_out <= "0000000000000001";
				else
					z_out <= "0000000000000000";
				end if;
				
				
				elsif ctrl = "110" then
				alu_out <= t8;
				c_out(0) <= carry ;
				if(t8= "0000000000000000") then
					z_out <= "0000000000000001";
				else
					z_out <= "0000000000000000";
				end if;
				
				
			end if;
	end process;
end architecture;