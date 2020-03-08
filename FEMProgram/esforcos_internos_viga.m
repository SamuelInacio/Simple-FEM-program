function [F_axial,Esforco_Transverso_1,Esforco_Transverso_2,Momento_1,Momento_2,F_internos] = esforcos_internos_viga(i,Elementos,gamma,U,L,E,A,I,MpA,Q)
% esforcos_internos_viga calcula os esforços internos de um viga

% tranformando a matriz de deslocamentos para coordenadas locais, é
% possivel calcular as forças e tensões internas de cada elemento
no1 = Elementos(i,1); %no1 um do elemento a calcular
no2 = Elementos(i,2); %no2 um do elemento a calcular
        Ke=[E(i)*A(i)/L(i) 0 0 -E(i)*A(i)/L(i) 0 0;...
            0 12*E(i)*I(i)/L(i)^3 6*E(i)*I(i)/L(i)^2 0 -12*E(i)*I(i)/L(i)^3 6*E(i)*I(i)/L(i)^2;...
            0 6*E(i)*I(i)/L(i)^2 4*E(i)*I(i)/L(i) 0 -6*E(i)*I(i)/L(i)^2 2*E(i)*I(i)/L(i);...
            -E(i)*A(i)/L(i) 0 0 E(i)*A(i)/L(i) 0 0;...
            0 -12*E(i)*I(i)/L(i)^3 -6*E(i)*I(i)/L(i)^2 0 12*E(i)*I(i)/L(i)^3 -6*E(i)*I(i)/L(i)^2;...
            0 6*E(i)*I(i)/L(i)^2 2*E(i)*I(i)/L(i) 0 -6*E(i)*I(i)/L(i)^2 4*E(i)*I(i)/L(i)];
        Ug=zeros(6,1); %guarda os valores da matriz U na matriz Uglobal
        Ug(1,1) =U(MpA(no1));
        Ug(2,1) =U(MpA(no1)+1);
        Ug(3,1) =U(MpA(no1)+2);
        Ug(4,1)=U(MpA(no2));
        Ug(5,1) =U(MpA(no2)+1);
        Ug(6,1) =U(MpA(no2)+2);
        T=[cosd(gamma(i)) sind(gamma(i)) 0 0 0 0;... %matriz transformação
            -sind(gamma(i)) cosd(gamma(i)) 0 0 0 0;...
            0 0 1 0 0 0;...
            0 0 0 cosd(gamma(i)) sind(gamma(i)) 0;...
            0 0 0 -sind(gamma(i)) cosd(gamma(i)) 0;...
            0 0 0 0 0 1];
        if Q(i) ~= 0 % se existir cargas distribuidas no Elemento, calcula-os para subtrair da equação
    x= sym('x');
    L= sym(L(i));
    Q1=symfun(Q(i),x);
    N_Iv =symfun(1+(-3/L^2)*x^2+(2/L^3)*x^3,x);
    N_Iteta =symfun(x+(-2/L)*x^2+(1/L^2)*x^3,x);
    N_IIv=symfun((3/L^2)*x^2-(2/L^3)*x^3,x);
    N_IIteta =symfun((-1/L)*x^2+(1/L^2)*x^3,x);
    V_Iv=-int(N_Iv*Q1,x,[0,L]);
    V_Iteta=-int(N_Iteta*Q1,x,[0,L]);
    V_IIv=-int(N_IIv*Q1,x,[0,L]);
    V_IIteta=-int(N_IIteta*Q1,x,[0,L]);
    Fe=[0; double(V_Iv); double(V_Iteta); 0; double(V_IIv); double(V_IIteta)];
        else
            Fe=[0; 0; 0; 0; 0; 0]; %matriz força 0 se não existir cargas distribuidas
        end
        Ue=T*Ug; %coordenadas globais para locais
         F_internos=(Ke*Ue)-Fe; %resolução do sistema de equações
         F_axial=F_internos(4); %força axial (tanto do n´1 um como do nó 2, de acordo com a convensão de sinais) )
         Esforco_Transverso_1=F_internos(2);
         Esforco_Transverso_2= F_internos(5);
         Momento_1 = F_internos(3);
         Momento_2=F_internos(6);         
end



