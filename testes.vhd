					
  process(switches, keys)
    signal valor : std_logic_vector(7 downto 0);
    variable cont : integer range 0 to 10;
	 variable d0, d1, d2, d3 : bit_vector (6 downto 0) := "1111111";
  begin
  
  
    if (keys(1) = '1') then
      valor <= valor + 1;
    end if;

    if (keys(2) = '1') then
      if cont > 0 then 
			cont := cont - 1;
		end if;
    end if;

    if (switches(0) = '1') then
      case cont is
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
		  when 10 =>
			cont:=0;
      end case;
		disp0 <= d0;
    end if;
	 
	 
  end process;