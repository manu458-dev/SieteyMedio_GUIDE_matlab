function cargar_variables_baraja()
    S = load('Baraja.mat');
    assignin('base','Baraja_fig', S.Baraja_fig);
    assignin('base','Baraja_val', S.Baraja_val);
    fprintf("¡Se han cargado exitosamente las variables a Matlab!\n");
end