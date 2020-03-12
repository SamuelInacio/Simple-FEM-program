% Assembler: performs the assembly of the global stiffness matrix matrices 
function [K, F, M] = Assembler(i, Kg, Fg, elements, K, MpA, elementType, F, Q, Mg, M, dynamicAnalysis)

    node1 = elements(i,1);
    node2 = elements(i,2);

    P_node1 = MpA(node1);
    P_node2 = MpA(node2);

    % Choose type of element to be assembled
    switch elementType(i) 
    
        % Element is a link
        case 'l'
            K(P_node1:P_node1+1, P_node1:P_node1+1) =  K(P_node1:P_node1+1, P_node1:P_node1+1) + Kg(1:2, 1:2);
            K(P_node1:P_node1+1, P_node2:P_node2+1) =  K(P_node1:P_node1+1, P_node2:P_node2+1) + Kg(1:2, 3:4);
            K(P_node2:P_node2+1, P_node1:P_node1+1) =  K(P_node2:P_node2+1, P_node1:P_node1+1) + Kg(3:4, 1:2);
            K(P_node2:P_node2+1, P_node2:P_node2+1) =  K(P_node2:P_node2+1, P_node2:P_node2+1) + Kg(3:4, 3:4);

        % Element is a beam   
        case 'b' 
            K(P_node1:P_node1+2, P_node1:P_node1+2) =  K(P_node1:P_node1+2, P_node1:P_node1+2) + Kg(1:3, 1:3);
            K(P_node1:P_node1+2, P_node2:P_node2+2) =  K(P_node1:P_node1+2, P_node2:P_node2+2) + Kg(1:3, 4:6);
            K(P_node2:P_node2+2, P_node1:P_node1+2) =  K(P_node2:P_node2+2, P_node1:P_node1+2) + Kg(4:6, 1:3);
            K(P_node2:P_node2+2, P_node2:P_node2+2) =  K(P_node2:P_node2+2, P_node2:P_node2+2) + Kg(4:6, 4:6);

            % Considering dynamic analysis
            if dynamicAnalysis == 'Y';
                M(P_node1:P_node1+2, P_node1:P_node1+2) = M(P_node1:P_node1+2, P_node1:P_node1+2) + Mg(1:3, 1:3);
                M(P_node1:P_node1+2, P_node2:P_node2+2) = M(P_node1:P_node1+2, P_node2:P_node2+2) + Mg(1:3, 4:6);
                M(P_node2:P_node2+2, P_node1:P_node1+2) = M(P_node2:P_node2+2, P_node1:P_node1+2) + Mg(4:6, 1:3);
                M(P_node2:P_node2+2, P_node2:P_node2+2) = M(P_node2:P_node2+2, P_node2:P_node2+2) + Mg(4:6, 4:6);
            end

            % Assembly of distributed loads
            if Q(i)~= 0
                F(P_node1:P_node1+2) = F(P_node1:P_node1+2) + Fg(1:3);
                F(P_node2:P_node2+2) = F(P_node2:P_node2+2) + Fg(4:6);
            end
    end %% switch
end