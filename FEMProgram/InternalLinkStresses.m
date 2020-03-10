
% esforcos_internos:  calcula os esforços internos de um elemento b
% tranformando a matriz de deslocamentos para coordenadas locais, é
% possivel calcular as forças e tensões internas de cada elemento

function [axialForce,tensao_axial ] = InternalLinkStresses(i, elements, gamma, U, elementLength, E, A, MpA)

    % Node 1 -  one of the elements to compute
    node1 = elements(i,1); 
    
    % Node 2 -  one of the elements to compute
    node2 = elements(i,2);
    
    % Matrix of local stiffness 
    Ke = A(i)*E(i)/elementLength(i)*[1 -1;-1 1]; 
    
    % Pre-allocation
    Ug = zeros(4,1);
    
    % Global displacement matrix
    Ug(1,1) = U(MpA(node1));     
    Ug(2,1) = U(MpA(node1)+1);
    Ug(3,1) = U(MpA(node2));
    Ug(4,1) = U(MpA(node2)+1);
    
    % Transformation matrix
    T = [cosd(gamma(i))     sind(gamma(i))            0                   0; 
              0                  0              cosd(gamma(i))      sind(gamma(i))];    
   
    % Transformation to local coordinates    
    Ue = T*Ug; 
    
    % Applied Forces
    appliedForces1 = Ke*Ue; 
    
    % Axial force according to sign convention
    axialForce = appliedForces1(2); 
    
    %Axial tension in the load  - tensão axial na barra
    tensao_axial = axialForce/A(i); 