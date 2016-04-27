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

entity GettingStarted is
    port ( 
        Clk : in std_logic;
        Rst : in std_logic;
        ClockEnable : in std_logic;
        Data1 : in std_logic;
        Data2 : in std_logic;
        Q : out std_logic
    );
end GettingStarted;

architecture Behavioral of GettingStarted is

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

    signal Data : std_logic;

begin

    FDRE_i0 : FDRE
    generic map (
        INIT => '0'
    )
    port map (
        Q => Q,
        C => Clk,
        CE => ClockEnable,
        R => Rst,
        D => Data
    );
    
    LUT2_i0 : LUT2
        generic map (
            INIT => "1000" -- and
        )
        port map (
            O => Data,
            I0 => Data1,
            I1 => Data2
        );

end Behavioral;
