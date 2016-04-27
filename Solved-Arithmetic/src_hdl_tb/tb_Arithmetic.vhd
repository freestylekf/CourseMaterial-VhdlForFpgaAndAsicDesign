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

library work;
use work.ArithmeticPackage.all;

entity tb_Arithmetic is
end tb_Arithmetic;

architecture Behavioral of tb_Arithmetic is

    component Arithmetic is
        port ( 
            Clk : in std_logic;
            Rst : in std_logic;
            MathFunc : in MathFuncEnum;
            OperandA : in std_logic_vector(7 downto 0);
            OperandB : in std_logic_vector(7 downto 0);
            Result : out std_logic_vector(7 downto 0)
        );
    end component;

    signal Clk : std_logic;
    signal Rst : std_logic;
    signal MathFunc : MathFuncEnum;
    signal OperandA : std_logic_vector(7 downto 0);
    signal OperandB : std_logic_vector(7 downto 0);
    signal Result : std_logic_vector(7 downto 0);

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
        OperandA <= (others => '0');
        OperandB <= (others => '0');
        MathFunc <= Nop;
        wait for 50 ns;
        Rst <= '0';
        OperandA <= x"05";
        OperandB <= x"04";
        wait for 10 ns;
        MathFunc <= Add;
        wait for 10 ns;
        MathFunc <= Nop;
        wait for 50 ns;
        MathFunc <= Mul;
        wait for 10 ns;
        MathFunc <= Nop;
        wait;
    end process;
    
    Check : process
    begin
        wait for 70 ns;
        assert Result = x"09" report "Test failed." severity FAILURE;
        wait for 70 ns;
        assert Result = x"14" report "Test failed." severity FAILURE;
        wait for 150 ns;
        assert false report "Simulation finished with no errors" severity FAILURE;
    end process;
    
    Arithmetic_i : Arithmetic
        port map (
            Clk => Clk,
            Rst => Rst,
            MathFunc => MathFunc,
            OperandA => OperandA,
            OperandB => OperandB,
            Result => Result
        );
    
end Behavioral;
