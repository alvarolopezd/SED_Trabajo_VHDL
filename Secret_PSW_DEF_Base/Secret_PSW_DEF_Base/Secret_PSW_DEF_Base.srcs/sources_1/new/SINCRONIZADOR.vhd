library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Esta entidad nos sirve para poder crear una señal estable a partir de las entradas del sistema
--Debido a que estas entradas tienen rebotes y funcionan con un reloj tan rapido pueden dar falsa informacion
-- Por lo tanto utilizamos este bloque , en el cual , usando la señal de reloj YA RALENTIZADA , vamos captando información
-- hasta que , durante tres flancos de reloj consecutivos en los cuales la señal este a uno, enviamos una  salida
-- que se corresponde con la señal que deseamos que envie la entrada. Sin este bloque al pulsar un boton o activar un switch
-- conseguimos tantos ceros y unos que la máquina de estados no sabe que hacer y deja de funcionar.

entity SINCRONIZADOR is
 port (
 CLK      : in std_logic;
 ENTRADA  : in std_logic;
 SALIDA   : out std_logic
 );
end SINCRONIZADOR;
architecture BEHAVIORAL of SINCRONIZADOR is
 signal REGISTRO : std_logic_vector(2 downto 0);
begin
 process (CLK)
 begin
 if rising_edge(CLK) then
 REGISTRO(2) <= REGISTRO(1);
 REGISTRO(1) <= REGISTRO(0);
 REGISTRO(0) <= ENTRADA;
 if REGISTRO = "111" then
 SALIDA <= '1';
 else 
 SALIDA <= '0';
 end if;
 end if;
 end process;
end behavioral;

