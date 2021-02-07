-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity TOP_tb is
end entity;

architecture test of TOP_tb is

    signal  SW0_t : std_logic;
    signal  SW1_t : std_logic;
    signal  SW2_t : std_logic;
    signal  SW3_t : std_logic;
    signal  SW4_t : std_logic;
    signal  SW5_t : std_logic;
    signal  SW6_t : std_logic;
    signal  SW7_t : std_logic;
    signal  SW8_t : std_logic;
    signal  SW9_t : std_logic;
    signal  CLK_t : std_logic:='0'; -- Reloj
    signal  NUMERO_t : std_logic;
    
    
component Switches is
        port(
  --ENTRADAS
      SW0_t : in std_logic;
      SW1_t : in std_logic;
      SW2_t : in std_logic;
      SW3_t : in std_logic;
      SW4_t : in std_logic;
      SW5_t : in std_logic;
      SW6_t : in std_logic;
      SW7_t : in std_logic;
      SW8_t : in std_logic;
      SW9_t : in std_logic;
      CLK_t : in std_logic; -- Reloj
 	  NUMERO_t  : out std_logic
        );
    end component;

begin

uut: Switches --UNIT UNDER TEST
    port map(
      SW0_t  => SW0_t,  
      SW1_t  => SW1_t,  
      SW2_t  => SW2_t,  
      SW3_t  => SW3_t,  
      SW4_t  => SW4_t,  
      SW5_t  => SW5_t,  
      SW6_t  => SW6_t,  
      SW7_t  => SW7_t,  
      SW8_t  => SW8_t,  
      SW9_t  => SW9_t,  
      CLK_t  => CLK_t,
      NUMERO_t   => NUMERO_t         
    );
    
 CLK_t <= not CLK_t after 0.5 sec;            --RELOJ PARA TESTBENCH
 SW0_t <= '0', '1' after 1.5  sec , '0' after 3.5  sec;
 SW1_t <= '0' ,'1' after 5.5  sec , '0' after 7.5  sec;
 SW2_t <= '0' ,'1' after 9.5  sec , '0' after 11.5 sec;
 SW3_t <= '0' ,'1' after 13.5 sec , '0' after 15.5 sec;
 SW4_t <= '0' ,'1' after 17.5 sec , '0' after 19.5 sec;
 SW5_t <= '0' ,'1' after 21.5 sec , '0' after 23.5 sec;
 SW6_t <= '0' ,'1' after 25.5 sec , '0' after 27.5 sec;
 SW7_t <= '0' ,'1' after 29.5 sec , '0' after 31.5 sec;
 SW8_t <= '0' ,'1' after 33.5 sec , '0' after 35.5 sec;
 SW9_t <= '0' ,'1' after 37.5 sec , '0' after 39.5 sec;
   
   process
    begin
    	wait for 50 sec;
        assert false
        	report "[SUCCESS]: simulation finished."
            severity failure;
        end process;
        
    end test;