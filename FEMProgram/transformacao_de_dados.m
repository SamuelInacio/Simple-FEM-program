function [ L, gamma,E_tipo] = transformacao_de_dados(Nos,Elementos,E_tipo,Analise_Dinamica)
%transformacao_de_dados calcula os comprimentos L, os angulos entre as
%coordenadas globais e locais de cada elemento

gamma=zeros(length(Elementos));
L=zeros(length(Elementos));
for i=1:length(Elementos) %calculo de L e de gamma
    coord_no1=Nos(Elementos(i,1),1:2);
    coord_no2=Nos(Elementos(i,2),1:2);
    L(i)=norm((coord_no2-coord_no1));
    xx=coord_no2(1)-coord_no1(1);
    yy=coord_no2(2)-coord_no1(2);
    if xx >= 0
        gamma(i)= atand(yy/xx);
    else
        gamma(i)= (180+atand(yy/xx));
    end
end
if Analise_Dinamica == 'S' %transforma todos os Elementos em vigas para realizar a analise dinamica
    for i=1:length(Elementos)
        E_tipo(i)='v';
    end
end
end

