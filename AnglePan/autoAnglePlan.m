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
% maskPath{4} = '/997/8/343/1065/771/'; % pons
maskPath{4} = '/997/8/343/1065/771/987/931/'; % pontine grey
%%
[template, meta] = nrrdread(fullfile(dataFolder,'average_template_50.nrrd'));   
%% plot
color1 = hsv(numel(nameList));
for i = 1:numel(nameList)
    clear data row col
    S = dir(fullfile(dataFolder,[char(nameList1(i)) '*.nrrd']));
    [data, meta] = nrrdread(fullfile(S.folder,S.name));
    dataAll(:,:,:,i) = data;
end
%%
figHand = figure;
ax1 = subplot(1,6,1);
plotInjectionVolume2(dataAll,atlas1,nameList1,nameList,cortexMask,dataFolder,ax1);
% plot projection volume
for i = 4
    %%
    thisAreaName = areaName{i};
    thisMaskPath = maskPath{i};
    %%
    t = readtable('C:\Users\Steinmetz lab\Documents\MATLAB\AllenProjection\projectionMap\areaCenter_vertical2.xlsx');
    exceldata = t{1:4,2:4};
    exceldata(:,1) = 228-exceldata(:,1);
    exceldata = exceldata(:,[2,3,1]);
    %%
    mask3d = create3dMask(thisMaskPath,st,atlas);
    threshold = 0.1;
    [cpoint] = autoProjectionCenter2(dataAll,mask3d,nameList1,threshold);
    %%
    ax5 = subplot(1,6,2);
    plane1 = fitPlane(cpoint);
    xvector = cross(plane1(4:6),plane1(7:9));
    [T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),plane1(1:3),xvector);
    [T2,x2,y2,z2] = getObliqueSliceMask(atlas,plane1,xvector,{maskPath{i}},st);
    [T3,x2,y2,z2] = getObliqueSliceMask(atlas,plane1,xvector,ctx,st);
    pointOrthog = projPointOnPlane(cpoint, plane1);
    angle1 = [-70,-90];
    angle2 = [-90,10];
    plotCenter3d(brainGridData,ax5,pointOrthog,color1,angle1);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(ax5,'gray')
    %% plot auto marked projection center, angle2
    ax6 = subplot(1,6,3);
    plotCenter3d(brainGridData,ax6,pointOrthog,color1,angle2);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(ax6,'gray')
    %% plot oblique slice and projection on oblique slice
    % get oblique slice atlas index
    ax7 = subplot(1,6,4);
    imshow(T,[]);
    hold on; 
    plotObliqueOutline(ax7,T2);
    hold on;
    plotObliqueOutline(ax7,T3);   
    % plot projected annotated center
    hold on;
    [pointOrthog2d] = oblique3dto2d(pointOrthog,x1,y1,z1,T);
    for j1 = 1:size(pointOrthog2d,1)
        plot(pointOrthog2d(j1,2),pointOrthog2d(j1,1),'o','MarkerSize',3,'MarkerFaceColor',color1(j1,:),'MarkerEdgeColor','none'); 
    end
    for j1 = 1:size(pointOrthog2d,1)
        if j1 < size(pointOrthog2d,1)
            plot(pointOrthog2d(j1:j1+1,2),pointOrthog2d(j1:j1+1,1),'Color',color1(j1,:),'LineWidth',2); 
        elseif j1 == size(pointOrthog2d,1)
            plot(pointOrthog2d([1,j1],2),pointOrthog2d([1,j1],1),'Color',color1(j1,:),'LineWidth',2); 
        end
    end
    %% plot oblique slice and projection on oblique slice
    % get oblique slice atlas index
    ylim1 = [min(pointOrthog2d(:,1))-20,max(pointOrthog2d(:,1))+20];
    xlim1 = [min(pointOrthog2d(:,2))-20,max(pointOrthog2d(:,2))+20];
    ax8 = subplot(1,6,5);
    imshow(T,[]);
    hold on; 
    plotObliqueOutline(ax8,T2); 
    % plot projected annotated center
    hold on
    [pointOrthog2d] = oblique3dto2d(pointOrthog,x1,y1,z1,T);
    for j1 = 1:size(pointOrthog2d,1)
        plot(pointOrthog2d(j1,2),pointOrthog2d(j1,1),'o','MarkerSize',3,'MarkerFaceColor',color1(j1,:),'MarkerEdgeColor','none'); 
    end
        for j1 = 1:size(pointOrthog2d,1)
        if j1 < size(pointOrthog2d,1)
            plot(pointOrthog2d(j1:j1+1,2),pointOrthog2d(j1:j1+1,1),'Color',color1(j1,:),'LineWidth',2); 
        elseif j1 == size(pointOrthog2d,1)
            plot(pointOrthog2d([1,j1],2),pointOrthog2d([1,j1],1),'Color',color1(j1,:),'LineWidth',2); 
        end
        end
    xlim(xlim1); ylim(ylim1);
    %%    
    % get oblique slice atlas index
    ylim1 = [min(pointOrthog2d(:,1))-20,max(pointOrthog2d(:,1))+20];
    xlim1 = [min(pointOrthog2d(:,2))-20,max(pointOrthog2d(:,2))+20];
    ax9 = subplot(1,6,6);
    % figHand = figure
    % ax9 = subplot(1,1,1);
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
sgtitle({['Midline:' num2str(t{8,2}) ' um'],['Angle from midline:',num2str(t{9,2})]});
end
%%
probeV = [pointOrthog(3,1)-pointOrthog(7,1), pointOrthog(3,2)-pointOrthog(7,2),pointOrthog(3,3)-pointOrthog(7,3)];
% Azimuth on yz plane (rotate from coronal xz plane)
coronalAngle = atan2(probeV(2),probeV(3));
% Elevation from yz plan 
APAngle = atan2(probeV(1),sqrt(probeV(2)^2+probeV(3)^2));
coronalAngle1 = rad2deg(coronalAngle); % angle from coronal plane
APAngle1 = rad2deg(APAngle);
%% 4 shank spin angle
% angle between 2 planes is equivalent to angles of their normal vectors
% normal vector for plane before spin
preSpin = cross(probeV,[0 0 1]);
% angle between preSpin and postSpin plane
angleSpin = atan2(norm(cross(preSpin,xvector)),dot(preSpin,xvector));
angleSpin1 = rad2deg(angleSpin);
%%
length = norm(probeV);
[x,y,z] = sph2cart(coronalAngle,APAngle,length);
pointNew = [pointOrthog(7,1)+z,pointOrthog(7,2)+y,pointOrthog(7,3)+x];
figure; 
aax = subplot(1,1,1);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,aax,pointOrthog,color1,angle1);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(aax,'gray')
hold on;
% for i = 1:7
% drawPoint3d(pointOrthog(i,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none'); 
% text(10,10,10,['point' num2str(i)]);
% pause(0.5);
% end
% hold on;
% drawPoint3d(pointOrthog(7,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none'); 
% hold on;
drawPoint3d(pointNew,'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
% hold on; 
% scatter3(x1(:,1),y1(:,1),z1(:,1),'k');
axis on;
%%
probeRef = [pointOrthog(7,:);pointOrthog(3,:)];
probeV2 = repmat(probeRef,3,1); 
probeV2(1:2,3) = probeV2(1:2,3)+5; probeV2(3:4,3) = probeV2(3:4,3)+10;
probeV2(5:6,3) = probeV2(5:6,3)+15;
%%
axang = [probeV(1) probeV(2) probeV(3) angleSpin];
rotm = axang2rotm(pi/2-axang);
zerocentered_probe = probeV2-repmat(probeRef,3,1); 
rotated_probe=rotm*zerocentered_probe';
rotated_probe = rotated_probe(1:3,:)'+ repmat(probeRef,3,1); 
%%
for i = 1:6
    d(i) = distancePointPlane(rotated_probe(i,:), plane1);
end
%%
figure; 
aax = subplot(1,1,1);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,aax,pointOrthog,color1,angle1);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(aax,'gray')
% hold on;
% drawPoint3d(pointNew,'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
for i = 1:6
hold on;
% drawPoint3d(probeV2(i,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
drawPoint3d(rotated_probe(i,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
end
%% sanity check test
% % point1 = [160,264,228];
% point1 = [1,10,sqrt(3)];
% coronalAngle = atan2(point1(2),point1(3));
% APAngle = atan2(point1(1),sqrt(point1(2)^2+point1(3)^2));
% coronalAngle1 = rad2deg(coronalAngle);
% APAngle1 = rad2deg(APAngle);
% length = norm(point1);
% [x,y,z] = sph2cart(coronalAngle,APAngle,length);
% pointNew = [z,y,x];
% figure; 
% drawPoint3d(pointNew,'MarkerSize',6,'MarkerFaceColor','k','MarkerEdgeColor','none'); 
%%
print(figHand, 'TargetPlan', '-dpdf', '-bestfit', '-painters');