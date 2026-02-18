function varargout = prueba(varargin)
% PRUEBA MATLAB code for prueba.fig
%      PRUEBA, by itself, creates a new PRUEBA or raises the existing
%      singleton*.
%
%      H = PRUEBA returns the handle to a new PRUEBA or the handle to
%      the existing singleton*.
%
%      PRUEBA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRUEBA.M with the given input arguments.
%
%      PRUEBA('Property','Value',...) creates a new PRUEBA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prueba_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prueba_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prueba

% Last Modified by GUIDE v2.5 18-Feb-2026 16:03:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prueba_OpeningFcn, ...
                   'gui_OutputFcn',  @prueba_OutputFcn, ...
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


% --- Executes just before prueba is made visible.
function prueba_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    rng('shuffle');

    % Crear y mezclar baraja
    handles.baraja_mezclada = crear_baraja_mezclada();

    % Crear txt_info si no existe en el .fig
    if ~isfield(handles, 'txt_info')
        figPos = get(hObject, 'Position');
        handles.txt_info = uicontrol('Parent', hObject, 'Style', 'text', ...
            'Tag', 'txt_info', ...
            'String', '', ...
            'Position', [50, 10, figPos(3)-100, 30], ...
            'FontSize', 13, 'FontWeight', 'bold', ...
            'ForegroundColor', [1, 1, 1], ...
            'BackgroundColor', [0.15, 0.4, 0.25], ...
            'HorizontalAlignment', 'center');
    end

    % Texto placeholder en el axes
    axes(handles.axes_carta);
    text(0.5, 0.5, {'Presiona', '"Pedir carta"', 'para comenzar'}, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 14, 'FontWeight', 'bold', ...
        'Color', [1, 0.84, 0], ...
        'Units', 'normalized');

    guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = prueba_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;


% --- Executes on button press in btn_pedir.
function btn_pedir_Callback(hObject, eventdata, handles)
% hObject    handle to btn_pedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isempty(handles.baraja_mezclada)
        handles.baraja_mezclada = crear_baraja_mezclada();
    end

    % Sacar carta
    carta = handles.baraja_mezclada(1, :);
    handles.baraja_mezclada(1, :) = [];

    numero = carta(1);
    valor  = carta(2);
    palo   = carta(3);

    % Mostrar imagen de la carta
    mostrar_imagen_carta(handles.axes_carta, numero, palo);

    % Mostrar info textual
    set(handles.txt_info, 'String', sprintf('%d de %s  —  Valor: %.1f', ...
        numero, nombre_palo(palo), valor));

    guidata(hObject, handles);


% ========================================================================
%                        FUNCIONES DEL JUEGO
% ========================================================================

function baraja_mezclada = crear_baraja_mezclada()
    baraja = zeros(40, 3);
    numeros = [1:7, 10:12];
    valores = [1:7, 0.5, 0.5, 0.5]';
    for palo = 1:4
        rango = (palo-1)*10 + 1 : palo*10;
        baraja(rango, 1) = numeros;
        baraja(rango, 2) = valores;
        baraja(rango, 3) = palo;
    end
    baraja_mezclada = baraja(randperm(40), :);

% ========================================================================
%                        FUNCIONES AUXILIARES
% ========================================================================

function mostrar_imagen_carta(ax, numero, palo)
    ruta = obtener_ruta_imagen(numero, palo);
    if exist(ruta, 'file')
        img = imread(ruta);
        cla(ax);
        imshow(img, 'Parent', ax);
        set(ax, 'Visible', 'off');
    else
        cla(ax);
        set(ax, 'Visible', 'off');
        text(0.5, 0.5, sprintf('%d de %s\n(imagen no encontrada)', numero, nombre_palo(palo)), ...
            'Parent', ax, ...
            'HorizontalAlignment', 'center', ...
            'FontSize', 12, 'FontWeight', 'bold', ...
            'Color', [1, 0.3, 0.3], ...
            'Units', 'normalized');
    end

function ruta = obtener_ruta_imagen(numero, palo)
    carpeta_base = fileparts(mfilename('fullpath'));
    nombres_palo = {'Oros', 'Copas', 'Espadas', 'Bastos'};
    carpeta_palo = nombres_palo{palo};

    if numero == 1
        nombre_archivo = sprintf('1_As_de_%s.png', carpeta_palo);
    else
        nombre_archivo = sprintf('%d_de_%s.png', numero, carpeta_palo);
    end

    ruta = fullfile(carpeta_base, 'assets', 'images', 'Mazos_de_cartas', carpeta_palo, nombre_archivo);

function nombre = nombre_palo(palo)
    nombres = {'Oro', 'Copa', 'Espada', 'Basto'};
    nombre = nombres{palo};
