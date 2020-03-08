% 
% Trabalho carlos para testar o programa- resultados iguais ao ANSYS
Nos=[18 6;12 6;12 0;6 0;6 6;0 0];  %coordenadas cartesianas dos n�s, No1 na primeira linha, N�2 na seg, ect
Elementos= [2 1;3 1;3 2;4 3;5 2;4 5;6 4;6 5]; %Elementos e respetivos n�s, Elemento1 na primeira linha, ect
E_tipo = ['v';'b';'v';'v';'v';'v';'b';'b']; %Tipo de Elemento [ b = barra; v = viga], linha corresponde ao N de Elem.
Movimentos_fixos0 = [1 0 0;0 0 0;1 1 0;0 0 0;0 0 0;1 1 0];% Graus de Liberdade constrangidos por apoios [Linhas - Numero do N�; Colunas - Dire��o xx, yy, teta (0 = Livre, 1 = constrangindo)] 
A=(149.1e-4)*ones(8,1); % Area de sec��o de cada Elemento [Unidade: m^2]
E= (210e9)*ones(8,1); % Modulo de Young de Cada Elementento [Unidade: Pa] 
I=(25170e-8)*ones(8,1); %Momento de Inercia de area Ixy [Unidade: m^4]
F_aplicada0 = [0 -25000 0; 0 0 15000;0 0 0; 0 0 -15000; 0 0 0;0 0 0]; %For�as Aplicadas nos N�s [linhas - N� de N�; Colunas - Fxx Fyy Mxy [Unidade: N, Nm]]
x=sym('x'); %permite a intrudu��o de qualquer tipo de fun��o para a carga distribuida
Q=[0;0;0;30000;0;0;0]; %Cargas Aplicadas nas Vigas por ordem do n� do Elemento
clear x;
ro=7850*ones(6,1);