library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_dec_conv is port
    (
    bcd      : in std_logic_vector(3 downto 0);
    decimal          : out integer
    );
end bcd_dec_conv;

architecture behavioral of bcd_dec_conv is

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

process(bcd)
    begin
        case bcd is 
            when nol => decimal <= 0;
            when satu => decimal <= 1;
            when dua => decimal <= 2;
            when tiga => decimal <= 3;
            when empat => decimal <= 4;
            when lima => decimal <= 5;
            when enam => decimal <= 6;
            when tujuh => decimal <= 7;
            when delapan => decimal <= 8;
            when sembilan => decimal <= 9;
            when others => -- kondisi tidak terpakai
				decimal <= 0;
        end case;
    end process;
end behavioral;