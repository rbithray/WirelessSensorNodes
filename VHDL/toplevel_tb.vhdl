library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity toplevel_tb is
-- Testbench has no ports
end toplevel_tb;

architecture Behavioral of toplevel_tb is

    -- Component declaration for the toplevel module
    component toplevel is
        port (
            clock        : in std_logic;
            environment  : in std_logic_vector(7 downto 0);
            sensor_data  : out std_logic_vector(7 downto 0);
            Rx           : in std_logic;
            Tx           : out std_logic;
            PMU_data     : in std_logic_vector(7 downto 0);
            mem_data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals to connect to the toplevel module
    signal clock        : std_logic := '0';
    signal environment  : std_logic_vector(7 downto 0) := (others => '0');
    signal sensor_data  : std_logic_vector(7 downto 0);
    signal Rx           : std_logic := '0';
    signal Tx           : std_logic;
    signal PMU_data     : std_logic_vector(7 downto 0) := (others => '0');
    signal mem_data_out : std_logic_vector(7 downto 0);

    -- Clock period constant
    constant clock_period : time := 20 ns;

begin

    -- Instantiate the toplevel module
    uut: toplevel
        port map (
            clock        => clock,
            environment  => environment,
            sensor_data  => sensor_data,
            Rx           => Rx,
            Tx           => Tx,
            PMU_data     => PMU_data,
            mem_data_out => mem_data_out
        );

    -- Clock generation process
    clock_process : process
    begin
        while true loop
            clock <= '0';
            wait for clock_period / 2;
            clock <= '1';
            wait for clock_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Initialise inputs
        environment <= (others => '0');
        Rx <= '0';
        PMU_data <= (others => '0');
        wait for 100 ns;

        -- Test case 1: Simulate environment changes
        environment <= "00001111";
        wait for 100 ns;

        -- Test case 2: Simulate incoming data on Rx
        Rx <= '1';
        wait for 50 ns;
        Rx <= '0';
        wait for 100 ns;

        -- Test case 3: Simulate PMU data
        PMU_data <= "10101010";
        wait for 100 ns;

        -- Add more test cases as needed

        -- End simulation
        wait;
    end process;

end Behavioral;