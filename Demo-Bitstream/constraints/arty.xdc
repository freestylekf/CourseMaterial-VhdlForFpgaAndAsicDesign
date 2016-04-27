
## Clock signal 100 Mhz

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports Clk]
create_clock -period 10.000 -name Clk -waveform {0.000 5.000} -add [get_ports Clk]

##LEDs

set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports { Led0 }];
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports { Led1 }];
set_property -dict { PACKAGE_PIN T9 IOSTANDARD LVCMOS33 } [get_ports { Led2 }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { Led3 }];

## Switches

set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports { Enable }];

## Buttons

set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports { Rst }];