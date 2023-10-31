library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MISO is
generic(
data: unsigned(23 downto 0) := "000000000000000000001000" -- max counting number for clock period
);
port(
clk: in std_logic; -- clock input;
start: in std_logic := '1';
data_out: out std_logic
);
end MISO;


architecture arc of MISO is 

signal data_counter: integer := 23;

begin

process(clk, start)
begin
	if clk' event and clk = '0' then 
			data_counter <= data_counter - 1; 
			
			if  start = '1' then 
			 	data_counter <= 23;
			end if;
			data_out<= data(data_counter);

	end if;

	
	end process;

end arc;