%-------------------------------------------------------------------------%
% Program:                                                                %
% Date:                                                                   %
% Author:                                                                 %
%-------------------------------------------------------------------------%

% Clear
clear all;
close all;
clc;

% Decision Input Data
input('Input the name of the script to be solved ');
dynamicAnalysis = input('Do you wish to perform dynamic analysis? (Y/N) ','s');

% If a dynamic analysis is desired, input the number of vibration modes
if (dynamicAnalysis == 'S')
    vibrationModes = input('Input the desired number of vibration modes');
end

% Perform data transformation
[length, gamma, e] = DataProcessing(nodes, elements, elementType, dynamicAnalysis); 

% Compute sizes and positions of nodes in the structure matrices
[K, MpA, F, M, FixedMovements, AppliedForce,GdL] = Posicao_Kg(Elements, ElementType, FixedMovements, AppliedForce0);

for i = 1:length(elements)
    switch elementType(i) %caso o elemento for uma barra cria a matrizes globais
        case 'b'
            [Kg] = E_Barra(i,length,gamma,A,E);
            Fg=0; %não utilizado, mas o matlab precisa que a variavel esteja definida para usar como input na assemblagem (só é efetivamente usado se for uma viga com cargas distribuidas)
            Mg=0; %mesma situacao
        case 'v'
            [ Mg,Kg,Fg] = E_Viga(i,length,gamma,E,A,I,Q,dynamicAnalysis,ro); %se for uma viga cria as matrizes K global 
    end
    [ K, F, M] = Assemblagem(i,Kg,Fg,Elementos,K,MpA,E_tipo,F,Q,Mg,M,dynamicAnalysis); % faz a assemblagem dos dados das matrizes globais nas matrizes da estrutura 
end

% Update the vector of forces
F = F + AppliedForce; 
AllMovements = 1:length(K);
FreeMovements = setdiff(AllMovements,FixedMovements);
U = zeros(length(K),1);

% Compute Free Movements
U(FreeMovements) = K(FreeMovements, FreeMovements)\F(FreeMovements); 

% Post-processing
for i = 1:length(MpA) 
    
    % Display dos Deslocamentos 
    fprintf('\n Displacement at Node %d',i);
    fprintf('\t xx = %f',U(MpA(i)));
    fprintf('\t yy = %f',U(MpA(i)+1));
    
    if GdL(i) == 3
       fprintf('\t theta = %f',U(MpA(i)+2));
    end
end

% Reacoes nos apoios
R = K * U - F; %calculo das reaçoes nos apoios
   fprintf('\n\n Reações nos Apoios %d','');
for i=1:max(max(Elementos)) %Display reações nos Apoios
    if Movimentos_fixos0(i,1) ~= 0
        fprintf('\nReação Nó %d',i);
    fprintf('xx = %f\n',R(MpA(i)));
    end
    if Movimentos_fixos0(i,2) ~= 0
          fprintf('Reação Nó %d',i);
    fprintf('yy = %f\n',R(MpA(i)+1));
    end
    if Movimentos_fixos0(i,3) ~= 0
        fprintf('Reação Nó %d',i);
    fprintf('Mz = %f\n',R(MpA(i)+2));
    end
    
end


if dynamicAnalysis == 'N'  %esforços internos de Elementos pedidos
    fprintf('\n Esforços internos dos Elementos %d\n\n','');
while true
ii = input('Numero de Elemento?  [0 Para terminar]');
if ii == 0
    break
else
    
switch E_tipo(ii)
    
    case 'b'   %se o elemento for uma barra
[ F_axial,tensao_axial] = esforcos_internos_barra(ii,Elementos,gamma,U,length,E,A,MpA);
 fprintf('Elemento %d\n',ii);
    fprintf('F_axial = %f\n',F_axial);
    fprintf('tensao_axial = %f\n\n',tensao_axial);
    case 'v' %se o elemento for uma viga
        [F_axial,Esforco_Transverso_1,Esforco_Transverso_2,Momento_1,Momento_2,F_internos] = esforcos_internos_viga(ii,Elementos,gamma,U,length,E,A,I,MpA,Q);
    fprintf('Elemento %d\n',ii);
    fprintf('F axial = %f\n',F_axial);
    fprintf('Esforco Transverso no nó 1 = %f\n',Esforco_Transverso_1);
    fprintf('Momento Aplicado no nó 1 = %f\n',Momento_1);
    fprintf('Esforco Transverso no nó 2 = %f\n',Esforco_Transverso_2);
    fprintf('Momento Aplicado no nó 2 = %f\n',Momento_2);
end
end
end %loop de display dos esforços internos
end
%Analise Dinamica 
if dynamicAnalysis == 'S'
    fprintf('\n Frequencias Naturais \n%d','');
    [uw,Wn] = Analise_Modal(K,M,FreeMovements,N_modos_de_vib);
    for i=1:length(Wn) %print das frequencias naturais
          fprintf('Frequencia Natural %d',i);
    fprintf(' = %f\n',Wn(i));
    end
    disp('modos de vibracao'); %print modos de vibracao
    disp(uw);
   
end




