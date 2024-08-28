library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_ascii_conv is port
( 
bcd : in std_logic_vector (3 downto 0);
ascii : out std_logic_vector(7 downto 0)
);
end bcd_ascii_conv;

architecture behavioral of bcd_ascii_conv is

constant nol : std_logic_vector(3 downto 0) := "0000";
constant satu : std_logic_vector(3 downto 0) := "0001";
constant dua : std_logic_vector(3 downto 0) := "0010";
constant tiga : std_logic_vector(3 downto 0) := "0011";
constant empat : std_logic_vector(3 downto 0) := "0100";
constant lima : std_logic_vector(3 downto 0) := "0101";
constant enam : std_logic_vector(3 downto 0) := "0110";
constant tujuh : std_logic_vector(3 downto 0) := "0111";
constant delapan : std_logic_vector(3 downto 0) := "1000";
constant sembilan : std_logic_vector(3 downto 0) := "1001";

begin

process(bcd)
begin
case bcd is
	when nol => ascii <= "0011" & "0000";
	when satu => ascii <= "0011" & "0001";
	when dua => ascii <= "0011" & "0010";
	when tiga => ascii <= "0011" & "0011";
	when empat => ascii <= "0011" & "0100";
	when lima => ascii <= "0011" & "0101";
	when enam => ascii <= "0011" & "0110";
	when tujuh => ascii <= "0011" & "0111";
	when delapan => ascii <= "0011" & "1000";
	when sembilan => ascii <= "0011" & "1001";
	when others => ascii <= "0011" & "1111";
end case;
end process;
end behavioral;