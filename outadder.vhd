library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity outadder is
   port(
      input : in std_logic_vector(19 downto 0);
      clk : in std_logic;
      summ : out std_logic_vector(47 downto 0)
   );
end outadder;

architecture behavioral of outadder is
   signal Ax, Bx, Cx, Dx, Ex : std_logic_vector(7 downto 0);
   signal clock : std_logic;
   constant ascii : std_logic_vector(3 downto 0) := "0011";
   constant comma : std_logic_vector(7 downto 0) := "00101100";
begin
 process(clk)
  begin
   if rising_edge(clk) then  -- Mengecek naiknya tepi clock
    clock <= not clk;  -- Inverter clock internal untuk pembuatan clock baru
   end if;
   end process;
   process(clock)
   begin 
      Ax <= ascii & input(19 downto 16);
      Bx <= ascii & input(15 downto 12);
      Cx <= ascii & input(11 downto 8);
      Dx <= ascii & input(7 downto 4);
      Ex <= ascii & input(3 downto 0);


      summ <= Ax & Bx & Cx & comma & Dx & Ex;
   end process;
end behavioral;