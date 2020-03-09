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
if (dynamicAnalysis == 'Y')
    vibrationModes = input('Input the desired number of vibration modes');
end

% Perform data transformation
[elementLength, gamma, elementType] = DataProcessing(nodes, elements, elementType, dynamicAnalysis); 

% Compute sizes and positions of nodes in the structure matrices
[K, MpA, F, M, fixedMovements, appliedForce, df] = Posicao_Kg(elements, elementType, newAppliedForce);

for i = 1:elementLength(elements)
    switch elementType(i) %caso o elemento for uma barra cria a matrizes globais
        % Links
        case 'l'
            [Kg] = elementLink(i, elementLength, gamma, A, E);
            Fg = 0; %n�o utilizado, mas o matlab precisa que a variavel esteja definida para usar como input na assemblagem (s� � efetivamente usado se for uma viga com cargas distribuidas)
            Mg = 0; %mesma situacao
        % beams    
        case 'b'
            %se for uma viga cria as matrizes K global 
            [ Mg,Kg,Fg] = elementBeam(i, elementLength, gamma, E, A, I, Q, dynamicAnalysis, ro); 
    end %% switch
    
    % faz a assemblagem dos dados das matrizes globais nas matrizes da estrutura 
    [K, F, M] = Assemblagem(i, Kg, Fg, Elementos, K, MpA, elementType, F, Q, Mg, M, dynamicAnalysis); 
end

% Update the vector of forces
F = F + appliedForce; 
allMovements = 1:length(K);
freeMovements = setdiff(allMovements, fixedMovements);
U = zeros(length(K),1);

% Compute Free Movements
U(freeMovements) = K(freeMovements, freeMovements)\F(freeMovements); 

% Post-processing
for i = 1:elementLength(MpA) 
    
    % Display dos Deslocamentos 
    fprintf('\n Displacement at Node %d',i);
    fprintf('\t xx = %f',U(MpA(i)));
    fprintf('\t yy = %f',U(MpA(i)+1));
    
    if df(i) == 3
       fprintf('\t theta = %f',U(MpA(i)+2));
    end
end

% Reaction at the supports
R = K * U - F; 
   
% Display Reaction at the supports
fprintf('\n\n Reaction at the supports %d','');

for i = 1:max(max(elements))     
    if newFixedMovements(i,1) ~= 0
        fprintf('\n Reaction at Node %d', i);
        fprintf('xx = %f\n', R(MpA(i)));
    end
    if newFixedMovements(i,2) ~= 0
        fprintf('Reaction at Node %d', i);
        fprintf('yy = %f\n', R(MpA(i)+1));
    end
    if newFixedMovements(i,3) ~= 0
        fprintf('Reaction at Node %d', i);
        fprintf('Mz = %f\n', R(MpA(i)+2));
    end    
end

% If no dynamic analysis is desired compute the internal "esfor�os" of the
% desired elements
if dynamicAnalysis == 'N' 
    fprintf('\n Internar "esfor�os" of the elements %d\n\n','');
    
    while true
        ii = input('Number of elements [Input 0 to terminate]');
        
        if ii == 0
            break
            else
                switch elementType(ii)

                    % The element is a bar
                    case 'b'   
                        [F_axial, tensao_axial] = esforcos_internos_barra(ii, elemnts, gamma, U, elementLength, E, A, MpA);
                        fprintf('Element %d\n', ii);
                        fprintf('F_axial = %f\n', F_axial);
                        fprintf('tensao_axial = %f\n\n', tensao_axial);

                    % The element is a beam
                    case 'v' 
                        [F_axial, Esforco_Transverso_1, Esforco_Transverso_2, Momento_1, Momento_2, F_internos] = esforcos_internos_viga(ii, elements, gamma, U,elementLength, E, A, I, MpA, Q);
                        fprintf('Elemento %d\n', ii);
                        fprintf('F axial = %f\n', F_axial);
                        fprintf('Esforco Transverso no n� 1 = %f\n',Esforco_Transverso_1);
                        fprintf('Applied moment at node 1 = %f\n', Momento_1);
                        fprintf('Esforco Transverso no n� 2 = %f\n', Esforco_Transverso_2);
                        fprintf('Applied moment at node 2 = %f\n', Momento_2);
                end
        end %% if
    end %% while
end %% iff

%Dynamic Analysis
if dynamicAnalysis == 'Y'
    
    % Display natural frequencies
    fprintf('\n Natural frequencies \n%d',''); % same as undamped frequencies ?
    
    [uw, Wn] = Analise_Modal(K, M, freeMovements, vibrationModes);
    for i=1:elementLength(Wn) 
          fprintf('Frequencia Natural %d',i);
    fprintf(' = %f\n',Wn(i));
    end
    disp('modos de vibracao'); 
    disp(uw);
   
end




