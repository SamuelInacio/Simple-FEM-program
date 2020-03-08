% 
% Analise de EF da treliça com 6 barras
%
Nos=[0 0; 0 3;4 3;4,0];  %coordenadas cartesianas dos nós, No1 na primeira linha, Nó2 na seg, ect
Elementos= [1 2;2 3;3 4]; %Elementos e respetivos nós, Elemento1 na primeira linha, ect
E_tipo = ['v';'v';'v']; %Tipo de Elemento [ b = barra; v = viga], linha corresponde ao N de Elem.
Movimentos_fixos0= [1 1 1;0 0 0;0 0 0;1 1 1]; % Graus de Liberdade constrangidos por apoios 
A= (14.9e-3)*ones(3,1); % Area de secção de cada Elemento [Unidade: m^2]
E= (210e9)*ones(3,1); % Modulo de Young de Cada Elementento [Unidade: Pa] 
I=(252*10^-6)*ones(3,1); %Momento de Inercia de area Ixy [Unidade: m^4]
F_aplicada0= [0 0 0; 30000 0 0; 0 0 0; 0 0  0]; %Forças Aplicadas nos Nós Fxx Fyy Mxy [Unidade: N, Nm]
x=sym('x');
Q=[0;5000; 0]; %Cargas Aplicadas nas Vigas 
clear x;
ro=7850*ones(3,1);