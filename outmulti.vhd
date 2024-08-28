library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity outmulti is
	port(
		A,B,C,D : in std_Logic_vector(7 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(71 downto 0)
	);
end outmulti;

architecture behavioral of outmulti is

component section8 is 
	port (
			num : IN integer;
			start : IN std_logic;
			clk : IN std_logic;
			reset : IN std_logic;
			out1 : OUT integer;
			out2 : OUT integer;
			out3 : OUT integer;
			out4 : OUT integer;
			out5 : OUT integer;
			out6 : OUT integer;
			out7 : OUT integer;
			out8 : OUT integer;
			finish : OUT std_logic
	);
end component;

component dec_ascii_conv is
	port(
		decimal : in integer;
		start : in std_logic;
		ascii : out std_logic_vector(7 downto 0)
	);
end component;

component multiplier is
	port(
		A,B,C,D : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		outINT : out integer;
		finished : out std_logic
	);
end component;

-- signals
signal multiplied : integer;
signal m1, m2, m3, m4, m5, m6, m7, m8 : integer;
signal doneSec : std_logic;
signal o1,o2,o3,o4,o5,o6,o7,o8 : std_logic_vector(7 downto 0);
signal proceed : std_logic;
signal donecon1, donecon2, donecon3, donecone4, donecon5, donecon6, donecon7, donecon8 : std_logic := '0';

begin

module_multiply : multiplier
port map (
	A => A,
	B => B,
	C => C,
	D => D,
	clk => clk,
	reset => reset,
	outINT => multiplied,
	finished => proceed
);

module_sectioning : section8
port map (
	num => multiplied,
	start => proceed,
	clk => clk,
	reset => reset,
	out1 => m1,
	out2 => m2, 
	out3 => m3,
	out4 => m4,
	out5 => m5,
	out6 => m6,
	out7 => m7,
	out8 => m8,
	finish => doneSec
);

module_asciiConv1 : dec_ascii_conv
port map (
	decimal => m1,
	start => doneSec,
	ascii => o1
);

module_asciiConv2 : dec_ascii_conv
port map (
	decimal => m2,
	start => doneSec,
	ascii => o2
);

module_asciiConv3 : dec_ascii_conv
port map (
	decimal => m3,
	start => doneSec,
	ascii => o3
);

module_asciiConv4 : dec_ascii_conv
port map (
	decimal => m4,
	start => doneSec,
	ascii => o4
);

module_asciiConv5 : dec_ascii_conv
port map (
	decimal => m5,
	start => doneSec,
	ascii => o5
);

module_asciiConv6 : dec_ascii_conv
port map (
	decimal => m6,
	start => doneSec,
	ascii => o6
);

module_asciiConv7 : dec_ascii_conv
port map (
	decimal => m7,
	start => doneSec,
	ascii => o7
);

module_asciiConv8 : dec_ascii_conv
port map (
	decimal => m8,
	start => doneSec,
	ascii => o8
);

process(o1,o2,o3,o4,o5,o6,o7,o8)

begin
output(7 downto 0) <= o8;
output(15 downto 8) <= o7;
output(23 downto 16) <= o6;
output(31 downto 24) <= o5;
output(39 downto 32) <= "00101110";
output(47 downto 40) <= o4;
output(55 downto 48) <= o3;
output(63 downto 56) <= o2;
output(71 downto 64) <= o1;

end process;

end behavioral;