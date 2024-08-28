library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
port (
	data_received : IN std_logic_vector (103 downto 0); -- a1a2.b1b2 c1c2.d1d2 (op) = 13 chars of 8 bits
	clk			  : IN std_logic;
	reset		  : IN std_logic;
	A,B,C,D		  : OUT std_logic_vector (7 downto 0);
	op			  : OUT std_logic_vector (7 downto 0)
);
end fsm;

architecture behavioral of fsm is
	type states IS (s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14) ;
	signal cState, nState : states;
	signal a1_proc,a2_proc,b1_proc, b2_proc,separator1_proc,separator2_proc,separator3_proc,separator_proc,c1_proc,c2_proc,d1_proc,d2_proc,op_proc : std_logic := '0';
	signal a1_skip,b1_skip,c1_skip,d1_skip,x1_skip,x2_skip,y1_skip,y2_skip : std_logic := '0';
	signal done : std_logic := '0';
	signal finalA, finalB, finalC,finalD, finalOP : std_logic_vector(7 downto 0);
begin
process(clk)
begin 
	if (clk'EVENT) and (clk = '1') then 
		if reset = '0' then
			cState <= s1;
		else 
			cState <= nState;
		end if;
	end if;
end process;
	
process(cState)

variable caseScan : std_logic_vector(7 downto 0);
variable tempA,tempB,tempC,tempD,tempOP : std_logic_vector(7 downto 0);

begin
	case cState is 
		when s1 => -- start and reset state
			done <= '0';
			a1_skip <= '0';
			b1_skip <= '0';
			c1_skip <= '0';
			d1_skip <= '0';
			x1_skip <= '0';
			x2_skip <= '0';
			y1_skip <= '0';
			y2_skip <= '0';
			a1_proc <= '0';
			caseScan := data_received(103 downto 96);
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					a1_proc <= '1';
					nState <= s2;
					tempA(7 downto 4) := data_received(99 downto 96);
					-- save to tempregister( left side save : ?????????xxxxxxxxx)
				when others =>
					a1_proc <= '0';
					nState <= s1;
					-- send back text "error" + reset registers
				end case;
		when s2 =>
			a2_proc <= '0';
			a1_skip <= '0';
			x1_skip <= '0';
            x2_skip <= '0';
			caseScan := data_received(95 downto 88);
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" => 
					a2_proc <= '1';
					nState <= s3;
                    tempA(3 downto 0) := data_received(91 downto 88);
					-- save to tempregister ( right side save : xxxxxxxxx ???????? ) & change register
				when "00101110" => -- comma
					a2_proc <= '1';
					a1_skip <= '1'; -- skips a1 (only a2 will be input)
					nState <= s4;
                    tempA(3 downto 0) := tempA(7 downto 4);
                    tempA(7 downto 4) := "0000";
					-- change register + shift tempreg from s1
				when "00100000" => -- space ( for input X = 1 digit decimal with no value under comma )
					a2_proc <= '1';
					x1_skip <= '1';
					nState <= s7;-- SKIP TO C INPUT STATES
                    tempA(3 downto 0) := tempA(7 downto 4);
                    tempA(7 downto 4) := "0000";
                    tempB := "00000000";
					-- change register
				when others =>
					nState <= s1;
					-- send back text "error" & re-initialize register
				end case;
		when s3 =>
			separator_proc <= '0';
			x2_skip <= '0';
            caseScan := data_received(87 downto 80); -- END OF PROGRESS -----
			case caseScan is 
				when "00101110" =>
					separator_proc <= '1';
					nState <= s4;
					-- change register
				when "00100000" =>  -- space( for input X = 2 digit decimal with no value under comma )
					nState <= s7;--SKIP TO C INPUT STATES
                    x2_skip <= '1';
                    tempB := "00000000";
				when others =>
					nState <= s1;
					-- send back text "error" & re-initialize register
				end case;
		when s4 => 
			b1_proc <= '0';
            if a1_skip = '1' then
                caseScan := data_received(87 downto 80);
            else 
                caseScan := data_received(79 downto 72);
            end if;
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					b1_proc <= '1';
					nState <= s5;
                    tempB(7 downto 4) := caseScan(3 downto 0);
					-- save to tempregister( left side save : ?????????xxxxxxxxx )
				when others =>
					nstate <= s1;
				end case;
		when s5 => 
			b2_proc <= '0';
            b1_skip <= '0';
            if a1_skip = '1' then
                caseScan := data_received(79 downto 72);
            else
                caseScan := data_received(71 downto 64);
            end if;
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					b2_proc <= '1';
					nState <= s6;
                    tempB(3 downto 0) := caseScan(3 downto 0);
					-- save to tempregister( left side save : ?????????xxxxxxxxx )
				when "00100000" =>
					nState <= s7;
                    b1_skip <= '1';
                    tempB(3 downto 0) := "0000";
					-- SKIP TO C INPUT STATES
				when others =>
					nstate <= s1;
				end case;
		when s6 =>
			separator1_proc <= '0';
            caseScan := data_received(63 downto 56);
			case caseScan is 
				when "00100000" =>
					separator1_proc <= '1';
					nState <= s7;
				when others => 
					nState <= s1;
				end case;
		when s7 =>
			c1_proc <= '0';
            if a1_skip = '1' then
                caseScan := data_received(63 downto 56);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(71 downto 64);
                    --2 byte skipped
                end if;
            else
                if x1_skip = '1' then
                    caseScan := data_received(87 downto 80);
                    -- 4 bytes skipped
                else
                    if x2_skip = '1' then
                        caseScan := data_received(79 downto 72);
                        -- 3 bytes skipped
                    else
                        if b1_skip = '1' then
                            caseScan := data_received(63 downto 56);
                            -- 1 byte skipped
                        else
                            caseScan := data_received(55 downto 48);
                            -- normal / no skips case
                        end if;
                    end if;
                end if;
            end if;
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					c1_proc <= '1';
					nState <= s8;
                    tempC(7 downto 4) := caseScan(3 downto 0);
					-- save to tempregister( left side save : ?????????xxxxxxxxx)
				when others =>
					c1_proc <= '0';
					nState <= s1;
					-- send back text "error"
				end case;
		when s8 => 
			c2_proc <= '0';
            y1_skip <= '0';
            c1_skip <= '0';
            y2_skip <= '0';
            if a1_skip = '1' then
                caseScan := data_received(55 downto 48);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(63 downto 56);
                    --2 byte skipped
                end if;
            else
                if x1_skip = '1' then
                    caseScan := data_received(79 downto 72);
                    -- 4 bytes skipped
                else
                    if x2_skip = '1' then
                        caseScan := data_received(71 downto 64);
                        -- 3 bytes skipped
                    else
                        if b1_skip = '1' then
                            caseScan := data_received(55 downto 48);
                            -- 1 byte skipped
                        else
                            caseScan := data_received(47 downto 40);
                            -- normal / no skips case
                        end if;
                    end if;
                end if;
            end if;
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					c2_proc <= '1';
					nState <= s9;
                    tempC(3 downto 0) := caseScan(3 downto 0);
					-- save to tempregister ( right side save : xxxxxxxxx ???????? ) & change register
				when "00101110" => -- comma
					c2_proc <= '1';
                    c1_skip <= '1';
					nState <= s10;
                    tempC(3 downto 0) := tempC(7 downto 4);
                    tempC(7 downto 4) := "0000";
					-- change register + shift tempreg from s7
				when "00100000" => -- space ( for input Y = 1 digit decimal with no value under comma )
					c2_proc <= '1';
                    y1_skip <= '1';
                    tempC(3 downto 0) := tempC(7 downto 4);
                    tempC(7 downto 4) := "0000";
                    tempD := "00000000"; 
					nState <= s13; -- SKIP TO OPERATOR INPUT STATES
					-- change register
				when others =>
					nState <= s1;
					-- send back text "error" & re-initialize register
				end case;
		when s9 =>
            if a1_skip = '1' then
                caseScan := data_received(47 downto 40);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(55 downto 48);
                    --2 byte skipped
					if c1_skip = '1' then
                        caseScan := data_received(63 downto 56);
                        -- 3 byte skipped
					end if;
                else 	
                    if c1_skip = '1' then
                        caseScan := data_received(55 downto 48);
                        -- 2 byte skipped
                    end if;
                end if;
			else
				if x1_skip = '1' then
					caseScan := data_received(71 downto 64);
					-- 4 bytes skipped
					if c1_skip = '1' then
						caseScan := data_received(79 downto 72);
						-- 5 byte skipped
					end if;
				else
					if x2_skip = '1' then
						caseScan := data_received(63 downto 56);
						-- 3 bytes skipped
						if c1_skip = '1' then
							caseScan := data_received(71 downto 64);
							-- 4 byte skipped
						end if;
					else
						if b1_skip = '1' then
							caseScan := data_received(47 downto 40);
							-- 1 byte skipped
							if c1_skip = '1' then
								caseScan := data_received(55 downto 48);
								-- 2 byte skipped
							end if;
						else
							if c1_skip = '1' then
								caseScan := data_received(47 downto 40);
								-- 1 byte skipped
							else
								caseScan := data_received(39 downto 32);
								-- normal / no skips case
							end if;
						end if;
					end if;
				end if;
            end if;
			separator2_proc <= '0';
            y2_skip <= '0';
			case caseScan is 
				when "00101110" =>
					separator2_proc <= '1';
					nState <= s10;
				when "00100000" => -- space ( for input Y = 2 digit decimal with no value under comma )
					nState <= s13;-- SKIP TO OPERATOR INPUT STATES
                    y2_skip <= '1';
                    tempD := "00000000";
				when others =>
					nState <= s1;
				end case;
		when s10 => 
		    if a1_skip = '1' then
                caseScan := data_received(39 downto 32);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(47 downto 40);
                    --2 byte skipped
					if c1_skip = '1' then
                        caseScan := data_received(55 downto 48);
                        -- 3 byte skipped
                    else
						if y2_skip = '1' then
							caseScan := data_received(71 downto 64);
							-- 5 byte skipped
                        elsif y1_skip = '1' then
                            caseScan := data_received(79 downto 72);
                            -- 6 byte skipped
						end if;
					end if;
                else 	
                    if c1_skip = '1' then
                        caseScan := data_received(47 downto 40);
                        -- 2 byte skipped
                    else
						if y2_skip = '1' then
							caseScan := data_received(63 downto 56);
							-- 4 byte skipped
						elsif y1_skip = '1' then
                            caseScan := data_received(71 downto 64);
                            -- 5 byte skipped
                        end if;
                    end if;
                end if;
			else
				if x1_skip = '1' then
					caseScan := data_received(63 downto 56);
					-- 4 bytes skipped
					if c1_skip = '1' then
						caseScan := data_received(71 downto 64);
						-- 5 byte skipped
					else
						if y2_skip = '1' then
							caseScan := data_received(87 downto 80);
							-- 7 byte skipped
						elsif y1_skip = '1' then
							caseScan := data_received(95 downto 88);
							-- 8 byte skipped
						end if;
					end if;
				else
					if x2_skip = '1' then
						caseScan := data_received(55 downto 48);
						-- 3 bytes skipped
						if c1_skip = '1' then
							caseScan := data_received(63 downto 56);
							-- 4 byte skipped
						else
							if y2_skip = '1' then 
								caseScan := data_received(79 downto 72);
								-- 6 byte skipped
							elsif y1_skip = '1' then
								caseScan := data_received(87 downto 80);
								-- 7 byte skipped
							end if;
						end if;
					else
						if b1_skip = '1' then
							caseScan := data_received(39 downto 32);
							-- 1 byte skipped
							if c1_skip = '1' then
								caseScan := data_received(47 downto 40);
								-- 2 byte skipped
							else
								if y2_skip = '1' then
									caseScan := data_received(63 downto 56);
									-- 4 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(71 downto 64);
									-- 5 byte skipped
								end if;
							end if;
						else
							if c1_skip = '1' then
								caseScan := data_received(39 downto 32);
								-- 1 byte skipped
							else
								if y2_skip = '1' then
									caseScan := data_received(55 downto 48);
									-- 3 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(63 downto 56);
									-- 4 byte skipped
								else 
									caseScan := data_received(31 downto 24);
									-- normal / no skips case
								end if;
							end if;
						end if;
					end if;
				end if;
            end if;
			d1_proc <= '0';
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					d1_proc <= '1';
					nState <= s11;
					tempD(7 downto 4) := caseScan(3 downto 0);
					-- save to tempregister( left side save : ????????? xxxxxxxxx )
				when others =>
					nState <= s1;
				end case;
		when s11 => 
		    if a1_skip = '1' then
                caseScan := data_received(31 downto 24);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(39 downto 32);
                    --2 byte skipped
					if c1_skip = '1' then
                        caseScan := data_received(47 downto 40);
                        -- 3 byte skipped
                    else
						if y2_skip = '1' then
							caseScan := data_received(63 downto 56);
							-- 5 byte skipped
                        elsif y1_skip = '1' then
                            caseScan := data_received(71 downto 64);
                            -- 6 byte skipped
						end if;
					end if;
                else 	
                    if c1_skip = '1' then
                        caseScan := data_received(39 downto 32);
                        -- 2 byte skipped
                    else
						if y2_skip = '1' then
							caseScan := data_received(55 downto 48);
							-- 4 byte skipped
						elsif y1_skip = '1' then
                            caseScan := data_received(63 downto 56);
                            -- 5 byte skipped
                        end if;
                    end if;
                end if;
			else
				if x1_skip = '1' then
					caseScan := data_received(55 downto 48);
					-- 4 bytes skipped
					if c1_skip = '1' then
						caseScan := data_received(63 downto 56);
						-- 5 byte skipped
					else
						if y2_skip = '1' then
							caseScan := data_received(79 downto 72);
							-- 7 byte skipped
						elsif y1_skip = '1' then
							caseScan := data_received(87 downto 80);
							-- 8 byte skipped
						end if;
					end if;
				else
					if x2_skip = '1' then
						caseScan := data_received(47 downto 40);
						-- 3 bytes skipped
						if c1_skip = '1' then
							caseScan := data_received(55 downto 48);
							-- 4 byte skipped
						else
							if y2_skip = '1' then 
								caseScan := data_received(71 downto 64);
								-- 6 byte skipped
							elsif y1_skip = '1' then
								caseScan := data_received(79 downto 72);
								-- 7 byte skipped
							end if;
						end if;
					else
						if b1_skip = '1' then
							caseScan := data_received(31 downto 24);
							-- 1 byte skipped
							if c1_skip = '1' then
								caseScan := data_received(39 downto 32);
								-- 2 byte skipped
							else
								if y2_skip = '1' then
									caseScan := data_received(55 downto 48);
									-- 4 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(63 downto 56);
									-- 5 byte skipped
								end if;
							end if;
						else
							if c1_skip = '1' then
								caseScan := data_received(31 downto 24);
								-- 1 byte skipped
							else
								if y2_skip = '1' then
									caseScan := data_received(47 downto 40);
									-- 3 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(55 downto 48);
									-- 4 byte skipped
								else 
									caseScan := data_received(23 downto 16);
									-- normal / no skips case
								end if;
							end if;
						end if;
					end if;
				end if;
            end if;
			d2_proc <= '0'; 
			d1_skip <= '0';
			case caseScan is 
				when "00110000" | "00110001" | "00110010" | "00110011" | "00110100" | "00110101" | "00110110" | "00110111" | "00111000" | "00111001" =>
					d2_proc <= '1'; 
					nState <= s12;
					tempD(3 downto 0) := caseScan(3 downto 0);
				when "00100000" =>
					d1_skip <= '1';
					tempD(3 downto 0) := "0000";
					nState <= s13;-- SKIP TO OPERATOR INPUT STATES
				when others =>
					nState <= s1;
				end case;
		when s12 => 
			if a1_skip = '1' then
                caseScan := data_received(23 downto 16);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(31 downto 24);
                    --2 byte skipped
					if c1_skip = '1' then
                        caseScan := data_received(39 downto 32);
                        -- 3 byte skipped
						if d1_skip = '1' then
							caseScan := data_received(47 downto 40);
							-- 4 byte skipped
						end if;
                    else
						if y2_skip = '1' then
							caseScan := data_received(55 downto 48);
							-- 5 byte skipped
                        elsif y1_skip = '1' then
                            caseScan := data_received(63 downto 56);
                            -- 6 byte skipped
						elsif d1_skip = '1' then
							caseScan := data_received(39 downto 32);
							-- 3 byte skipped
						end if;
					end if;
                else 	
                    if c1_skip = '1' then
                        caseScan := data_received(31 downto 24);
                        -- 2 byte skipped
						if d1_skip = '1' then	
							caseScan := data_received(39 downto 32);
							-- 3 byte skipped
						end if;
                    else
						if y2_skip = '1' then
							caseScan := data_received(47 downto 40);
							-- 4 byte skipped
						elsif y1_skip = '1' then
                            caseScan := data_received(55 downto 48);
                            -- 5 byte skipped
						elsif d1_skip = '1' then
							caseScan := data_received(31 downto 24);
							-- 2 byte skipped
                        end if;
                    end if;
                end if;
			else
				if x1_skip = '1' then
					caseScan := data_received(47 downto 40);
					-- 4 bytes skipped
					if c1_skip = '1' then
						caseScan := data_received(55 downto 48);
						-- 5 byte skipped
						if d1_skip = '1' then
							caseScan := data_received(63 downto 56);
							-- 6 byte skipped
						end if;
					else
						if y2_skip = '1' then
							caseScan := data_received(71 downto 64);
							-- 7 byte skipped
						elsif y1_skip = '1' then
							caseScan := data_received(79 downto 72);
							-- 8 byte skipped
						elsif d1_skip = '1' then
							caseScan := data_received(55 downto 48);
							-- 5 byte skipped
						end if;
					end if;
				else
					if x2_skip = '1' then
						caseScan := data_received(39 downto 32);
						-- 3 bytes skipped
						if c1_skip = '1' then
							caseScan := data_received(47 downto 40);
							-- 4 byte skipped
							if d1_skip = '1' then
								caseScan := data_received(55 downto 48);
								-- 5 byte skipped
							end if;
						else
							if y2_skip = '1' then 
								caseScan := data_received(63 downto 56);
								-- 6 byte skipped
							elsif y1_skip = '1' then
								caseScan := data_received(71 downto 64);
								-- 7 byte skipped
							elsif d1_skip = '1' then
								caseScan := data_received(47 downto 40);
								-- 4 byte skipped 
							end if;
						end if;
					else
						if b1_skip = '1' then
							caseScan := data_received(23 downto 16);
							-- 1 byte skipped
							if c1_skip = '1' then
								caseScan := data_received(31 downto 24);
								-- 2 byte skipped
								if d1_skip = '1' then
									caseScan := data_received(39 downto 32);
									-- 3 byte skipped
								end if;
							else
								if y2_skip = '1' then
									caseScan := data_received(47 downto 40);
									-- 4 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(55 downto 48);
									-- 5 byte skipped
								elsif d1_skip = '1' then
									caseScan := data_received(31 downto 24);
									-- 2 byte skipped
								end if;
							end if;
						else
							if c1_skip = '1' then
								caseScan := data_received(23 downto 16);
								-- 1 byte skipped
								if d1_skip = '1' then
									caseScan := data_received(31 downto 24);
									-- 2 byte skipped
								end if;
							else
								if y2_skip = '1' then
									caseScan := data_received(39 downto 32);
									-- 3 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(47 downto 40);
									-- 4 byte skipped
								elsif d1_skip = '1' then
									caseScan := data_received(23 downto 16);
									-- 1 byte skipped
								else 
									caseScan := data_received(15 downto 8);
									-- normal / no skips case
								end if;
							end if;
						end if;
					end if;
				end if;
            end if;
			separator3_proc <= '0';
			case caseScan is 
				when "00100000" =>
					separator3_proc <= '1';
					nState <= s13;
				when others =>
					nState <= s1;
				end case;
		when s13 => 
			if a1_skip = '1' then
                caseScan := data_received(15 downto 8);
                -- 1 byte skipped
                if b1_skip = '1' then
                    caseScan := data_received(23 downto 16);
                    --2 byte skipped
					if c1_skip = '1' then
                        caseScan := data_received(31 downto 24);
                        -- 3 byte skipped
						if d1_skip = '1' then
							caseScan := data_received(39 downto 32);
							-- 4 byte skipped
						end if;
                    else
						if y2_skip = '1' then
							caseScan := data_received(47 downto 40);
							-- 5 byte skipped
                        elsif y1_skip = '1' then
                            caseScan := data_received(55 downto 48);
                            -- 6 byte skipped
						elsif d1_skip = '1' then
							caseScan := data_received(31 downto 24);
							-- 3 byte skipped
						end if;
					end if;
                else 	
                    if c1_skip = '1' then
                        caseScan := data_received(23 downto 16);
                        -- 2 byte skipped
						if d1_skip = '1' then
							caseScan := data_received(31 downto 24);
							-- 3 byte skipped
						end if;
                    else
						if y2_skip = '1' then
							caseScan := data_received(39 downto 32);
							-- 4 byte skipped
						elsif y1_skip = '1' then
                            caseScan := data_received(47 downto 40);
                            -- 5 byte skipped
						elsif d1_skip = '1' then
							caseScan := data_received(23 downto 16);
							-- 2 byte skipped
                        end if;
                    end if;
                end if;
			else
				if x1_skip = '1' then
					caseScan := data_received(39 downto 32);
					-- 4 bytes skipped
					if c1_skip = '1' then
						caseScan := data_received(47 downto 40);
						-- 5 byte skipped
						if d1_skip = '1' then
							caseScan := data_received(55 downto 48);
							-- 6 byte skipped
						end if;
					else
						if y2_skip = '1' then
							caseScan := data_received(63 downto 56);
							-- 7 byte skipped
						elsif y1_skip = '1' then
							caseScan := data_received(71 downto 64);
							-- 8 byte skipped
						elsif d1_skip = '1' then
							caseScan := data_received(47 downto 40);
							-- 5 byte skipped
						end if;
					end if;
				else
					if x2_skip = '1' then
						caseScan := data_received(31 downto 24);
						-- 3 bytes skipped
						if c1_skip = '1' then
							caseScan := data_received(39 downto 32);
							-- 4 byte skipped
							if d1_skip = '1' then
								caseScan := data_received(47 downto 40);
								-- 5 byte skipped
							end if;
						else
							if y2_skip = '1' then 
								caseScan := data_received(55 downto 48);
								-- 6 byte skipped
							elsif y1_skip = '1' then
								caseScan := data_received(63 downto 56);
								-- 7 byte skipped
							elsif d1_skip = '1' then
								caseScan := data_received(39 downto 32);
								-- 4 byte skipped
							end if;
						end if;
					else
						if b1_skip = '1' then
							caseScan := data_received(15 downto 8);
							-- 1 byte skipped
							if c1_skip = '1' then
								caseScan := data_received(23 downto 16);
								-- 2 byte skipped
								if d1_skip = '1' then
									caseScan := data_received(31 downto 24);
									-- 3 byte skipped
								end if;
							else
								if y2_skip = '1' then
									caseScan := data_received(39 downto 32);
									-- 4 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(47 downto 40);
									-- 5 byte skipped
								elsif d1_skip = '1' then	
									caseScan := data_received(23 downto 16);
									-- 2 byte skipped
								end if;
							end if;
						else
							if c1_skip = '1' then
								caseScan := data_received(15 downto 8);
								-- 1 byte skipped
								if d1_skip = '1' then
									caseScan := data_received(23 downto 16);
									-- 2 byte skipped
								end if;
							else
								if y2_skip = '1' then
									caseScan := data_received(31 downto 24);
									-- 3 byte skipped
								elsif y1_skip = '1' then
									caseScan := data_received(39 downto 32);
									-- 4 byte skipped
								elsif d1_skip = '1' then
									caseScan := data_received(15 downto 8);
									-- 1 byte skipped
								else 
									caseScan := data_received(7 downto 0);
									-- normal / no skips case
								end if;
							end if;
						end if;
					end if;
				end if;
            end if;
			op_proc <= '0';
			case caseScan is 
				when "00101010" | "00101011" | "00101101" =>
					op_proc <= '1'; 
					nState <= s14;-- calculate and finish
					tempOP := caseScan;
				when others =>
					nState <= s1;
				end case;
		when s14 =>
			done <= '1';
			finalA <= tempA;
			finalB <= tempB;
			finalC <= tempC;
			finalD <= tempD;
			finalOP <= tempOP;
			nState <= s1;
		end case;
	end process;
	
	process(done)
	begin
		if done = '1' then
			A <= finalA;
			B <= finalB;
			C <= finalC;
			D <= finalD;
			op <= finalOP;
		end if;
	end process;
end behavioral;