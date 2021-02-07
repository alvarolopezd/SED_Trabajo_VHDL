-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--En esta entidad se relacionan todos los bloques , creamos las instancias necesarias para todos los botones y switches , el cotol del reloj
-- y las instancias para Switches , el display y la máquina de estados.

entity TOP is
  Port ( 
  --ENTRADAS
  -- Mediante los switches podemos introducir el número deseado a la placa. 
  -- SW0_t corresponde al 0 , SW1_t al 1 y asi sucesivamente
      SW0_t : in std_logic;
      SW1_t : in std_logic;
      SW2_t : in std_logic;
      SW3_t : in std_logic;
      SW4_t : in std_logic;
      SW5_t : in std_logic;
      SW6_t: in std_logic;
      SW7_t : in std_logic;
      SW8_t : in std_logic;
      SW9_t : in std_logic;
  --Señal CLK que usa nuestra maquina de estados. 
  --Esta entrada CLK pasa antes por un bloque que crea un reloj mucho mas lento que el de la placa, el cual funciona a 100 MHZ 
      CLK_t : in std_logic; -- Reloj
  -- Entradas que corresponden a 3 botones, los cuales son , si nos fijamos en la botonera en forma de cruz de la placa
  
      OK_t               : in std_logic;  --Boton de la izquierda
 	  RESET_parcial_t    :in std_logic;   --Boton del centro
 	  RESET_t            : in std_logic;  --Boton de arriba
  --SALIDAS
  -- Las siguientes dos salidas corresponden al numero que se imprime en pantalla y al display seleccionado
  -- Gracias a anode podemos encender el display deseado , en nuestro caso vamos de uno en uno en los 4 displays de la izquierda
  -- Mientras que DISPLAY_t es el valor que imprime el display seleccionado
      DISPLAY_t          : out std_logic_vector(6 downto 0);              
      ANODE_t: out std_logic_vector(7 downto 0); 
  -- Las siguientes tres salidas se relacionan con 3 leds, como dice su nombre, los cuales usaremos , junto con el display
  -- para transmitir al usuario información sobre si ha acertado o no la contraseña secreta.
      LED_ACIERTO_t      : out std_logic;
 	  LED_ERROR_t        : out std_logic;
 	  LED_FATAL_ERROR_t  : out std_logic
       );
       
end TOP;

architecture Behavioral of TOP is

 component SINCRONIZADOR
    port(
    CLK      : in std_logic;
    ENTRADA  : in std_logic;
    SALIDA   : out std_logic
    );
 end component;
 
 component CLK_CONTROL 
    port(
    CLK_origen :in std_logic;
    CLK_modificado :out std_logic
    );
 end component; 
 
 component Switches
    port(
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
 end component;
 
 component FSM
    port(
    CLK              : in std_logic;
 	OK               : in std_logic;
 	RESET_parcial    :in std_logic;
 	RESET            : in std_logic;
 	NUMERO           : in std_logic_vector(6 downto 0);
 	--SALIDAS
 	VAL_DISPLAY_1    : out std_logic_vector(6 downto 0);
 	VAL_DISPLAY_2    : out std_logic_vector(6 downto 0);
 	VAL_DISPLAY_3    : out std_logic_vector(6 downto 0);
 	VAL_DISPLAY_4    : out std_logic_vector(6 downto 0);
 	LED_ACIERTO      : out std_logic;
 	LED_ERROR        : out std_logic;
 	LED_FATAL_ERROR  : out std_logic
    );
  end component;
  
  component Display 
     port(
       CLK : in std_logic; -- Reloj
       VAL_DISPLAY_1    : in std_logic_vector(6 downto 0);
 	   VAL_DISPLAY_2    : in std_logic_vector(6 downto 0);
 	   VAL_DISPLAY_3    : in std_logic_vector(6 downto 0);
 	   VAL_DISPLAY_4    : in std_logic_vector(6 downto 0);  
 	   DISPLAY          : out std_logic_vector(6 downto 0);              
       ANODE: out std_logic_vector(7 downto 0) -- Activacion de cada uno de los displays     
     );
  end component;
  
  signal CLK_mod :std_logic;
  signal SW0_mod :std_logic;
  signal SW1_mod :std_logic;
  signal SW2_mod :std_logic;
  signal SW3_mod :std_logic;
  signal SW4_mod :std_logic;
  signal SW5_mod :std_logic;
  signal SW6_mod :std_logic;
  signal SW7_mod :std_logic;
  signal SW8_mod :std_logic;
  signal SW9_mod :std_logic;
  signal OK_mod :std_logic;
  signal RESET_parcial_mod :std_logic;
  signal RESET_mod :std_logic;
  signal NUMERO_mod:std_logic_vector(6 downto 0);
  signal VAL_DISPLAY_1_mod    :  std_logic_vector(6 downto 0);
  signal VAL_DISPLAY_2_mod    :  std_logic_vector(6 downto 0);
  signal VAL_DISPLAY_3_mod    :  std_logic_vector(6 downto 0);
  signal VAL_DISPLAY_4_mod    :  std_logic_vector(6 downto 0);
begin
 
 --GESTION DE RELOJ
 
 Inst_CLK : CLK_CONTROL PORT MAP(
 CLK_origen => CLK_t,
 CLK_modificado => CLK_mod
 );
 
 --GESTION DE SWITCHES CON SINCRONIZADOR
 
 Inst_SW0 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW0_t,
 SALIDA  => SW0_mod
 );
 Inst_SW1 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW1_t,
 SALIDA  => SW1_mod
 );
 Inst_SW2 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW2_t,
 SALIDA  => SW2_mod
 );
 Inst_SW3 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW3_t,
 SALIDA  => SW3_mod
 );
 Inst_SW4 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW4_t,
 SALIDA  => SW4_mod
 );
 Inst_SW5 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW5_t,
 SALIDA  => SW5_mod
 );
 Inst_SW6 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW6_t,
 SALIDA  => SW6_mod
 );
 Inst_SW7 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW7_t,
 SALIDA  => SW7_mod
 );
 Inst_SW8 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW8_t,
 SALIDA  => SW8_mod
 );
 Inst_SW9 : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => SW9_t,
 SALIDA  => SW9_mod
 );
 
--GESTION DE BOTONES CON SINCRONIZADOR
 Inst_OK : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => OK_t,
 SALIDA  => OK_mod
 );
 Inst_RESET_parcial : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => RESET_parcial_t,
 SALIDA  => RESET_parcial_mod
 );
 Inst_RESET : SINCRONIZADOR PORT MAP(
 CLK     => CLK_mod,
 ENTRADA => RESET_t,
 SALIDA  => RESET_mod
 );
 
 Inst_Switches : Switches PORT MAP (
      SW0 => SW0_mod,
      SW1 => SW1_mod,
      SW2 => SW2_mod,
      SW3 => SW3_mod,
      SW4 => SW4_mod,
      SW5 => SW5_mod,
      SW6 => SW6_mod,
      SW7 => SW7_mod,
      SW8 => SW8_mod,
      SW9 => SW9_mod,
      CLK => CLK_mod, -- Reloj
      NUMERO => NUMERO_mod
 );
 
 Inst_FSM : FSM PORT MAP (
    CLK => CLK_mod,        
 	OK  => OK_mod,             
 	RESET_parcial => RESET_parcial_mod,  
 	RESET  => RESET_mod,        
 	NUMERO => NUMERO_mod,          
 	VAL_DISPLAY_1 => VAL_DISPLAY_1_mod,   
 	VAL_DISPLAY_2 => VAL_DISPLAY_2_mod,      
 	VAL_DISPLAY_3 => VAL_DISPLAY_3_mod,      
 	VAL_DISPLAY_4 => VAL_DISPLAY_4_mod,      
 	LED_ACIERTO => LED_ACIERTO_t,    
 	LED_ERROR => LED_ERROR_t,      
 	LED_FATAL_ERROR  => LED_FATAL_ERROR_t
 );
 
 Inst_Display : Display PORT MAP (
       CLK => CLK_mod,
       VAL_DISPLAY_1 => VAL_DISPLAY_1_mod,   
 	   VAL_DISPLAY_2 => VAL_DISPLAY_2_mod,      
       VAL_DISPLAY_3 => VAL_DISPLAY_3_mod,      
 	   VAL_DISPLAY_4 => VAL_DISPLAY_4_mod,      
 	   DISPLAY => DISPLAY_t,                    
       ANODE => ANODE_t
 );
 
end behavioral;

