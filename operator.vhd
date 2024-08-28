library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity operator is port
(
inputop : in std_logic_vector (7 downto 0);
op		: out std_logic_vector(1 downto 0)
);
end operator;

architecture behavioral of operator is

constant kali	: std_logic_vector(7 downto 0) := "00101010";
constant tambah	: std_logic_vector(7 downto 0) := "00101011";
constant kurang : std_logic_vector(7 downto 0) := "00101101";

begin

	process(inputop)
	begin
		case inputop is
			when kali => op <= "10";
			when tambah => op <= "01";
			when kurang => op <= "00";
			when others => op <= "ZZ";
		end case;
	end process;
end behavioral;