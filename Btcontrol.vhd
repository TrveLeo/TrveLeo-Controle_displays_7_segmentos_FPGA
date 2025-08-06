library IEEE;
Use IEEE.std_logic_1164.all;

entity Btcontrol is 
port( clkin: in std_logic; --50MHz
		bot0 : in std_logic;
		bot1 : in std_logic;
		bot2 : in std_logic;
		bot3 : in std_logic;
		LedsG : out std_logic_vector (7 downto 0);
		LedsR : out std_logic_vector (9 downto 0);
		
		segment0 : inout std_logic_vector(0 to 6) := "0000001";
		segment1 : inout std_logic_vector(0 to 6) := "0000001";
		segment2 : inout std_logic_vector(0 to 6) := "0000001";
		segment3 : inout std_logic_vector(0 to 6) := "0000001");
end Btcontrol;

architecture hardware of Btcontrol is 

signal op : std_logic_vector(2 downto 0);
signal leds : std_logic_vector (9 downto 0) := "0000000000";

component selectbt
				port( clkdb: in std_logic;
						but0 : in std_logic;
						but1 : in std_logic;
						but2 : in std_logic;
						but3 : in std_logic;
						ops  : out std_logic_vector(2 downto 0) );
end component;

begin

bt: selectbt
		port map  ( clkdb => clkin,
						but0 => bot0,
						but1 => bot1,
						but2 => bot2,
						but3 => bot3,
						ops => op );

process(clkin)
variable b1,b2,b3,b4 : std_logic;
begin
if (clkin'event and clkin = '1') then
		case op is
			when "001" => 
				if (b1 = '0') then
					leds <= leds xor "0000000001";
					b1 := '1';
					b2 := '0';
					b3 := '0';
					b4 := '0';
				end if;
			when "010" =>
				if (b2 = '0') then
					leds <= leds xor "0000000010";
					b1 := '0';
					b2 := '1';
					b3 := '0';
					b4 := '0';
				end if;
			when "011" =>
				if (b3 = '0') then
					leds <= leds xor "0000000100";
					b1 := '0';
					b2 := '0';
					b3 := '1';
					b4 := '0';
				end if;
			when "100" =>
				if (b4 = '0') then
					leds <= leds xor "0000001000";
					b1 := '0';
					b2 := '0';
					b3 := '0';
					b4 := '1';
				end if;
			when Others => 
				leds <= leds xor "0000000000";
				b1 := '0';
				b2 := '0';
				b3 := '0';
				b4 := '0';
		end case;
	
end if;
		
LedsR <= leds;		
LedsG(0) <= op(0);
LedsG(1) <= op(1);
LedsG(2) <= op(2);

end process;

end hardware;