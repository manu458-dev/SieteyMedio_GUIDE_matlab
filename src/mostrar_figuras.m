function mostrar_figuras(carta_a_mostrar,pos, usuario, handles)

%pathname = 'D:\uam\trimestre 2\Inteligencia Computacional\semana4\SieteyMedio_GUIDE_matlab\assets\images\Mazos_de_cartas\Parte_Trasera\';
baseDir  = fileparts(mfilename('fullpath'));
rutaBase = fullfile(baseDir, '..', 'assets', 'images', 'Mazos_de_cartas');

% VERIFICACIÓN DE QUE TURNO ES:
% Si es jugador
if(strcmp(usuario, 'jugador'))
    switch pos
        % EN ESTA SECCIÓN, ESTAN LOS PANELES DEL JUGADOR
        case 1
            set(handles.PanelJ1,'Visible','on');
            %img = imread([pathname, char(carta_a_mostrar), '.png']);
            %axes(handles.axesJ1);
            %image(img);
            %axis off;
            set(handles.PanelJ1, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ1);
        case 2
            set(handles.PanelJ2, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ2);

        case 3
            set(handles.PanelJ3, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ3);
        case 4
            set(handles.PanelJ4, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ4);
        case 5
            set(handles.PanelJ5, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ5);
        case 6
            set(handles.PanelJ6, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ6);
        case 7
            set(handles.PanelJ7, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ7);

        case 8
            set(handles.PanelJ8, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ8);

        case 9
            set(handles.PanelJ9, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ9);

        case 10
            set(handles.PanelJ10, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ10);

        case 11
            set(handles.PanelJ11, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ11);

        case 12
            set(handles.PanelJ12, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesJ12);
    end

% Si es la casa   
else
    switch pos
        case 1
            set(handles.PanelC1, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC1);

        case 2
            set(handles.PanelC2, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC2);
        case 3
            set(handles.PanelC3, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC3);
        case 4
            set(handles.PanelC4, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC4);
        case 5
            set(handles.PanelC5, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC5);
        case 6
            set(handles.PanelC6, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC6);
        case 7
            set(handles.PanelC7, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC7);
        case 8
            set(handles.PanelC8, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC8);
        case 9
            set(handles.PanelC9, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC9);
        case 10
            set(handles.PanelC10, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC10);
        case 11
            set(handles.PanelC11, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC11);
        case 12
            set(handles.PanelC12, 'Visible', 'on');
            imgPath = fullfile(rutaBase, carta_a_mostrar);  % ej: .../Oros/1_As_de_Oros.png
            img = imread(imgPath);
            imshow(img, 'Parent', handles.axesC12);
    end

end

