library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ascii_bcd_conv is port
( 
inputbil : in std_logic_vector (7 downto 0);
bcd : out std_logic_vector(3 downto 0)
);
end ascii_bcd_conv;

architecture behavioral of ascii_bcd_conv is

constant nol : std_logic_vector(7 downto 0) := "00110000";
constant satu : std_logic_vector(7 downto 0) := "00110001";
constant dua : std_logic_vector(7 downto 0) := "00110010";
constant tiga : std_logic_vector(7 downto 0) := "00110011";
constant empat : std_logic_vector(7 downto 0) := "00110100";
constant lima : std_logic_vector(7 downto 0) := "00110101";
constant enam : std_logic_vector(7 downto 0) := "00110110";
constant tujuh : std_logic_vector(7 downto 0) := "00110111";
constant delapan : std_logic_vector(7 downto 0) := "00111000";
constant sembilan : std_logic_vector(7 downto 0) := "00111001";

begin

process(inputbil)
begin
case inputbil is
	when nol => bcd <= "0000";
	when satu => bcd <= "0001";
	when dua => bcd <= "0010";
	when tiga => bcd <= "0011";
	when empat => bcd <= "0100";
	when lima => bcd <= "0101";
	when enam => bcd <= "0110";
	when tujuh => bcd <= "0111";
	when delapan => bcd <= "1000";
	when sembilan => bcd <= "1001";
	when others => bcd <= "1111";
end case;
end process;
end behavioral;