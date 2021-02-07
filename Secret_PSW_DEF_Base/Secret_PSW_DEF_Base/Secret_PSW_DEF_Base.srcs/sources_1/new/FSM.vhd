-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--Esta entidad es la máquina de estados de nuestro proyecto. Presentamos los estados que posee la máquina:
-- S0  =>  Estado inicial al cual solo se accede al iniciar la máquina ,al pulsar el boton RESET o acertando o fallando completamente
--         la contraseña. Inicializa todas las variables y etea la contraseña del sistema.
--         En este caso la modificamos en la señal " pasw " y es 1 2 3 4.
-- S1  =>  Estado de reposo a la cual se llega tras conocer si has acertado , fallado o perdido y pulsas el boton RESET_parcial
--         o bien cuando al introducir una contraseña te equivocas y quieres reintroducirla de nuevo sin gastar un intento
-- S2  => Obtención del primer número
-- S3  => Estado de tránsito entre el primer y el segundo número
-- S4  => Obtención del segundo número
-- S5  => Estado de tránsito entre el segundo y el tercer número
-- S6  => Obtención del tercer número
-- S7  => Estado de tránsito entre el tercer y el cuarto número
-- S8  => Obtención del cuarto número
-- S9  => Estado en el que se le pregunta al usuario si quiere introducir esa contraseña. Si pulsa OK se procedera a comprobar 
--        la contraseña y se pasara al estado S10 . Si el usuario se ha confundido pulsa RESET_parcial y pasa al estado S1.
--        Aclarar que esta situación no es un error al comprobar la contraseña , es un error en el cual el usuario se ha equivocado
--        al activar los switches y quiere reintroducir la contraseña sin gastar un intento
-- S10 => En este estado se comprueba si la contraseña que ha introducido el usuario es correcta o no. Si es correcta pasa al estado S11.
--        Si es incorrecta PERO aun tiene intentos para adivinar la contraseña pasa al estado S12 y si se ha quedado sin intento pasa a S13
-- S11 => Estado de acierto. Enciende el led correspondiente y muestra en pantalla Y E S y el número de fallos cometidos.  
--        Pulsando el boton RESET_parcial se regresa al estado S0
-- S12 => Estado de error. Enciende el led correspondiente y muestra en pantalla n O   y el número de fallos cometidos.  
--        Pulsando el boton RESET_parcial se regresa al estado S1
-- S13 => Estado de error total. Enciende el led correspondiente y muestra en pantalla n O   F  
--        Pulsando el boton RESET_parcial se regresa al estado S0
--
-- La representación de la máquina de estados es la siguiente:
--
--                     S1--------<---------<--------<-------<--------<---|
--                      |                                        |       |               
--                      V                                        ^      S12   
--                      |                                        |       |              
--            S0---->--S2-->-S3-->-S4-->-S5-->-S6-->-S7-->-S8-->-S9--->-S10-->-S13--->--| 
--             |                                                         |              v
--             ^                                                        S11---->----->--| 
--             |                                                                        v
--             |--<-----<-----<------<-------<---------<---------<---------<-------<-----            
--
--
--  
-- En este bloque hay 3 process diferentes:
-- El primero llamado "reset_total" se encarga de gestionar la máquina de estados
-- si se pulsa el botón RESET o de hacer que funcione de forma sincrona .
-- El segundo process llamado "nextstate_decod" se encarga de las transiciones entre estados 
-- El tercer process llamado "output_decod" gestiona las funcionalidades de cada estado
--              
--------------------------------------------------INSTRUCCIONES------------------------------------------------------------------------
-- Cuando encendemos la placa hay que dar al botón superior de la cruzeta (RESET) para inicializar bien la máquina
-- Una vez pulsado se debe ir introduciendo dígito a dígito el número que se quiera para ver si es la contraseña correcta o no  
-- Obtenidos los cuatro números. Se nos hace la pregunta de si estamos seguros que es esa contraseña.
-- En caso afirmativo pulsamos el botón izquierdo de la cruzeta ( OK )  y en caso contrario pulsamos el botón 
-- del centro de la cruzeta ( RESET_parcial ), en el cual se nos permitire reintroducir la clave. 
-- Si  hemos decidido seguir se comprueba si has acertado o no y se te muestra en pantalla . 
-- Tras recibir la notificación debes pulsar el boton del centro para volver a intentarlo
-- en el caso que ya hayas terminado o intentarlo otra vez si aun te quedas intentos.


entity FSM is
  port (
 	--ENTRADAS
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
end FSM;

architecture behavioral of FSM is

type STATES is (S0, S1, S2, S3 , S4, S5, S6, S7, S8, S9, S10, S11, S12 , S13);
signal current_state: STATES:=S0;
signal next_state: STATES:=S0;
signal contador_fallos: integer :=0;                --Nos permite saber cuantos fallos lleva el usuario
signal error_pasw   : std_logic;                    --Señal que utilizamos como flag 
signal pasw :std_logic_vector (27 downto 0);        --Contraseña del sistema . SE PUEDE MODIFICAR EN S0
signal current_pasw :std_logic_vector(27 downto 0); --Signal donde se guarda la contraseña del usuario
signal ayuda_numero: std_logic_vector(6 downto 0);  --Señal que utilizamos como ayuda para guardar la contraseña actual
signal ayuda_flanco : std_logic;                    --Flag para ayudar a guardar la contraseña

begin

--- GESTION DE BOTON RESET ASINCRONO
reset_total: process(RESET,CLK,current_state)
begin
if RESET = '1' then 
current_state <= S0;
elsif rising_edge(CLK) then
current_state <= next_state;
end if;
end process;

--- TRANSICION DE ESTADOS 
nextstate_decod: process (OK, RESET_parcial,NUMERO,current_state,contador_fallos,ayuda_numero)
begin
next_state <= current_state;

case current_state is          
  when S0 =>    --Transicion de estado S0 a S2
   if NUMERO /= "1111110" then   -- Significa que hay algún SWITCH activo que esta mandando un número. No nos importa
    next_state <= S2;            -- para la transición saber que número manda, solo que manda un número
    ayuda_numero <= NUMERO;
   else next_state <= S0;
   end if;    
  when S1 =>    --Transicion de estado S1 a S2
   if NUMERO /= "1111110" then  
    next_state <= S2;
    ayuda_numero <= NUMERO;
   end if;
  when S2 =>    --Transicion de estado S2 a S3
   if NUMERO = "1111110" then     -- Significa que todos los SWITCH estan a cero , y por lo tanto no se envia ningún número
    next_state <= S3;
   end if;
  when S3 =>    --Transicion de estado S3 a S4
   if NUMERO /= "1111110" then
    next_state <= S4;
    ayuda_numero <= NUMERO; 
   end if;
  when S4 =>    --Transicion de estado S4 a S5
   if NUMERO = "1111110" then
    next_state <= S5;
   end if;
  when S5 =>    --Transicion de estado S5 a S6   
   if NUMERO /= "1111110" then
    next_state <= S6;
    ayuda_numero <= NUMERO;
   end if; 
  when S6 =>    --Transicion de estado S6 a S7
   if NUMERO = "1111110" then
    next_state <= S7;
   end if;    
  when S7 =>    --Transicion de estado S7 a S8
   if NUMERO /= "1111110" then
    next_state <= S8;
    ayuda_numero <= NUMERO;
   end if; 
  when S8 =>    --Transicion de estado S8 a S9
   if NUMERO = "1111110" then
    next_state <= S9;
   end if;  
  when S9 =>    --Transicion de estado S9 a S1 o S10 
   if OK = '1' then
    next_state <= S10;
   elsif RESET_parcial = '1' then
    next_state <= S1;
   else 
    next_state <= S9;
   end if;   
  when S10 =>   --Transicion de estado S10 a S11 , S12 o S13
   if (current_pasw = pasw) then
   next_state <= S11;
   elsif (current_pasw /= pasw) and (contador_fallos < 2) then
   next_state <= S12;
   else
   next_state <= S13;
   end if;
  when S11 =>   --Transicion de estado S11 a S1
   if RESET_parcial = '1' then
   next_state <= S0;
   end if;
  when S12 =>   --Transicion de estado S12 a S1
   if RESET_parcial = '1' then
   next_state <= S1;
   end if;
  when S13 =>   --Transicion de estado S13 a S1
   if RESET_parcial = '1' then
   next_state <= S0;
   end if;
  when others =>
   next_state <= S0;
  end case;
end process;

--- ACCIONES DE CADA ESTADO 
output_decod: process (NUMERO,current_state,contador_fallos,error_pasw,pasw,current_pasw)
  begin
  case current_state is
  when S0 =>  -- Desarrollo de S0
  	LED_ERROR<='0';
    LED_FATAL_ERROR<='0';
    LED_ACIERTO<='0';
    pasw(27 downto 21)  <="1001111";  -- primer digito de la contraseña -- 1
    pasw(20 downto 14)  <="0010010";  --segundo digito de la contraseña -- 2
    pasw(13 downto  7)  <="0000110";  --tercer digito de la contraseña  -- 3
    pasw(6  downto  0)  <="1001100";  --cuarto digito de la contraseña  -- 4
    VAL_DISPLAY_1 <= "1111110"; -- guion
    VAL_DISPLAY_2 <= "1111110"; -- guion
    VAL_DISPLAY_3 <= "1111110"; -- guion
    VAL_DISPLAY_4 <= "1111110"; -- guion
    contador_fallos <= 0;
    error_pasw <= '1';
    ayuda_flanco <='1';
  when S1 =>  -- Desarrollo de S1 
   	LED_ERROR<='0';
  	LED_FATAL_ERROR <='0';
  	LED_ACIERTO <='0';
  	error_pasw<='1';
    VAL_DISPLAY_1 <= "1111110"; -- guion
    VAL_DISPLAY_2 <= "1111110"; -- guion
    VAL_DISPLAY_3 <= "1111110"; -- guion
    VAL_DISPLAY_4 <= "1111110"; -- guion
    ayuda_flanco<='1';
  when S2 =>  -- Desarrollo de S2
    if ayuda_flanco = '1' then
    current_pasw(27 downto 21) <= ayuda_numero;
    ayuda_flanco <= '0';
    end if;
    VAL_DISPLAY_1 <= current_pasw(27 downto 21);
    VAL_DISPLAY_2 <= "1111110"; -- guion
    VAL_DISPLAY_3 <= "1111110"; -- guion
    VAL_DISPLAY_4 <= "1111110"; -- guion
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';  
    error_pasw <= '1';
  when S3 =>  -- Desarrollo de S3
   ayuda_flanco <= '1';
    VAL_DISPLAY_1 <= current_pasw(27 downto 21);
    VAL_DISPLAY_2 <= "1111110"; -- guion
    VAL_DISPLAY_3 <= "1111110"; -- guion
    VAL_DISPLAY_4 <= "1111110"; -- guion
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';   
  when S4 =>  -- Desarrollo de S4
   if ayuda_flanco = '1' then
    current_pasw(20 downto 14) <= ayuda_numero;
    ayuda_flanco <= '0';
    end if;
     VAL_DISPLAY_1 <= current_pasw(27 downto 21);
     VAL_DISPLAY_2  <= current_pasw(20 downto 14);
     VAL_DISPLAY_3 <= "1111110"; -- guion
     VAL_DISPLAY_4 <= "1111110"; -- guion
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0'; 
  when S5 =>  -- Desarrollo de S5
   ayuda_flanco <= '1';
    VAL_DISPLAY_1 <= current_pasw(27 downto 21);
     VAL_DISPLAY_2  <= current_pasw(20 downto 14);
     VAL_DISPLAY_3 <= "1111110"; -- guion
     VAL_DISPLAY_4 <= "1111110"; -- guion
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';     
  when S6 =>  -- Desarrollo de S6
    if ayuda_flanco = '1' then
    current_pasw(13 downto 7) <= ayuda_numero;
    ayuda_flanco <= '0';
    end if;
     VAL_DISPLAY_1 <= current_pasw(27 downto 21);
     VAL_DISPLAY_2  <= current_pasw(20 downto 14);
     VAL_DISPLAY_3  <= current_pasw(13 downto 7); 
     VAL_DISPLAY_4 <= "1111110"; -- guion 
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0'; 
  when S7 =>  -- Desarrollo de S7
   ayuda_flanco <= '1';
     VAL_DISPLAY_1 <= current_pasw(27 downto 21);
     VAL_DISPLAY_2  <= current_pasw(20 downto 14);
     VAL_DISPLAY_3  <= current_pasw(13 downto 7); 
     VAL_DISPLAY_4 <= "1111110"; -- guion 
   LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';    
  when S8 =>  -- Desarrollo de S8
   if ayuda_flanco = '1' then
    current_pasw(6 downto 0) <= ayuda_numero;
    ayuda_flanco <= '0';
    end if;
     VAL_DISPLAY_1 <= current_pasw(27 downto 21);
     VAL_DISPLAY_2  <= current_pasw(20 downto 14);
     VAL_DISPLAY_3  <= current_pasw(13 downto 7); 
     VAL_DISPLAY_4  <= current_pasw(6 downto 0);
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';
  when S9 =>  -- Desarrollo de S9
   ayuda_flanco <= '1';
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';
    VAL_DISPLAY_4  <= "1000100";  -- Y 
    VAL_DISPLAY_3  <= "0110000";  -- E 
    VAL_DISPLAY_2  <= "0100100";  -- S 
    VAL_DISPLAY_1  <= "0001101";  -- ? 
    error_pasw <='1';
   when S10 =>  -- Desarrollo de S10
    LED_ACIERTO <= '0';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';
    error_pasw <= '1';
   when S11 =>  -- Desarrollo de S11
    if contador_fallos = 0 then
      VAL_DISPLAY_1  <= "0000001";  -- numero de fallos 0
    elsif contador_fallos = 1 then
      VAL_DISPLAY_1  <="1001111";   --numero de fallos 1
    elsif contador_fallos = 2 then
      VAL_DISPLAY_1  <="0010010";   --numero de fallos 2
    end if;
    VAL_DISPLAY_4  <= "1000100";  -- Y 
    VAL_DISPLAY_3  <= "0110000";  -- E 
    VAL_DISPLAY_2  <= "0100100";  -- S 
    LED_ACIERTO <= '1';
    LED_ERROR <= '0';
    LED_FATAL_ERROR <= '0';
   when S12 =>  -- Desarrollo de S12
   if error_pasw = '1' then
    contador_fallos <= contador_fallos +1;
    error_pasw <= '0';
   end if;
   if contador_fallos = 1 then
      VAL_DISPLAY_1  <="1001111";   --numero de fallos 1
    elsif contador_fallos = 2 then
      VAL_DISPLAY_1  <="0010010";   --numero de fallos 2
    end if;
    VAL_DISPLAY_4  <= "1101010";  -- n 
    VAL_DISPLAY_3  <= "0000001";  -- O
    VAL_DISPLAY_2  <= "1111111";  -- 
    LED_ERROR <= '1';
    LED_ACIERTO <= '0';
    LED_FATAL_ERROR <= '0';
   when S13 =>  -- Desarrollo de S13
    VAL_DISPLAY_4  <= "1101010";  -- n
    VAL_DISPLAY_3  <= "0000001";  -- O
    VAL_DISPLAY_2  <= "1111111";  -- 
    VAL_DISPLAY_1  <= "0111000";  -- F 
    LED_FATAL_ERROR <= '1';
    LED_ERROR <= '1';
    LED_ACIERTO <= '0';
   when others =>
    LED_ACIERTO <= '1';
    LED_ERROR <= '1';
    LED_FATAL_ERROR <= '1';
  end case;  
  end process;
end behavioral;

