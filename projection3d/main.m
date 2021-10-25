%% addpath
githubDir = 'C:\Users\Steinmetz lab\Documents\git';
addpath(genpath(fullfile(githubDir, 'matGeom\matGeom')))
addpath(genpath(fullfile(githubDir, 'allenCCF')))
addpath(genpath(fullfile(githubDir, 'npy-matlab')))
%%
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
nameList = ["SSp_bfd"; "SSp_n"; "SSp_m"; "SSp_ul"; "SSp_ll"; "SSp_tr"];
nameList1 = strcat(nameList, '_coronal');
dfolder = 'C:\Users\Steinmetz lab\Documents\git\allenCCF\AllenCCFMap';
st = loadStructureTree(fullfile(dfolder,'structure_tree_safe_2017.csv')); % a table of what all the labels mean
ctx = '/997/8/567/688/';
cortexMask = create3dMask(ctx,st,atlas);
%% 4 subareas
areaName = {'thalamus','striatum','midbrain','pons'};
maskPath{1} = '/997/8/343/1129/549/'; % thalamus
maskPath{2} = '/997/8/567/623/477/'; % striatum
maskPath{3} = '/997/8/343/313/'; % midbrain
maskPath{4} = '/997/8/343/1065/771/'; % pons
%%
[template, meta] = nrrdread(fullfile(dataFolder,'average_template_50.nrrd'));   
%% plot
color1 = hsv(numel(nameList));
figHand = figure;
ax1 = subplot(4,8,1);
plotInjectionVolume(atlas1,nameList1,nameList,cortexMask,dataFolder,ax1);
% plot projection volume
for i = 1:4
    %%
    thisAreaName = areaName{i};
    thisMaskPath = maskPath{i};
    %%
    subplot(4,8,1+(i-1)*8)
    if i ~= 1
        title(thisAreaName,'Position', [0.5, 0.5]);
    else 
        hold on
        title(thisAreaName,'Position', [120, 350]);
    end
    axis off   
    %%
    mask3d = create3dMask(thisMaskPath,st,atlas);
    ax2 = subplot(4,8,2+(i-1)*8);
    angle1 = [-70,-90];
    [cpoint] = plotProjectionVolume3d(ax2,brainGridData,dataFolder,mask3d,nameList1,color1,angle1);
    cpoint = double(cpoint);
    if i==1
        title('full projection volume');
    end
    %% plot auto genetrated center, angle1
    ax3 = subplot(4,8,3+(i-1)*8);
    angle1 = [-70,-90];
    plane1 = fitPlane(cpoint);
    xvector = cross(plane1(4:6),plane1(7:9));
    [T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),plane1(1:3),xvector);
    cpointOrthog = projPointOnPlane(cpoint, plane1);
    plotCenter3d(brainGridData,ax3,cpointOrthog,color1,angle1);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(ax3,'gray')
    xvector1 = cross(plane1(4:6),plane1(7:9));
    if i==1
        title('weighted center');
    end
    %% plot auto genetrated center, angle2
    ax4 = subplot(4,8,4+(i-1)*8);
    angle2 = [-90,10];
    plotCenter3d(brainGridData,ax4,cpointOrthog,color1,angle2);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(ax4,'gray')
    if i==1
        title('weighted center');
    end
    %% plot oblique slice and projection on oblique slice
    % get oblique slice atlas index
    ax7 = subplot(4,8,7+(i-1)*8);
    imshow(T,[]);
    % plot weighted center
    [projArea2,x2,y2,z2] = getObliqueSliceMask(double(atlas),plane1,xvector1,thisMaskPath,st);
    hold on
    [cpointOrthog2d] = oblique3dto2d(cpointOrthog,x1,y1,z1,T);
    for j2 = 1:numel(nameList)
        plot(cpointOrthog2d(j2,2),cpointOrthog2d(j2,1),'o','MarkerSize',3,'MarkerFaceColor',color1(j2,:),'MarkerEdgeColor','none'); 
    end
    if i==1
        title('weighted oblique slice');
    end
    %% plot maunally marked projection center, angle1
    t = readtable('projectionMap\areaCenter_vertical.xlsx','Sheet',thisAreaName);
    exceldata = t{2:end,2:end};
    exceldata(:,1) = 228-exceldata(:,1);
    exceldata = exceldata(:,[2,3,1]);
    %%
    ax5 = subplot(4,8,5+(i-1)*8);
    plane1 = fitPlane(exceldata);
    xvector = cross(plane1(4:6),plane1(7:9));
    [T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),plane1(1:3),xvector);
    pointOrthog = projPointOnPlane(exceldata, plane1);
    plotCenter3d(brainGridData,ax5,pointOrthog,color1,angle1);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(ax5,'gray')
    xvector = cross(plane1(4:6),plane1(7:9));
    if i==1
        title('manually marked center');
    end
    %% plot maunally marked projection center, angle2
    ax6 = subplot(4,8,6+(i-1)*8);
    plotCenter3d(brainGridData,ax6,pointOrthog,color1,angle2);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(ax6,'gray')
    if i==1
        title('manually marked center');
    end
    %% plot oblique slice and projection on oblique slice
    % get oblique slice atlas index
    ax7 = subplot(4,8,8+(i-1)*8);
    imshow(T,[]);
    % plot projected annotated center
    hold on
    [pointOrthog2d] = oblique3dto2d(pointOrthog,x1,y1,z1,T);
    for j1 = 1:numel(nameList)
        plot(pointOrthog2d(j1,2),pointOrthog2d(j1,1),'o','MarkerSize',3,'MarkerFaceColor',color1(j1,:),'MarkerEdgeColor','none'); 
    end
    if i==1
        title('manual oblique slice');
    end
end