% 
% Trabalho Madelina para testar o programa. Resultados iguais ao Ansys
%
Nos=[0 0; 0 6;6 6;6 12;0 12];  %coordenadas cartesianas dos nós, No1 na primeira linha, Nó2 na seg, ect
Elementos= [1 2;2 3;2 5;4 5;3 4;3 5;1 3]; %Elementos e respetivos nós, Elemento1 na primeira linha, ect
E_tipo = ['v';'v';'v';'v';'v';'b';'b']; %Tipo de Elemento [ b = barra; v = viga], linha corresponde ao N de Elem. 
Movimentos_fixos0 = [1 0 0; 0 0 0; 0 1 0;0 0 0; 1 1 0];
A=(149e-4)*ones(7,1); % Area de secção de cada Elemento [Unidade: m^2]
E= (210e9)*ones(7,1); % Modulo de Young de Cada Elementento [Unidade: Pa] 
I=(252e-6)*ones(7,1); %Momento de Inercia de area Ixy [Unidade: m^4]
alt_v= 262e-3*ones(7,1); %Altura da secçao da viga
F_aplicada0 = [0 -25000 0; 0 0 0; 0 0 -15000; 25000 25000 0; 0 0 0]; %Forças Aplicadas nos Nós [linhas - Nº de Nó; Colunas - Fxx Fyy Mxy [Unidade: N, Nm]]
x=sym('x'); %permite a intrudução de qualquer tipo de função para a carga distribuida
Q=[0;0;30000;0;0;0;0]; %Cargas Aplicadas nas Vigas por ordem do nº do Elemento
clear x;
ro=7850*ones(7,1);