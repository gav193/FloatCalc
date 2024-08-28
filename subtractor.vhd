library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
    port (
        p,q,r,s : in integer;
        t,u,v,w : in integer;
		reset : in std_logic;
        outputS1,outputS2,outputS3,outputS4 : out integer;
        sign : out std_logic;
        clk : in std_logic
    );
end entity;

architecture behavioral of subtractor is
    signal tempdh, tempcg, tempbf, tempae : integer := 0;
    signal aminus, bminus, cminus : integer := 0;
	signal A,B,C,D,E,F,G,H : integer := 0;
	signal OC : integer;
	
	component comparator is
        port (
			A,B,C,D : in integer;
			E,F,G,H : in integer;
			outputS1 : out integer;
			clk : in std_logic
		);
	end component;
	
    begin
    bandingkan : comparator
    port map(p,q,r,s,t,u,v,w,OC,clk);
        
        process
		begin
		wait until rising_edge(clk);
		
		if reset = '0' then
			
			tempdh <= 0;
			tempcg <= 0;
			tempbf <= 0;
			tempae <= 0;
			aminus <= 0;
			bminus <= 0;
			cminus <= 0;
			A <= 0;
			B <= 0;
			C <= 0;
			D <= 0;
			E <= 0;
			F <= 0;
			G <= 0;
			H <= 0;
			
		else
			if (OC = 1) then
				A <= p;
				B <= q;
				C <= r;
				D <= s;
				E <= t;
				F <= u;
				G <= v;
				H <= w;
				sign <= '0';
			elsif (OC = 2) then
				A <= t;
				B <= u;
				C <= v;
				D <= w;
				E <= p;
				F <= q;
				G <= r;
				H <= s;
				sign <= '1';
			end if;
			
			if (D < H) then
				tempdh <= 10+D-H;
				cminus <= C-1;
			else tempdh <= D- H;
			end if;
			
			if (cminus = 0) then
				if (C < G) then
					tempcg <= 10 + C-G;
					bminus <= B-1;
				else tempcg <= C-G;
				end if;
			elsif (cminus /= 0) then
				if (cminus<G) then
					tempcg <= 10 + cminus - G;
					bminus <= B -1;
				else tempcg <= cminus - G;
				end if;
			end if;
			
			if bminus = 0 then
				if B < F then
					tempbf <= 10 + B - F;
					aminus <= A -1;
				else tempbf <= B-F;
				end if;
			elsif bminus /= 0 then
				if bminus < F then
					tempbf <= 10 + bminus - F;
					aminus <= A -1;
				else tempbf <= bminus - F;
				end if;
			end if;
			
			if aminus = 0 then
				if A < E then
					tempae <= E-A;
				else tempae <= A-E;
				end if;
			elsif aminus /= 0 then
				if aminus < E then 
					tempae <= E - aminus;
				else tempae <= aminus - E;
				end if;
			end if;
			outputS1 <= tempae;
			outputS2 <= tempbf;
			outputS3 <= tempcg;
			outputS4 <= tempdh;
		end if;
		end process;
	end behavioral;
	
    