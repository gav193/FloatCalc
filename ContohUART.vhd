-- library
library ieee;
use ieee.std_logic_1164.all;

-- entity
entity ContohUART is
	port(
		clk 			: in std_logic;
		rst_n 			: in std_logic;
-- paralel part
		button			: in std_logic;
		Seven_Segment	: out std_logic_vector(7 downto 0) ;
		Digit_SS		: out std_logic_vector(3 downto 0) ;
-- serial part
		rs232_rx 		: in std_logic;
		rs232_tx 		: out std_logic
	);
End entity;


Architecture RTL of ContohUART is

	component KalkulatorFP is 
	port(
        Aa,Bb,Cc,Dd    : in std_logic_vector (7 downto 0);
        op      : in std_logic_vector (7 downto 0); -- vector (1 downto 0)
        outmux   : out std_logic_vector (71 downto 0);
        finish : out std_logic 
    );
	end component;

	Component my_uart_top is
	port(
			clk 		: in std_logic;
			rst_n 		: in std_logic;
			send 		: in std_logic;
			send_data	: in std_logic_vector(7 downto 0) ;
			receive 	: out std_logic;
			receive_data: out std_logic_vector(7 downto 0) ;
			tx_en 	: out std_logic;
			rs232_rx 	: in std_logic;
			rs232_tx 	: out std_logic
	);
	end Component;
	
	component fsm is 
	port(
			 data_received : IN std_logic_vector (103 downto 0); 
			 clk     : IN std_logic;
			 reset    : IN std_logic;
			 A,B,C,D    : OUT std_logic_vector (7 downto 0);
			 op     : OUT std_logic_vector (7 downto 0)
			);
	end component;
	
	signal send_data,receive_data	: std_logic_vector(7 downto 0);
	signal receive,send	: std_logic;
	signal receive_c	: std_logic;
	signal done	: std_logic := '0';
	signal tempreg			: std_logic_vector(103 downto 0):= (others => '0');
	signal finalreg			: std_logic_vector(103 downto 0):= (others => '0');
	signal temporary1,temporary2,temporary3,temporary4,temporary5,temporary6,temporary7,temporary8,temporary9,temporary10,temporary11,temporary12,temporary13		: std_logic_vector(7 downto 0);
	signal A,B,C,D : std_logic_vector(7 downto 0);
	signal op : std_logic_vector(7 downto 0);
	signal output : std_logic_vector(71 downto 0);
	signal tx_enA, tx_enD : std_logic;
	type arrS is array (0 to 8) of std_logic_vector(7 downto 0);
	signal arrTX : arrS;
	signal counts : integer := 0;
	signal finish : std_logic;
	
	
begin

	UART: my_uart_top 
	port map (
			clk 		=> clk,
			rst_n 		=> rst_n,
			send 		=> tx_enA,
			send_data	=> send_data,
			receive 	=> receive,
			receive_data=> receive_data,
			tx_en => tx_enA,
			rs232_rx 	=> rs232_rx,
			rs232_tx 	=> rs232_tx
	);
	
	Process(clk)
	
	variable count : integer := 0;
	
	begin
		if ((clk = '1') and clk'event) then
			receive_c <= receive;
			if ((receive = '0') and (receive_c = '1'))then
--			if (receive = '1') then
				tempreg((103-count) downto (96-count)) <= receive_data;
				count := count + 8;
			end if;
			if (receive_data = "00101010" or receive_data= "00101011" or receive_data= "00101101") then 
				done <= '1';
			end if;
		end if;
		
		if rst_n = '0' then
			tempreg <= (others => '0');
			done <= '0';
			count := 0;
		end if;
		
	end process;
	
	Digit_SS <= "1110";
	
	process(done)
	begin
		if done = '1' then
			finalreg <= tempreg;
			temporary1 <= tempreg(103 downto 96);
			temporary2 <= tempreg(95 downto 88);
			temporary3 <= tempreg(87 downto 80);
			temporary4 <= tempreg(79 downto 72);
			temporary5 <= tempreg(71 downto 64);
			temporary6 <= tempreg(63 downto 56);
			temporary7 <= tempreg(55 downto 48);
			temporary8 <= tempreg(47 downto 40);
			temporary9 <= tempreg(39 downto 32);
			temporary10 <= tempreg(31 downto 24);
			temporary11 <= tempreg(23 downto 16);
			temporary12 <= tempreg(15 downto 8);
			temporary13 <= tempreg(7 downto 0);
		end if;
	end process;
	
	module_fsm : fsm
	port map(finalreg,clk,rst_n,A,B,C,D,op);
	
	module_topcalc : KalkulatorFP
	port map(A,B,C,D,op,output,finish);
	
	process(clk)
	
	variable temp : std_logic_vector (71 downto 0);
	
	begin
	if finish = '1' then
		temp := output;
		if clk= '1' and clk'EVENT then
			if temp(71 downto 64) /= "00000000" then
				arrTX(counts) <= temp(71 downto 64);
				temp(71 downto 64) := "00000000";
				temp(71 downto 8) := temp(63 downto 0);
				counts <= counts + 1;
			end if;
		end if;
	end if;
	end process;
	
	Seven_Segment <= arrTX(counts);
	
	process(counts,tx_enA)
	begin	
	if finish = '1' then
		if tx_enA = '1' then
				--send data
			if counts = 0 then
				send_data <= arrTX(0);
			else 
				send_data <= arrTX(counts);
			end if;
		end if;
	end if;
	end process;

end architecture;