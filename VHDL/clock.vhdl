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
        clock_out <= '1'; -- Toggle clock every 10 ns
        wait for 10 ns;
        clock_out <= '0';
        wait for 10 ns;
    end process;
end Behavioral;
