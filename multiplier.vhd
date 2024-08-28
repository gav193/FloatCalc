library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
	port(
		A,B,C,D : in std_logic_vector(7 downto 0);
		clk		: in std_logic;
		reset	: in std_logic;
		outINT: out integer;
		finished : out std_logic
	);
end multiplier;

architecture behavioral of multiplier is

	signal reg1, reg2, reg3, reg4 : unsigned(15 downto 0) := (others => '0');
	signal saveA, saveB, saveC, saveD : unsigned(7 downto 0);
	signal doneC, doneD, doneN, done1,done2,done3 : std_logic := '0';
	signal out4, out3, out2, out1,AC,BC,BD,AD : integer := 0;
	constant nol        : std_logic_vector(3 downto 0) := "0000";
    constant satu       : std_logic_vector(3 downto 0) := "0001";
    constant dua        : std_logic_vector(3 downto 0) := "0010";
    constant tiga       : std_logic_vector(3 downto 0) := "0011";
    constant empat      : std_logic_vector(3 downto 0) := "0100";
    constant lima       : std_logic_vector(3 downto 0) := "0101";
    constant enam       : std_logic_vector(3 downto 0) := "0110";
    constant tujuh      : std_logic_vector(3 downto 0) := "0111";
    constant delapan    : std_logic_vector(3 downto 0) := "1000";
    constant sembilan   : std_logic_vector(3 downto 0) := "1001";

begin

saveA <= unsigned(A);
saveB <= unsigned(B);
saveC <= unsigned(C);
saveD <= unsigned(D);


process 

	variable temp1, temp2, temp3, temp4 : integer := 0;
	variable countc, countd: integer := 0 ;
	variable a1,a2,b1,b2,c1,c2,d1,d2 : unsigned (3 downto 0);
	variable numa1,numa2,numb1,numb2,numc1,numc2,numd1,numd2 : integer := 0;
	variable totala,totalb,totalc, totald : integer := 0;
	
begin

wait until clk'EVENT and clk = '1';

a1 := saveA(7 downto 4);
a2 := saveA(3 downto 0);
b1 := saveB(7 downto 4);
b2 := saveB(3 downto 0);
c1 := saveC(7 downto 4);
c2 := saveC(3 downto 0);
d1 := saveD(7 downto 4);
d2 := saveD(3 downto 0);

numa1 := to_integer(a1);
numa2 := to_integer(a2);
numb1 := to_integer(b1);
numb2 := to_integer(b2);
numc1 := to_integer(c1);
numc2 := to_integer(c2);
numd1 := to_integer(d1);
numd2 := to_integer(d2);

totala := numa1 + numa1 + numa1 + numa1 + numa1 + numa1 + numa1 + numa1 + numa1 + numa1 + numa2;
totalb := numb1 + numb1 + numb1 + numb1 + numb1 + numb1 + numb1 + numb1 + numb1 + numb1 + numb2;
totalc := numc1 + numc1 + numc1 + numc1 + numc1 + numc1 + numc1 + numc1 + numc1 + numc1 + numc2;
totald := numd1 + numd1 + numd1 + numd1 + numd1 + numd1 + numd1 + numd1 + numd1 + numd1 + numd2;

if reset = '0' then
	temp1 := totala; -- A for A*C
	temp2:= totalb; -- B for B*C
	temp3 := totala; -- A for A*D
	temp4 := totalb; -- B for B*D
	countc := 1;
	countd := 1;
	doneC <= '0';
	doneD <= '0';
else 
	if countc < totalc then
		temp1 := temp1 + totala; -- A*C
		temp2 := temp2 + totalb; -- B*C
		countc := countc + 1;
	elsif countc = totalc then
		AC <= temp1;
		BC <= temp2;
		doneC <= '1';
	end if;

	if countd < totald then
		temp3 := temp3 + totala; -- A*D
		temp4 := temp4 + totalb; -- B*D
		countd := countd + 1;
	elsif countd = totald then
		AD <= temp3;
		BD <= temp4;
		doneD <= '1';
	end if;
end if;
end process;

process(doneC,doneD,clk,reset)

constant hundred : integer := 100;
constant hundhundred : integer := 10000;
variable countH, countH2 : integer := 0;
variable hasil1, hasil2 : integer := 0;
variable donedone : std_logic := '1';

begin
if reset = '0' then	
	finished <= '0';
	countH := 0; 
	countH2 := 0;
	hasil1 := 0;
	hasil2 := 0;
	donedone := '1';

else 
	if clk'EVENT and clk = '1' then
		if doneC = '1' and doneD = '1' then
			if donedone = '1' then
				if countH < hundred then
					countH := countH + 1;
					hasil1 := hasil1 + AD + BC;
				else
					if countH2 < hundhundred then
						countH2 := countH2 + 1;
						hasil2 := hasil2 + AC;
					else
						hasil1 := hasil1 + BD;
						donedone := '0';
					end if;
				end if;
			else
				outINT <= hasil1 + hasil2;
				finished <= '1';
			end if;
		end if;
	end if;
end if;

end process;


end behavioral;