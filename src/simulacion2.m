function varargout = simulacion2(varargin)
% SIMULACION2 MATLAB code for simulacion2.fig
%      SIMULACION2, by itself, creates a new SIMULACION2 or raises the existing
%      singleton*.
%
%      H = SIMULACION2 returns the handle to a new SIMULACION2 or the handle to
%      the existing singleton*.
%
%      SIMULACION2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULACION2.M with the given input arguments.
%
%      SIMULACION2('Property','Value',...) creates a new SIMULACION2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulacion2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulacion2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulacion2_OpeningFcn, ...
                   'gui_OutputFcn',  @simulacion2_OutputFcn, ...
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


% --- Executes just before simulacion2 is made visible.
function simulacion2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Limpiar campos de resultados de forma segura
tags_a_limpiar = {'editVecesJ', 'editVecesC', 'editEmpate', 'edit4', 'edit5'};
for i = 1:length(tags_a_limpiar)
    if isfield(handles, tags_a_limpiar{i})
        set(handles.(tags_a_limpiar{i}), 'String', '');
    end
end

% Redireccionar callbacks programaticamente para asegurar independencia del FIG
componentes = fieldnames(handles);
for i = 1:length(componentes)
    comp = handles.(componentes{i});
    % Verificar que sea un handle escalar y que tenga la propiedad Callback
    if ~isempty(comp) && isscalar(comp) && ishandle(comp) && isprop(comp, 'Callback')
        try
            cb_actual = get(comp, 'Callback');
            if ischar(cb_actual) && contains(cb_actual, 'simulacion(')
                % Extraer nombre del callback local
                tokens = regexp(cb_actual, '''([^'']+)''', 'tokens');
                if ~isempty(tokens)
                    cb_nombre = tokens{1}{1};
                    % Intentar vincular de forma que siempre pase 3 argumentos
                    try
                        set(comp, 'Callback', @(h, e) simulacion2(cb_nombre, h, e, guidata(h)));
                    catch
                    end
                end
            end
        catch
            % Algunos componentes pueden dar error al consultar propiedades
        end
    end
end

% Forzar vinculo de botones criticos
if isfield(handles, 'BtnEmpezar'), set(handles.BtnEmpezar, 'Callback', @(h, e) BtnEmpezar_Callback(h, e, guidata(h))); end
if isfield(handles, 'BtnSalir'), set(handles.BtnSalir, 'Callback', @(h, e) BtnSalir_Callback(h, e, guidata(h))); end

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = simulacion2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% 
function textENumero_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function textENumero_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in BtnSalir.
function BtnSalir_Callback(hObject, eventdata, handles)
% Cerrar de forma segura
if isfield(handles, 'figureEmpate')
    delete(handles.figureEmpate);
elseif isfield(handles, 'figure1')
    delete(handles.figure1);
else
    close(gcbf);
end


% --- Executes on button press in BtnEmpezar.
function BtnEmpezar_Callback(hObject, eventdata, handles)
% Validar estructura de handles
if ~isstruct(handles)
    msgbox('Error: La estructura de la GUI no se cargo correctamente. Intenta reiniciar con "clear all".', 'Error', 'error');
    return;
end

% Verificación de versión
msgbox('Ejecutando Simulacion2 - Version v3 (Empates)', 'Update', 'help');

% Cambiar nombre a la ventana si existe el tag
if isfield(handles, 'figureEmpate')
    set(handles.figureEmpate, 'Name', 'Siete y Medio - Simulacion V3');
elseif isfield(handles, 'figure1')
    set(handles.figure1, 'Name', 'Siete y Medio - Simulacion V3');
end

% Leer el numero de iteraciones
num_iter = str2double(get(handles.textENumero, 'String'));
if isnan(num_iter) || num_iter <= 0
    msgbox('Error: ingresa un numero valido de iteraciones.', 'Error', 'error');
    return;
end
num_iter = round(num_iter);

% Leer las estrategias seleccionadas
estrategias_J = get(handles.popupEstrategiasJ, 'String');
idx_J = get(handles.popupEstrategiasJ, 'Value');
est_J_nombre = estrategias_J{idx_J};

estrategias_C = get(handles.popupEstrategiasC, 'String');
idx_C = get(handles.popupEstrategiasC, 'Value');
est_C_nombre = estrategias_C{idx_C};

% Mapear nombres 
est_J = mapear_estrategia(est_J_nombre);
est_C = mapear_estrategia(est_C_nombre);

% Ejecutar la simulacion
fprintf('\nSimulando %d partidas...\n', num_iter);
resultados = montecarlo_sim(num_iter, est_J, est_C);

% Calcular resultados exclusivos para la visualización
v_jugador = resultados.victorias_jugador;
v_empate = resultados.empates;
v_casa_pura = resultados.victorias_casa - v_empate;

pct_jugador = (v_jugador / num_iter) * 100;
pct_casa = (v_casa_pura / num_iter) * 100;
pct_empate = (v_empate / num_iter) * 100;

% Mostrar resultados en los edit text
set(handles.editVecesJ, 'String', sprintf('%d (%.1f%%)', v_jugador, pct_jugador));
set(handles.editVecesC, 'String', sprintf('%d (%.1f%%)', v_casa_pura, pct_casa));

% Actualizar campo de empate de forma robusta
empate_str = sprintf('%d (%.1f%%)', v_empate, pct_empate);
tags_empate = {'editEmpate', 'edit4', 'edit5'};
exito_empate = false;

for i = 1:length(tags_empate)
    if isfield(handles, tags_empate{i})
        set(handles.(tags_empate{i}), 'String', empate_str);
        exito_empate = true;
    end
end

if ~exito_empate
    fprintf('\n[ADVERTENCIA] No se encontro un tag para empates. Tags disponibles:\n');
    disp(fieldnames(handles));
end

% Dibujar histograma en el axes
cla(handles.axesGrafica);
datos = [v_jugador, v_casa_pura, v_empate];
colores = [0.2 0.6 0.9; 0.9 0.3 0.3; 0.3 0.8 0.4];

% Usar una sola serie de barras (más robusto para etiquetas)
b = bar(handles.axesGrafica, datos, 0.6, 'FaceColor', 'flat');
b.CData = colores;

% Etiquetas sobre las barras
for i = 1:length(datos)
    text(handles.axesGrafica, i, datos(i), sprintf('%d', datos(i)), ...
        'Parent', handles.axesGrafica, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontSize', 10, 'FontWeight', 'bold');
end

% Configurar ejes
set(handles.axesGrafica, 'XTick', [1 2 3], 'XTickLabel', {'Jugador', 'Casa', 'Empate'});
xlim(handles.axesGrafica, [0.4 3.6]);
ylabel(handles.axesGrafica, 'Partidas', 'FontSize', 10);
title(handles.axesGrafica, sprintf('Resultados (%d partidas)', num_iter), 'FontSize', 12);
grid(handles.axesGrafica, 'on');
set(handles.axesGrafica, 'FontSize', 10);

% Forzar actualización de la GUI
drawnow;

fprintf('\n=== Monte Carlo: %d partidas ===\n', num_iter);
fprintf('Jugador: %.1f%% | Casa (Pura): %.1f%% | Empate: %.1f%%\n', ...
    pct_jugador, pct_casa, pct_empate);


% --- Executes on selection change in popupEstrategiasC.
function popupEstrategiasC_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupEstrategiasC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupEstrategiasJ.
function popupEstrategiasJ_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupEstrategiasJ_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%  mapear el nombre de estrategia 
function clave = mapear_estrategia(nombre)
    switch lower(strtrim(nombre))
        case {'probabilidad', 'probabilistica'}
            clave = 'probabilistica';
        case 'conservadora'
            clave = 'conservadora';
        case 'moderada'
            clave = 'moderada';
        case 'arriesgada'
            clave = 'arriesgada';
        otherwise
            clave = 'moderada';  % default
    end



function editVecesC_Callback(hObject, eventdata, handles)
% hObject    handle to editVecesC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVecesC as text
%        str2double(get(hObject,'String')) returns contents of editVecesC as a double


% --- Executes during object creation, after setting all properties.
function editVecesC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVecesC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVecesJ_Callback(hObject, eventdata, handles)
% hObject    handle to editVecesJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVecesJ as text
%        str2double(get(hObject,'String')) returns contents of editVecesJ as a double


% --- Executes during object creation, after setting all properties.
function editVecesJ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVecesJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function editEmpate_Callback(hObject, eventdata, handles)
% hObject    handle to editEmpate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEmpate as text
%        str2double(get(hObject,'String')) returns contents of editEmpate as a double


% --- Executes during object creation, after setting all properties.
function editEmpate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEmpate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to editEmpate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEmpate as text
%        str2double(get(hObject,'String')) returns contents of editEmpate as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEmpate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
