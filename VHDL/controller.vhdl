library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port (
        clock           : in STD_LOGIC;                   -- Clock signal
        enable          : in STD_LOGIC;                   -- Enable signal
        sensor_data     : in STD_LOGIC_VECTOR(7 downto 0); -- Sensor data input
        memory_data     : in STD_LOGIC_VECTOR(7 downto 0); -- Memory data input
        radio_data      : in STD_LOGIC_VECTOR(7 downto 0); -- Radio data input
        write_to_memory : out STD_LOGIC;                  -- Write enable signal
        memory_data_out : out STD_LOGIC_VECTOR(7 downto 0); -- Memory data output
        memory_address  : out STD_LOGIC_VECTOR(7 downto 0); -- Memory address output
        radio_Tx        : out STD_LOGIC;                  -- Radio transmit signal
        enables         : out STD_LOGIC_VECTOR(2 downto 0); -- Enables for sensor, radio, memory
        PMU_data        : in STD_LOGIC_VECTOR(7 downto 0)  -- PMU data input
    );
end controller;

architecture Behavioral of controller is
begin
    process(clock)
    begin
        -- Process logic will be added here later
    end process;
end Behavioral;
