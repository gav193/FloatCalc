library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_ascii_conv is port
    (
    decimal      : in integer;
	start		 : in std_logic;
    ascii          : out std_logic_vector(7 downto 0)
    );
end dec_ascii_conv;

architecture behavioral of dec_ascii_conv is

    constant nol        : std_logic_vector(7 downto 0) := "00110000";
    constant satu       : std_logic_vector(7 downto 0) := "00110001";
    constant dua        : std_logic_vector(7 downto 0) := "00110010";
    constant tiga       : std_logic_vector(7 downto 0) := "00110011";
    constant empat      : std_logic_vector(7 downto 0) := "00110100";
    constant lima       : std_logic_vector(7 downto 0) := "00110101";
    constant enam       : std_logic_vector(7 downto 0) := "00110110";
    constant tujuh      : std_logic_vector(7 downto 0) := "00110111";
    constant delapan    : std_logic_vector(7 downto 0) := "00111000";
    constant sembilan   : std_logic_vector(7 downto 0) := "00111001";

    begin

process(decimal, start)
    begin
		if start = '1' then
			case decimal is 
				when 0 => ascii <= nol;
				when 1 => ascii <= satu;
				when 2 => ascii <= dua;
				when 3 => ascii <= tiga;
				when 4 => ascii <= empat;
				when 5 => ascii <= lima;
				when 6 => ascii <= enam;
				when 7 => ascii <= tujuh;
				when 8 => ascii <= delapan;
				when 9 => ascii <= sembilan;	
				when others => ascii <= "11111111";
			end case;
		end if;
    end process;
end behavioral;