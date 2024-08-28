-- Library
library IEEE;
use ieee.std_logic_1164.all;

-- entity
entity speed_select is
port(
	clk : std_logic;
	rst_n : std_logic;
	bps_start : std_logic;
	clk_bps : out std_logic
);
end entity;

architecture RTL of speed_select is
	signal cnt : integer range 0 to 8191; -- (2^13)-1

	constant BPS_PARA: integer :=		5207; -- 9600
	constant BPS_PARA_2: integer :=		2603; -- 9600

	signal clk_bps_r : std_logic;			
	signal uart_ctrl : std_logic_vector(2 downto 0) ; 
begin
	
	process(clk, rst_n)
	begin
		if (rst_n = '0') then cnt <= 0;
		elsif (clk='1' and clk'event) then
			if ((cnt = BPS_PARA) or (bps_start = '0')) then cnt <= 0; -- end if;
			else cnt <= cnt + 1;
			end if;
		end if;
	end process;
	
	process(clk, rst_n)
	begin
		if (rst_n = '0') then clk_bps_r <= '0';
		elsif (clk='1' and clk'event) then
			if((cnt = BPS_PARA_2) and (bps_start='1')) then clk_bps_r <= '1';
			else clk_bps_r <= '0';
			end if;
		end if;
	end process;

	clk_bps <= clk_bps_r;

end architecture;



