function filteredProj = projectionVolumeFilter(mask3d,filename,threshold)
[data, meta] = nrrdread(filename);
data(not(mask3d)) = 0;
data(:,:,1:114) = 0;                                                   % all left hemisphere intenisties are ignored before find center 
IntensityMax = max(data(:));
data(data<=IntensityMax*threshold)=0;                                   % set Intensity threshold to be above 10% to get rid of noisy pixels
filteredProj = data;
end