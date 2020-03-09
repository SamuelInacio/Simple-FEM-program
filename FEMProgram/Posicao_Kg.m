function [ K,MpA,F,M,Movimentos_fixos,F_aplicada,GdL] = Posicao_Kg( Elementos,E_tipo,Movimentos_fixos0,F_aplicada0)
%POSICAO_KG algoritmo que define as dimensões da matriz K,F,M e cria uma matriz que identifica os graus de liberdade de cada Nó e a posição das matrizes Rigidez globais na assemblagem
%Modifica o formato do vetor das forças aplicadas e da matriz dos Apoios para o formato com que o programa foi construido (intruduzir os dados no formato pedido permite a automatização da refinação da malha)  


%algoritmo que cria uma matriz que identifica os graus de liberdade de cada nó
tamanho_K=0;
GdL = 2*ones(max(max(Elementos)),1); %se mais nda for mudado, isto assume que todos os nós estão
%ligados a barras, logo têm 2GdL
[linhas , ~]=size(Elementos);
for i = 1:linhas %muda o Gdl dos Nós para 3 que estão ligados a pelo menos uma viga
    no1 = Elementos(i,1);
    no2 = Elementos(i,2);
    if E_tipo(i) == 'b'
        GdL(no1) = 3;
        GdL(no2) = 3;
    end
end
%algoritmo que usa a matriz dos graus de liberdade para criar a matriz
%posiçao na assemblagem

MpA=zeros(length(GdL),1);
MpA(1)=1;
tamanho_K =tamanho_K+GdL(1);
%Algorito que determina o tamanho de K
for i = 2:length(GdL)
    tamanho_K =tamanho_K+GdL(i);
    posicao=MpA(i-1)+GdL(i-1);
    MpA(i) = posicao;
    
end
K=zeros(tamanho_K); % Pre inicialização das matrizes com os tamanhos corretos
F= zeros(tamanho_K,1);
M=zeros(tamanho_K);
F_aplicada1=zeros(tamanho_K,1);
Movimentos_fixos1=zeros(tamanho_K,1);
for i=1:max(max(Elementos)) %modifica o vetor força dos dados iniciais para ser compativel com o programa
    F_aplicada1(MpA(i))=F_aplicada0(i,1);
    F_aplicada1(MpA(i)+1)=F_aplicada0(i,2);
    Movimentos_fixos1(MpA(i))=Movimentos_fixos0(i,1);
    Movimentos_fixos1(MpA(i)+1)=Movimentos_fixos0(i,2);
    if GdL(i) > 2
         F_aplicada1(MpA(i)+2)=F_aplicada0(i,3);
         Movimentos_fixos1(MpA(i)+2)=Movimentos_fixos0(i,3);
    end
    F_aplicada=F_aplicada1;
end
Movimentos_fixos2 =zeros(sum(sum(Movimentos_fixos1)),1);
j=1;
for i=1:length(Movimentos_fixos1) %modifica o vetor dos Apoios para ser compativel com o programa
    if Movimentos_fixos1(i) ~= 0
        Movimentos_fixos2(j)=i;
        j=j+1;
    end
end
Movimentos_fixos=Movimentos_fixos2;
clear j;

    


