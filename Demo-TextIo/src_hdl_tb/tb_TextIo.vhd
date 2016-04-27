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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity tb_TextIo is
end tb_TextIo;

architecture Behavioral of tb_TextIo is

    component TextIo is
        port (
            Clk : in std_logic;
            Rst : in std_logic;
            Value : out std_logic_vector(3 downto 0)
        );
    end component;

    signal Clk : std_logic;
    signal Rst : std_logic;
    signal Value : std_logic_vector(3 downto 0);

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
        wait;
    end process;
    
    Check : process
    begin
        wait for 250 ns;
        assert Value = x"F" report "Test failed." severity FAILURE;
        assert false report "Simulation finished with no errors" severity FAILURE;
    end process;

    WriteFile : process
        file F : TEXT open WRITE_MODE is "../../../../../textio/counter.txt";
        variable L : Line;
        variable First : BOOLEAN := TRUE;
    begin
        wait until rising_edge(Clk);
        wait for 1 ns;
        
        if First then
            Write(L, STRING'("Rst Value"));
            Writeline(F, L);
            First := FALSE;
        end if;
        
        Write(L, Rst);
        Write(L, Value, RIGHT, 7);
        Writeline(F, L);
        
    end process;

    TextIo_i : TextIo
        port map (
            Clk => Clk,
            Rst => Rst,
            Value => Value
        );

end Behavioral;