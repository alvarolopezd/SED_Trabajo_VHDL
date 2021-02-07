-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--Esta entidad es la m�quina de estados de nuestro proyecto. Presentamos los estados que posee la m�quina:
-- S0  =>  Estado inicial al cual solo se accede al iniciar la m�quina ,al pulsar el boton RESET o acertando o fallando completamente
--         la contrase�a. Inicializa todas las variables y etea la contrase�a del sistema.
--         En este caso la modificamos en la se�al " pasw " y es 1 2 3 4.
-- S1  =>  Estado de reposo a la cual se llega tras conocer si has acertado , fallado o perdido y pulsas el boton RESET_parcial
--         o bien cuando al introducir una contrase�a te equivocas y quieres reintroducirla de nuevo sin gastar un intento
-- S2  => Obtenci�n del primer n�mero
-- S3  => Estado de tr�nsito entre el primer y el segundo n�mero
-- S4  => Obtenci�n del segundo n�mero
-- S5  => Estado de tr�nsito entre el segundo y el tercer n�mero
-- S6  => Obtenci�n del tercer n�mero
-- S7  => Estado de tr�nsito entre el tercer y el cuarto n�mero
-- S8  => Obtenci�n del cuarto n�mero
-- S9  => Estado en el que se le pregunta al usuario si quiere introducir esa contrase�a. Si pulsa OK se procedera a comprobar 
--        la contrase�a y se pasara al estado S10 . Si el usuario se ha confundido pulsa RESET_parcial y pasa al estado S1.
--        Aclarar que esta situaci�n no es un error al comprobar la contrase�a , es un error en el cual el usuario se ha equivocado
--        al activar los switches y quiere reintroducir la contrase�a sin gastar un intento
-- S10 => En este estado se comprueba si la contrase�a que ha introducido el usuario es correcta o no. Si es correcta pasa al estado S11.
--        Si es incorrecta PERO aun tiene intentos para adivinar la contrase�a pasa al estado S12 y si se ha quedado sin intento pasa a S13
-- S11 => Estado de acierto. Enciende el led correspondiente y muestra en pantalla Y E S y el n�mero de fallos cometidos.  
--        Pulsando el boton RESET_parcial se regresa al estado S0
-- S12 => Estado de error. Enciende el led correspondiente y muestra en pantalla n O   y el n�mero de fallos cometidos.  
--        Pulsando el boton RESET_parcial se regresa al estado S1
-- S13 => Estado de error total. Enciende el led correspondiente y muestra en pantalla n O   F  
--        Pulsando el boton RESET_parcial se regresa al estado S0
--
-- La representaci�n de la m�quina de estados es la siguiente:
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
-- El primero llamado "reset_total" se encarga de gestionar la m�quina de estados
-- si se pulsa el bot�n RESET o de hacer que funcione de forma sincrona .
-- El segundo process llamado "nextstate_decod" se encarga de las transiciones entre estados 
-- El tercer process llamado "output_decod" gestiona las funcionalidades de cada estado
--              
--------------------------------------------------INSTRUCCIONES------------------------------------------------------------------------
-- Cuando encendemos la placa hay que dar al bot�n superior de la cruzeta (RESET) para inicializar bien la m�quina
-- Una vez pulsado se debe ir introduciendo d�gito a d�gito el n�mero que se quiera para ver si es la contrase�a correcta o no  
-- Obtenidos los cuatro n�meros. Se nos hace la pregunta de si estamos seguros que es esa contrase�a.
-- En caso afirmativo pulsamos el bot�n izquierdo de la cruzeta ( OK )  y en caso contrario pulsamos el bot�n 
-- del centro de la cruzeta ( RESET_parcial ), en el cual se nos permitire reintroducir la clave. 
-- Si  hemos decidido seguir se comprueba si has acertado o no y se te muestra en pantalla . 
-- Tras recibir la notificaci�n debes pulsar el boton del centro para volver a intentarlo
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
signal error_pasw   : std_logic;                    --Se�al que utilizamos como flag 
signal pasw :std_logic_vector (27 downto 0);        --Contrase�a del sistema . SE PUEDE MODIFICAR EN S0
signal current_pasw :std_logic_vector(27 downto 0); --Signal donde se guarda la contrase�a del usuario
signal ayuda_numero: std_logic_vector(6 downto 0);  --Se�al que utilizamos como ayuda para guardar la contrase�a actual
signal ayuda_flanco : std_logic;                    --Flag para ayudar a guardar la contrase�a

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
   if NUMERO /= "1111110" then   -- Significa que hay alg�n SWITCH activo que esta mandando un n�mero. No nos importa
    next_state <= S2;            -- para la transici�n saber que n�mero manda, solo que manda un n�mero
    ayuda_numero <= NUMERO;
   else next_state <= S0;
   end if;    
  when S1 =>    --Transicion de estado S1 a S2
   if NUMERO /= "1111110" then  
    next_state <= S2;
    ayuda_numero <= NUMERO;
   end if;
  when S2 =>    --Transicion de estado S2 a S3
   if NUMERO = "1111110" then     -- Significa que todos los SWITCH estan a cero , y por lo tanto no se envia ning�n n�mero
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
    pasw(27 downto 21)  <="1001111";  -- primer digito de la contrase�a -- 1
    pasw(20 downto 14)  <="0010010";  --segundo digito de la contrase�a -- 2
    pasw(13 downto  7)  <="0000110";  --tercer digito de la contrase�a  -- 3
    pasw(6  downto  0)  <="1001100";  --cuarto digito de la contrase�a  -- 4
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

