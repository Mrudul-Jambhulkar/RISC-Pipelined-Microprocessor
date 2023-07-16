library ieee;
use ieee.std_logic_1164.all;

entity alu_beh is
generic(
operand_width : integer:=4);
port (
A: in std_logic_vector(operand_width-1 downto 0);
B: in std_logic_vector(operand_width-1 downto 0);
op: out std_logic_vector(5 downto 0)) ;

end alu_beh;

architecture a1 of alu_beh is





function max1(A: in std_logic_vector(operand_width-1 downto 0);
B: in std_logic_vector(operand_width-1 downto 0))

return std_logic_vector is

variable max : std_logic_vector(5 downto 0);

begin

if (A(0)=B(0)) and
	(A(1)=B(1)) and
	(A(2)=B(2)) and
	(A(3)=B(3)) then
	max := ('0','0','0','0','0','0');
	
elsif A(3) > B(3) then
	max := "00" & A;

elsif A(3) < B(3) then
	max := "00" & B;
	
elsif (A(3) = B(3)) and (A(2) > B(2)) then
	max := "00" & A;
	
elsif (A(3) = B(3)) and (A(2) < B(2)) then
	max := "00" & B;
	
elsif (A(3) = B(3)) and (A(2) = B(2)) and (A(1) > B(1)) then
	max := "00" & A;
	
elsif (A(3) = B(3)) and (A(2) = B(2)) and (A(1) < B(1)) then
	max := "00" & B;
	
elsif (A(3) = B(3)) and (A(2) = B(2)) and (A(1) = B(1)) and (A(0) > B(0)) then
	max := "00" & A;
	
elsif (A(3) = B(3)) and (A(2) = B(2)) and (A(1) = B(1)) and (A(0) < B(0)) then
	max := "00" & B;

	end if;
	return max;
	end max1;







function andy(A: in std_logic_vector(operand_width-1 downto 0);
B: in std_logic_vector(operand_width-1 downto 0))
return std_logic_vector is
 
 variable andy1 : std_logic_vector(3 downto 0);
-- Declare "sum" and "carry" variable
-- you can use aggregate to initialize the variables as shown below
-- variable variable_name : std_logic_vector(3 downto 0) := (others => '0');
begin

L1 : for i in 0 to 3 loop
        andy1(i) := A(i) and B(i) ;
		 end loop L1; 
-- write logic for addition
-- Hint: Use for loop
return "00" & andy1; --according to your logic you can change what you want to return
end andy;







function multi(A: in std_logic_vector(operand_width-1 downto 0))
return std_logic_vector is
	variable mul: std_logic_vector(5 downto 0);
	variable carry: std_logic_vector(4 downto 0);
begin
	L1: for i in 0 to 3 loop
			if i=0 then
			mul(i) := A(i) xor '0';
			carry(i) := A(i) and '0';
			else
			mul(i) := A(i) xor A(i-1) xor carry(i-1);
			carry(i) := (A(i) and A(i-1)) or (carry(i-1) and (A(i) xor A(i-1)));
			end if;
		end loop;
		mul(4) := A(3) xor carry(3);
		mul(5) := A(3) and carry(3);
return mul; 
end multi;






function eq(A: in std_logic_vector(operand_width-1 downto 0);
B: in std_logic_vector(operand_width-1 downto 0))

return std_logic_vector is

variable res : std_logic_vector(5 downto 0);

begin

if (A(0)=B(0)) and
	(A(1)=B(1)) and
	(A(2)=B(2)) and
	(A(3)=B(3)) then
	res := "00" & A;
else res := ('0','0','0','0','0','0');
end if;
return res;
end eq;






begin
alu : process( A, B)

--declare other variables
begin
-- complete VHDL code for various outputs of ALU based on select lines
if A(3) = '0' and B(3) = '0'  then
 op <=  max1(A,B);
elsif A(3) = '0' and B(3) = '1' then 
op <=  andy(A,B);
elsif A(3) = '1' and B(3) = '0' then
op <= multi(A) ;
else
op <=  eq(A,B);
 end if;

-- Hint: use if/else statement
--
-- add function usage :
-- signal_name <= add(A,B)
-- variable_name := add(A,B)
--
-- concatenate operator usage:
-- "0000"&A
end process alu ; -- alu
end a1 ; -- a1