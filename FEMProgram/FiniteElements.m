%-------------------------------------------------------------------------%
% Program: Finite Elements                                                %
% Date:  March 2020                                                       %
% Author: Samuel In�cio                                                   %
%-------------------------------------------------------------------------%

% Clear
clear all;
clc;

% Decision Condicioned on Input Data
input('Name of the script to be solved: ');
dynamicAnalysis = input('Perform dynamic analysis? (Y/N): ','s');

% If a dynamic analysis is desired, input the number of vibration modes
if (dynamicAnalysis == 'Y')
    vibrationModes = input('Desired number of vibration modes: ');
end

% Perform Data Transformation
[elementLength, gamma, elementType] = DataProcessing(nodes, elements, elementType, dynamicAnalysis); 

% Compute sizes and positions of nodes in the structure matrices
[K, MpA, F, M, fixedMovements, appliedForce, df] = PositionKg(elements, elementType, fixedMovements0, appliedForce0);

for i = 1:length(elements)
    switch elementType(i) 
        
        % Element is a Link - creates the global matrices
        case 'l'
            [Kg] = ElementLink(i, elementLength, gamma, A, E);
            
            % Not used, however needs to be specified in the assembly if the element is a beam with distributed loads
            Fg = 0; 
            Mg = 0; 
            
        % Element is a Beam   
        case 'b'            
            [Mg, Kg, Fg] = ElementBeam(i, elementLength, gamma, E, A, I, Q, dynamicAnalysis, rho); 
            
    end %% switch
    
    % Assembly of the global matrices of the struture 
    [K, F, M] = Assembler(i, Kg, Fg, elements, K, MpA, elementType, F, Q, Mg, M, dynamicAnalysis); 
end

% Update the vector of forces
F = F + appliedForce; 

allMovements = 1:length(K);
freeMovements = setdiff(allMovements, fixedMovements);
U = zeros(length(K),1);

% Compute Free Movements
U(freeMovements) = K(freeMovements, freeMovements)\F(freeMovements); 

% Post-processing
for i = 1:length(MpA) 
    
    % Display dos Deslocamentos 
    fprintf('\n Displacement at Node %d: ',i);
    fprintf('\t xx = %f',U(MpA(i)));
    fprintf('\t yy = %f',U(MpA(i)+1));
    
    if df(i) == 3
       fprintf('\t theta = %f',U(MpA(i)+2));
    end
end

% Reaction at the supports
R = K * U - F; 
   
% Display reactions at the supports
fprintf('\n\n Reaction at the supports %d','');

for i = 1:max(max(elements))   
    
    if fixedMovements0(i,1) ~= 0
        fprintf('\n Reaction at Node %d', i);
        fprintf('xx = %f\n', R(MpA(i)));
    end
    
    if fixedMovements0(i,2) ~= 0
        fprintf('Reaction at Node %d', i);
        fprintf('yy = %f\n', R(MpA(i)+1));
    end
    
    if fixedMovements0(i,3) ~= 0
        fprintf('Reaction at Node %d', i);
        fprintf('Mz = %f\n', R(MpA(i)+2));
    end    
end

% If no dynamic analysis is desired compute the internal stresses of the desired elements
if dynamicAnalysis == 'N' 
    fprintf('\n Internal stresses of the elements %d\n\n','');
    
    while true
        ii = input('Number of elements [Input 0 to terminate]');
        
        if ii == 0
            break
            else
                switch elementType(ii)

                    % The element is a link
                    case 'l'   
                        [axialForce, axialStress] =  InternalLinkStresses(ii, elements, gamma, U, elementLength, E, A, MpA);
                        fprintf('Element %d\n', ii);
                        fprintf('F_axial = %f\n', axialForce);
                        fprintf('tensao_axial = %f\n\n', axialStress);

                    % The element is a beam
                    case 'b' 
                        [axialForce, Esforco_Transverso_1, Esforco_Transverso_2, Momento_1, Momento_2, F_internos] = InternalBeamStresses(ii, elements, gamma, U,elementLength, E, A, I, MpA, Q);
                        fprintf('Elemento %d\n', ii);
                        fprintf('F axial = %f\n', axialForce);
                        fprintf('Esforco Transverso no n� 1 = %f\n',Esforco_Transverso_1);
                        fprintf('Applied moment at node 1 = %f\n', Momento_1);
                        fprintf('Esforco Transverso no n� 2 = %f\n', Esforco_Transverso_2);
                        fprintf('Applied moment at node 2 = %f\n', Momento_2);
                end
        end %% if
    end %% while
end %% iff


% Dynamic Analysis
if dynamicAnalysis == 'Y'
    
    % Display natural frequencies
    fprintf('\n Natural frequencies \n%d',''); % same as undamped frequencies ?
    
    [uw, Wn] = ModalAnalysis(K, M, freeMovements, vibrationModes);
    
    for i = 1:length(Wn) 
          fprintf('Natural Frequency %d',i);
          fprintf(' = %f\n',Wn(i));
    end
    
    disp('Vibration Modes'); 
    disp(uw);
   
end %% if




