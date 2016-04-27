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
use IEEE.NUMERIC_STD.ALL;

entity FloatAdd32Bit is
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
end FloatAdd32Bit;

architecture Behavioral of FloatAdd32Bit is

    component floating_point_0 is
      port ( 
        aclk : in STD_LOGIC;
        s_axis_a_tvalid : in STD_LOGIC;
        s_axis_a_tready : out STD_LOGIC;
        s_axis_a_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        s_axis_b_tvalid : in STD_LOGIC;
        s_axis_b_tready : out STD_LOGIC;
        s_axis_b_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        m_axis_result_tvalid : out STD_LOGIC;
        m_axis_result_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 )
      );
    end component;

begin

    floating_point_0_i : floating_point_0
      port map ( 
        aclk => Clk,
        s_axis_a_tvalid => OperandAValid,
        s_axis_a_tready => OperandAReady,
        s_axis_a_tdata => OperandA,
        s_axis_b_tvalid => OperandBValid,
        s_axis_b_tready => OperandBReady,
        s_axis_b_tdata => OperandB,
        m_axis_result_tvalid => ResultValid,
        m_axis_result_tdata => Result
      );

end Behavioral;
