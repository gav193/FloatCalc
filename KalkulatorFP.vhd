library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity KalkulatorFP is
    port (
        Aa,Bb,Cc,Dd    : in std_logic_vector (7 downto 0);
        op      : in std_logic_vector (7 downto 0); -- vector (1 downto 0)
        outmux   : out std_logic_vector (71 downto 0);
        finish : out std_logic
    );
end entity;

architecture behavioral of KalkulatorFP is
    
	component bcd_dec_conv is
        port (
			bcd      : in std_logic_vector (3 downto 0);
			decimal  : out integer
		);
    end component;   
    
	component comparator is
        port (
			A,B,C,D : in integer;
			E,F,G,H : in integer;
			outputS1 : out integer;
			clk : in std_logic
    );
    end component;   
      
	component dec_ascii_conv is
        port (
			decimal      : in integer;
			start	     : in std_logic;
			ascii          : out std_logic_vector(7 downto 0)
		);
    end component; 
    
    
    component adder is
        port (
			A,B,C,D : in std_logic_vector(7 downto 0);
			clk : in std_logic;
			reset : in std_logic;
			sum : out std_logic_vector(47 downto 0)
        );     
    end component;

    component subtractor is
        port (
            p,q,r,s : in integer;
            t,u,v,w : in integer;
            reset : in std_logic;
            outputS1 : out integer;
            outputS2 : out integer;
            outputS3 : out integer;
            outputS4 : out integer;
            sign : out std_logic;
            clk : in std_logic
        );
    end component; 
    
    component operator is
        port (
			inputop : in std_logic_vector (7 downto 0);
			op      : out std_logic_vector (1 downto 0) 
		);
    end component; 
    
    component osubtract_conv is
        port (
			angka1 : in std_logic_vector (7 downto 0);
			angka2 : in std_logic_vector (7 downto 0);
			angka3 : in std_logic_vector (7 downto 0);
			angka4 : in std_logic_vector (7 downto 0);
			sign   : in std_logic;
			outputg : out std_logic_vector (47 downto 0);
			clk     : in std_logic
		);
    end component;
    
    
    component outmulti is
        port (
			A,B,C,D : in std_Logic_vector(7 downto 0);
			clk : in std_logic;
			reset : in std_logic;
			output : out std_logic_vector(71 downto 0)
		);
    end component; 
    
    component section4 is
        port (
			num : IN integer;
			clk : IN std_logic;
			out1 : OUT integer;
			out2 : OUT integer;
			out3 : OUT integer;
			out4 : OUT integer;
			finish : OUT std_logic
		);
    end component; 


    component section8 is
        port (
			num : IN integer;
			start : IN std_logic;
			clk : IN std_logic;
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

	

 signal P : std_logic_vector (3 downto 0);
 signal Q : std_logic_vector (3 downto 0);
 signal R : std_logic_vector (3 downto 0);
 signal S : std_logic_vector (3 downto 0) ;
 signal T : std_logic_vector (3 downto 0) ;
 signal U : std_logic_vector (3 downto 0) ;
 signal V : std_logic_vector (3 downto 0) ;
 signal W : std_logic_vector (3 downto 0) ;
 signal decimal1, decimal2, decimal3, decimal4, decimal5, decimal6, decimal7, decimal8 : integer;
 signal ascii1, ascii2, ascii3, ascii4 : std_logic_vector(7 downto 0);
 signal outputS1,outputS2,outputS3,outputS4 : integer;
 signal outputg : std_logic_vector(47 downto 0);
 signal sign : std_logic;
 signal clk : std_logic;
 signal reset : std_logic;
 signal summ : std_logic_vector(47 downto 0);
 signal output : std_logic_vector(71 downto 0);
 signal outop : std_logic_vector(1 downto 0);
 
begin

	P <= Aa(7 downto 4);
	Q <= Aa(3 downto 0);
	R <= Bb(7 downto 4);
	S <= Bb(3 downto 0);
	T <= Cc(7 downto 4);
	U <= Cc(3 downto 0);
	V <= Dd(7 downto 4);
	W <= Dd(3 downto 0);

	bcddec1 : bcd_dec_conv
	port map (P, decimal1);
	
	bcddec2 : bcd_dec_conv
	port map (Q, decimal2);
	
	bcddec3 : bcd_dec_conv
	port map (R, decimal3);
	
	bcddec4 : bcd_dec_conv
	port map (S, decimal4);
	
	bcddec5 : bcd_dec_conv
	port map (T, decimal5);
	
	bcddec6 : bcd_dec_conv
	port map (U, decimal6);
	
	bcddec7 : bcd_dec_conv
	port map (V, decimal7);
	
	bcddec8 : bcd_dec_conv
	port map (W, decimal8);
	
	decascii1 : dec_ascii_conv
	port map (outputS1,'1', ascii1);
	
	decascii2 : dec_ascii_conv
	port map (outputS2,'1', ascii2);
	
	decascii3 : dec_ascii_conv
	port map (outputS3,'1', ascii3);
	
	decascii4 : dec_ascii_conv
	port map (outputS4,'1', ascii4);

	adder1 : adder
	port map(Aa, Bb, Cc, Dd, clk, reset, summ);

	subtractor1 : subtractor 
	port map(decimal1, decimal2, decimal3, decimal4, decimal5, decimal6, 
	decimal7, decimal8, reset, outputS1,outputS2,outputS3,outputS4, sign, clk);

	outsubtractor1 : osubtract_conv
	port map(ascii1, ascii2, ascii3, ascii4, sign, outputg, clk);

	outmultiplier1 : outmulti
	port map(Aa,Bb,Cc,Dd, clk,reset, output);
	
	operator1 : operator
	port map(op, outop);
	
	process 
		begin
		wait until rising_edge(clk);
		if outop = "10" then
			outmux <= output;
		elsif outop = "01" then
			outmux <= summ & "000000000000000000000000";
		elsif outop = "00" then
			outmux <= outputg & "000000000000000000000000";
		end if;
	end process;
	
	process(output)
	begin
		if reset = '1' then
			finish<='1';
		else 
			finish <= '0';
		end if;
	end process;
		
end behavioral;