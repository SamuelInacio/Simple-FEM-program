function [ Element_Length, gamma, element_type] = DataProcessing(nodes, element_number ,element_type, dynamic_analisys)
% Data_Processing calculates beam and link length L, and the angle gamma between local and global element coordinates.
gamma=zeros(length(element_number));
Element_Length=zeros(length(element_number));
for i=1:length(element_number) %calculo de L e de gamma
    coord_no1=nodes(element_number(i,1),1:2);
    coord_no2=nodes(element_number(i,2),1:2);
    Element_Length(i)=norm((coord_no2-coord_no1));
    xx=coord_no2(1)-coord_no1(1);
    yy=coord_no2(2)-coord_no1(2);
    if xx >= 0
        gamma(i)= atand(yy/xx);
    else
        gamma(i)= (180+atand(yy/xx));
    end
end
if dynamic_analisys == 'S' %transforma todos os Elementos em vigas para realizar a analise dinamica
    for i=1:length(element_number)
        element_type(i)='v';
    end
end
end

