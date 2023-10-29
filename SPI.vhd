library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SPI is 
generic(
control_bits: unsigned(7 downto 0):= "00011000"; -- the 3 forst zeros are add on order to make the word 8bits, the first 1 is the starting bits
avrg_width: integer:=1; 
word_width: integer:= 24
);
port(
MOSI: out std_logic; -- the master output slave input pin or input to ADC 
MISO: in std_logic; -- the slave output master input data or the output data from ADC
SCLK: in std_logic; -- the SPI protocol clock
ADC_CLK: out std_logic; -- the ADC clock
ADC_CS: out std_logic := '1'; -- the ship select pin
data_rec: out unsigned(11 downto 0); -- the recived data from ADC in form of 1 byte word
numberout: out std_logic
);


end SPI;


architecture arc of SPI is 
signal tx_data: unsigned(word_width - 1 downto 0); -- transmited data from FPGA to SPI ship
signal rx_data: unsigned(word_width - 1 downto 0);	-- recived data from SPI ship to FPGA
signal data_tx_counter: integer:= word_width;		-- a counter to count in each rising edge of the clock in order to send data
signal data_rx_counter: integer:= word_width;		-- a counter to count in each falling edge of the clock in order to recive data
signal avr_data: unsigned(11 downto 0);
SIGNAL avrg: integer:=avrg_width;
signal ADC_CS_linker: std_logic := '1';		-- this value will link the ship select value 

begin

    -- SPI communication process
	 
	 
spi_tx_data: process(SCLK,ADC_CS_linker)  -- the transmission process on each rising_edge
		begin			
			ADC_CS <=  ADC_CS_linker; -- set the ship select to 1 or 0 according to the rising_edge counter
			if(rising_edge(SCLK)) then
					data_tx_counter <= data_tx_counter -1; -- decrese in each clock 
					if(data_tx_counter < 1) then
						ADC_CS_linker <= '1';  -- set ship select to 1 in preparing it to the next data tranciver
						data_tx_counter <= word_width; -- reload the word value to the counter

					elsif(data_tx_counter = word_width) then -- if counter is initialized then set ship select to 0 for data to be send 
						tx_data(word_width - 1 downto 16) <= control_bits; -- reload the control data to the transmission word
						ADC_CS_linker <= '0';  -- CS is active low

					else 
						MOSI <= tx_data(data_tx_counter); -- shift data to the MOSI or to the SPI ship 

					end if;
					
					
				

			end if;
		end process spi_tx_data;


spi_rx_data: process(SCLK)		 -- the reciving  process on each falling_edge
		begin
	if(falling_edge(SCLK)) then
					data_rx_counter <= data_rx_counter -1; -- decrese in each clock 
					if(data_rx_counter = word_width) then
						rx_data(word_width - 1 downto 0) <= (others => '0'); -- set the reciving word to 0 preparing it to next recived word
					elsif(data_rx_counter = 0) then 
						avrg <= avrg -1;
						avr_data <= avr_data + rx_data(13 downto 2); -- addition of data in order to count the average but is not used since the value of number of summition is set to 1
						data_rx_counter <= word_width; -- reload initinal value to the reciving counter
						
					elsif(avrg = 0) then 
								data_rec <= avr_data / avrg_width;
								avrg <= avrg_width;	
					elsif(avrg = avrg_width) then 
								avr_data <= (others => '0');		
					end if;
					rx_data(data_rx_counter) <= MISO;
					numberout <= MISO;
			
			end if;
		end process spi_rx_data;
			

ADC_CLK <= SCLK;		


	

end arc;