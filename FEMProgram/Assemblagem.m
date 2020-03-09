
function [ K, F, M] = Assemblagem(i,Kg,Fg,Elementos,K,MpA,E_tipo,F,Q,Mg,M,Analise_Dinamica)
%Assemblagem função que faz a assemblagem das Matrizes de rigidez Globais
% Assemblagem
no1= Elementos(i,1);
no2= Elementos(i,2);
P_no1 = MpA(no1);
P_no2 = MpA(no2);
switch E_tipo(i) %assemblagem se o Elemento for uma barra
    case 'l'
        K(P_no1:P_no1+1,P_no1:P_no1+1) =  K(P_no1:P_no1+1,P_no1:P_no1+1)+Kg(1:2,1:2);
        K(P_no1:P_no1+1,P_no2:P_no2+1) =  K(P_no1:P_no1+1,P_no2:P_no2+1)+Kg(1:2,3:4);
        K(P_no2:P_no2+1,P_no1:P_no1+1) =  K(P_no2:P_no2+1,P_no1:P_no1+1)+Kg(3:4,1:2);
        K(P_no2:P_no2+1,P_no2:P_no2+1) =  K(P_no2:P_no2+1,P_no2:P_no2+1)+Kg(3:4,3:4);
    case 'b' %assemblagem se o Elemento for uma viga
        K(P_no1:P_no1+2,P_no1:P_no1+2) =  K(P_no1:P_no1+2,P_no1:P_no1+2)+Kg(1:3,1:3);
        K(P_no1:P_no1+2,P_no2:P_no2+2) =  K(P_no1:P_no1+2,P_no2:P_no2+2)+Kg(1:3,4:6);
        K(P_no2:P_no2+2,P_no1:P_no1+2) =  K(P_no2:P_no2+2,P_no1:P_no1+2)+Kg(4:6,1:3);
        K(P_no2:P_no2+2,P_no2:P_no2+2) =  K(P_no2:P_no2+2,P_no2:P_no2+2)+Kg(4:6,4:6);
        if Analise_Dinamica == 'S'; %assemblagem da matriz massas
            M(P_no1:P_no1+2,P_no1:P_no1+2)= M(P_no1:P_no1+2,P_no1:P_no1+2)+Mg(1:3,1:3);
            M(P_no1:P_no1+2,P_no2:P_no2+2)= M(P_no1:P_no1+2,P_no2:P_no2+2)+Mg(1:3,4:6);
            M(P_no2:P_no2+2,P_no1:P_no1+2)= M(P_no2:P_no2+2,P_no1:P_no1+2)+Mg(4:6,1:3);
            M(P_no2:P_no2+2,P_no2:P_no2+2)= M(P_no2:P_no2+2,P_no2:P_no2+2)+Mg(4:6,4:6);
        end
    
        
        %Assemblagem cargas Distribuidas
        if Q(i)~= 0
            F(P_no1:P_no1+2)=F(P_no1:P_no1+2)+Fg(1:3);
            F(P_no2:P_no2+2)=F(P_no2:P_no2+2)+Fg(4:6);
        end
end
end