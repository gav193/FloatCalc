library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity section4 is
	port (
		num : IN integer;
		clk : IN std_logic;
		reset : IN std_logic;
		out1 : OUT integer;
		out2 : OUT integer;
		out3 : OUT integer;
		out4 : OUT integer;
		finish : OUT std_logic
	);
end section4;

architecture behavioral of section4 is

	signal tempnum : integer := 0;
	signal tempout1, tempout2, tempout3, tempout4 : integer := 0;
	signal done : std_logic := '0';

begin	
process(clk)

variable count1, count2, count3, count4 : integer := 0;

begin
if clk'EVENT and clk = '1' then
	if reset = '0' then
		tempnum <= num;
		count1 := 0;
		count2 := 0;
		count3 := 0;
		count4 := 0;
		done <= '0';
		finish <= '0';
	else
		if tempnum < 1000 then
			tempout1 <= count1;
			if tempnum < 100 then
				tempout2 <= count2;
				if tempnum < 10 then
					tempout3 <= count3; 
					if tempnum < 1 then
						tempout4 <= count4;
						done <= '1';
						finish <= '1';
					else 
						tempnum <= tempnum - 1;
						count4 := count4 + 1;
					end if;
				else 
					tempnum <= tempnum - 10;
					count3 := count3 + 1;
				end if;
			else 
				tempnum <= tempnum - 100;
				count2 := count2 + 1;
			end if;
		else
			tempnum <= tempnum - 1000;
			count1 := count1 + 1;
		end if;
	end if;
end if;
end process;

process(done)
begin
if done = '1' then
	out1 <= tempout1;
	out2 <= tempout2;
	out3 <= tempout3;
	out4 <= tempout4;
end if;
end process;
end behavioral;