
%ElementLink: Creates the stiffness matrix of the link element in global variables
function [Kg] = ElementLink(i, elementLength, gamma, A, E)

    % Stiffness matrix in local coordinates
    Ke = A(i)*E(i)/elementLength(i)*[1 -1; -1 1];
    
    % Transformation matrix
    T = [cosd(gamma(i))     sind(gamma(i))            0                   0; 
              0                  0              cosd(gamma(i))      sind(gamma(i))];
    
    % Stiffness matrix in global coordinates
    Kg = T'*Ke*T;
end

