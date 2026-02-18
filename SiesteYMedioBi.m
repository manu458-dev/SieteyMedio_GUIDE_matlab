close all
clear all
clc
rng('shuffle');

% ===================== MAIN =====================
baraja = crear_baraja();
baraja_mezclada = baraja(randperm(40), :);

mostrar_bienvenida();

[cartas_J, P_J, baraja_mezclada, abandono] = turno_jugador(baraja_mezclada);

if abandono
    return;
end

[cartas_C, P_C, baraja_mezclada] = turno_casa(baraja, baraja_mezclada, cartas_J, P_J);

if ~isempty(P_C) && sum(P_C) <= 7.5
    determinar_ganador(sum(P_C), sum(P_J));
end

% ===================== FUNCIONES =====================

function baraja = crear_baraja()
    baraja = zeros(40, 3);
    numeros = [1:7, 10:12];
    valores = [1:7, 0.5, 0.5, 0.5]';
    for palo = 1:4
        rango = (palo-1)*10 + 1 : palo*10;
        baraja(rango, 1) = numeros;
        baraja(rango, 2) = valores;
        baraja(rango, 3) = palo;
    end
end

function mostrar_bienvenida()
    fprintf("\t\tBienvenidos al juego del Siete y Medio\n");
    fprintf("La casa es benevolente con sus invitados, es por ello que inicias el juego\n\n");
    fprintf("=============================================================================\n\n");
    fprintf("Dependiendo el numero es el palo que sacaste:\n1=Oro  2=Copa  3=Espada  4=Basto\n");
end

function mostrar_cartas(cartas)
    fprintf('%-10s %-10s %-10s\n', 'Numero', 'Valor', 'Palo');
    for i = 1:size(cartas, 1)
        fprintf('%-10d %-10.2f %-10d\n', cartas(i,1), cartas(i,2), cartas(i,3));
    end
end

function [carta, baraja_mezclada] = sacar_carta(baraja_mezclada)
    carta = baraja_mezclada(1, :);
    baraja_mezclada(1, :) = [];
end

function [cartas_J, P_J, baraja_mezclada, abandono] = turno_jugador(baraja_mezclada)
    cartas_J = [];
    P_J = [];
    indice = 1;
    abandono = false;

    while true
        fprintf("\nTu puntuacion actual es de: %.2f\n", sum(P_J));
        P = input("¿Quieres pedir más cartas?\n1 = Pedir carta | 0 = Plantarse: \n");

        if P == 0
            break;
        end

        [carta, baraja_mezclada] = sacar_carta(baraja_mezclada);
        cartas_J(indice, :) = carta;
        P_J(indice) = carta(2);
        indice = indice + 1;

        mostrar_cartas(cartas_J);

        if sum(P_J) > 7.5
            fprintf("Te pasaste, has perdido todo. :(\n");
            abandono = true;
            return;
        end
    end

    if sum(P_J) == 0
        fprintf("La casa ha ganado!\n\t¿Creiste que con cero puntos ganabas?\n");
        abandono = true;
    end
end

function [cartas_C, P_C, baraja_mezclada] = turno_casa(baraja_original, baraja_mezclada, cartas_J, P_J)
    fprintf("----------------------------------------------------------------------------\n");
    fprintf("Es el turno de la casa...\n");
    fprintf("La casa empieza con 0.00\n\n");

    % Mostrar cartas visibles del jugador (todas menos la última)
    fprintf("La casa ve que el jugador tiene:\n");
    mostrar_cartas(cartas_J(1:end-1, :));
    puntos_visibles_J = sum(P_J(1:end-1));
    fprintf("Puntos visibles del jugador: %.2f\n\n", puntos_visibles_J);

    cartas_C = [];
    P_C = [];
    indice = 1;

    while true
        [carta, baraja_mezclada] = sacar_carta(baraja_mezclada);
        cartas_C(indice, :) = carta;
        P_C(indice) = carta(2);
        puntos_casa = sum(P_C);
        indice = indice + 1;

        mostrar_cartas(cartas_C);
        fprintf('Puntuacion de la casa: %.2f\n', puntos_casa);

        if puntos_casa > 7.5
            fprintf("\nLa casa se ha pasado con %.2f. ¡El jugador gana!\n", puntos_casa);
            return;
        end

        [Pg, Pp] = calcular_probabilidades(baraja_original, cartas_J, cartas_C, puntos_visibles_J, puntos_casa);

        fprintf('Pg (ganar sin pedir) = %.4f\n', Pg);
        fprintf('Pp (perder si pide)  = %.4f\n\n', Pp);

        if debe_plantarse(Pg, Pp)
            fprintf("La casa decide plantarse con %.2f puntos.\n", puntos_casa);
            break;
        else
            fprintf("La casa decide pedir otra carta...\n");
        end
    end
end

function [Pg, Pp] = calcular_probabilidades(baraja_original, cartas_J, cartas_C, puntos_visibles_J, puntos_casa)
    % Reconstruir baraja desconocida (sin cartas visibles)
    cartas_conocidas = [cartas_J(1:end-1, :); cartas_C];
    baraja_nueva = baraja_original;
    for i = 1:size(cartas_conocidas, 1)
        idx = find(baraja_nueva(:,1) == cartas_conocidas(i,1) & baraja_nueva(:,3) == cartas_conocidas(i,3), 1);
        baraja_nueva(idx, :) = [];
    end

    num_desconocidas = size(baraja_nueva, 1);

    % --- Pg: prob de ganar sin pedir ---
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
    PA = sum(vector_prob);

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

    % --- Pp: prob de pasarse si pide ---
    se_pasan = (baraja_nueva(:, 2) + puntos_casa) > 7.5;
    Pp = sum(se_pasan) / num_desconocidas;
end

function decision = debe_plantarse(Pg, Pp)
    decision = (Pg >= 0.7) || (Pg >= 0.1 && Pg < 0.7 && Pp >= 0.55);
end

function determinar_ganador(puntos_casa, puntos_jugador)
    if puntos_casa > puntos_jugador
        fprintf("La casa ha ganado todo, suerte a la proxima.\n");
    elseif puntos_casa == puntos_jugador
        fprintf("Empate, pero aqui la casa siempre gana, ¡has perdido!\n");
    else
        fprintf("¡Le has ganado a la casa! No era tan dificil despues de todo.\n");
    end
end
