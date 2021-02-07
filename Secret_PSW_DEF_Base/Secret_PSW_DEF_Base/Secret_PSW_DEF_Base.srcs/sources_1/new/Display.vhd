
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--En este bloque guardamos los cuatro valores que nos envia la máquina de estados y los imprimos en el display correspondiente de uno en uno.
-- En el proceso gestion_anode variamos la señal ANODE cada flanco de reloj en los primeros 4 bits del vector. Los 4 últimos se quedan siempre a uno 
-- ya que de esta manera los otros 4 displays que no se usan nos aseguramos de que estan apagados. Si nos fijamos en como usamos ANODE
-- podemos ver que , para encender el display correspondiente , usamos un 0. Por lo tanto , ANODE solo varia entre 4 valores 
-- los cuales solo tienen un 0 que se mueve en las cuatro primeras posiciones y el resto a 1
-- En mostras display lo que se asigna es el valor correspondiente a cada display en funcionçión del ANODE actual.
-- En realidad no usamos la salida Anode , si noq ue usamos una señal interna que nos agiliza la seleccion del display la asignacion de valores a este

entity Display is
  port (
       CLK : in std_logic; -- Reloj
       VAL_DISPLAY_1    : in std_logic_vector(6 downto 0);
 	   VAL_DISPLAY_2    : in std_logic_vector(6 downto 0);
 	   VAL_DISPLAY_3    : in std_logic_vector(6 downto 0);
 	   VAL_DISPLAY_4    : in std_logic_vector(6 downto 0);  
 	   DISPLAY          : out std_logic_vector(6 downto 0);              
       ANODE: out std_logic_vector(7 downto 0) -- Activacion de cada uno de los displays        -
   );
end Display;

architecture Behavioral of Display is

 signal selected_display: std_logic_vector (1 downto 0):="00";	--Display seleccionado.

begin

gestion_anode : process (selected_display, CLK)
begin
 if rising_edge(CLK) then
  if selected_display = "00" then
    selected_display <= "01";
    ANODE(3 downto 0) <= "1011";
  elsif selected_display = "01" then
    selected_display <= "10";
    ANODE(3 downto 0) <= "1101";
  elsif selected_display = "10" then
    selected_display <= "11";
    ANODE(3 downto 0) <= "1110";
  elsif selected_display = "11" then
    selected_display <= "00";
    ANODE(3 downto 0) <= "0111";
  end if;
  end if;
  ANODE(7 downto 4) <="1111";
end process;

mostrar_display : process(selected_display,VAL_DISPLAY_1,VAL_DISPLAY_2,VAL_DISPLAY_3,VAL_DISPLAY_4)
begin
case selected_display is
   when "00" => DISPLAY <= VAL_DISPLAY_1;
   when "01" => DISPLAY <= VAL_DISPLAY_2;
   when "10" => DISPLAY <= VAL_DISPLAY_3;
   when "11" => DISPLAY <= VAL_DISPLAY_4;
   when others => DISPLAY <= "1111110";
 end case;
end process;
end behavioral;