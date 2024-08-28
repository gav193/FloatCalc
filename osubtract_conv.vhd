library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity osubtract_conv is 
	port (
		angka1 : in std_logic_vector(7 downto 0);
		angka2 : in std_logic_vector(7 downto 0);
		angka3 : in std_logic_vector(7 downto 0);
		angka4 : in std_logic_vector(7 downto 0);
		sign   : in std_logic;
		outputg : out std_logic_vector(47 downto 0);
		clk : in std_logic
	);
end entity;

architecture behavioral of osubtract_conv is
	constant koma : std_logic_vector (7 downto 0) := "00101100";
begin
	process
		begin
		wait until rising_edge(clk);
		if (sign = '1') then
			outputg <= "00101101" & angka1 & angka2 & koma & angka3 & angka4;
		else outputg <= "00110000" & angka1 & angka2 & koma & angka3 & angka4;	
		end if;
	end process;
end behavioral;