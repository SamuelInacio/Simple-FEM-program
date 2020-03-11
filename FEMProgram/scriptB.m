
%% Script B - describe the problem. Trabalho Carlos
% Results are similar to ANSYS

% Cartesian Node coordinates, node 1 at first line, node 2 at second line...
nodes = [18 6; 12 6; 12 0; 6 0; 6 6; 0 0];  

% Elements and respective nodes, node 1 at first line, ect
elements = [2 1; 3 1; 3 2; 4 3; 5 2; 4 5; 6 4; 6 5];

% Element Type [ l = link; b = beam], line corresponds to the number of elements
elementType = ['b';'l';'b';'b';'b';'b';'l';'l']; 

% Degrees of freedom constrained by the support [Lines - number of the node; Columns - direction xx, yy, teta (0 = free, 1 = constrained)] 
fixedMovements0 = [1 0 0; 0 0 0; 1 1 0; 0 0 0; 0 0 0; 1 1 0];

% Transversal section of each element [m^2]
A = (149.1e-4)*ones(8,1);

% Young Modulus of each element [Pa] 
E = (210e9)*ones(8,1); 

% Moment of Inertia of Area Ixy [m^4] -- (Momento de Inercia de area) 
I = (25170e-8)*ones(8,1); 

% Applied forces at the nodes [Lines - node number; Columns - Fxx Fyy Mxy [N, Nm]]
appliedForce0 = [0 -25000 0; 0 0 15000; 0 0 0; 0 0 -15000; 0 0 0; 0 0 0]; 

% Allows for the input of any type of function for the distributed load 
x = sym('x'); 

% Applied loads in the beam by order of element
Q = [0; 0; 0; 30000; 0; 0; 0];

clear x;

% Steel density
rho = 7850*ones(6,1);