% Node coordinates, node 1 at first line, node 2 at second line...
nodes = [0 0; 0.5 0; 1 0];  

% Elements and respective nodes, node 1 at first line, ect
elements = [1 2;2 3];         

% Element Type [ l = link; b = beam], line corresponds to the number of elements
elementType = ['b'; 'b'];   

% Degrees of freedom constrained by the support [Lines - number of the node; Columns - direction xx, yy, teta (0 = free, 1 = constrained)] 
fixedMovements0 = [1 1 1; 0 0 0; 0 0 0];    

% Transversal section of each element [m^2]
A = (149.1e-4)*ones(2,1); 

% Young Modulus of each element [Pa] 
E = (210e9)*ones(2,1);    

% Moment of Inertia of Area Ixy [m^4] -- (Momento de Inercia de area) 
I = (25170e-8)*ones(2,1);                                                     

% Applied forces at the nodes [Lines - node number; Columns - Fxx Fyy Mxy [N, Nm]]
appliedForce0 = [0 0 0; 0 0 0;0 1000 0];

% Allows for the input of any type of function for the distributed load 
x = sym('x');            

% Applied loads in the beam by order of element
Q = [0;0];

clear x;

% ??
rho = 7850*ones(2,1);