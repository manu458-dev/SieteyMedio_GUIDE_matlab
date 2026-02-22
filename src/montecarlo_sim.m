function resultados = montecarlo_sim(num_iteraciones, estrategia_jugador, estrategia_casa)

    victorias_jugador = 0;
    victorias_casa    = 0;
    empates           = 0;

    for iter = 1:num_iteraciones
        % Crear y barajear mazo
        baraja_original = crear_baraja_sim();
        baraja = baraja_original(randperm(40), :);

        % Turno del jugador
        [cartas_J, P_J, baraja, jugador_se_paso] = turno_jugador_auto(baraja, estrategia_jugador);

        % Si el jugador se paso de 7.5, la casa gana automaticamente
        if jugador_se_paso
            victorias_casa = victorias_casa + 1;
            continue;
        end

        % Turno de la casa
        [P_C, casa_se_paso] = turno_casa_auto(baraja_original, baraja, cartas_J, P_J, estrategia_casa);

        % Si la casa se paso de 7.5, el jugador gana automaticamente
        if casa_se_paso
            victorias_jugador = victorias_jugador + 1;
            continue;
        end

        % Comparar puntos para determinar ganador
        puntos_J = sum(P_J);
        if P_C > puntos_J
            victorias_casa = victorias_casa + 1;
        elseif P_C == puntos_J
            % En empate, gana la casa
            empates = empates + 1;
            victorias_casa = victorias_casa + 1;
        else
            victorias_jugador = victorias_jugador + 1;
        end
    end

    % Armar struct de resultados
    resultados.victorias_jugador  = victorias_jugador;
    resultados.victorias_casa     = victorias_casa;
    resultados.empates            = empates;
    resultados.porcentaje_jugador = (victorias_jugador / num_iteraciones) * 100;
    resultados.porcentaje_casa    = (victorias_casa / num_iteraciones) * 100;
end


% BARAJA
function baraja = crear_baraja_sim()
    baraja = zeros(40, 3);
    numeros = [1:7, 10:12];
    valores = [1:7, 0.5, 0.5, 0.5];
    for palo = 1:4
        rango = (palo-1)*10 + 1 : palo*10;
        baraja(rango, 1) = numeros;
        baraja(rango, 2) = valores;
        baraja(rango, 3) = palo;
    end
end


% SACAR CARTA
function [carta, baraja] = sacar_carta_sim(baraja)
    carta = baraja(1, :);
    baraja(1, :) = [];
end


% TURNO DEL JUGADOR
function [cartas_J, P_J, baraja, se_paso] = turno_jugador_auto(baraja, estrategia)
    cartas_J = [];
    P_J = [];
    indice = 1;
    se_paso = false;

    switch estrategia
        case 'probabilidad'
            % --- Estrategia probabilistica ---
            % Calcula la probabilidad de pasarse (Pp) con las cartas
            % que quedan en el mazo. Si Pp >= 0.5, se planta.
            while true
                [carta, baraja] = sacar_carta_sim(baraja);
                cartas_J(indice, :) = carta;
                P_J(indice) = carta(2);
                indice = indice + 1;

                puntos_J = sum(P_J);

                % Se paso de 7.5 -> pierde
                if puntos_J > 7.5
                    se_paso = true;
                    return;
                end

                % Calcular prob de pasarse si pide otra carta
                % usando las cartas que quedan en el mazo
                cartas_pasan = (baraja(:, 2) + puntos_J) > 7.5;
                Pp = sum(cartas_pasan) / size(baraja, 1);

                % Si hay >= 50% de probabilidad de pasarse, se planta
                if Pp >= 0.5
                    return;
                end
            end

        case {'conservadora', 'moderada', 'arriesgada'}
            % --- Estrategias por umbral fijo ---
            switch estrategia
                case 'conservadora'
                    umbral = 4;   % Se planta con 4 o mas -> juega seguro
                case 'moderada'
                    umbral = 5;   % Se planta con 5 o mas -> equilibrado
                case 'arriesgada'
                    umbral = 6;   % Se planta con 6 o mas -> arriesgado
            end

            while true
                [carta, baraja] = sacar_carta_sim(baraja);
                cartas_J(indice, :) = carta;
                P_J(indice) = carta(2);
                indice = indice + 1;

                if sum(P_J) > 7.5
                    se_paso = true;
                    return;
                end

                if sum(P_J) >= umbral
                    return;
                end
            end

        otherwise
            [cartas_J, P_J, baraja, se_paso] = turno_jugador_auto(baraja, 'moderada');
    end
end


% TURNO DE LA CASA 

function [puntos_casa, se_paso] = turno_casa_auto(baraja_original, baraja, cartas_J, P_J, estrategia)
    se_paso = false;

    % Puntos visibles del jugador (la casa no ve la ultima carta)
    if length(P_J) > 1
        puntos_visibles_J = sum(P_J(1:end-1));
    else
        puntos_visibles_J = 0;  % solo 1 carta -> toda oculta
    end

    cartas_C = [];
    P_C = [];
    indice = 1;

    switch estrategia
        case 'probabilidad'
            % Saca cartas y calcula probabilidades
            while true
                [carta, baraja] = sacar_carta_sim(baraja);
                cartas_C(indice, :) = carta;
                P_C(indice) = carta(2);
                puntos_casa = sum(P_C);
                indice = indice + 1;

                % jugador gana
                if puntos_casa > 7.5
                    se_paso = true;
                    return;
                end

                % Calcular Pg y Pp con Bayes
                [Pg, Pp] = calcular_prob_sim(baraja_original, cartas_J, cartas_C, puntos_visibles_J, puntos_casa);

                % plantarse o seguir pidiendo
                if debe_plantarse_sim(Pg, Pp)
                    return;
                end
            end

        case {'conservadora', 'arriesgada'}
            if strcmp(estrategia, 'conservadora')
                umbral = 4;   % Se planta con 4 o mas
            else
                umbral = 6;   % Se planta con 6 o mas
            end

            while true
                [carta, baraja] = sacar_carta_sim(baraja);
                cartas_C(indice, :) = carta;
                P_C(indice) = carta(2);
                puntos_casa = sum(P_C);
                indice = indice + 1;

                if puntos_casa > 7.5
                    se_paso = true;
                    return;
                end

                if puntos_casa >= umbral
                    return;
                end
            end

        otherwise
            % Default: probabilidad
            [puntos_casa, se_paso] = turno_casa_auto(baraja_original, baraja, cartas_J, P_J, 'probabilidad');
    end
end


% PROBABILIDADES

function [Pg, Pp] = calcular_prob_sim(baraja_original, cartas_J, cartas_C, puntos_visibles_J, puntos_casa)
    % Quitar cartas conocidas (visibles del jugador + todas de la casa)
    cartas_conocidas = [cartas_J(1:end-1, :); cartas_C];
    baraja_nueva = baraja_original;
    for i = 1:size(cartas_conocidas, 1)
        idx = find(baraja_nueva(:,1) == cartas_conocidas(i,1) & baraja_nueva(:,3) == cartas_conocidas(i,3), 1);
        baraja_nueva(idx, :) = [];
    end

    num_desconocidas = size(baraja_nueva, 1);

    % Pg: Prob de ganar plantandose
    % P(A) = prob de que la carta oculta no pase al jugador
    Pg = 0;
    valores_unicos = unique(baraja_nueva(:, 2));
    matriz_eventos = zeros(length(valores_unicos), 2);
    matriz_eventos(:, 1) = valores_unicos;

    for i = 1:length(valores_unicos)
        if valores_unicos(i) + puntos_visibles_J <= 7.5
            matriz_eventos(i, 2) = sum(baraja_nueva(:, 2) == valores_unicos(i));
        end
    end

    vector_prob = matriz_eventos(:, 2) / num_desconocidas;
    PA = sum(vector_prob);  % P(jugador no se paso)

    % P(B|A) = prob de que la casa gane DADO que el jugador no se paso
    if PA > 0
        PBA = vector_prob / PA;
        for i = 1:size(matriz_eventos, 1)
            if matriz_eventos(i, 2) > 0
                if puntos_casa >= puntos_visibles_J + matriz_eventos(i, 1)
                    Pg = Pg + PBA(i);
                end
            end
        end
    end

    % Pp: Prob de pasarse si la casa pide otra carta
    se_pasan = (baraja_nueva(:, 2) + puntos_casa) > 7.5;
    Pp = sum(se_pasan) / num_desconocidas;
end


% DECISION DE PLANTARSE
function decision = debe_plantarse_sim(Pg, Pp)
    decision = (Pg >= 0.7) || (Pg >= 0.1 && Pg < 0.7 && Pp >= 0.55);
end
