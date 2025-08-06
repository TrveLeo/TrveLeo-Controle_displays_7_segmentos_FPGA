library IEEE;
Use IEEE.std_logic_1164.all;

entity selectbt is 
port( clkdb: in std_logic; --50MHz
		but0 : in std_logic;
		but1 : in std_logic;
		but2 : in std_logic;
		but3 : in std_logic;
		ops  : out std_logic_vector(2 downto 0));
end selectbt;

architecture logica of selectbt is 

begin

process(clkdb)

variable vetor0 : std_logic_vector(3 downto 0) := "0000";
variable vetor1 : std_logic_vector(3 downto 0) := "0000";
variable vetor2 : std_logic_vector(3 downto 0) := "0000";
variable vetor3 : std_logic_vector(3 downto 0) := "0000";
variable cont : integer range 0 to 999999;

begin
	
 if (clkdb'event and clkdb = '1') then
   cont := cont +1 ;
	
  if (cont = 125000) then
   ops <= "000";
	vetor0(3 downto 1) := vetor0(2 downto 0);
	vetor1(3 downto 1) := vetor1(2 downto 0);
	vetor2(3 downto 1) := vetor2(2 downto 0);
	vetor3(3 downto 1) := vetor3(2 downto 0);
	vetor0(0) := but0;
	vetor1(0) := but1;
	vetor2(0) := but2;
	vetor3(0) := but3;
	if (vetor0 = "0000") then
		ops <= "001";
	end if;	
	if (vetor1 = "0000") then
		ops <= "010";
	end if;
	if (vetor2 = "0000") then
		ops <= "011";
	end if;
	if (vetor3 = "0000") then
		ops <= "100";
	end if;
  cont := 0;
  end if; 
 end if;
end process;

end logica;