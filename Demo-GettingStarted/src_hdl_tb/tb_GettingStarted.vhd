----------------------------------------------------------------------------------
-- MIT License (MIT)
-- 
-- Copyright (c) 2016 Denis Vasilik
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy 
-- of this software and associated documentation files (the "Software"), to deal 
-- in the Software without restriction, including without limitation the rights 
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
-- copies of the Software, and to permit persons to whom the Software is furnished
--  to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
-- SOFTWARE.
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_GettingStarted is
end tb_GettingStarted;

architecture Behavioral of tb_GettingStarted is

    component GettingStarted is
        port ( 
            Clk : in std_logic;
            Rst : in std_logic;
            ClockEnable : in std_logic;
            Data1 : in std_logic;
            Data2 : in std_logic;
            Q : out std_logic
        );
    end component;
    
    signal Clk : std_logic;
    signal Rst : std_logic;
    
    signal Q : std_logic;
    signal Data1 : std_logic;
    signal Data2 : std_logic;
    signal ClockEnable : std_logic;

begin

    ClkGen : process
    begin
        wait for 5 ns;
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
    end process;

    StimGen : process
    begin
        Rst <= '1';
        ClockEnable <= '0';
        Data1 <= '0';
        Data2 <= '0';
        wait for 100 ns;
        Rst <= '0';
        wait for 10 ns;
        ClockEnable <= '1';
        wait for 10 ns;
        Data1 <= '1';
        wait for 10 ns;
        Data2 <= '1';
        wait;
    end process;
    
    Check : process
    begin
        wait for 150 ns;
        assert Q = '1' report "Test failed." severity FAILURE;
        assert false report "Simulation finished with no errors" severity FAILURE;
    end process;
    
    GettingStarted_i : GettingStarted
        port map ( 
            Clk => Clk, 
            Rst => Rst,
            ClockEnable => ClockEnable,
            Data1 => Data1,
            Data2 => Data2,
            Q => Q
        );
    
end Behavioral;
