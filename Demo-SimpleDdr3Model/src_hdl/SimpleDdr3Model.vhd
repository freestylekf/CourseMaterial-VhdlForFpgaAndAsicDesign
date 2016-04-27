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

entity SimpleDdr3Model is
    Port ( 
        app_addr : in std_logic_vector ( 27 downto 0 );
        app_cmd : in std_logic_vector ( 2 downto 0 );
        app_en : in std_logic;
        app_wdf_data : in std_logic_vector ( 127 downto 0 );
        app_wdf_end : in std_logic;
        app_wdf_mask : in std_logic_vector ( 15 downto 0 );
        app_wdf_wren : in std_logic;
        app_rd_data : out std_logic_vector ( 127 downto 0 );
        app_rd_data_end : out std_logic;
        app_rd_data_valid : out std_logic;
        app_rdy : out std_logic;
        app_wdf_rdy : out std_logic;
        app_sr_req : in std_logic;
        app_ref_req : in std_logic;
        app_zq_req : in std_logic;
        app_sr_active : out std_logic;
        app_ref_ack : out std_logic;
        app_zq_ack : out std_logic;
        ui_clk : out std_logic;
        ui_clk_sync_rst : out std_logic;
        init_calib_complete : out std_logic;
        sys_clk_i : in std_logic;
        clk_ref_i : in std_logic;
        sys_rst : in std_logic
    );
end SimpleDdr3Model;

architecture Behavioral of SimpleDdr3Model is

    signal State : unsigned(3 downto 0);
    
    constant WaitForRun0 : natural := 0;
    constant Read0 : natural := 1;
    constant Read1 : natural := 2;
    constant Read2 : natural := 3;
    constant Write0 : natural := 4;
    constant Write1 : natural := 5;
    constant Write2 : natural := 6;
    
    constant Ddr3ReadCommand : std_logic_vector(2 downto 0) := "001";
    constant Ddr3WriteCommand : std_logic_vector(2 downto 0) := "000";
    
    type RamType is array (0 to 4096) of std_logic_vector(127 downto 0);
    
    signal Ram : RamType := (others => (others => '0'));
    
    signal InitCalibComplete : std_logic;
    signal UiClk : std_logic;
    signal UiClkSyncRst : std_logic;
    signal WriteToRam : std_logic;
    signal LineNumber : unsigned(15 downto 0) := x"0000";
    signal RamInitData : std_logic_vector(127 downto 0);
    signal InitWriteToRam : std_logic;

begin

    init_calib_complete <= InitCalibComplete;
    ui_clk <= UiClk;
    ui_clk_sync_rst <= UiClkSyncRst;

    app_sr_active <= '0';
    app_ref_ack <= '0';
    app_zq_ack <= '0';

    SimpleDdr3ClkGen : process
    begin
        UiClk <= '0';
        wait for 7.5 ns;
        UiClk <= '1';
        wait for 7.5 ns;
    end process;
    
    SimpleDdr3SyncRst : process
    begin
        UiClkSyncRst <= '1';
        wait until InitCalibComplete = '1';
        UiClkSyncRst <= '0';
        wait;
    end process;
    
    SimpleDdr3WriteToRam : process (UiClk, UiClkSyncRst) is
    begin
        if rising_edge(UiClk) then
            if( InitCalibComplete = '0' and InitWriteToRam = '1' ) then
                Ram(to_integer(LineNumber)) <= RamInitData;
            elsif( InitCalibComplete = '1' and WriteToRam = '1' ) then
                Ram(to_integer(unsigned(app_addr(27 downto 4)))) <= app_wdf_data;
            end if;
        end if;
    end process;
    
    SimpleDdr3Init : process
        file MemFile : TEXT open READ_MODE is "../../../../../textio/Ddr3Ram.mem";
        variable FileLine : LINE;
        variable Success : BOOLEAN;
        variable Data : std_logic_vector(127 downto 0);
    begin
        InitWriteToRam <= '0';
        InitCalibComplete <= '0';
        RamInitData <= (others => '0');
        wait until rising_edge(UiClk);

        while not EndFile(MemFile) loop
            ReadLine(MemFile, FileLine);
            HRead(FileLine, Data);
            wait for 1 ns;
            
            RamInitData <= Data;
            InitWriteToRam <= '1';
            wait until rising_edge(UiClk);
            InitWriteToRam <= '0';
            LineNumber <= LineNumber + 1;
            wait for 1 ns;
        end loop;
        
        FILE_CLOSE(MemFile);
        
        wait for 1000 us;
       
        InitCalibComplete <= '1';
        wait;
    end process;

    SimpleDdr3Read : process (UiClk, UiClkSyncRst) is
    begin
        if rising_edge(UiClk) then
            if( UiClkSyncRst = '1' ) then
                app_rdy <= '0';
                app_wdf_rdy <= '0';
                app_rd_data <= (others => '0');
                app_rd_data_end <= '0';
                app_rd_data_valid <= '0';
                WriteToRam <= '0';
                State <= (others => '0');
            else
                if( State = WaitForRun0 ) then
                    app_rd_data_valid <= '0';
                    app_rdy <= '1';
                    app_wdf_rdy <= '1';
                    if( app_en = '1' ) then
                        if( app_cmd = Ddr3ReadCommand ) then
                            State <= to_unsigned(Read0, State'LENGTH);
                        elsif ( app_cmd = Ddr3WriteCommand ) then
                            app_rdy <= '0';
                            app_wdf_rdy <= '0';
                            State <= to_unsigned(Write0, State'LENGTH);
                        end if;
                    end if;
                elsif( State = Read0 ) then
                    State <= to_unsigned(Read1, State'LENGTH);
                elsif( State = Read1 ) then
                    app_rdy <= '0';
                    State <= to_unsigned(Read2, State'LENGTH);
                elsif( State = Read2 ) then
                    app_rd_data_valid <= '1';
                    app_rd_data <= Ram(to_integer(unsigned(app_addr(27 downto 4))));
                    State <= to_unsigned(WaitForRun0, State'LENGTH);
                elsif( State = Write0 ) then
                    WriteToRam <= '1';
                    app_rdy <= '1';
                    app_wdf_rdy <= '1';
                    State <= to_unsigned(Write1, State'LENGTH);
                elsif( State = Write1 ) then
                    WriteToRam <= '0';
                    State <= to_unsigned(WaitForRun0, State'LENGTH);
                end if;
            end if;
        end if;
    end process;

end Behavioral;
