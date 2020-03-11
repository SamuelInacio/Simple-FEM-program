% PositionKg: Definies the dimensions of the matrices K,F,M and creates a
% matrix to identify the degrees of freedom of each node and the position
% of the stiffness global matrices in the assembly

%Modifica o formato do vetor das forças aplicadas e da matriz dos Apoios para o formato com que o programa foi construido (intruduzir os dados no formato pedido permite a automatização da refinação da malha)  

function [K, MpA, F, M, fixedMovements, appliedForce, df] = PositionKg(elements, elementType, fixedMovements0, appliedForce0)

    % Algorythm:  creates a matrix that identifies the degrees of freedom in each node
    sizeK = 0;
    
    % If nothing else changes, all nodes are connected to links, hence twice the df
    df = 2*ones(max(max(elements)),1); 
    
    [linhas , ~] = size(elements);
    
    % muda o Gdl dos Nós para 3 que estão ligados a pelo menos uma viga
    for i = 1:linhas 
        node1 = elements(i,1);
        node2 = elements(i,2);
        
        % Element is a beam
        if elementType(i) == 'b'
            df(node1) = 3;
            df(node2) = 3;
        end
    end
    
    %algoritmo que usa a matriz dos graus de liberdade para criar a matriz
    %posiçao na assemblagem

    MpA = zeros(length(df),1);
    MpA(1) = 1;
    sizeK = sizeK + df(1);
    
    %Algorito que determina o tamanho de K
    for i = 2:length(df)
        sizeK = sizeK + df(i);
        position = MpA(i-1) + df(i-1);
        MpA(i) = position;

    end
    
    % Pre inicialização das matrizes com os tamanhos corretos
    K = zeros(sizeK); 
    F = zeros(sizeK, 1);
    M = zeros(sizeK);
    appliedForce1 = zeros(sizeK,1);
    fixedMovements1 = zeros(sizeK,1);
    
    % modifica o vetor força dos dados iniciais para ser compativel com o programa
    for i=1:max(max(elements))
        
        appliedForce1(MpA(i)) = appliedForce0(i,1);
        appliedForce1(MpA(i)+1) = appliedForce0(i,2);
        fixedMovements1(MpA(i)) = fixedMovements0(i,1);
        fixedMovements1(MpA(i)+1) = fixedMovements0(i,2);
        
        if df(i) > 2
             appliedForce1(MpA(i)+2) = appliedForce0(i,3);
             fixedMovements1(MpA(i)+2) = fixedMovements0(i,3);
        end
        appliedForce = appliedForce1;
    end %%for
    
    
    fixedMovements2 = zeros(sum(sum(fixedMovements1)),1);
    j=1;
    
    %modifica o vetor dos Apoios para ser compativel com o programa
    for i=1:length(fixedMovements1) 
        if fixedMovements1(i) ~= 0
            fixedMovements2(j)=i;
            j=j+1;
        end
    end
    fixedMovements = fixedMovements2;
    clear j;

end


