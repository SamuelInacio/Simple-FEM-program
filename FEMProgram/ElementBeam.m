
% ElementBeam -Create stiffness matrixof the beam element in global coordinates
function [Mg, Kg, Fg] = ElementBeam(i, elementLength, alpha, E, A, I, Q, dynamicAnalysis, rho)

    % Beam stiffness matrix as seen from local coordinates
    Ke = [E(i)*A(i)/elementLength(i)              0                           0                -E(i)*A(i)/elementLength(i)             0                            0; 
                 0               12*E(i)*I(i)/elementLength(i)^3    6*E(i)*I(i)/elementLength(i)^2            0             -12*E(i)*I(i)/elementLength(i)^3     6*E(i)*I(i)/elementLength(i)^2;
                 0               6*E(i)*I(i)/elementLength(i)^2     4*E(i)*I(i)/elementLength(i)              0              -6*E(i)*I(i)/elementLength(i)^2     2*E(i)*I(i)/elementLength(i);
         -E(i)*A(i)/elementLength(i)             0                           0                 E(i)*A(i)/elementLength(i)              0                           0;
                 0               -12*E(i)*I(i)/elementLength(i)^3  -6*E(i)*I(i)/elementLength(i)^2            0              12*E(i)*I(i)/elementLength(i)^3    -6*E(i)*I(i)/elementLength(i)^2;
                 0               6*E(i)*I(i)/elementLength(i)^2     2*E(i)*I(i)/elementLength(i)              0              -6*E(i)*I(i)/elementLength(i)^2     4*E(i)*I(i)/elementLength(i)];

    % Transformation matriz
    T = [cosd(alpha(i))     sind(alpha(i))       0              0                   0            0;
        -sind(alpha(i))     cosd(alpha(i))       0              0                   0            0;
              0                   0              1              0                   0            0;
              0                   0              0       cosd(alpha(i))      sind(alpha(i))      0;
              0                   0              0      -sind(alpha(i))      cosd(alpha(i))      0;
              0                   0              0              0                   0            1];

    % Beam stiffness matrix as seen from global coordinates
    Kg = T'*Ke*T;


    % If modal analysis is desired
    if dynamicAnalysis == 'Y' 

        % Pre-allocation
        Me = zeros(6);

        % Matrix of mass for local coordinates
        Me(1,4) = 1/6; 
        Me(2,3) = 11*elementLength(i)/210;
        Me(2,5) = 9/70;
        Me(2,6) = -13*elementLength(i)/420;
        Me(3,5) = -Me(2,6);
        Me(3,6) = -elementLength(i)^2/140;
        Me(5,6) = -Me(2,3);

        Me = Me + Me';

        Me(1,1) = 1/3;
        Me(2,2) = 13/35;
        Me(3,3) = elementLength(i)^2/105;
        Me(4,4) = Me(1,1);
        Me(5,5) = Me(2,2);
        Me(6,6) = Me(3,3);

        % Matrix of mass for local coordinates
        Me = rho(i)*A(i)*elementLength(i)*Me;

        % Coordinate transformation (global coordinates)
        Mg = T'*Me*T; 

            else
                Mg = zeros(6);
    end %%if

    % Pre-allocation
    Fg = zeros(6,1);

    % Compute matrix of global forces for distributed loads
%     if Q(i) ~= 0
% 
%         % Symbolic computation
%         %x = sym('x'); 
%         %elementLength = sym(elementLength(i));
%         %Q1 = symfun(Q(i),x);
%         Q1 = Q(i);
%         
%         % Shape functions at node 1, direction y
%         N_Iv = symfun(1+(-3/elementLength^2)*x^2+(2/elementLength^3)*x^3, x); 
% 
%         %Shape functions at node 1, direction theta
%         N_Iteta = symfun(x+(-2/elementLength)*x^2+(1/elementLength^2)*x^3, x); 
% 
%         %funções de formas nó 2 direção y
%         N_IIv = symfun((3/elementLength^2)*x^2-(2/elementLength^3)*x^3, x);  
% 
%         %funções de formas nó 2 direção teta
%         N_IIteta = symfun((-1/elementLength)*x^2+(1/elementLength^2)*x^3, x); 
% 
%         %calculo do integral da função de forma nó 1 direção y
%         V_Iv = -int(N_Iv*Q1, x, [0, elementLength]); 
% 
%          %calculo do integral nó 1 direção teta
%         V_Iteta = -int(N_Iteta*Q1, x, [0, elementLength]);
% 
%         %calculo do integral nó 2 direção y
%         V_IIv = -int(N_IIv*Q1, x, [0, elementLength]); 
% 
%         %calculo do integral nó 2 direção teta
%         V_IIteta = -int(N_IIteta*Q1, x, [0, elementLength]); 
% 
%          %posiciona o resultado do integral na matriz formas global e converte o tipo de variavel simbolico para um tipo double
%         Fe = [0; double(V_Iv); double(V_Iteta); 0; double(V_IIv); double(V_IIteta)];
% 
%         %tranformação para variaveis globais
%         Fg = T'*Fe; 
        
%   end %%if

end

