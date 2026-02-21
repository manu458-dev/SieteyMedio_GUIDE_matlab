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

% SE LIMPIAN LOS CONTENEDORES (PANELS)
reiniciar_juego(handles);

%SE HACE EL PROCESO DE CARGA DE BARAJA
cargar_variables_baraja();

% SE BARAJEA (handles se actualiza con Baraja_fig y Baraja_val barajeadas)
handles = barajear(hObject, handles);

handles
% SE REPARTE 1 CARTA AL JUGADOR
mostrar_figuras('Espadas/1_As_de_Espadas.png',1,'jugador',handles);
%mostrar_figuras('Espadas/2_de_Espadas.png',2,'jugador',handles);
%mostrar_figuras('Espadas/3_de_Espadas.png',1,'casa',handles);
%mostrar_figuras('Espadas/4_de_Espadas.png',2,'casa',handles);

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
pos_ver_c = handles.pos_ver_c;
P_J = handles.P_J;

if(P_J <= 7.5 && pos_ver_c<=13)
    fprintf("%i", pos_ver_c);
    mostrar_figuras('Espadas/1_As_de_Espadas.png',pos_ver_c,'jugador',handles);
    
    pos_ver_c = pos_ver_c + 1;
    handles.pos = pos_ver_c;
    guidata(hObject, handles);

    P_J = P_J + 1.5;
    handles.P_J = P_J;
    guidata(hObject, handles);
else
    fprintf("Se ha pasado el jugador, ha perdido");
    set(handles.PanelResultados, 'Visible', 'on');
    set(handles.editResultados, 'String', 'Te has pasado!!!, gana la Casa!!!');
end



% --- Executes on button press in btnPlantarse.
function btnPlantarse_Callback(hObject, eventdata, handles)
fprintf("Has presionado el botón de 'PLANTARSE'\n");
% AQUI SE GUARDAN O ACTUALIZAN LAS VARIABLES ACTUALE

% SE "VOLTEA" la ultima carta del jugador (que se vea la parte trasera)

% ESTE BOTON DESENCADENA EL EVENTO DE LA CASA
fprintf("le toca jugar a la casa!!");

% AQUI IRIA EL PROCESO DE LA CASA, LO QUE SE HIZO EN LAS PRACTICAS
set(handles.PanelResultados, 'Visible', 'on');
set(handles.editResultados, 'String', 'Turno de la casa');
mostrar_figuras('Espadas/1_As_de_Espadas.png',1,'casa',handles);

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
