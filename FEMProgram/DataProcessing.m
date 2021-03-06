%DataProcessing: computes the length and the angles between the local and
%                global coordinates of each element
function [elementLength, alpha, elementType] = DataProcessing(nodes, elements, elementType, dynamicAnalysis)

    % Pre-alocations
    alpha = zeros(length(elements),1);
    elementLength = zeros(length(elements),1);

    % Compute length and gamma
    for i = 1:size(elements,1)

        % Global coordinates
        coordNode1 = nodes(elements(i,1),1:2);
        coordNode2 = nodes(elements(i,2),1:2);

        % Length
        elementLength(i)= norm((coordNode2-coordNode1));

        % Local Coordinates
        xx = coordNode2(1)-coordNode1(1);
        yy = coordNode2(2)-coordNode1(2);

        % Angles
        if xx >= 0
            alpha(i) = atand(yy/xx);
            else
                alpha(i) = (180+atand(yy/xx));
        end
    end %% for

    % If a dynamic analysis is required   
    if dynamicAnalysis == 'Y' 
        
        % Transform all elements into beams
        for i = 1:length(elements)
            elementType(i) = 'b';
        end        
    end    
end 