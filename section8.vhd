library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity section8 is
 port ( 
   num : IN integer;
   start : IN std_logic;
   clk : IN std_logic;
   reset : IN std_logic;
   out1 : OUT integer;
   out2 : OUT integer;
   out3 : OUT integer;
   out4 : OUT integer;
   out5 : OUT integer;
   out6 : OUT integer;
   out7 : OUT integer;
   out8 : OUT integer;
   finish : OUT std_logic
 );
end section8;

architecture behavioral of section8 is
 
 signal tempnum : integer := 0;
 signal tempout1, tempout2, tempout3, tempout4, tempout5 ,tempout6, tempout7, tempout8 : integer := 0;
 signal done : std_logic := '0';

begin

process(clk)

variable count1, count2, count3, count4, count5, count6, count7, count8 : integer := 0;
variable once : integer := 0;

begin
if clk'EVENT and clk = '1' then
	if start = '1' then 
		if once = 0 then	
			tempnum <= num;
			once := once + 1;
		else
			if reset = '0' then
			   count1 := 0;
			   count2 := 0;
			   count3 := 0;
			   count4 := 0;
			   count5 := 0;
			   count6 := 0;
			   count7 := 0;
			   count8 := 0;
			   done <= '0';
			else
			   if tempnum < 10000000 then
				tempout1 <= count1;
				if tempnum < 1000000 then
					tempout2 <= count2;
					if tempnum < 100000 then
						tempout3 <= count3;
						if tempnum < 10000 then
							tempout4 <= count4;
							if tempnum < 1000 then
								tempout5 <= count5;
								if tempnum < 100 then
									tempout6 <= count6;
									if tempnum < 10 then
										tempout7 <= count7;
										if tempnum < 1 then
										   tempout8 <= count8;
										   done <= '1';
										   finish <= '1';
										else
											tempnum <= tempnum - 1;
											count8 := count8 + 1;
										end if;
									else
										tempnum <= tempnum - 10;
										count7 := count7 + 1;
									end if;
								else
									tempnum <= tempnum - 100;
									count6 := count6 + 1;
								end if;
							else
								tempnum <= tempnum - 1000;
								count5 := count5 + 1;
							end if;
						else
							tempnum <= tempnum - 10000;
							count4 := count4 + 1;
						end if;
					else 
						tempnum <= tempnum - 100000;
						count3 := count3 + 1;
					end if;
				else
					tempnum <= tempnum - 1000000;
					count2 := count2 + 1;
				end if;
			else 
				tempnum <= tempnum - 10000000;
				count1 := count1 + 1;
			end if;
		end if; 
	end if; 
else 
  finish <= '0';
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
 out5 <= tempout5;
 out6 <= tempout6;
 out7 <= tempout7;
 out8 <= tempout8;
end if;
end process;
end behavioral;