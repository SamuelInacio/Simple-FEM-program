%% Script D:  

% Cartesian Node coordinates, node 1 at first line, node 2 at second line...
nodes = [0 0; 0 3; 4 3; 4,0];  

% Elements and respective nodes, node 1 at first line, ect
elements = [1 2; 2 3; 3 4]; 

% Element Type [ l = link; b = beam], line corresponds to the number of elements
elementType = ['v'; 'v'; 'v']; 

% Degrees of freedom constrained by the support [Lines - number of the node; Columns - direction xx, yy, teta (0 = free, 1 = constrained)] 
fixedMovements0 = [1 1 1;0 0 0;0 0 0;1 1 1]; 

% Transversal section of each element [m^2]
A = (14.9e-3)*ones(3,1); 

% Young Modulus of each element [Pa] 
E = (210e9)*ones(3,1);

% Moment of Inertia of Area Ixy [m^4]
I = (252*10^-6)*ones(3,1);

% Applied forces at the nodes [Lines - node number; Columns - Fxx Fyy Mxy [N, Nm]]
appliedForce0 = [0 0 0; 30000 0 0; 0 0 0; 0 0  0];

% Allows for the input of any type of function for the distributed load 
x = sym('x');

% Applied loads in the beam by order of element
Q = [0; 5000; 0];

clear x;

% Steel density
rho = 7850*ones(3,1);