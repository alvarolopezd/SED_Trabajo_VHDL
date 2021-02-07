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
    signal  OK_t               : std_logic;
    signal	RESET_parcial_t    : std_logic;
    signal	RESET_t            : std_logic;
  --SALIDAS
    signal    DISPLAY_t         :  std_logic_vector(6 downto 0); --Salida del display              
    signal    ANODE_t           :  std_logic_vector(7 downto 0); -- Activacion de cada uno de los displays      
    signal    LED_ACIERTO_t     :  std_logic;
 	signal    LED_ERROR_t       :  std_logic;
 	signal    LED_FATAL_ERROR_t :  std_logic;

component TOP is
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
      OK_t               : in std_logic;
 	  RESET_parcial_t    : in std_logic;
 	  RESET_t            : in std_logic;
  --SALIDAS
      DISPLAY_t          : out std_logic_vector(6 downto 0);              
      ANODE_t            : out std_logic_vector(7 downto 0); -- Activacion de cada uno de los displays      
      LED_ACIERTO_t      : out std_logic;
 	  LED_ERROR_t        : out std_logic;
 	  LED_FATAL_ERROR_t  : out std_logic
        );
    end component;

begin

uut: TOP --UNIT UNDER TEST
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
      OK_t   => OK_t,           
 	  RESET_parcial_t  => RESET_parcial_t,   
 	  RESET_t  => RESET_t,          
  --SALIDAS
      DISPLAY_t          => DISPLAY_t,            
      ANODE_t            => ANODE_t,
      LED_ACIERTO_t      => LED_ACIERTO_t,   
 	  LED_ERROR_t        => LED_ERROR_t,
 	  LED_FATAL_ERROR_t  => LED_FATAL_ERROR_t
    );
    
 --CLK_t <= not CLK_t after 0.00000001 sec;  --RELOJ REAL DE LA PLACA 
 -- PARA LOS TESTBENCH USAMOS OTRO RELOJ DEBIDO A QUE TARDA MUCHO LA SIMULACIÓN CON UN RELOJ REAL
 
 CLK_t <= not CLK_t after 0.2 ms;            --RELOJ PARA TESTBENCH
 SW0_t <= '0', '1' after 40 sec , '0' after 40.5 sec,'1' after 41 sec , '0' after 41.5 sec,'1' after 42 sec , '0' after 42.5 sec ,'1' after 43 sec , '0' after 43.5 sec;
 SW1_t <= '0' , '1' after 1 sec , '0' after 1.5 sec ;
 SW2_t <= '0' , '1' after 2 sec , '0' after 2.5 sec ;
 SW3_t <= '0' , '1' after 3 sec , '0' after 3.5 sec;
 SW4_t <= '0' , '1' after 4 sec , '0' after 4.5 sec;
 SW5_t <= '0' , '1' after 10 sec , '0' after 10.5 sec , '1' after 20 sec , '0' after 20.5 sec;
 SW6_t <= '0' , '1' after 11 sec , '0' after 11.5 sec , '1' after 21 sec , '0' after 21.5 sec ;
 SW7_t <= '0' , '1' after 12 sec , '0' after 12.5 sec , '1' after 22 sec , '0' after 22.5 sec ;
 SW8_t <= '0' , '1' after 13 sec , '0' after 13.5 sec , '1' after 23 sec , '0' after 23.5 sec ;
 SW9_t <= '0', '1' after 30 sec , '0' after 30.5 sec,'1' after 31 sec , '0' after 31.5 sec,'1' after 32 sec , '0' after 32.5 sec ,'1' after 33 sec , '0' after 33.5 sec;
 OK_t <= '0' , '1' after 7 sec , '0' after 7.5 sec , '1' after 15 sec, '0' after 15.5 sec, '1' after 25 sec, '0' after 25.5 sec, '1' after 45 sec, '0' after 45.5 sec;
 RESET_parcial_t <= '0' , '1' after 9 sec , '0' after 9.5 sec , '1' after 17 sec,'0' after 17.5 sec, '1' after 27 sec,'0' after 27.5 sec, '1' after 37 sec,'0' after 37.5 sec, '1' after 47 sec,'0' after 47.5 sec;
 RESET_t <= '1' ,'0' after 0.2 sec;  
 
  process
    begin
    	wait for 50 sec;
        assert false
        	report "[SUCCESS]: simulation finished."
            severity failure;
        end process;
end test;