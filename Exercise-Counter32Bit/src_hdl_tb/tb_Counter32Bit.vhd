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

entity tb_Counter32Bit is
end tb_Counter32Bit;

architecture Behavioral of tb_Counter32Bit is
    
    component Counter32Bit is
        port ( 
            Clk : in std_logic;
            Rst : in std_logic;
            Enable : in std_logic;
            Value : out std_logic_vector(31 downto 0)
        );
    end component;

    signal Clk : std_logic;
    signal Rst : std_logic;
    signal Enable : std_logic;
    signal Value : std_logic_vector(31 downto 0);

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
        wait for 100 ns;
        Rst <= '0';
        Enable <= '1';
        wait;
    end process;
    
    Check : process
    begin
        wait for 150 ns;
        assert Value = x"00000005" report "Test failed." severity FAILURE;
        wait for 150 ns;
        assert false report "Simulation finished with no errors" severity FAILURE;
    end process;

    Counter32Bit_i : Counter32Bit
        port map ( 
            Clk => Clk,
            Rst => Rst,
            Enable => Enable,
            Value => Value
        );

end Behavioral;
