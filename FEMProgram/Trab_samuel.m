% 
% Trabalho samuel
Nos=[0 0;6 0;12 0;6 6;6 12];                                %coordenadas cartesianas dos nós, No1 na primeira linha, Nó2 na seg, ect
Elementos= [1 2;2 3;3 4;1 4;2 4;4 5];                       %Elementos e respetivos nós, Elemento1 na primeira linha, ect
E_tipo = ['b';'b';'v';'v';'b';'v'];                         %Tipo de Elemento [ b = barra; v = viga], linha corresponde ao N de Elem.
Movimentos_fixos0 = [0 0 0;0 0 0;0 0 0;0 0 0;1 1 1];          % Graus de Liberdade constrangidos por apoios [Linhas - Numero do Nó; Colunas - Direção xx, yy, teta (0 = Livre, 1 = constrangindo)] 
A=(149.1e-4)*ones(6,1);                                         % Area de secção de cada Elemento [Unidade: m^2]
E= (210e9)*ones(6,1);                                               % Modulo de Young de Cada Elementento [Unidade: Pa] 
I=(25170e-8)*ones(6,1);                                                     %Momento de Inercia de area Ixy [Unidade: m^4]
F_aplicada0 = [0 -25000 0; 0 -50000 0;0 -75000 -15000; 0 0 0; 0 0 0]; %Forças Aplicadas nos Nós [linhas - Nº de Nó; Colunas - Fxx Fyy Mxy [Unidade: N, Nm]]
x=sym('x');                                                             %permite a intrudução de qualquer tipo de função para a carga distribuida
Q=[0;0;0;30000;0;0;0];                                                    %Cargas Aplicadas nas Vigas por ordem do nº do Elemento
clear x;
ro=7850*ones(6,1);