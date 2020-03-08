function [uw,Wn] = Analise_Modal(K,M,Mov_livres,N_modos_de_vib)
%Analise_Modal Resolve o problema de valores e vetores proprios que calcula
%as frequencias naturais e os modos de vibração
[uw,w] = eigs(K(Mov_livres,Mov_livres),M(Mov_livres,Mov_livres),N_modos_de_vib,'sa');
Wn=zeros(1,length(w));
for i=1:length(w)
Wn(i)=sqrt(w(i,i))/(2*pi);
end
end

