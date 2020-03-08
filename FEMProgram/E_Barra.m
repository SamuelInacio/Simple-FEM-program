function [Kg] = E_Barra(i,L,gamma,A,E)
%E_barra Cria a matriz rigidez do elemento barra em variaveis Globais
    % Matriz de rigidez em coordenadas locais 
    Ke= A(i)*E(i)/L(i)*[1 -1;-1 1];
    % Matriz de transformaçao
    T= [cosd(gamma(i)) sind(gamma(i)) 0 0;...
        0 0 cosd(gamma(i)) sind(gamma(i))];
    Kg= T'*Ke*T;
end

