library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
    port (
        A,B,C,D : in integer;
        E,F,G,H : in integer;
        clk     : in std_logic;
        outputS1 : out integer
    );
end comparator;

architecture behavioral of comparator is

begin
    process 
    begin
    wait until rising_edge(clk);
    if (A > E) then
        outputS1 <= 1;
    elsif (A = E) then
        if (B > F) then
            outputS1 <= 1;
        elsif (B=F) then
            if (C > G) then
                outputS1 <= 1;
            elsif (C = G) then 
                outputS1 <= 1;
            else outputS1 <= 2;
            end if;
        else outputS1 <= 2;
        end if;
    else outputS1 <= 2;
    end if;
    end process;
end behavioral;