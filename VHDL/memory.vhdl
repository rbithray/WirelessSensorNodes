library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory is
    Port (
        mem_addr  : in STD_LOGIC_VECTOR(7 downto 0); -- Memory address
        mem_data  : inout STD_LOGIC_VECTOR(7 downto 0); -- Memory data
        write_mem : in STD_LOGIC;                   -- Write enable signal
        clock     : in STD_LOGIC                    -- Clock signal
    );
end memory;

architecture Behavioral of memory is
begin
    process(clock)
    begin
        -- Process logic will be added here later
    end process;
end Behavioral;
