    function varargout = GUIDE1(varargin)
% GUIDE1 MATLAB code for GUIDE1.fig
%      GUIDE1, by itself, creates a new GUIDE1 or raises the existing
%      singleton*.
%
%      H = GUIDE1 returns the handle to a new GUIDE1 or the handle to
%      the existing singleton*.
%
%      GUIDE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDE1.M with the given input arguments.
%
%      GUIDE1('Property','Value',...) creates a new GUIDE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIDE1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIDE1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIDE1

% Last Modified by GUIDE v2.5 21-Feb-2026 12:53:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIDE1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIDE1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIDE1 is made visible.
function GUIDE1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIDE1 (see VARARGIN)

% Choose default command line output for GUIDE1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%CONFIGURACIÓN DE VARIALES GLOBALES PERSONALIZADAS
handles.P_J = 0.0; % PUNTUACIÓN TOTAL DEL JUGADOR
guidata(hObject, handles);

handles.P_C = 0.0; % PUNTUACIÓN TOTAL DE LA CASA
guidata(hObject, handles);

handles.pos_carta_1 = 1; % USAR con VARIABLES Baraja_figura y Bajara_valor
guidata(hObject, handles);

handles.total_cartas = 40; % auxiliar para el calculo de probabilidades
guidata(hObject, handles);

handles.pos_ver_c = 1; % contador para desplegar los paneles del jugador y carta
guidata(hObject, handles);

handles.i = 1;
guidata(hObject, handles);
% UIWAIT makes GUIDE1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.axesJ13.Toolbar.Visible = 'off';
al_abrir_ventana(handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUIDE1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% CONFIGURACIÓN DE FONDO DE PANTALLA
%   setBackgroundWindow(hObject);   -

%%%% SUPPORT FUNCTIONS %%%%
%% CONFIGURACION DE FONDO DE PANTALLA
% Recibe como parametro el objeto componente sobre el que se quieref
% configurar
function setBackgroundWindow(hObject)
 % 1) Que el axes cubra toda la figura
    set(hObject, 'Units','normalized', ...
                 'Position',[0 0 1 1]);

    % 2) Cargar imagen
    basePath = fileparts(mfilename('fullpath'));
    imgPath  = fullfile(basePath, './green-background1.jpg'); % cambia por tu archivo
    I = imread(imgPath);

    % 3) Dibujar imagen estirada
    image('Parent', hObject, 'CData', I);

    % Forzar que ocupe TODO el axes
    set(hObject, 'XLim', [1 size(I,2)], ...
                 'YLim', [1 size(I,1)], ...
                 'YDir', 'reverse');   % importante para que no se invierta

    % Ajuste para que se estire
    set(hObject, 'Position',[0 0 1 1]);
    axis(hObject, 'off');
    set(hObject, 'Units','normalized');

    % 4) Que no bloquee botones
    set(hObject, 'HitTest','off');
    set(findobj(hObject,'Type','image'),'HitTest','off');

    % 5) Mandar al fondo
    uistack(hObject,'bottom');


% --- Executes on button press in btnNuevoJuego.
function btnNuevoJuego_Callback(hObject, eventdata, handles)
fprintf("Has presionado el botón de 'JUEVO NUEVO'\n");

% SE LIMPIAN LOS CONTENEDORES Y SE RESETEAN LAS VARIABLES
handles = reiniciar_juego(handles);
guidata(hObject, handles);

%SE HACE EL PROCESO DE CARGA DE BARAJA
crear_variables_baraja();
cargar_variables_baraja();

% SE BARAJEA (handles se actualiza con Baraja_fig y Baraja_val barajeadas)
handles = barajear(hObject, handles);

% SE REPARTE 1 CARTA AL JUGADOR
% Tomar la primera carta de la baraja barajeada
carta_fig = handles.Baraja_fig{handles.pos_carta_1};  % ruta relativa de la imagen
carta_val = handles.Baraja_val(handles.pos_carta_1);  % valor numérico de la carta

% Actualizar puntuación del jugador
handles.P_J = handles.P_J + carta_val;
guidata(hObject, handles);

% Mostrar la carta en la posición visual 1 del jugador
mostrar_figuras(carta_fig, handles.pos_ver_c, 'jugador', handles);

% Avanzar contadores
handles.pos_carta_1 = handles.pos_carta_1 + 1;  % siguiente carta del mazo
handles.pos_ver_c   = handles.pos_ver_c   + 1;  % siguiente slot visual del jugador
guidata(hObject, handles);

fprintf("Carta repartida al jugador: %s  (valor: %.1f) | P_J total: %.1f\n", ...
        carta_fig, carta_val, handles.P_J);

% SE COMIENZA CON EL CLICLO REPARTIR - PEDIR/PLANTARSE

% SE PASA EL TURNO A LA MAQUINA
    % Aqui se implementa lo que se hizo en la práctica anterior

% SE EVAUAL LOS RESULTADOS (ver ganador)




% --- Executes on button press in btnSimulacion.
function btnSimulacion_Callback(hObject, eventdata, handles)

fprintf("Has presionado el botón de 'SIMULACIÓN'\n");


% --- Executes on button press in btnSalir.
function btnSalir_Callback(hObject, eventdata, handles)
fprintf("Has presionado el botón de 'SALIR'\n");
figure1_CloseRequestFcn(handles.figure1, eventdata, handles)


% --- Executes on button press in btnPedir.
function btnPedir_Callback(hObject, eventdata, handles)
fprintf("Has presionado el botón de 'PEDIR MÁS CARTAS'\n");

P_J       = handles.P_J;
pos_ver_c = handles.pos_ver_c;

% Solo se puede pedir si no se ha pasado y quedan slots visuales
if (P_J <= 7.5 && pos_ver_c <= 12)

    % --- Tomar siguiente carta del mazo ---
    carta_fig = handles.Baraja_fig{handles.pos_carta_1};
    carta_val = handles.Baraja_val(handles.pos_carta_1);

    % --- Actualizar puntuación del jugador ---
    P_J = P_J + carta_val;
    handles.P_J = P_J;
    guidata(hObject, handles);

    % --- Mostrar la carta en el slot visual correspondiente ---
    mostrar_figuras(carta_fig, pos_ver_c, 'jugador', handles);
    fprintf("Carta pedida: %s  (valor: %.1f) | P_J total: %.1f\n", carta_fig, carta_val, P_J);

    % --- Avanzar contadores ---
    handles.pos_carta_1 = handles.pos_carta_1 + 1;
    handles.pos_ver_c   = pos_ver_c + 1;
    guidata(hObject, handles);

    % --- Verificar si el jugador se pasó DESPUÉS de sumar ---
    if P_J > 7.5
        fprintf("¡El jugador se ha pasado! P_J = %.1f\n", P_J);
        set(handles.PanelResultados, 'Visible', 'on');
        set(handles.editResultados, 'String', sprintf('¡Te has pasado! (%.1f) Gana la Casa!!!', P_J));
    end

else
    fprintf("No se puede pedir más cartas. P_J=%.1f pos=%d\n", P_J, pos_ver_c);
    set(handles.PanelResultados, 'Visible', 'on');
    set(handles.editResultados, 'String', '¡No puedes pedir más cartas!');
end



% --- Executes on button press in btnPlantarse.
function btnPlantarse_Callback(hObject, eventdata, handles)
fprintf("Has presionado el botón de 'PLANTARSE'\n");

% El jugador se planta: mostrar mensaje provisional
P_J = handles.P_J;
fprintf("El jugador se planta con P_J = %.2f\n", P_J);
set(handles.PanelResultados, 'Visible', 'on');
set(handles.editResultados, 'String', sprintf('Te plantaste con %.1f. Turno de la casa...', P_J));

% --- TURNO DE LA CASA: repartir primera carta ---
carta_fig_c = handles.Baraja_fig{handles.pos_carta_1};
carta_val_c = handles.Baraja_val(handles.pos_carta_1);

handles.P_C         = handles.P_C + carta_val_c;
handles.pos_carta_1 = handles.pos_carta_1 + 1;
guidata(hObject, handles);

mostrar_figuras(carta_fig_c, 1, 'casa', handles);
fprintf("Casa recibe 1a carta: %s (valor: %.1f) | P_C = %.2f\n", carta_fig_c, carta_val_c, handles.P_C);

% Verificar si la primera carta ya pasa de 7.5 (muy raro pero posible)
if handles.P_C > 7.5
    set(handles.editResultados, 'String', ...
        sprintf('¡Ganaste! La casa se pasó en su primera carta (%.1f vs tu %.1f)', handles.P_C, P_J));
    return;
end

% --- BUCLE COMPLETO DE LA CASA (decisión probabilística) ---
handles = juega_casa(hObject, handles);
function editResultados_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function editResultados_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axesJ13_CreateFcn(hObject, eventdata, handles)
handles.axesJ13.Toolbar.Visible = 'off';


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
fprintf("Se ha cerrado la ventana con éxito\n");
