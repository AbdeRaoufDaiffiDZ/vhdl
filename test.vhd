library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY TEST IS 
port(
data: in unsigned(3 downto 0);
dataout: out unsigned(7 downto 0)
);
end test;


architecture arc of test is

begin

	process(data) 
		begin
		
			dataout <= data * 3 / 2;
		end process;

end arc;