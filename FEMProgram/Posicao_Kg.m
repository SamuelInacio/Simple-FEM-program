%POSICAO_KG algoritmo que define as dimens�es da matriz K,F,M e cria uma matriz que identifica os graus de liberdade de cada N� e a posi��o das matrizes Rigidez globais na assemblagem
%Modifica o formato do vetor das for�as aplicadas e da matriz dos Apoios para o formato com que o programa foi construido (intruduzir os dados no formato pedido permite a automatiza��o da refina��o da malha)  


function [K, MpA, F, M, fixedMovements, appliedForce, df] = Posicao_Kg(elements, elementType, fixedMovements0, appliedForce0)


    %algoritmo que cria uma matriz que identifica os graus de liberdade de cada n�
    sizeK = 0;
    
    %se mais nda for mudado, isto assume que todos os n�s est�o ligados a barras, logo t�m 2GdL
    df = 2*ones(max(max(elements)),1); 
    
    [linhas , ~] = size(elements);
    
    %muda o Gdl dos N�s para 3 que est�o ligados a pelo menos uma viga
    for i = 1:linhas 
        node1 = elements(i,1);
        node2 = elements(i,2);
        if elementType(i) == 'v'
            df(node1) = 3;
            df(node2) = 3;
        end
    end
    
    %algoritmo que usa a matriz dos graus de liberdade para criar a matriz
    %posi�ao na assemblagem

    MpA = zeros(length(df),1);
    MpA(1) = 1;
    sizeK = sizeK + df(1);
    
    %Algorito que determina o tamanho de K
    for i = 2:length(df)
        sizeK = sizeK + df(i);
        position = MpA(i-1) + df(i-1);
        MpA(i) = position;

    end
    
    % Pre inicializa��o das matrizes com os tamanhos corretos
    K = zeros(sizeK); 
    F = zeros(sizeK, 1);
    M = zeros(sizeK);
    F_aplicada1 = zeros(sizeK,1);
    Movimentos_fixos1 = zeros(sizeK,1);
    
    % modifica o vetor for�a dos dados iniciais para ser compativel com o programa
    for i=1:max(max(elements))
        
        F_aplicada1(MpA(i)) = appliedForce0(i,1);
        F_aplicada1(MpA(i)+1) = appliedForce0(i,2);
        Movimentos_fixos1(MpA(i)) = fixedMovements0(i,1);
        Movimentos_fixos1(MpA(i)+1) = fixedMovements0(i,2);
        
        if df(i) > 2
             F_aplicada1(MpA(i)+2) = appliedForce0(i,3);
             Movimentos_fixos1(MpA(i)+2) = fixedMovements0(i,3);
        end
        appliedForce = F_aplicada1;
    end %%for
    
    
    Movimentos_fixos2 = zeros(sum(sum(Movimentos_fixos1)),1);
    j=1;
    
    %modifica o vetor dos Apoios para ser compativel com o programa
    for i=1:length(Movimentos_fixos1) 
        if Movimentos_fixos1(i) ~= 0
            Movimentos_fixos2(j)=i;
            j=j+1;
        end
    end
    fixedMovements = Movimentos_fixos2;
    clear j;

end


