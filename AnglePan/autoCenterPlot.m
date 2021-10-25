%% addpath
githubDir = 'C:\Users\Steinmetz lab\Documents\git';
addpath(genpath(fullfile(githubDir, 'matGeom\matGeom')))
addpath(genpath(fullfile(githubDir, 'allenCCF')))
addpath(genpath(fullfile(githubDir, 'npy-matlab')))
addpath(genpath('C:\Users\Steinmetz lab\Documents\MATLAB\AllenProjection'));
%% scale down brainGridData
fpath = 'C:\Users\Steinmetz lab\Documents\git\allenCCF\Browsing Functions';
brainGridData = readNPY(fullfile(fpath, 'brainGridData.npy'));
brainGridData = brainGridData(:,[3,1,2]);
brainGridData = brainGridData/4.7188;
%% import data
dataFolder = 'C:\Users\Steinmetz lab\Documents\MATLAB\AllenProjection\allenData';
[atlas, metaAVGT] = nrrdread(fullfile(dataFolder, 'annotation_50.nrrd'));
atlas1 = squeeze(sum(atlas,1));
% nameList = ["SSp_bfd"; "SSp_n"; "SSp_m"; "SSp_ul"; "SSp_ll"; "SSp_tr"; "RSP"; "VISp"; "ECT"];
nameList = ["SSp_bfd"; "SSp_n"; "SSp_m"; "SSp_ul"; "SSp_ll"; "SSp_tr"; "VISp"];
nameList1 = strcat(nameList, '_coronal');
dfolder = 'C:\Users\Steinmetz lab\Documents\git\allenCCF\AllenCCFMap';
st = loadStructureTree(fullfile(dfolder,'structure_tree_safe_2017.csv')); % a table of what all the labels mean
% ctx = '/997/8/567/688/';
ctx = '/997/8/567/';
cortexMask = create3dMask(ctx,st,atlas);
%% 4 subareas
areaName = {'thalamus','striatum','midbrain','pons'};
maskPath{1} = '/997/8/343/1129/549/'; % thalamus
maskPath{2} = '/997/8/567/623/477/'; % striatum
maskPath{3} = '/997/8/343/313/'; % midbrain
maskPath{4} = '/997/8/343/1065/771/'; % pons
%%
[template, meta] = nrrdread(fullfile(dataFolder,'average_template_50.nrrd'));   
%% load all projection data
color1 = hsv(numel(nameList));
for i = 1:numel(nameList)
    clear data row col
    S = dir(fullfile(dataFolder,[char(nameList1(i)) '*.nrrd']));
    [data, meta] = nrrdread(fullfile(S.folder,S.name));
    dataAll(:,:,:,i) = data;
end
%% plot injection veiw and oblique slice
figHand = figure;
ax1 = subplot(1,3,1);
plotInjectionVolume2(dataAll,atlas1,nameList1,nameList,cortexMask,dataFolder,ax1);
% plot injection volume
areaID = 2;
thisAreaName = areaName{areaID};
thisMaskPath = maskPath{areaID};
% manual points
t = readtable('C:\Users\Steinmetz lab\Documents\MATLAB\AllenProjection\projectionMap\areaCenter_vertical2.xlsx');
exceldata = t{1:4,2:4};
exceldata(:,1) = 228-exceldata(:,1);
exceldata = exceldata(:,[2,3,1]);
% auto points
mask3d = create3dMask(thisMaskPath,st,atlas);
threshold = 0.1;
[cpoint] = autoProjectionCenter2(dataAll,mask3d,nameList1,threshold);
% plot oblique slice in 3d brain
ax5 = subplot(1,3,2);
plane1 = fitPlane(cpoint);
xvector = cross(plane1(4:6),plane1(7:9));
[T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),plane1(1:3),xvector);
[T2,x2,y2,z2] = getObliqueSliceMask(atlas,plane1,xvector,{maskPath{areaID}},st);
[T3,x2,y2,z2] = getObliqueSliceMask(atlas,plane1,xvector,ctx,st);
pointOrthog = projPointOnPlane(cpoint, plane1);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,ax5,pointOrthog,color1,angle1);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(ax5,'gray')
% plot oblique slice and projection on oblique slice
% get oblique slice atlas index
[pointOrthog2d] = oblique3dto2d(pointOrthog,x1,y1,z1,T);  
% get oblique slice atlas index
ylim1 = [min(pointOrthog2d(:,1))-20,max(pointOrthog2d(:,1))+20];
xlim1 = [min(pointOrthog2d(:,2))-20,max(pointOrthog2d(:,2))+20];
% plot oblique slice in 2d image
ax9 = subplot(1,3,3);
hb1 = imshow(T,[]);
hold on; 
plotObliqueOutline(ax9,T2); 
hold on; 
plotObliqueOutline(ax9,T3); 
for j = 1:numel(nameList)
    data1 = squeeze(dataAll(:,:,:,j));
    [TheColorImage,x1,y1,z1] = obliqueslice(permute(data1,[2,1,3]),plane1(1:3),xvector);
    imageSize = size(TheColorImage);
    colorIntensity = TheColorImage/max(TheColorImage(:));
    thisColor = color1(j,:);
    thisColorImage = cat(3, thisColor(1)*ones(imageSize),...
        thisColor(2)*ones(imageSize), thisColor(3)*ones(imageSize)); 
    hold on
    hb2(j) = imshow(thisColorImage);
    hold off
    set(hb2(j),'AlphaData',colorIntensity);
end
hold on;
scatter(refLine2d(:,2),refLine2d(:,1),3,'r','filled');
% sgtitle({['Midline:' num2str(t{8,2}) ' um'],['Angle from midline:',num2str(t{9,2})]});
