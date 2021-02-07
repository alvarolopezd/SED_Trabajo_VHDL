-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- En esta entidad se introduce el reloj que utiliza la placa , en nuestro caso el de 100 MHZ , y modificando la variable contador
--Conseguimos crear un reloj artificial mucho mas lento que el de la placa. En nuestro caso el reloj cambia de cero a uno cada 0.0005 segundos
-- o cada 0.5 milisegundos. 

--Si se quiere realizar un testbench recomendamos implementar en este un reloj mucho mas lento que el de la placa y disminuir la variable
-- contador para poder agilizar las simulaciones. En nuestro caso , para los testbench hemos utilizado un reloj que cambiaba cada 2 milisegundos
-- y hemos puesto la variable contador a 10.


entity CLK_CONTROL is
port (
   CLK_origen :in std_logic;
   CLK_modificado :out std_logic
);
end CLK_CONTROL;

architecture behavioral of CLK_CONTROL is

signal contador : integer range 0 to 500000 :=0;
signal reloj_interno :std_logic:='0';
begin

gestion_CLK: process(CLK_origen,contador)

begin

if rising_edge(CLK_origen) then
  contador <= contador + 1;
  --if contador >= 50000 then           ---- DESCOMENTAR SI SE USA EN SITUACION REAL CON PLACA
  if contador >= 10 then            ---- DESCOMENTAR SI SE USA EN TESTBENCH CON RELOJ 2 MS
   reloj_interno <= not(reloj_interno) ;
   contador <= 0;
  end if;
end if;

end process;
CLK_modificado <= reloj_interno;
end behavioral;