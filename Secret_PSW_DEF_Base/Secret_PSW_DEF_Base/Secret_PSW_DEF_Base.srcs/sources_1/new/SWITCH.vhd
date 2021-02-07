-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Bloque encargado de gestionar los interruptores. Las entradas a este bloque son los switches QUE YA HAN PASADO POR EL SINCRONIZADOR
-- y la salida de este bloque es un vector  std_logic (6 downto 0). Traducimos la señal de cada switch a un vector de 7 bits ya que esto
-- nos simplifica mucho el uso de los displays y no necesitamos de ningun decodificador
-- Hemos realizado este bloque de tal manera que el interruptor que tiene mas prioridad es el mas bajo ( 0 ) y el que tiene menos es el  ( 9 )
-- De esta manera nunca se podran escribir dos números a la vez. 

entity Switches is
  Port (
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
      NUMERO: out std_logic_vector (6 downto 0)
        );
end Switches;

architecture Behavioral of Switches is

begin

SWITCH_PROCESS:process (CLK)
 begin
     if rising_edge (CLK) then
          if    SW0 = '1' then 
            NUMERO <= "0000001"; --0
          elsif SW1 = '1' then
            NUMERO <= "1001111"; --1
          elsif SW2 = '1' then
            NUMERO <= "0010010"; --2
          elsif SW3 = '1' then
            NUMERO <= "0000110"; --3
          elsif SW4 = '1' then
            NUMERO <= "1001100"; --4
          elsif SW5 = '1' then
            NUMERO <= "0100100"; --5
          elsif SW6 = '1' then
            NUMERO <= "0100000"; --6
          elsif SW7 = '1' then
            NUMERO <= "0001111"; --7
          elsif SW8 = '1' then
            NUMERO <= "0000000"; --8
          elsif SW9 = '1' then
           NUMERO <= "0000100";  --9
          else
           NUMERO <= "1111110"; -- guion, no se esta enviando NINGÚN NÚMERO 
          end if;
     end if;
   end process;

end Behavioral;