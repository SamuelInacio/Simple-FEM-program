% InternalBeamStresses: computes the internal forces of a beam element. 
%                       By tranforming the displacement matrix to local 
%                       coordinates, computes the internal forces and 
%                       stresses of each element
function [axialForce, shearForce1, shearForce2, moment1, moment2, F_internos] = InternalBeamStresses(i, elements, alpha, U, elementLength, E, A, I, MpA, Q)

    % Node 1 -  one of the elements to compute
    node1 = elements(i,1); 
    
    % Node 1 -  one of the elements to compute
    node2 = elements(i,2);

    % Beam stiffness matrix as seen from local coordinates
    Ke = [E(i)*A(i)/elementLength(i)              0                           0                -E(i)*A(i)/elementLength(i)             0                            0; 
                 0               12*E(i)*I(i)/elementLength(i)^3    6*E(i)*I(i)/elementLength(i)^2            0             -12*E(i)*I(i)/elementLength(i)^3     6*E(i)*I(i)/elementLength(i)^2;
                 0               6*E(i)*I(i)/elementLength(i)^2     4*E(i)*I(i)/elementLength(i)              0              -6*E(i)*I(i)/elementLength(i)^2     2*E(i)*I(i)/elementLength(i);
         -E(i)*A(i)/elementLength(i)             0                           0                 E(i)*A(i)/elementLength(i)              0                           0;
                 0               -12*E(i)*I(i)/elementLength(i)^3  -6*E(i)*I(i)/elementLength(i)^2            0              12*E(i)*I(i)/elementLength(i)^3    -6*E(i)*I(i)/elementLength(i)^2;
                 0               6*E(i)*I(i)/elementLength(i)^2     2*E(i)*I(i)/elementLength(i)              0              -6*E(i)*I(i)/elementLength(i)^2     4*E(i)*I(i)/elementLength(i)];
      
    % Pre-allocation 
    Ug = zeros(6,1); 

    % Global stiffness matrix  
    Ug(1,1) = U(MpA(node1));
    Ug(2,1) = U(MpA(node1)+1);
    Ug(3,1) = U(MpA(node1)+2);
    Ug(4,1) = U(MpA(node2));
    Ug(5,1) = U(MpA(node2)+1);
    Ug(6,1) = U(MpA(node2)+2);
    
    % Transformation matriz
    T = [cosd(alpha(i))     sind(alpha(i))       0              0                   0            0;
        -sind(alpha(i))     cosd(alpha(i))       0              0                   0            0;
              0                   0              1              0                   0            0;
              0                   0              0       cosd(alpha(i))      sind(alpha(i))      0;
              0                   0              0      -sind(alpha(i))      cosd(alpha(i))      0;
              0                   0              0              0                   0            1];

    % If distributed loads exist in the element, compute them to remove them from the equation
    if Q(i) ~= 0 
        
        x = sym('x');
        elementLength = sym(elementLength(i));
        Q1 = symfun(Q(i),x);
        N_Iv = symfun(1+(-3/elementLength^2)*x^2+(2/elementLength^3)*x^3,x);
        N_Iteta = symfun(x+(-2/elementLength)*x^2+(1/elementLength^2)*x^3,x);
        N_IIv = symfun((3/elementLength^2)*x^2-(2/elementLength^3)*x^3,x);
        N_IIteta = symfun((-1/elementLength)*x^2+(1/elementLength^2)*x^3,x);
        V_Iv = -int(N_Iv*Q1,x,[0,elementLength]);
        V_Iteta = -int(N_Iteta*Q1,x,[0,elementLength]);
        V_IIv = -int(N_IIv*Q1,x,[0,elementLength]);
        V_IIteta = -int(N_IIteta*Q1,x,[0,elementLength]);

        Fe = [0; double(V_Iv); double(V_Iteta); 0; double(V_IIv); double(V_IIteta)];
        
        else
            % matriz for�a 0 se n�o existir cargas distribuidas   
            Fe = [0; 0; 0; 0; 0; 0]; 
    end
    
    % Tranform global coordinates in local coordinates
    Ue = T*Ug; 
    
    % Solving the system of equations
    F_internos = (Ke*Ue)-Fe; 
    
    % for�a axial (tanto do n�1 um como do n� 2, de acordo com a convens�o de sinais) )
    axialForce = F_internos(4);
    
    shearForce1 = F_internos(2);
    shearForce2 = F_internos(5);
    moment1 = F_internos(3);
    moment2 = F_internos(6);         
end
