clear;
clc;
input('Introduza o script com os dados da estrutura a resolver? ') %inputs 
Analise_Dinamica = input('Efetuar análise dinamica? (S/N) ','s');
if Analise_Dinamica == 'S'
N_modos_de_vib = input('Numero de Modos de Vibração a calcular?');
end
[ L, gamma,E_tipo] = transformacao_de_dados(Nos,Elementos,E_tipo,Analise_Dinamica); %funções de tranformação de dados e calculo dos tamanhos e posições dos nós nas matrizes da estrutura
[ K,MpA,F,M,Movimentos_fixos,F_aplicada,GdL] = Posicao_Kg( Elementos,E_tipo,Movimentos_fixos0,F_aplicada0);

for i=1:length(Elementos)
    switch E_tipo(i) %caso o elemento for uma barra cria a matrizes globais
        case 'b'
            [Kg] = E_Barra(i,L,gamma,A,E);
            Fg=0; %não utilizado, mas o matlab precisa que a variavel esteja definida para usar como input na assemblagem (só é efetivamente usado se for uma viga com cargas distribuidas)
            Mg=0; %mesma situacao
        case 'v'
            [ Mg,Kg,Fg] = E_Viga(i,L,gamma,E,A,I,Q,Analise_Dinamica,ro); %se for uma viga cria as matrizes K global 
    end
    [ K, F, M] = Assemblagem(i,Kg,Fg,Elementos,K,MpA,E_tipo,F,Q,Mg,M,Analise_Dinamica); % faz a assemblagem dos dados das matrizes globais nas matrizes da estrutura 
end

F = F+F_aplicada; %finaliza o vetor forças
Movimentos_todos = 1:length(K);
Mov_livres = setdiff(Movimentos_todos,Movimentos_fixos);
U = zeros(length(K),1);
U(Mov_livres) = K(Mov_livres,Mov_livres)\F(Mov_livres); %calcula os deslocalemntos livres

% Pos-processamento
for i=1:length(MpA) % Display dos Deslocamentos 
    fprintf('\n Deslocamento Nó %d',i);
    fprintf('     xx = %f',U(MpA(i)));
    fprintf('     yy = %f',U(MpA(i)+1));
    if GdL(i) == 3
       fprintf('      teta = %f',U(MpA(i)+2));
    end
end

% Reacoes nos apoios
R = K * U - F; %calculo das reaçoes nos apoios
   fprintf('\n\n Reações nos Apoios %d','');
for i=1:max(max(Elementos)) %Display reações nos Apoios
    if Movimentos_fixos0(i,1) ~= 0
        fprintf('\nReação Nó %d',i);
    fprintf('xx = %f\n',R(MpA(i)));
    end
    if Movimentos_fixos0(i,2) ~= 0
          fprintf('Reação Nó %d',i);
    fprintf('yy = %f\n',R(MpA(i)+1));
    end
    if Movimentos_fixos0(i,3) ~= 0
        fprintf('Reação Nó %d',i);
    fprintf('Mz = %f\n',R(MpA(i)+2));
    end
    
end


if Analise_Dinamica == 'N'  %esforços internos de Elementos pedidos
    fprintf('\n Esforços internos dos Elementos %d\n\n','');
while true
ii = input('Numero de Elemento?  [0 Para terminar]');
if ii == 0
    break
else
    
switch E_tipo(ii)
    
    case 'b'   %se o elemento for uma barra
[ F_axial,tensao_axial] = esforcos_internos_barra(ii,Elementos,gamma,U,L,E,A,MpA);
 fprintf('Elemento %d\n',ii);
    fprintf('F_axial = %f\n',F_axial);
    fprintf('tensao_axial = %f\n\n',tensao_axial);
    case 'v' %se o elemento for uma viga
        [F_axial,Esforco_Transverso_1,Esforco_Transverso_2,Momento_1,Momento_2,F_internos] = esforcos_internos_viga(ii,Elementos,gamma,U,L,E,A,I,MpA,Q);
    fprintf('Elemento %d\n',ii);
    fprintf('F axial = %f\n',F_axial);
    fprintf('Esforco Transverso no nó 1 = %f\n',Esforco_Transverso_1);
    fprintf('Momento Aplicado no nó 1 = %f\n',Momento_1);
    fprintf('Esforco Transverso no nó 2 = %f\n',Esforco_Transverso_2);
    fprintf('Momento Aplicado no nó 2 = %f\n',Momento_2);
end
end
end %loop de display dos esforços internos
end
%Analise Dinamica 
if Analise_Dinamica == 'S'
    fprintf('\n Frequencias Naturais \n%d','');
    [uw,Wn] = Analise_Modal(K,M,Mov_livres,N_modos_de_vib);
    for i=1:length(Wn) %print das frequencias naturais
          fprintf('Frequencia Natural %d',i);
    fprintf(' = %f\n',Wn(i));
    end
    display('modos de vibracao'); %print modos de vibracao
    display(uw);
   
end




