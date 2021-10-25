function [pointOrthog] = oblique3dto2d(point,x,y,z,T)
for i = 1:size(point,1)
    point1 = point(i,:);
    pointLinearIndexInSlice = find(ceil(x)==ceil(point1(1)) &...
                                   ceil(y)==ceil(point1(2)) &...
                                   ceil(z)==ceil(point1(3)) );
    if isempty(pointLinearIndexInSlice)
        pointLinearIndexInSlice = find((ceil(x)==ceil(point1(1))|ceil(x)==(ceil(point1(1))-1)|ceil(x)==(ceil(point1(1))-2)|ceil(x)==(ceil(point1(1))+1)) &...
                                       (ceil(y)==ceil(point1(2))|ceil(y)==(ceil(point1(2))-1)|ceil(y)==(ceil(point1(2))-2)|ceil(y)==(ceil(point1(2))+1)) &...
                                       (ceil(z)==ceil(point1(3))|ceil(z)==(ceil(point1(3))-1)|ceil(z)==(ceil(point1(3))-2)|ceil(z)==(ceil(point1(3))+1)));   
    end
    [pointRow,pointColumn] = ind2sub(size(T),pointLinearIndexInSlice);
    pointOrthog(i,1) = mode(pointRow); pointOrthog(i,2) = mode(pointColumn);
end