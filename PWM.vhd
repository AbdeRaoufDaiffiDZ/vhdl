library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PWM is 
 generic (
	 pwm_period : integer := 10;-- pwm period, defult is 20ms
	 min_value: integer:= 0; -- the max range of the input value in order to map to pwm period value
	 max_input_range: integer:= 4096 -- the max range of the input value in order to map to pwm period value
  );
port(
Clk: in std_logic; -- clk signal that will be  taken from clock divider 
pwm_input : in unsigned(11 downto 0); -- the input of duty_cycle will be the refernce value of the length of the pwm cycle
pwm_out : out std_logic-- the output pwm signal after being generated
);
end PWM; 


architecture arc of PWM is

signal pwm_cnt: integer := 0; -- the counter will be incremanted each clk cycle in order to generate pwm signal
signal mapped_input: integer range 0 to pwm_period ; -- this will hold the mapped value of the input

begin
	mapped_input <= min_value + (((pwm_period - min_value)*to_integer(pwm_input)) / max_input_range);

process(clk)
begin
	

  if rising_edge(clk) then
				 pwm_cnt <= pwm_cnt +1; -- increment the counter of

			if pwm_cnt < mapped_input  then -- check if pwm counter is less then the desierd value of duty cycle
				pwm_out <= '1';  -- if true set output ti HIGH
			ELSif pwm_cnt >= pwm_period then -- check whethere the counter reaches the max value which is the pwm period or not, if yes reset the counter
				pwm_cnt <= 0;
			else
				pwm_out <= '0'; -- if false set output to LOW
			end if;
      			
  end if; 
	
end process;
	
		
end arc;
