library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port(
        A,B,C,D : in std_logic_vector(7 downto 0);
        clk : in std_logic;
		reset : in std_logic;
        sum : out std_logic_vector(47 downto 0)
);
end adder;

architecture behavioral of adder is
    signal saveA,saveB, saveC, saveD : unsigned(7 downto 0);
    signal out2 : unsigned(11 downto 0);
    signal out1 : unsigned(7 downto 0);
    signal done : std_logic := '0';
	signal outputA: std_logic_vector(19 downto 0);
	signal p2 : std_logic_vector(11 downto 0);
	signal p1 : std_logic_vector(7 downto 0);
	component outadder is
	port 	(
	input : in std_logic_vector(19 downto 0);
      clk : in std_logic;
      summ : out std_logic_vector(47 downto 0)
   );
end component;
    begin

        saveA <= unsigned(A);
        saveB <= unsigned(B);
        saveC <= unsigned(C);
        saveD <= unsigned(D);

        process(clk)

        variable temp1 : unsigned(11 downto 0) := (others => '0');
        variable temp2 : unsigned(11 downto 0) := (others => '0');
        constant six0 : unsigned(3 downto 0) := "0110" ;
        constant six1 : unsigned(7 downto 0) := "01100000" ;
        variable arrA, arrB, arrC, arrD : unsigned(4 downto 0);


        begin
		if reset = '0' then
			temp1 := (others => '0');
			temp2 := (others => '0');
			done <= '0';
		else
			if (clk = '1' and clk'EVENT) then
				temp1 := ("0000" & saveB) + ("0000" & saveD); -- bawah koma
				arrA := ('0' & saveB(3 downto 0)) + ('0' & saveD(3 downto 0));
				if to_integer(arrA) > 9 then
					temp1 := temp1 + ("00000000" & six0);
				end if;
				arrB := ('0' & saveB(7 downto 4)) + ('0' & saveD(7 downto 4));
				if to_integer(arrB) > 9 then
					temp1 := temp1 + ("0000" & six1);
				end if;

				temp2 := ("0000" & saveA) + ("0000" & saveC); -- atas koma
				arrC := ('0' & saveA(3 downto 0)) + ('0' & saveC(3 downto 0));
				if to_integer(arrC) > 9 then
					temp2 := temp2 + ("00000000" & six0);
					if temp1(8) = '1' then 
						arrC := arrC + "00001";
						if to_integer(arrC) > 9 then
							temp2 := temp2 + ("00000000" & six0);
						end if;
					end if;
				end if;
				arrD := ('0' & saveA(7 downto 4)) + ('0' & saveC(7 downto 4));
				if to_integer(arrD) > 9 then
					temp2 := temp2 + ("0000" & six1);
					if temp1(8) = '1' then
						arrD := ('0' & temp2(3 downto 0)) + "00001";
						if to_integer(arrD) > 9 then
							temp2 := temp2 + ("0000" & six1);
						end if;
					end if;
				end if; 
				done <= '1';
			end if;

			if done = '1' then
				out1 <= temp1(7 downto 0);
				out2 <= temp2(11 downto 0);
				p1 <= std_logic_vector(out1) ;
				p2 <= std_logic_vector(out2);
				outputA <= std_logic_vector(out2) & std_logic_vector(out1);
				sum <= "0011"& p2(11 downto 8) & "0011" & p2(7 downto 4) & "0011" & p2(3 downto 0) & "00101100" & "0011" & p1(7 downto 4) & "0011" & p1(3 downto 0);
			end if;
		end if;
        end process;


  end behavioral;