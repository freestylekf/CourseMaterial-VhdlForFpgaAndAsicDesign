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

entity tb_SimpleDdr3Model is
end tb_SimpleDdr3Model;

architecture Behavioral of tb_SimpleDdr3Model is

    signal Ddr3ControllerState : unsigned(3 downto 0);
    
    constant Ddr3ControllerWait0 : natural := 0;
    constant Ddr3ControllerWrite0 : natural := 1;
    constant Ddr3ControllerWrite1 : natural := 2;
    constant Ddr3ControllerWrite2 : natural := 3;
    constant Ddr3ControllerWrite3 : natural := 4;
    constant Ddr3ControllerRead0 : natural := 5;
    constant Ddr3ControllerRead1 : natural := 6;
    constant Ddr3ControllerRead2 : natural := 7;
    constant Ddr3ControllerRead3 : natural := 8;

	--
	-- TODO: Create a Clocking Wizard IP using the Xilinx IP Generator!
	--
    component ClockingWizard is
      port ( 
        Clk : in STD_LOGIC;
        Clk100M : out STD_LOGIC;
        Clk166M : out STD_LOGIC;
        Clk200M : out STD_LOGIC;
        reset : in STD_LOGIC;
        locked : out STD_LOGIC
      );
    end component;

    component SimpleDdr3Model is
        port ( 
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
    end component;

    signal Clk : std_logic;
    signal Rst : std_logic;

    signal app_addr : std_logic_vector ( 27 downto 0 );
    signal app_cmd : std_logic_vector ( 2 downto 0 );
    signal app_en : std_logic;
    signal app_wdf_data : std_logic_vector ( 127 downto 0 );
    signal app_wdf_end : std_logic;
    signal app_wdf_mask : std_logic_vector ( 15 downto 0 );
    signal app_wdf_wren : std_logic;
    signal app_rd_data : std_logic_vector ( 127 downto 0 );
    signal app_rd_data_end : std_logic;
    signal app_rd_data_valid : std_logic;
    signal app_rdy : std_logic;
    signal app_wdf_rdy : std_logic;
    signal app_sr_req : std_logic;
    signal app_ref_req : std_logic;
    signal app_zq_req : std_logic;
    signal app_sr_active : std_logic;
    signal app_ref_ack : std_logic;
    signal app_zq_ack : std_logic;
    signal ui_clk : std_logic;
    signal ui_clk_sync_rst : std_logic;
    signal init_calib_complete : std_logic;

    signal Clk100M : std_logic;
    signal Clk166M : std_logic;
    signal Clk200M : std_logic;
    signal Locked : std_logic;
    
    signal Ddr3ControllerReadData : std_logic_vector(127 downto 0);

    constant Ddr3ReadCommand : std_logic_vector(2 downto 0) := "001";
    constant Ddr3WriteCommand : std_logic_vector(2 downto 0) := "000";

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
        wait for 100 ns;
        wait;
    end process;
      
    WriteToAndReadFromDdr3 : process (ui_clk, ui_clk_sync_rst) is
    begin
        if rising_edge(ui_clk) then
            if( ui_clk_sync_rst = '1' ) then
                Ddr3ControllerReadData <= (others => '0');
                app_sr_req <= '0';
                app_ref_req <= '0';
                app_zq_req <= '0';
                app_addr <= (others => '0');
                app_cmd <= Ddr3ReadCommand;
                app_en <= '0';
                app_wdf_data <= (others => '0');
                app_wdf_end <= '0';
                app_wdf_mask <= (others => '0');
                app_wdf_wren <= '0';
                Ddr3ControllerState <= (others => '0');
            else
                if( Ddr3ControllerState = Ddr3ControllerWait0 ) then
                    if( init_calib_complete = '1' ) then
                        Ddr3ControllerState <= to_unsigned(Ddr3ControllerWrite0, Ddr3ControllerState'LENGTH);
                    end if;
                elsif( Ddr3ControllerState = Ddr3ControllerWrite0 ) then
                    if( app_rdy = '1' and app_wdf_rdy = '1' ) then
                        app_en <= '1';
                        app_cmd <= Ddr3WriteCommand;
                        app_addr <= (others => '0');
                        app_wdf_wren <= '1';
                        app_wdf_end <= '1';
                        app_wdf_data <= x"AABBCCDDAABBCCDDAABBCCDDAABBCCDD";
                        Ddr3ControllerState <= to_unsigned(Ddr3ControllerWrite2, Ddr3ControllerState'LENGTH);
                    end if;
                elsif( Ddr3ControllerState = Ddr3ControllerWrite2 ) then
                    app_wdf_wren <= '0';
                    app_wdf_end <= '0';
                    if( app_rdy = '1' and app_wdf_rdy = '1' ) then
                       app_en <= '0';
                       Ddr3ControllerState <= to_unsigned(Ddr3ControllerRead0, Ddr3ControllerState'LENGTH);
                    end if;
                elsif( Ddr3ControllerState = Ddr3ControllerRead0 ) then
                    if( app_rdy = '1' ) then
                        app_cmd <= Ddr3ReadCommand;
                        app_addr <= (others => '0');
                        app_en <= '1';
                        Ddr3ControllerState <= to_unsigned(Ddr3ControllerRead1, Ddr3ControllerState'LENGTH);
                    end if;
                elsif( Ddr3ControllerState = Ddr3ControllerRead1 ) then
                    if( app_rdy = '1' ) then
                        app_en <= '0';
                        Ddr3ControllerState <= to_unsigned(Ddr3ControllerRead2, Ddr3ControllerState'LENGTH);
                    end if;
                elsif( Ddr3ControllerState = Ddr3ControllerRead2 ) then
                    if( app_rd_data_valid = '1' ) then
                        Ddr3ControllerReadData <= app_rd_data;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    Check : process
    begin
        wait for 1100 us;
        assert Ddr3ControllerReadData = x"AABBCCDDAABBCCDDAABBCCDDAABBCCDD" report "Test failed." severity FAILURE;
        assert false report "Simulation finished without errors." severity FAILURE;
    end process;

    SimpleDdr3Model_i : SimpleDdr3Model
        port map ( 
            app_addr => app_addr,
            app_cmd => app_cmd,
            app_en => app_en,
            app_wdf_data => app_wdf_data,
            app_wdf_end => app_wdf_end,
            app_wdf_mask => app_wdf_mask,
            app_wdf_wren => app_wdf_wren,
            app_rd_data => app_rd_data,
            app_rd_data_end => app_rd_data_end,
            app_rd_data_valid => app_rd_data_valid,
            app_rdy => app_rdy,
            app_wdf_rdy => app_wdf_rdy,
            app_sr_req => app_sr_req,
            app_ref_req => app_ref_req,
            app_zq_req => app_zq_req,
            app_sr_active => app_sr_active,
            app_ref_ack => app_ref_ack,
            app_zq_ack => app_zq_ack,
            ui_clk => ui_clk,
            ui_clk_sync_rst => ui_clk_sync_rst,
            init_calib_complete => init_calib_complete,
            sys_clk_i => Clk166M,
            clk_ref_i => Clk200M,
            sys_rst => Rst
        );

    ClockingWizard_i : ClockingWizard
      port map ( 
        Clk => Clk,
        Clk100M => Clk100M,
        Clk166M => Clk166M,
        Clk200M => Clk200M,
        reset => Rst,
        locked => Locked
      );

end Behavioral;
