library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity radio is
    Port (
        Rx         : in STD_LOGIC;                   -- Input signal
        enable     : in STD_LOGIC;                   -- Enable signal
        clock      : in STD_LOGIC;                   -- Clock signal
        Tx         : out STD_LOGIC;                  -- Output signal
        radio_data : out STD_LOGIC_VECTOR(7 downto 0) -- Radio data output
    );
end radio;

architecture Behavioral of radio is
begin
    process(clock)
    begin
        -- Process logic will be added here later
    end process;
end Behavioral;
