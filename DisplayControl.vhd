-- Leandro Baldan


--Inicializa as bibliotecas necessárias
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



--Define a entidade displayControl
entity DisplayControl is
  port(
    switches : in bit_vector(3 downto 0); --Switches
    keys : in  std_logic_vector(3 downto 0); --Botões
    disp0 : inout bit_vector(0 to 6) :="0000001"; --Segmentos do Display 0
    disp1 : inout bit_vector(0 to 6); --Segmentos do Display 1
    disp2 : inout bit_vector(0 to 6); --Segmentos do Display 2
    disp3 : inout bit_vector(0 to 6); --Segmentos do Display 3
	 clkin : in std_logic -- Sinal de clock (necessário para o debounce e para verificar transição de borda dos botões)
  );
end DisplayControl;

architecture logic of DisplayControl is

signal op : std_logic_vector(2 downto 0); --Sinais correspondentes à opão de botão
signal b0, b1, b2, b3: std_logic; -- sinai correspondentes ao botão pressionado


-- Traz o componente que aplica o debounce
component selectbt
				port( clkdb: in std_logic;
						but0 : in std_logic;
						but1 : in std_logic;
						but2 : in std_logic;
						but3 : in std_logic;
						ops  : out std_logic_vector(2 downto 0) );					
end component;

begin

-- Mapeamento de portas entre o displayControl e selectbt
bt: selectbt
		port map  ( clkdb => clkin,
						but0 => keys(0),
						but1 => keys(1),
						but2 => keys(2),
						but3 => keys(3),
						ops => op);



				
						
						
process(clkin, keys, b0,b1,b2,b3) -- Processo que define o botão pressionado
begin
if (clkin'event and clkin = '1') then
		case op is
			when "001" => 
				if (b0= '0') then
					b0<= '1';
					b1<= '0';
					b2<= '0';
					b3<= '0';
				end if;
			when "010" =>
				if (b1= '0') then
					b0<= '0';
					b1<= '1';
					b2<= '0';
					b3<= '0';
				end if;
			when "011" =>
				if (b2= '0') then
					b0<= '0';
					b1<= '0';
					b2<= '1';
					b3<= '0';
				end if;
			when "100" =>
				if (b3= '0') then
					b0<= '0';
					b1<= '0';
					b2<= '0';
					b3<= '1';
				end if;
			when Others => 
				b0<= '0';
				b1<= '0';
				b2<= '0';
				b3<= '0';
		end case;
	
end if;


end process;						
						
						
process(clkin,b0,b1,switches) --Processo responsável por controlar os displays

	variable d0, d1, d2, d3 : bit_vector (6 downto 0) := "1111111"; --Variavel que armazena o estado do display
	variable valor1 : integer :=0; -- Variável que armazena o valor do display0
	variable valor2 : integer :=0; --Variável que armazena o valor do display1
	variable valor3 : integer :=0; --Variável que armazena o valor do display2
	variable valor4 : integer :=0; --Variável que armazena o valor do display3
	variable keys_a : std_logic_vector(3 downto 0) := "0000"; --Variável que armazena o estado anterior dos botões
  begin

  
if rising_edge(clkin) then --Todo processo ocorre apartir de uma transição do clock

  if (valor1=0 and valor2=0 and valor3=0 and valor4=0) then
		disp0 <= "0000001";
		disp1 <= "0000001";
		disp2 <= "0000001";
		disp3 <= "0000001";
end if;

--CONTROLE DO display0
if (switches(0) = '1') then --Verifica se o display está acionado
	

		if (b0 = '1' and keys_a(0) ='0') then -- Verifica se houve uma transição de borda de subida do botão		
			valor1 := valor1 + 1; --Botão 0 acrescenta +1 no display			
			if (valor1 = 10) then -- Verifica se a variável valor1 é igual a 10			
				valor1 := 0; -- Se for 10, valor1 retorna a zero
			end if;
		end if;
		
		
		if (b1 = '1' and keys_a(1) ='0') then --Verifica se houve uma transição de borda de subida do botão		
			valor1 := valor1 - 1;  --Botão 1 decrementa -1 no display			
			if (valor1<0) then -- Verifica se a variável valor1 é menor que zero			
				valor1:=9;-- Se for menor que zero , valor1 retorna a 9
				
			end if;
		end if;
		
		if (b2 = '1' and keys_a(2) = '0') then --Verifica se houve uma transição de borda de subida do botão
			valor1:=0;  --Botão 2 zera o display
		end if;
		
--Atribuiçãoi de valores no display
	case valor1 is
        when 0 => 
		  d0 := "0000001";
        when 1 => 
		  d0 := "1001111";
        when 2 => 
		  d0 := "0010010";
        when 3 => 
		  d0 := "0000110";
        when 4 => 
		  d0 := "1001100";
        when 5 => 
		  d0 := "0100100";
        when 6 => 
		  d0 := "0100000";
        when 7 => 
		  d0 := "0001111";
        when 8 => 
		  d0 := "0000000";
        when 9 => 
		  d0 := "0000100";
		  when others =>
		  d0 := "0000001";
      end case;
		disp0 <= d0;
		
end if;

	
	--ABAIXO A LÓGICA É A MESMA PARA OS OUTROS 3 DISPLAYS
	
if (switches(1) = '1') then
	
		if (b0 = '1' and keys_a(0) ='0') then
			valor2 := valor2+ 1;
			if (valor2 = 10) then
				valor2 := 0;
			end if;
		end if;
		
		if (b1 = '1' and keys_a(1) ='0') then
			valor2 := valor2 - 1;
			if (valor2<0) then
				valor2:=9;
			end if;
		end if;
		
		if (b2 = '1' and keys_a(2) = '0') then
			valor2:=0;
		end if;
		
  
	case valor2 is
        when 0 => 
		  d1 := "0000001";
        when 1 => 
		  d1 := "1001111";
        when 2 => 
		  d1 := "0010010";
        when 3 => 
		  d1 := "0000110";
        when 4 => 
		  d1 := "1001100";
        when 5 => 
		  d1 := "0100100";
        when 6 => 
		  d1 := "0100000";
        when 7 => 
		  d1 := "0001111";
        when 8 => 
		  d1 := "0000000";
        when 9 => 
		  d1 := "0000100";
		  when others =>
		  d1 := "0000001";
      end case;
		disp1 <= d1;
		
end if;

if (switches(2) = '1') then
	
		if (b0 = '1' and keys_a(0) ='0') then
			valor3 := valor3+ 1;
			if (valor3 = 10) then
				valor3 := 0;
			end if;
		end if;
		
		if (b1 = '1' and keys_a(1) ='0') then
			valor3 := valor3 - 1;
			if (valor3<0) then
				valor3:=9;
			end if;
		end if;
		
		if (b2 = '1' and keys_a(2) = '0') then
			valor3:=0;
		end if;
		
  
	case valor3 is
        when 0 => 
		  d2 := "0000001";
        when 1 => 
		  d2 := "1001111";
        when 2 => 
		  d2 := "0010010";
        when 3 => 
		  d2 := "0000110";
        when 4 => 
		  d2 := "1001100";
        when 5 => 
		  d2 := "0100100";
        when 6 => 
		  d2 := "0100000";
        when 7 => 
		  d2 := "0001111";
        when 8 => 
		  d2 := "0000000";
        when 9 => 
		  d2 := "0000100";
		  when others =>
		  d2 := "0000001";
      end case;
		disp2 <= d2;
		
end if;


if (switches(3) = '1') then
	
		if (b0 = '1' and keys_a(0) ='0') then
			valor4 := valor4+ 1;
			if (valor4 = 10) then
				valor4 := 0;
			end if;
		end if;
		
		if (b1 = '1' and keys_a(1) ='0') then
			valor4 := valor4 - 1;
			if (valor4<0) then
				valor4:=9;
			end if;
		end if;
		
		if (b2 = '1' and keys_a(2) = '0') then
			valor4:=0;
		end if;
		
  
	case valor4 is
        when 0 => 
		  d3 := "0000001";
        when 1 => 
		  d3 := "1001111";
        when 2 => 
		  d3 := "0010010";
        when 3 => 
		  d3 := "0000110";
        when 4 => 
		  d3 := "1001100";
        when 5 => 
		  d3 := "0100100";
        when 6 => 
		  d3 := "0100000";
        when 7 => 
		  d3 := "0001111";
        when 8 => 
		  d3 := "0000000";
        when 9 => 
		  d3 := "0000100";
		  when others =>
		  d3 := "0000001";
      end case;
		disp3 <= d3;
		
end if;


--Atualiza o valor anterior dos botões
		keys_a(0) := b0; 
		keys_a(1) := b1;
		keys_a(2) := b2;
end if;
  
  
  end process;
  end logic;