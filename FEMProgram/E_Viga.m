function [ Mg,Kg,Fg] = E_Viga(i,L,gamma,E,A,I,Q,Analise_Dinamica,ro)
%E_Viga - Cria a matriz Rigidez do elemento viga em variaveis Globais
%Matriz Rigidez viga no referencial Local
Ke=[E(i)*A(i)/L(i) 0 0 -E(i)*A(i)/L(i) 0 0;... 
    0 12*E(i)*I(i)/L(i)^3 6*E(i)*I(i)/L(i)^2 0 -12*E(i)*I(i)/L(i)^3 6*E(i)*I(i)/L(i)^2;...
    0 6*E(i)*I(i)/L(i)^2 4*E(i)*I(i)/L(i) 0 -6*E(i)*I(i)/L(i)^2 2*E(i)*I(i)/L(i);...
    -E(i)*A(i)/L(i) 0 0 E(i)*A(i)/L(i) 0 0;...
    0 -12*E(i)*I(i)/L(i)^3 -6*E(i)*I(i)/L(i)^2 0 12*E(i)*I(i)/L(i)^3 -6*E(i)*I(i)/L(i)^2;...
    0 6*E(i)*I(i)/L(i)^2 2*E(i)*I(i)/L(i) 0 -6*E(i)*I(i)/L(i)^2 4*E(i)*I(i)/L(i)];
%Matriz transformação
T=[cosd(gamma(i)) sind(gamma(i)) 0 0 0 0;...
    -sind(gamma(i)) cosd(gamma(i)) 0 0 0 0;...
    0 0 1 0 0 0;...
    0 0 0 cosd(gamma(i)) sind(gamma(i)) 0;...
    0 0 0 -sind(gamma(i)) cosd(gamma(i)) 0;...
    0 0 0 0 0 1];
%Matriz Rigidez Viga Referencial Global
Kg=T'*Ke*T;
%Matriz Massas variavel local
if Analise_Dinamica == 'S'  % se fizermos analise modal
    Me=zeros(6);
Me(1,4)=1/6; %matriz massa local
    Me(2,3)=11*L(i)/210;
    Me(2,5)=9/70;
    Me(2,6)=-13*L(i)/420;
    Me(3,5)=-Me(2,6);
    Me(3,6)=-L(i)^2/140;
    Me(5,6)=-Me(2,3);
    Me=Me+Me';
    Me(1,1)=1/3;
    Me(2,2)=13/35;
    Me(3,3)= L(i)^2/105;
    Me(4,4)=Me(1,1);
    Me(5,5)= Me(2,2);
    Me(6,6)= Me(3,3);
    Me=ro(i)*A(i)*L(i)*Me;
    Mg=T'*Me*T; %transformação de coordenadas
else
    Mg=zeros(6);
end
    
%calculo da matriz força global para cargas distribuidas
Fg=zeros(6,1);
if Q(i) ~= 0
    x= sym('x'); %calculo simbolico
    L= sym(L(i));
    Q1=symfun(Q(i),x);
    N_Iv =symfun(1+(-3/L^2)*x^2+(2/L^3)*x^3,x); %funções de formas nó 1 direção y
    N_Iteta =symfun(x+(-2/L)*x^2+(1/L^2)*x^3,x); %funções de formas nó 1 direção teta
    N_IIv=symfun((3/L^2)*x^2-(2/L^3)*x^3,x);   %funções de formas nó 2 direção y
    N_IIteta =symfun((-1/L)*x^2+(1/L^2)*x^3,x); %funções de formas nó 2 direção teta
    V_Iv=-int(N_Iv*Q1,x,[0,L]); %calculo do integral da função de forma nó 1 direção y
    V_Iteta=-int(N_Iteta*Q1,x,[0,L]); %calculo do integral nó 1 direção teta
    V_IIv=-int(N_IIv*Q1,x,[0,L]); %calculo do integral nó 2 direção y
    V_IIteta=-int(N_IIteta*Q1,x,[0,L]); %calculo do integral nó 2 direção teta
    Fe=[0; double(V_Iv); double(V_Iteta); 0; double(V_IIv); double(V_IIteta)]; %posiciona o resultado do integral na matriz formas global e converte o tipo de variavel simbolico para um tipo double
    Fg=T'*Fe; %tranformação para variaveis globais
end

end

