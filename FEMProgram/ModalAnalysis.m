
% Modal Analysis: Determines the eigen values and eigen vectors needed to
%                 compute the natural frequencies and vibration modes

function [uw,Wn] = ModalAnalysis(K, M, freeMovements, vibrationModes)

    [uw,w] = eigs(K(freeMovements, freeMovements), M(freeMovements, freeMovements), vibrationModes,'sa');
    Wn = zeros(1, length(w));

    for i = 1:length(w)
        Wn(i) = sqrt(w(i,i))/(2*pi);
    end
    
end

