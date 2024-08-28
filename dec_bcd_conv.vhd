library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_bcd_conv is port
    (
    decimal      : in integer;
    bcd          : out std_logic_vector(3 downto 0)
    );
end dec_bcd_conv;

architecture behavioral of dec_bcd_conv is

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

process(decimal)
    begin
        case decimal is 
            when 0 => bcd <= nol;
            when 1 => bcd <= satu;
            when 2 => bcd <= dua;
            when 3 => bcd <= tiga;
            when 4 => bcd <= empat;
            when 5 => bcd <= lima;
            when 6 => bcd <= enam;
            when 7 => bcd <= tujuh;
            when 8 => bcd <= delapan;
            when 9 => bcd <= sembilan;
            when others => 
				bcd <="1111";
        end case;
    end process;
end behavioral;