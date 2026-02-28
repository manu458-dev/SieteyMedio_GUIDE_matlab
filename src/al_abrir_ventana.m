function al_abrir_ventana(handles)
    % Ruta relativa desde la ubicación de este fichero
    baseDir   = fileparts(mfilename('fullpath'));
    pathname  = fullfile(baseDir, '..', 'assets', 'images', 'Mazos_de_cartas', 'Parte_Trasera');
    imagename = "Parte_Trasera";

    % Lista de axes
    ax = [
        handles.axesJ1
        handles.axesJ2
        handles.axesJ3
        handles.axesJ4
        handles.axesJ5
        handles.axesJ6
        handles.axesJ7
        handles.axesJ8
        handles.axesJ9
        handles.axesJ10
        handles.axesJ11
        handles.axesJ12
        handles.axesJ13
        handles.axesC1
        handles.axesC2
        handles.axesC3
        handles.axesC4
        handles.axesC5
        handles.axesC6
        handles.axesC7
        handles.axesC8
        handles.axesC9
        handles.axesC10
        handles.axesC11
        handles.axesC12
        handles.axesC13
        handles.axesBaraja
    ];

    % Leer imagen (usa fullfile para evitar errores de \)
    filename = fullfile(pathname, imagename + ".jpeg");
    img = imread(filename);

    % Pintar en todos los axes
    for k = 1:numel(ax)
        cla(ax(k), 'reset');                 % limpia el axes
        imshow(img, 'Parent', ax(k));        % dibuja en ESE axes
        axis(ax(k), 'off');

        %% quita las opciones de arriba del acces (el pequeño toolbar)
        ax(k).Toolbar.Visible = 'off';

    end
end