library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity toplevel is
    Port (
        clk       : in  STD_LOGIC;       -- Clock input
        sensor_in : in  STD_LOGIC_VECTOR(7 downto 0); -- Sensor data input
        comm   : out STD_LOGIC_VECTOR(7 downto 0)  -- Radio/Antenna output
    );
end toplevel;

architecture Behavioral of toplevel is
    signal processed_data : STD_LOGIC_VECTOR(7 downto 0);
begin

    -- Example process for handling sensor data
    process(clk)
    begin
        if rising_edge(clk) then
            -- Simple passthrough or processing logic
            processed_data <= sensor_in; -- Replace with actual processing logic
        end if;
    end process;

    -- Assign processed data to antenna output
    antenna <= processed_data;

end Behavioral;