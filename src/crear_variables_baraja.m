% Permite crear un archivo .mat con los valores de los nombres de los
% archivos de las imagenes de la baraja (Baraja_fig) y los valores
% correspondientes a su figura (Baraja_val)

function crear_variables_baraja()
    Baraja_fig={'As_de_oros','As_de_espadas','As_de_copas','As_de_bastos','2_de_oros','2_de_espadas','2_de_copas','2_de_bastos','3_de_oros','3_de_espadas','3_de_copas','3_de_bastos','4_de_oros','4_de_espadas','4_de_copas','4_de_bastos','5_de_oros','5_de_espadas','5_de_copas','5_de_bastos','6_de_oros','6_de_espadas','6_de_copas','6_de_bastos','7_de_oros','7_de_espadas','7_de_copas','7_de_bastos','Sota_de_oros','Sota_de_espadas','Sota_de_copas','Sota_de_bastos','Caballo_de_oros','Caballo_de_espadas','Caballo_de_copas','Caballo_de_bastos','Rey_de_oros','Rey_de_espadas','Rey_de_copas','Rey_de_bastos'};
    Baraja_val=[1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]
    
    save("Baraja.mat", 'Baraja_fig', 'Baraja_val');