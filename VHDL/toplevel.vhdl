library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity toplevel is
    Port (
        clk     : in  STD_LOGIC;
        sensor  : in  STD_LOGIC_VECTOR(7 downto 0);
        comms   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end toplevel;

architecture Behavioral of toplevel is

    -- Component declarations
    component memory is
        Port (
            clk     : in  STD_LOGIC;
            data_in : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component controller is
        Port (
            clk     : in  STD_LOGIC;
            sensor  : in  STD_LOGIC_VECTOR(7 downto 0);
            mem_data: in  STD_LOGIC_VECTOR(7 downto 0);
            comms   : out STD_LOGIC_VECTOR(7 downto 0);
            mem_wr  : out STD_LOGIC;
            mem_in  : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Signals for interconnection
    signal mem_data_out : STD_LOGIC_VECTOR(7 downto 0);
    signal mem_wr       : STD_LOGIC;
    signal mem_data_in  : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Instantiate memory
    mem_inst : memory
        Port map (
            clk     => clk,
            data_in => mem_data_in,
            data_out=> mem_data_out
        );

    -- Instantiate controller
    ctrl_inst : controller
        Port map (
            clk     => clk,
            sensor  => sensor,
            mem_data=> mem_data_out,
            comms   => comms,
            mem_wr  => mem_wr,
            mem_in  => mem_data_in
        );

end Behavioral;