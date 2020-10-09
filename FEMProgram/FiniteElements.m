%-------------------------------------------------------------------------%
% Program: Finite Elements                                                %
% Date:  March 2020                                                       %
% Authors: Samuel In�cio                                                  %
%-------------------------------------------------------------------------%
%addpath('C:\Users\Samuel\Documents\GitHub\Simple-FEM-program\FEMProgram\octave-rapidjson-master');

function [Results,JResults] = FiniteElements(Structure, dynamicAnalysis)

    % If a dynamic analysis is desired, input the number of vibration modes
     addpath('C:\Users\Samuel\Documents\GitHub\Simple-FEM-program\FEMProgram\jsonlab');
     Structure = loadjson(Structure);
     
    if (dynamicAnalysis == 'Y')
        vibrationModes = input('Desired number of vibration modes: ');
    end
    
    % Perform Data Transformation
    [ nodes,elements,elementType,fixedMovements0,A,E,I,appliedForce0,Q,rho ] = StructToVectorsParser( Structure);
    [elementLength, alpha, elementType] = DataProcessing(nodes, elements, elementType, dynamicAnalysis);

    % Compute sizes and positions of nodes in the structure matrices
    [K, MpA, F, M, fixedMovements, appliedForce, df] = PositionKg(elements, elementType, fixedMovements0, appliedForce0);

    for i = 1:size(elements,1)
        switch elementType(i)

            % Element is a Link
            case 'l'
                [Kg] = ElementLink(i, elementLength, alpha, A, E);

                % Not used, however needs to be specified in the assembly if the element is a beam with distributed loads
                Fg = 0;
                Mg = 0;

                % Element is a Beam
            case 'b'
                [Mg, Kg, Fg] = ElementBeam(i, elementLength, alpha, E, A, I, Q, dynamicAnalysis, rho);

        end %% switch

        % Assembly of the global matrices of the struture
        [K, F, M] = Assembler(i, Kg, Fg, elements, K, MpA, elementType, F, Q, Mg, M, dynamicAnalysis);

    end

    % Update the vector of forces
    F = F + appliedForce;

    allMovements = 1:length(K);
    freeMovements = setdiff(allMovements, fixedMovements);
    U = zeros(length(K),1);

    % Compute Free Movements
    U(freeMovements) = K(freeMovements, freeMovements)\F(freeMovements);

    % Display reactions at the supports
    fprintf('\n\n Displacements at the nodes\n');

    % Post-processing
    for i = 1:length(MpA)

        % Display dos Deslocamentos
        nodeNumber = strcat('Node',num2str(i)); 
        fprintf('\n Node %d: ',i);
        fprintf('\t xx_%d = %f', i, U(MpA(i)));
        fprintf('\t yy_%d = %f', i, U(MpA(i)+1));
        Results.(nodeNumber).Displacements = U(MpA(i):(MpA(i)+1));

        if df(i) == 3
            fprintf('\t theta_%d = %f', i, U(MpA(i)+2));
            Results.(nodeNumber).Displacements = U(MpA(i):(MpA(i)+2));
        end
    end

    % Reaction at the supports
    R = K * U - F;

    % Display reactions at the supports
    fprintf('\n\n Reactions at the supports\n');

    for i = 1:max(max(elements))

        if fixedMovements0(i,1) ~= 0
            fprintf('\n Node %d: ', i);
            fprintf('\t xx_%d = %f\n', i, R(MpA(i)));
            Results.(nodeNumber).Reactions = R(MpA(i));
        end

        if fixedMovements0(i,2) ~= 0
            fprintf(' Node %d: ', i);
            fprintf('\t yy_%d = %f\n', i, R(MpA(i)+1));
            Results.(nodeNumber).Reactions = R(MpA(i):(MpA(i)+1));
        end

        if fixedMovements0(i,3) ~= 0
            fprintf(' Node %d: ', i);
            fprintf('\t Mz_%d = %f\n', i, R(MpA(i)+2));
            Results.(nodeNumber).Reactions = R(MpA(i):(MpA(i)+2));
        end
    end

    % If no dynamic analysis is desired compute the internal stresses of the desired elements
    if dynamicAnalysis == 'N'
        fprintf('\n Internal stresses of the elements \n\n');

        for ii = 1:length(elementType);
            
            Element = strcat('Element',num2str(ii));

            switch elementType(ii)

                % Element is a Link
                case 'l'
                    [axialForce, axialStress] =  InternalLinkStresses(ii, elements, alpha, U, elementLength, E, A, MpA);
                    fprintf('\n Element %d\n\n', ii);
                    fprintf('\t Axial Force = %f\n', axialForce);
                    fprintf('\t Axial Stress = %f\n\n', axialStress);
                    Results.(Element).AxialForce = axialForce;
                    Results.(Element).AxialStress = axialStress;

                    % Element is a Beam
                case 'b'
                    [axialForce, shearForce1, shearForce2, moment1, moment2] = InternalBeamStresses(ii, elements, alpha, U,elementLength, E, A, I, MpA, Q);
                    fprintf(' Element %d\n\n', ii);
                    fprintf('\t Axial Force = %f\n', axialForce);
                    fprintf('\t Shear Force at node 1 = %f\n',shearForce1);
                    fprintf('\t Applied moment at node 1 = %f\n', moment1);
                    fprintf('\t Shear Force at node 2 = %f\n', shearForce2);
                    fprintf('\t Applied moment at node 2 = %f\n\n', moment2);
                    Results.(Element).AxialForce = axialForce;
                    Results.(Element).shearForce1 = shearForce1;
                    Results.(Element).shearForce2 = shearForce2;
                    Results.(Element).moment1 = moment1;
                    Results.(Element).moment2 = moment2;
            end
        end %% for
    end %% iff


    % Dynamic Analysis
    if dynamicAnalysis == 'Y'

        % Display natural frequencies
        fprintf('\n\n Natural frequencies\n\n'); % same as undamped frequencies ?

        [uw, Wn] = ModalAnalysis(K, M, freeMovements, vibrationModes);

        for i = 1:length(Wn)
            fprintf(' Frequency %d',i);
            fprintf(' = %f\n',Wn(i));
        end

        fprintf('\n\n Vibration Modes\n\n');
        disp(uw);

    end %% if
    JResults = savejson('Result',Results,'result.json');

end
