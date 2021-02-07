-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity SWITCHES_tb is
end entity;

architecture test of SWITCHES_tb is

    signal  SW0 : std_logic;
    signal  SW1 : std_logic;
    signal  SW2 : std_logic;
    signal  SW3 : std_logic;
    signal  SW4 : std_logic;
    signal  SW5 : std_logic;
    signal  SW6 : std_logic;
    signal  SW7 : std_logic;
    signal  SW8 : std_logic;
    signal  SW9 : std_logic;
    signal  CLK : std_logic:='0'; -- Reloj
    signal  NUMERO : std_logic_vector(6 downto 0);
    
    
component Switches is
        port(
  --ENTRADAS
      SW0 : in std_logic;
      SW1 : in std_logic;
      SW2 : in std_logic;
      SW3 : in std_logic;
      SW4 : in std_logic;
      SW5 : in std_logic;
      SW6 : in std_logic;
      SW7 : in std_logic;
      SW8 : in std_logic;
      SW9 : in std_logic;
      CLK : in std_logic; -- Reloj
 	  NUMERO  : out std_logic_vector(6 downto 0)
        );
    end component;

begin

uut: Switches --UNIT UNDER TEST
    port map(
      SW0  => SW0,  
      SW1  => SW1,  
      SW2  => SW2,  
      SW3  => SW3,  
      SW4  => SW4,  
      SW5  => SW5,  
      SW6  => SW6,  
      SW7  => SW7,  
      SW8  => SW8,  
      SW9  => SW9,  
      CLK  => CLK,
      NUMERO   => NUMERO         
    );
    
 CLK <= not CLK after 0.5 sec;            --RELOJ PARA TESTBENCH
 SW0 <= '0', '1' after 1.5  sec , '0' after 3.5  sec;
 SW1 <= '0' ,'1' after 5.5  sec , '0' after 7.5  sec;
 SW2 <= '0' ,'1' after 9.5  sec , '0' after 11.5 sec;
 SW3 <= '0' ,'1' after 13.5 sec , '0' after 15.5 sec;
 SW4 <= '0' ,'1' after 17.5 sec , '0' after 19.5 sec;
 SW5 <= '0' ,'1' after 21.5 sec , '0' after 23.5 sec;
 SW6 <= '0' ,'1' after 25.5 sec , '0' after 27.5 sec;
 SW7 <= '0' ,'1' after 29.5 sec , '0' after 31.5 sec;
 SW8 <= '0' ,'1' after 33.5 sec , '0' after 35.5 sec;
 SW9 <= '0' ,'1' after 37.5 sec , '0' after 39.5 sec;
   
      process
    begin
    	wait for 40 sec;
        assert false
        	report "[SUCCESS]: simulation finished."
            severity failure;
        end process;
        
    end test;




