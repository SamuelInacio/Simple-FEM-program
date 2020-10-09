function [ nodes,elements,elementType,fixedMovements0,A,E,I,appliedForce0,Q,rho ] = StructToVectorsParser( Structure)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nodes           = Structure.nodes;
elements        = Structure.elements;
elementType     = char(Structure.elementType);
fixedMovements0 = Structure.fixedMovements0;
A               = Structure.A;
E               = Structure.E;
I               = Structure.I;
appliedForce0   = Structure.appliedForce0;
Q               = Structure.Q;
rho             = Structure.rho;
end

