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

entity tb_ModelledMemory is
end tb_ModelledMemory;

architecture Behavioral of tb_ModelledMemory is

    component ModelledMemory is
        port ( 
            Clk : in std_logic;
            WriteEnable : in std_logic;
            Address : in std_logic_vector(7 downto 0);
            DataIn : in std_logic_vector(7 downto 0);
            DataOut : out std_logic_vector(7 downto 0)
        );
    end component;

    signal Clk : std_logic;
    signal WriteEnable : std_logic;
    signal Address : std_logic_vector(7 downto 0);
    signal DataIn : std_logic_vector(7 downto 0);
    signal DataOut : std_logic_vector(7 downto 0);

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
        WriteEnable <= '0';
        Address <= (others => '0');
        DataIn <= (others => '0');
        wait for 100 ns;
        WriteEnable <= '1';
        Address <= x"05";
        DataIn <= x"CA";
        wait for 10 ns;
        Address <= x"06";
        DataIn <= x"FE";
        wait for 10 ns;
        WriteEnable <= '0';
        Address <= (others => '0');
        DataIn <= (others => '0');
        wait;
    end process;
    
    ModelledMemory_i : ModelledMemory
        port map (
            Clk => Clk,
            WriteEnable => WriteEnable, 
            Address => Address,
            DataIn => DataIn,
            DataOut => DataOut
        );
    
end Behavioral;
