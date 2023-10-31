library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LEDs is


port(
number_inc: in unsigned(11 downto 0);
bit1: out std_logic;
bit2:out std_logic;
bit3:out std_logic;
bit4:out std_logic;
bit5:out std_logic;
bit6:out std_logic;
bit7:out std_logic;
bit8:out std_logic;
bit9:out std_logic;
bit10:out std_logic;
bit11:out std_logic;
bit12:out std_logic
);

end LEDs;




architecture arc of LEDs is

begin

bit1<= number_inc(0);
bit2<= number_inc(1);
bit3<= number_inc(2);
bit4<= number_inc(3);
bit5<= number_inc(4);
bit6<= number_inc(5);
bit7<= number_inc(6);
bit8<= number_inc(7);
bit9<= number_inc(8);
bit10<= number_inc(9);
bit11<= number_inc(10);
bit12<= number_inc(11);
	
end arc;