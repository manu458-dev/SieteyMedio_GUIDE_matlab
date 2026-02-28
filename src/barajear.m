function handles = barajear(hObject, handles)
% BARAJEAR  Baraja aleatoriamente las variables Baraja_fig y Baraja_val
%           que fueron cargadas previamente al workspace base por
%           cargar_variables_baraja().
%
%   Algoritmo del profesor:
%     - 100 iteraciones externas (itera = 100)
%     - En cada iteración, se generan entre 1 y 2000 intercambios aleatorios
%     - Cada intercambio toma dos posiciones c1 y c2 al azar (1..40)
%       y permuta tanto la figura como el valor de esas posiciones.
%
%   Al finalizar, las baraja barajeadas se guardan en handles y en guidata.

    % Recuperar variables del workspace base
    Baraja_fig = evalin('base', 'Baraja_fig');
    Baraja_val = evalin('base', 'Baraja_val');

    itera = 100;

    for i = 1:itera
        cambios = round(1 + (rand * 1999));   % entre 1 y 2000 intercambios

        for j = 1:cambios
            c1 = round(1 + rand * 39);   % posición aleatoria 1 (1..40)
            c2 = round(1 + rand * 39);   % posición aleatoria 2 (1..40)

            % Intercambiar figuras
            aux_f         = Baraja_fig(c1);
            aux_v         = Baraja_val(c1);
            Baraja_fig(c1) = Baraja_fig(c2);
            Baraja_val(c1) = Baraja_val(c2);
            Baraja_fig(c2) = aux_f;
            Baraja_val(c2) = aux_v;
        end
    end

    % Guardar la baraja barajeada en handles para que esté disponible en la GUI
    handles.Baraja_fig = Baraja_fig;
    guidata(hObject, handles);
    handles.Baraja_val = Baraja_val;
    guidata(hObject, handles);

    fprintf("¡Baraja barajeada exitosamente!\n");
end
