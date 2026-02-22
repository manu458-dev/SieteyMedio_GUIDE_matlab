function handles = juega_casa(hObject, handles)
    fprintf("----------------------------------------------------------------------------\n");
    fprintf("Es el turno de la casa...\n");
    fprintf("La casa empieza con %.2f (ya tiene su primera carta)\n\n", handles.P_C);

    % Slot visual de la casa (pos 1 ya fue usada en btnPlantarse, empezar en 2)
    pos_ver_c_casa = 2;

    % Puntos visibles del jugador (la casa NO ve la última carta)
    % Igual que en SiesteYMedioBi2.m: puntos_visibles_J = sum(P_J(1:end-1))
    cartas_J = handles.cartas_J_val;
    if length(cartas_J) > 1
        puntos_visibles_J = sum(cartas_J(1:end-1));
    else
        puntos_visibles_J = 0;  % solo tiene 1 carta -> toda oculta
    end
    ultima_carta_J_val = cartas_J(end);  % valor de la carta oculta

    % BUCLE DE TURNO DE LA CASA
    while true

        % Calcular probabilidades con el estado actual del mazo
        [Pg, Pp] = calcular_probabilidades_casa(handles, puntos_visibles_J, ultima_carta_J_val);

        fprintf('Pg (ganar plantandose) = %.4f\n', Pg);
        fprintf('Pp (pasarse si pide)   = %.4f\n\n', Pp);

        % Decision: plantarse o pedir?
        if debe_plantarse_casa(Pg, Pp)
            fprintf("La casa decide plantarse con %.2f puntos.\n", handles.P_C);
            break;
        end

        % La casa pide una carta mas
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

        % Se paso la casa? 
        if handles.P_C > 7.5
            fprintf("\nLa casa se paso con %.2f. El jugador gana!\n", handles.P_C);
            set(handles.PanelResultados, 'Visible', 'on');
            set(handles.editResultados, 'String', ...
                sprintf('Ganaste! La casa se paso (%.1f vs tu %.1f)', handles.P_C, handles.P_J));
            return;
        end
    end

    %  GANA LA CASA
    handles = determinar_ganador_gui(hObject, handles);
end


%  calcular probabilidades 
%   - Cartas desconocidas = mazo restante + carta oculta del jugador
%   - Pg usa probabilidad condicional: P(casa gana | jugador no se pasa)
function [Pg, Pp] = calcular_probabilidades_casa(handles, puntos_visibles_J, ultima_carta_J_val)
    % Cartas en el mazo (no repartidas) + carta oculta del jugador
    idx_inicio       = handles.pos_carta_1;
    valores_mazo     = handles.Baraja_val(idx_inicio:end);
    valores_desconocidos = [valores_mazo, ultima_carta_J_val];
    num_desconocidas     = length(valores_desconocidos);
    puntos_casa          = handles.P_C;

    if num_desconocidas <= 0
        Pg = 0; Pp = 0;
        return;
    end

    %  P(A)  la carta oculta no pasa al jugador de 7.5 
    valores_unicos = unique(valores_desconocidos);
    matriz_eventos = zeros(length(valores_unicos), 2);
    matriz_eventos(:, 1) = valores_unicos;

    for i = 1:length(valores_unicos)
        v = valores_unicos(i);
        if v + puntos_visibles_J <= 7.5
            cant = sum(valores_desconocidos == v);
            matriz_eventos(i, 2) = cant;
        end
    end

    vector_prob = matriz_eventos(:, 2) / num_desconocidas;
    PA = sum(vector_prob);

    %  P(B|A) -> dado que no se paso, la casa le gana? 
    Pg = 0;
    if PA > 0
        PBA = vector_prob / PA;
        for i = 1:size(matriz_eventos, 1)
            if matriz_eventos(i, 2) > 0
                v = matriz_eventos(i, 1);
                if puntos_casa >= puntos_visibles_J + v
                    Pg = Pg + PBA(i);
                end
            end
        end
    end

    %  probabilidad de pasarse si la casa pide una carta mas
    se_pasan = (valores_desconocidos + puntos_casa) > 7.5;
    Pp = sum(se_pasan) / num_desconocidas;
end


%  decision de plantarse
function decision = debe_plantarse_casa(Pg, Pp)
    decision = (Pg >= 0.7) || (Pg >= 0.1 && Pg < 0.7 && Pp >= 0.55);
end


%  determinar y mostrar el ganador en la GUI
function handles = determinar_ganador_gui(hObject, handles)
    P_J = handles.P_J;
    P_C = handles.P_C;

    set(handles.PanelResultados, 'Visible', 'on');

    if P_C > P_J
        msg = sprintf('Gana la Casa! (%.1f vs tu %.1f)', P_C, P_J);
        fprintf("La casa ha ganado. (%.2f vs %.2f)\n", P_C, P_J);
    elseif P_C == P_J
        msg = sprintf('Empate (%.1f), pero gana la Casa en caso de empate.', P_C);
        fprintf("Empate %.2f - gana la casa.\n", P_C);
    else
        msg = sprintf('Ganaste! (%.1f vs casa %.1f)', P_J, P_C);
        fprintf("El jugador gana! (%.2f vs %.2f)\n", P_J, P_C);
    end

    set(handles.editResultados, 'String', msg);
    guidata(hObject, handles);
end
