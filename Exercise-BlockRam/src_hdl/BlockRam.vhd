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

entity BlockRamWrapper256x8 is
    port ( 
      Clk : in std_logic;
      WriteEnableA : in std_logic_vector(0 to 0);
      AddressA : in std_logic_vector(7 downto 0);
      DataInA : in std_logic_vector(7 downto 0);
      DataOutA : out std_logic_vector(7 downto 0);
      WriteEnableB : in std_logic_vector(0 to 0);
      AddressB : in std_logic_vector(7 downto 0);
      DataInB : in std_logic_vector(7 downto 0);
      DataOutB : out std_logic_vector(7 downto 0)
    );
end BlockRamWrapper256x8;

architecture Behavioral of BlockRamWrapper256x8 is

    component blk_mem_gen_0 is
      port ( 
        clka : in std_logic;
        wea : in std_logic_vector(0 to 0);
        addra : in std_logic_vector(7 downto 0);
        dina : in std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb : in std_logic;
        web : in std_logic_vector(0 to 0);
        addrb : in std_logic_vector(7 downto 0);
        dinb : in std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0)
      );
    end component;

begin

    blk_mem_gen_0_i : blk_mem_gen_0
      port map ( 
        clka => Clk,
        wea => WriteEnableA,
        addra => AddressA,
        dina => DataInA,
        douta => DataOutA,
        clkb => Clk,
        web => WriteEnableB,
        addrb => AddressB,
        dinb => DataInB,
        doutb => DataOutB
      );

end Behavioral;
