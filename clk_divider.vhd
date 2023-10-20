LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY clk_divider IS
    GENERIC (
        period_max : INTEGER := 50000000 -- max counting number for clock slow
    );
    PORT (
        clk : IN STD_LOGIC; -- clock input;

        clk_slow : OUT STD_LOGIC -- clock output which gonna be slow when it will be devided

    );
END clk_divider;
ARCHITECTURE arc OF clk_divider IS
    SIGNAL clk_counter : INTEGER := 1;
    SIGNAL tmp : STD_LOGIC := '0';

BEGIN
    divider : PROCESS (clk)
    BEGIN
        IF (clk' event AND clk = '1') THEN
            clk_counter <= clk_counter + 1;

            IF (clk_counter = period_max) THEN -- if the counter excied the max number return to 0
                tmp <= NOT tmp;
                clk_counter <= 1;
            END IF;

        END IF;
    END PROCESS;
    clk_slow <= tmp;

END arc;