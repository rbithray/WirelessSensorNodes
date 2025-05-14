library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock is
    Port (
        clock_out : out STD_LOGIC -- Output clock signal
    );
end clock;

architecture Behavioral of clock is
begin
    process
    begin
        clock_out <= not clock_out after 10 ns; -- Toggle clock every 10 ns
    end process;
end Behavioral;
