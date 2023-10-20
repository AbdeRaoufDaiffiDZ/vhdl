LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY PWM IS
    GENERIC (
        pwm_period : INTEGER := 1000000;-- pwm period, defult is 20ms
        max_input_range : INTEGER := 4096 -- the max range of the input value in order to map to pwm period value
    );
    PORT (
        Clk : IN STD_LOGIC; -- clk signal that will be  taken from clock divider 
        rst : IN STD_LOGIC; -- to rest the pwm to 0 if its HIGH
        pwm_input : IN INTEGER RANGE 0 TO max_input_range; -- the input of duty_cycle will be the refernce value of the length of the pwm cycle
        pwm_out : OUT STD_LOGIC -- the output pwm signal after being generated
    );
END PWM;
ARCHITECTURE arc OF PWM IS

    SIGNAL pwm_cnt : INTEGER := 1; -- the counter will be incremanted each clk cycle in order to generate pwm signal
    SIGNAL input_range : INTEGER RANGE 0 TO max_input_range; -- this var will hold the value of the input from SPI protocol
    SIGNAL mapped_input : INTEGER RANGE 0 TO pwm_period; -- this will hold the mapped value of the input

BEGIN
    input_range <= pwm_input;
    mapped_input <= input_range * (pwm_period / max_input_range);

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN -- rest the pwm counter, pwm output when its HIGH
                pwm_cnt <= 1;
                pwm_out <= '0';

            ELSE
                IF pwm_cnt < mapped_input THEN -- check if pwm counter is less then the desierd value of duty cycle
                    pwm_out <= '1'; -- if true set output ti HIGH
                ELSE
                    pwm_out <= '0'; -- if false set output to LOW
                END IF;
            END IF;
            pwm_cnt <= pwm_cnt + 1; -- increment the counter of
        END IF;

        IF pwm_cnt >= pwm_period THEN -- check whethere the counter reaches the max value which is the pwm period or not, if yes reset the counter
            pwm_cnt <= 1;

        END IF;

    END PROCESS;
END arc;