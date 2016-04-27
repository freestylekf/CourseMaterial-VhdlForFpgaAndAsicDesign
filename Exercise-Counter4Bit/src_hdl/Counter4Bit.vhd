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
library UNISIM;
use UNISIM.VComponents.all;

entity Counter4Bit is
    port (
        Clk : in std_logic;
        Rst : in std_logic;
        Value : out std_logic_vector(3 downto 0)
    );
end Counter4Bit;

architecture Behavioral of Counter4Bit is

    component FDRE
    generic (
        INIT : BIT
    );
    port (
        Q : out std_logic;
        C : in std_logic;
        CE : in std_logic;
        R : in std_logic;
        D : in std_logic
    );
    end component;
    
    component LUT2
        generic (
            INIT : BIT_VECTOR(3 downto 0)
        );
        port (
            O : out std_logic;
            I0 : in std_logic;
            I1 : in std_logic
        );
    end component;
    
    component LUT1
        generic (
            INIT : BIT_VECTOR(1 downto 0)
        );
        port (
            O : out std_logic;
            I0 : in std_logic
        );
    end component;
    
    signal Q0, Q1, Q2, Q3 : std_logic;
    signal CE : std_logic;
    signal O0, O1 : std_logic;

begin

    CE <= '1';
    Value <= Q3 & Q2 & Q1 & Q0;
    
    -- Instantiate FDREs and LUTs Here

end Behavioral;
