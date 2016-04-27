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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_BlockRam is
end tb_BlockRam;

architecture Behavioral of tb_BlockRam is

    component BlockRamWrapper256x8 is
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
    end component;

    signal Clk : std_logic;
    signal Rst : std_logic;
    
    signal WriteEnableA : std_logic_vector(0 to 0);
    signal AddressA : std_logic_vector(7 downto 0);
    signal DataInA : std_logic_vector(7 downto 0);
    signal DataOutA : std_logic_vector(7 downto 0);
    signal WriteEnableB : std_logic_vector(0 to 0);
    signal AddressB : std_logic_vector(7 downto 0);
    signal DataInB : std_logic_vector(7 downto 0);
    signal DataOutB : std_logic_vector(7 downto 0);

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
        WriteEnableB <= "0";
        AddressB <= x"00";
        DataInB <= x"00";
        wait for 10 ns;
        Rst <= '0';
        wait for 100 ns;
        AddressB <= x"03";
        wait;
    end process;
    
    ReadFile : process
        file MemFile : TEXT open READ_MODE is "../../../../../textio/block_ram.txt";
        variable LineNumber : unsigned(7 downto 0) := x"00";
        variable FileLine : LINE;
        variable Success : BOOLEAN;
        variable Data : std_logic_vector(7 downto 0);
    begin
        wait until rising_edge(Clk);

        if LineNumber < 5 then 
            ReadLine(MemFile, FileLine);
            Read(FileLine, Data, Success);
            assert Success report "Unable to read from file.";

            wait for 1 ns;
            
            AddressA <= std_logic_vector(LineNumber);
            WriteEnableA <= "1";
            DataInA <= Data;
            
            LineNumber := LineNumber + 1;
        else
            FILE_CLOSE(MemFile);
            WriteEnableA <= "0";
        end if;
    end process;
    
    Check : process
    begin
        wait for 150 ns;
        assert DataOutB = x"04" report "Test failed." severity FAILURE;
        assert false report "Simulation finished with no errors" severity FAILURE;
    end process;
    
    BlockRamWrapper256x8_i : BlockRamWrapper256x8
      port map ( 
        Clk => Clk,
        WriteEnableA => WriteEnableA,
        AddressA => AddressA,
        DataInA => DataInA,
        DataOutA => DataOutA,
        WriteEnableB => WriteEnableB,
        AddressB => AddressB,
        DataInB => DataInB,
        DataOutB => DataOutB
      );

end Behavioral;
