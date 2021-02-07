-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity CLK_CONTROL_tb is
end CLK_CONTROL_tb;

architecture Test of CLK_CONTROL_tb is

    signal  CLK_origen: std_logic:='0'; -- Reloj;z
    signal  CLK_modificado : std_logic;

component CLK_CONTROL is
        port(
      CLK_origen : in std_logic;
      CLK_modificado  : out std_logic              
        );
end component;

begin

uut: CLK_CONTROL --UNIT UNDER TEST
    port map(
      CLK_origen => CLK_origen,
      CLK_modificado  => CLK_modificado 
    );

CLK_origen <= not CLK_origen after 0.25 sec;            --RELOJ PARA TESTBENCH
process
    begin
    	wait for 40 sec;
        assert false
        	report "[SUCCESS]: simulation finished."
            severity failure;
        end process;

end Test;
