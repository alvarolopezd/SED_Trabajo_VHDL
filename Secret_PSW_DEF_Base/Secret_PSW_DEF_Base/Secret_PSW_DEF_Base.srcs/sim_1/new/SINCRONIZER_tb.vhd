-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity SINCRONIZER_tb is
end SINCRONIZER_tb;

architecture Test of SINCRONIZER_tb is

    signal  ENTRADA : std_logic;
    signal  CLK : std_logic:='0'; -- Reloj
 	signal  SALIDA :  std_logic;

component SINCRONIZADOR is
        port(
      ENTRADA : in std_logic;
      CLK   : in std_logic; -- Reloj
      SALIDA  : out std_logic              
        );
end component;

begin

uut: SINCRONIZADOR --UNIT UNDER TEST
    port map(
      ENTRADA => ENTRADA,
      CLK  => CLK,
      SALIDA   => SALIDA         
    );

CLK <= not CLK after 0.5 sec;            --RELOJ PARA TESTBENCH
ENTRADA <= '0','1' after 0.5 sec ,'0' after 1.5 sec , '1' after 2.5 sec , '0' after 4.5 sec , '1' after 6.5 sec ;
process
    begin
    	wait for 12 sec;
        assert false
        	report "[SUCCESS]: simulation finished."
            severity failure;
        end process;

end Test;
