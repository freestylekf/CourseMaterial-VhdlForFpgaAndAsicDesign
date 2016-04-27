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

entity tb_FloatAdd32Bit is
end tb_FloatAdd32Bit;

architecture Behavioral of tb_FloatAdd32Bit is

    component FloatAdd32Bit is
        port ( 
            Clk : in std_logic;
            Rst : in std_logic;
            OperandAValid : in std_logic;
            OperandAReady : out std_logic;
            OperandA : in std_logic_vector(31 downto 0);
            OperandBValid : in std_logic;
            OperandBReady : out std_logic;
            OperandB : in std_logic_vector(31 downto 0);
            Result : out std_logic_vector(31 downto 0);
            ResultValid : out std_logic
        );
    end component;

    signal Clk : std_logic;
    signal Rst : std_logic;
    signal OperandAValid : std_logic;
    signal OperandAReady : std_logic;
    signal OperandA : std_logic_vector(31 downto 0);
    signal OperandBValid : std_logic;
    signal OperandBReady : std_logic;
    signal OperandB : std_logic_vector(31 downto 0);
    signal Result : std_logic_vector(31 downto 0);
    signal ResultValid : std_logic;

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
        OperandAValid <= '0';
        OperandBValid <= '0';
        OperandA <= (others => '0');
        OperandB <= (others => '0');
        wait for 100 ns;
        OperandA <= x"40000000"; -- 2.0f
        OperandB <= x"C0400000";
        OperandAValid <= '1';
        OperandBValid <= '1';
        wait for 10 ns;
        OperandAValid <= '0';
        OperandBValid <= '0';
        wait for 200 ns;
        OperandA <= x"40000000"; -- 2.0f
        OperandB <= x"C1700000"; -- -15.0f
        OperandAValid <= '1';
        OperandBValid <= '1';
        wait for 10 ns;
        OperandAValid <= '0';
        OperandBValid <= '0';
        wait;
    end process;

    FloatAdd32Bit_i : FloatAdd32Bit
        port map ( 
            Clk => Clk,
            Rst => Rst,
            OperandAValid => OperandAValid,
            OperandAReady => OperandAReady,
            OperandA => OperandA,
            OperandBValid => OperandBValid,
            OperandBReady => OperandBReady,
            OperandB => OperandB,
            Result => Result,
            ResultValid => ResultValid
        );

end Behavioral;
