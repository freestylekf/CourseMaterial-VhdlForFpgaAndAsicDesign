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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.ArithmeticPackage.all;

entity Arithmetic is
    port ( 
        Clk : in std_logic;
        Rst : in std_logic;
        MathFunc : in MathFuncEnum;
        OperandA : in std_logic_vector(7 downto 0);
        OperandB : in std_logic_vector(7 downto 0);
        Result : out std_logic_vector(7 downto 0)
    );
end Arithmetic;

architecture Behavioral of Arithmetic is

begin

    MathCalculator : process (Clk)
    begin
        if rising_edge(Clk) then
            if( Rst = '1' ) then
                Result <= (others => '0');
            else
                case MathFunc is
                    when Add =>
                        Result <= std_logic_vector(unsigned(OperandA) + unsigned(OperandB));
                    when Sub =>
                        Result <= std_logic_vector(unsigned(OperandA) - unsigned(OperandB));
                    when Mul => 
                        Result <= std_logic_vector(unsigned(OperandA(3 downto 0)) * unsigned(OperandB(3 downto 0)));
                    when Div =>
                        Result <= std_logic_vector(unsigned(OperandA) / unsigned(OperandB));
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
