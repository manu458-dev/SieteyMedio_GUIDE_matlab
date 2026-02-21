function handles = juega_casa(hObject, handles)
% JUEGA_CASA  Implementa el turno completo de la máquina (casa).
%
%   Adaptación de turno_casa() de SiesteYMedioBi2.m al contexto GUIDE:
%   - No se eliminan cartas del arreglo; se usa pos_carta_1 como puntero
%   - Cada carta se muestra en la GUI con mostrar_figuras()
%   - Al final se evalúa el ganador y se muestra en editResultados

    fprintf("----------------------------------------------------------------------------\n");
    fprintf("Es el turno de la casa...\n");
    fprintf("La casa empieza con %.2f (ya tiene su primera carta)\n\n", handles.P_C);

    % Slot visual de la casa (pos 1 ya fue usada en btnPlantarse, empezar en 2)
    pos_ver_c_casa = 2;

    % Puntos visibles del jugador (la casa NO ve la última carta del jugador)
    % Aproximación: la casa conoce P_J - valor de la última carta (desconocida)
    % Como no guardamos cartas individuales, usamos P_J directamente como
    % referencia (simplificación válida para el proyecto)
    puntos_visibles_J = handles.P_J;

    % --------------------------------------------------------
    % BUCLE DE TURNO DE LA CASA
    % --------------------------------------------------------
    while true

        % Calcular probabilidades con el estado actual del mazo
        [Pg, Pp] = calcular_probabilidades_casa(handles, puntos_visibles_J);

        fprintf('Pg (ganar plantándose) = %.4f\n', Pg);
        fprintf('Pp (pasarse si pide)   = %.4f\n\n', Pp);

        % ---- Decisión: ¿plantarse o pedir? ----
        if debe_plantarse_casa(Pg, Pp)
            fprintf("La casa decide plantarse con %.2f puntos.\n", handles.P_C);
            break;
        end

        % ---- La casa pide una carta más ----
        fprintf("La casa decide pedir otra carta...\n");

        carta_fig = handles.Baraja_fig{handles.pos_carta_1};
        carta_val = handles.Baraja_val(handles.pos_carta_1);

        handles.P_C         = handles.P_C + carta_val;
        handles.pos_carta_1 = handles.pos_carta_1 + 1;
        guidata(hObject, handles);

        % Mostrar carta en la GUI (slots C2, C3, ...)
        if pos_ver_c_casa <= 12
            mostrar_figuras(carta_fig, pos_ver_c_casa, 'casa', handles);
            pos_ver_c_casa = pos_ver_c_casa + 1;
        end

        fprintf("Casa recibe carta: %s (valor: %.1f) | P_C total: %.2f\n", ...
                carta_fig, carta_val, handles.P_C);

        % ---- ¿Se pasó la casa? ----
        if handles.P_C > 7.5
            fprintf("\nLa casa se pasó con %.2f. ¡El jugador gana!\n", handles.P_C);
            set(handles.PanelResultados, 'Visible', 'on');
            set(handles.editResultados, 'String', ...
                sprintf('¡Ganaste! La casa se pasó (%.1f vs tu %.1f)', handles.P_C, handles.P_J));
            return;
        end
    end

    % --------------------------------------------------------
    % DETERMINAR GANADOR (la casa se plantó sin pasarse)
    % --------------------------------------------------------
    handles = determinar_ganador_gui(hObject, handles);
end


% =========================================================================
% FUNCIÓN AUXILIAR: calcular probabilidades
%   Adaptación de calcular_probabilidades() de SiesteYMedioBi2.m
%   Sin eliminar cartas del arreglo — usa pos_carta_1 como índice de inicio
% =========================================================================
function [Pg, Pp] = calcular_probabilidades_casa(handles, puntos_visibles_J)
    % Cartas "desconocidas" = las que quedan desde pos_carta_1 en adelante
    idx_inicio     = handles.pos_carta_1;
    total_cartas   = length(handles.Baraja_val);
    num_desconocidas = total_cartas - idx_inicio + 1;

    if num_desconocidas <= 0
        Pg = 0; Pp = 0; return;
    end

    valores_restantes = handles.Baraja_val(idx_inicio:end);
    puntos_casa       = handles.P_C;

    % --- Pg: probabilidad de ganar plantándose (sin pedir) ---
    % La casa gana si P_C > puntos_visibles_J y la carta oculta no ayuda al jugador
    Pg = 0;
    valores_unicos = unique(valores_restantes);
    for i = 1:length(valores_unicos)
        v = valores_unicos(i);
        cant = sum(valores_restantes == v);
        prob_v = cant / num_desconocidas;
        % Si el jugador tomara esta carta no superaría a la casa
        if (puntos_visibles_J + v) <= puntos_casa
            Pg = Pg + prob_v;
        end
    end

    % --- Pp: probabilidad de pasarse si la casa pide una carta más ---
    se_pasan = (valores_restantes + puntos_casa) > 7.5;
    Pp = sum(se_pasan) / num_desconocidas;
end


% =========================================================================
% FUNCIÓN AUXILIAR: decisión de plantarse
%   Misma lógica que debe_plantarse() de SiesteYMedioBi2.m
% =========================================================================
function decision = debe_plantarse_casa(Pg, Pp)
    decision = (Pg >= 0.7) || (Pg >= 0.1 && Pg < 0.7 && Pp >= 0.55);
end


% =========================================================================
% FUNCIÓN AUXILIAR: determinar y mostrar el ganador en la GUI
% =========================================================================
function handles = determinar_ganador_gui(hObject, handles)
    P_J = handles.P_J;
    P_C = handles.P_C;

    set(handles.PanelResultados, 'Visible', 'on');

    if P_C > P_J
        msg = sprintf('¡Gana la Casa! (%.1f vs tu %.1f)', P_C, P_J);
        fprintf("La casa ha ganado. (%.2f vs %.2f)\n", P_C, P_J);
    elseif P_C == P_J
        msg = sprintf('Empate (%.1f), pero gana la Casa en caso de empate.', P_C);
        fprintf("Empate %.2f — gana la casa.\n", P_C);
    else
        msg = sprintf('¡Ganaste! (%.1f vs casa %.1f)', P_J, P_C);
        fprintf("¡El jugador gana! (%.2f vs %.2f)\n", P_J, P_C);
    end

    set(handles.editResultados, 'String', msg);
    guidata(hObject, handles);
end
