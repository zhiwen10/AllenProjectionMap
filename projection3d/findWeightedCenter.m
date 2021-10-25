function cpoint = findWeightedCenter(filteredProj)
[x,y,z] = ndgrid(1:size(filteredProj,1),1:size(filteredProj,2),1:size(filteredProj,3));
xcentre = sum(x .* filteredProj,'all') / sum(filteredProj,'all');
ycentre = sum(y .* filteredProj,'all') / sum(filteredProj,'all');
zcentre = sum(z .* filteredProj,'all') / sum(filteredProj,'all');
cpoint = [xcentre,ycentre,zcentre];
end