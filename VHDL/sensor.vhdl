library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SensorModule is
    Port (
        environment : in REAL;                       -- Analog input from the environment
        clock       : in STD_LOGIC;                  -- Clock signal
        enable      : in STD_LOGIC;                  -- Enable signal
        sensor_data : out STD_LOGIC_VECTOR(7 downto 0) -- Output sensor data
    );
end SensorModule;

architecture Behavioral of SensorModule is
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if enable = '1' then
                -- Simulate an analog-to-digital conversion by scaling the environment signal
                -- (assumed to be a real number between 0.0 and 1.0) to an 8-bit digital value.
                sensor_data <= STD_LOGIC_VECTOR(TO_UNSIGNED(integer(environment * 255.0), 8));
            else
                sensor_data <= (others => '0'); -- Output zero when not enabled
            end if;
        end if;
    end process;
end Behavioral;