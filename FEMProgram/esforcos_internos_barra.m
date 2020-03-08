function [ F_axial,tensao_axial ] = esforcos_internos_barra(i,Elementos,gamma,U,L,E,A,MpA)
% esforcos_internos calcula os esforços internos de um elemento b

% tranformando a matriz de deslocamentos para coordenadas locais, é
% possivel calcular as forças e tensões internas de cada elemento

        no1 = Elementos(i,1); %no1 um do elemento a calcular
no2 = Elementos(i,2); %no2 um do elemento a calcular
        Ke = A(i)*E(i)/L(i)*[1 -1;-1 1]; %matriz rigidez local
        Ug = zeros(4,1);
        Ug(1,1) = U(MpA(no1));     %matriz deslocamento Global
        Ug(2,1) =U(MpA(no1)+1);
        Ug(3,1)=U(MpA(no2));
        Ug(4,1) =U(MpA(no2)+1);
        T= [cosd(gamma(i)) sind(gamma(i)) 0 0;...  %matriz transformacao global para local
            0 0 cosd(gamma(i)) sind(gamma(i))];
        Ue=T*Ug; %transformacao para coordenadas locais
        F_aplicadas1=Ke*Ue; %forças aplicadas
        F_axial= F_aplicadas1(2); %força axial de acordo com a convensão de sinais
        tensao_axial=F_axial/A(i); %tensão axial na barra