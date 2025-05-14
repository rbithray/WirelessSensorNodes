library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SensorModule is
    Port (
        environment : in STD_LOGIC_VECTOR(7 downto 0); -- Input from the environment
        clock       : in STD_LOGIC;                   -- Clock signal
        enable      : in STD_LOGIC;                   -- Enable signal
        sensor_data : out STD_LOGIC_VECTOR(7 downto 0) -- Output sensor data
    );
end SensorModule;

architecture Behavioral of SensorModule is
begin
    process(clock)
    begin
        -- Process logic will be added here later
    end process;
end Behavioral;