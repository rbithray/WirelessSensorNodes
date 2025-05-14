library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity toplevel is
    port (
        -- Clock signal
        clock : in std_logic;

        -- Sensor module
        environment : in std_logic_vector(7 downto 0);
        sensor_data : out std_logic_vector(7 downto 0);

        -- Radio
        Rx : in std_logic;
        Tx : out std_logic;

        -- PMU
        PMU_data : in std_logic_vector(7 downto 0);

        -- Memory
        mem_data_out : out std_logic_vector(7 downto 0)
    );
end toplevel;

architecture Behavioral of toplevel is

    -- Signals for interconnections
    signal enable_sensor, enable_radio, enable_memory : std_logic;
    signal write_mem : std_logic;
    signal mem_addr : std_logic_vector(7 downto 0);
    signal mem_data_in : std_logic_vector(7 downto 0);
    signal radio_data : std_logic_vector(7 downto 0);
    signal controller_mem_data : std_logic_vector(7 downto 0);
    signal controller_mem_addr : std_logic_vector(7 downto 0);
    signal controller_radio_tx : std_logic;

begin

    -- Sensor module instantiation
    SensorModule_inst : entity work.SensorModule
        port map (
            environment => environment,
            clock => clock,
            enable => enable_sensor,
            sensor_data => sensor_data
        );

    -- Radio instantiation
    Radio_inst : entity work.Radio
        port map (
            Rx => Rx,
            enable => enable_radio,
            clock => clock,
            Tx => Tx,
            radio_data => radio_data
        );

    -- Memory instantiation
    Memory_inst : entity work.Memory
        port map (
            mem_addr => mem_addr,
            mem_data => mem_data_in,
            write_mem => write_mem,
            clock => clock,
            mem_data => mem_data_out
        );

    -- PMU instantiation
    PMU_inst : entity work.PMU
        port map (
            PMU_data => PMU_data,
            clock => clock,
            enable => enable_sensor & enable_radio & enable_memory
        );

    -- Controller instantiation
    Controller_inst : entity work.Controller
        port map (
            clock => clock,
            enable => enable_sensor & enable_radio & enable_memory,
            sensor_data => sensor_data,
            memory_data => mem_data_out,
            radio_data => radio_data,
            write_to_memory => write_mem,
            memory_data => controller_mem_data,
            memory_address => controller_mem_addr,
            radio_Tx => controller_radio_tx,
            enables => enable_sensor & enable_radio & enable_memory,
            PMU_data => PMU_data
        );

end Behavioral;