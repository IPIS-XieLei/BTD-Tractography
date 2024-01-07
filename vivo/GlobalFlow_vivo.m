% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Author: Jianzhong He
% % Mail: vsmallerx@gmail.com
% % Version: MATLAB R2018a
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Private function
% % 
% 
% %% Public function
% % 
% 
% %% Introduction
% % Tractography for Optical Radiation in HCP data.
% 
% clear;clc;
% addpath('.\144226\tgn');
% addpath('\mrtrix3_matlab\');
% addpath('D:\stream_tracking_5_25\144226\');
% 
% %% Parameter
str=['begin TGN ...........'];
disp(str);
SDE_Order = 6
step_size = 0.3;
FiberCount = 10000;
FiberCup = 0;
multi = 1;
N = 4;

%% File path
% path = 'D:\stream_tracking_5_25\144226';
% MaskFile = '/media/brainplan/XLdata/CNs/test/100307/fiber/CNII/100307_ON-label-expand.nii.gz';
% DWIFile = '/media/brainplan/XLdata/CNs/test/100307/fa.nii.gz';
% T1File = '/media/brainplan/XLdata/CNs/test/100307/T1w_acpc_dc_restore_1.25.nii.gz';
% PeaksFile = '/media/brainplan/XLdata/CNs/test/100307/Diffusion/peaks.mif';
% PeaksFile1 = '/media/brainplan/XLdata/CNs/test/100307/peaks.nii.gz';
% vtkFiles = '/media/brainplan/XLdata/CNs/test/100307/fiber/CNII/ON_LL.tck';
% StartFile = '/media/brainplan/XLdata/CNs/test/100307/fiber/CNII/100307_ON-label-expand.nii.gz';
% EndFile =
% '/media/brainplan/XLdata/CNs/test/100307/fiber/CNII/100307_ON-label-expand.nii.gz';
% 100307 12112 112920 113821 118831
MaskFile =  '/media/brainplan/XLdata/GTD/GTD5/100307/mask/AF_left_2.nii.gz';
DWIFile = '/media/brainplan/XLdata/GTD/HCP5_GTD/100307/tract_seg/FA_MNI.nii.gz';
T1File = '/media/brainplan/XLdata/GTD/HCP5_GTD/100307/tract_seg/FA_MNI.nii.gz';
PeaksFile = '/media/brainplan/XLdata/GTD/HCP5_GTD/100307/tract_seg/tractseg_output/peaks.mif';
PeaksFile1 = '/media/brainplan/XLdata/GTD/HCP5_GTD/100307/tract_seg/tractseg_output/peaks.nii.gz';
vtkFiles = '/media/brainplan/XLdata/GTD/HCP5_GTD/100307/tract_seg/tractseg_output/fiber/AF_left.tck';
StartFile = '/media/brainplan/XLdata/GTD/GTD5/100307/mask/AF_left_b.nii.gz';
EndFile = '/media/brainplan/XLdata/GTD/GTD5/100307/mask/AF_left_e.nii.gz';
path_saved = '/media/brainplan/XLdata/GTD/GTD5/100307/GTD_SD/AFNEW/AF_left_GTD11.tck'
% saveflowfilename = '/media/brainplan/XLdata/GTD/GTD5/100307/GTD_SD/gen/peaks_GTD_CST_left.nii';
% saveselectpeaksfilename = '/media/brainplan/XLdata/GTD/GTD5/100307/GTD_SD/gen/peaks_select_CST_left.nii';

%% Read file
T1data = niftiread(T1File); T1info = niftiinfo(T1File);
T1affine = T1info.Transform.T; T1affine = T1affine'; T1affineInv = T1affine^-1;
DWIdata = niftiread(DWIFile); DWIinfo = niftiinfo(DWIFile);
DWIaffine = DWIinfo.Transform.T; DWIaffine = DWIaffine'; DWIaffineInv = DWIaffine^-1;
Peaks_img = read_mrtrix(PeaksFile); peaks = Peaks_img.data;
% peaks = niftiread(PeaksFile1);
% infopeaks = niftiinfo(PeaksFile1);
T1dim = size(T1data); T1dim = T1dim(1:3);
DWIdim = size(DWIdata);DWIdim = T1dim(1:3);
mask = niftiread(MaskFile);
startpoint = niftiread(StartFile);
endpoint = niftiread(EndFile);
% [startpoint, endpoint, wmpoint, notinpoint] = get_label(StructinfoFile, path, dim);

%% OR streamlines for directions guidence
str=['Preparing   seedpoints ...........'];
disp(str);
[startx,starty,startz] = ind2sub(T1dim,find(startpoint==1));
[endx,endy,endz] = ind2sub(T1dim,find(endpoint==1));
startposition = [startx,starty,startz]; endposition = [endx,endy,endz];
vtkimg=read_mrtrix_tracks(vtkFiles);
% vtkimg = read_vtk_tracts(vtkFiles);
[maskx,masky,maskz] = ind2sub(size(mask),find(mask>0));
maskposition = [maskx,masky,maskz];
starts = zeros(1,3);
starts = startposition;
% starts = maskposition
% % ends = zeros(1,3);
% ends = endposition

% starts=zeros(1,3);
% ends=zeros(1,3);
% num=1;
% num_e=1;
% for i=1:size(maskposition)
%     start=maskposition(i,:);
% %     if start(2)>64&&start(2)<84&&start(1)<95&&start(1)>86
%     if start(2)>64&&start(2)<80
% %     if start(2)>82&&start(2)<88
%         starts(num,:)=start;
%         num=num+1;
%     end
%      if start(2)<94
%         ends(num_e,:)=start;
%         num_e=num_e+1;
%     end
% end
        
streamlines = cell(1,1); 
vtkdata = vtkimg.data;
for i=1:size(vtkdata,2), streamlines{i} = vtkdata{i}; end
streamlines = transform(streamlines, DWIaffineInv);

% Change start point if streamlines(1) not in the start ROI
for i=1:size(streamlines,1)
    Tract = streamlines{i};
    intTract = round(Tract);
    intstartTract = intTract(1:10,:);%10
    if isempty(intersect(intstartTract,starts,'rows'))
        streamlines{i} = Tract(end:-1:1,:);
    end
end

%% Preprocess peaks
[peaks, WeightedPeaks] = PreparingPeaks(peaks, 0.01, 0.3, 1);

%% tck2vox
% mask = zeros(dim);
% affine = get_affine(img); affine = affine^-1;
% Tracts = transform(streamlines, affine); 
% [endx,endy,endz] = ind2sub(dim, find(endpoint==1)); endposition = [endx,endy,endz];
% [startx,starty,startz] = ind2sub(dim, find(startpoint==1)); 
% startposition = [startx,starty,startz];
% [wmx,wmy,wmz] = ind2sub(dim, find(wmpoint==1)); wmposition = [wmx,wmy,wmz];
% [notinx,notiny,notinz] = ind2sub(dim, find(notinpoint==1)); 
% notinposition = [notinx,notiny,notinz];
% for i = 1:size(Tracts,1)
%     Tract = Tracts{i}; intTract = round(Tract);
%     if isempty(intersect(endposition,intTract,'rows')) || ...
%             isempty(intersect(startposition,intTract,'rows')) || ...
%             isempty(intersect(wmposition,intTract,'rows')) || ...
%             ~isempty(intersect(notinposition,intTract,'rows'))
%         Tracts{i} = [];
%     end
% end
% Tracts(cellfun('length',Tracts)==0)=[]; Tracts_ = Tracts;

%% get mask and int tract
% matTracts = cell2mat(Tracts);
% intmatTracts = unique(round(matTracts),'rows'); 
% intmatTracts(any(intmatTracts(1,:)==0)|any(intmatTracts(2,:)==0)|any(intmatTracts(3,:)==0)...
%                 |any(intmatTracts(1,:)>dim(1))|any(intmatTracts(2,:)>dim(2))...
%                 |any(intmatTracts(3,:)>dim(3)),:) = [];
% for i = 1:size(intmatTracts,1)
%     mask(intmatTracts(i,1),intmatTracts(i,2),intmatTracts(i,3)) = 1;
% end
str=['Preparing   peaks ...........'];
disp(str);
%% Convert streamlines,startposition,endposition to DWI coordinate
affine = DWIaffineInv*T1affine;
DWIstreamlines = transform(streamlines, affine);
% DWIstartposition = cell(1); DWIstartposition{1} = startposition;
% DWIstartposition = transform(DWIstartposition, affine);
% DWIstartposition = round(DWIstartposition{1});
% DWIendposition = cell(1); DWIendposition{1} = endposition;
% DWIendposition = transform(DWIendposition, affine);
% DWIendposition = round(DWIendposition{1});

%% Select Bundlepeaks
% peaksmask = repmat(mask,1,1,1,3,3);
% bundlepeaks = bundlepeaks.*peaksmask;
% bundleWeightedPeaks = bundleWeightedPeaks.*peaksmask;

%% Get peaks
BundlePeaks = zeros(size(mask,1),size(mask,2),size(mask,3),1,3);
matTracts = cell2mat(DWIstreamlines);
intmatTracts = round(matTracts);
for i = 1:size(intmatTracts)
    if all(squeeze(BundlePeaks(intmatTracts(i,1),intmatTracts(i,2),intmatTracts(i,3),1,:))==0)
        TractVector = matTracts(i+1,:)-matTracts(i,:); 
        TractVector = TractVector/norm(TractVector);
        BundlePeaks(intmatTracts(i,1),intmatTracts(i,2),intmatTracts(i,3),1,:) = TractVector;
    end
end
% % save_selected_mask_peaks(BundlePeaks,infopeaks)
% save('/media/brainplan/XLdata/CNs/test/100307/genereta/BundlePeaks.mif',BundlePeaks)

DirsROI = zeros(0,3); WeightedDirsROI = zeros(0,3); ROIpositions = zeros(0,3);
for i = 1:size(maskposition,1)
    position = maskposition(i,:);
%     tic
    [DirROI,WeightedDirROI] = DirectCorrectbyStream(position,peaks,WeightedPeaks,BundlePeaks);
%     toc
    if any(DirROI(:)~=0) && any(WeightedDirROI(:)~=0)
        ROIpositions = [ROIpositions;repmat(position,size(DirROI,1),1)];
        DirsROI = [DirsROI;DirROI]; WeightedDirsROI = [WeightedDirsROI;WeightedDirROI];
    end
end
% %%%%%%%%%%%%Save Peaks%%%%%%%%%%%%
% save_selectedpeaks(DirsROI,ROIpositions,PeaksFile1,saveselectpeaksfilename)
% % selectedpeaks = zeros(size(peaks));
% % for i=1:size(DirsROI,1)
% %     DirsROI(i,1) = -DirsROI(i,1);
% %     selectedpeaks(ROIpositions(i,1),ROIpositions(i,2),ROIpositions(i,3),1:3) = DirsROI(i,:);   
% % end
% % selectpeaks_img = Peaks_img;
% % selectpeaks_img.data = selectedpeaks;
% % filename = '/media/brainplan/XLdata/CNs/test/100307/genereta/100307_selectpeaks.mif'; % must be 'XXX' rather than "XXX"
% % write_mrtrix(selectpeaks_img, filename)
%% iteration
str=['Preparing   fitting ...........'];
disp(str);
if  SDE_Order==4
   [A, fvalIntra1] = GetATernaryFifth(ROIpositions, DirsROI, WeightedDirsROI);
end
if  SDE_Order==5
   [A, fvalIntra3] = GetATernarySixth(ROIpositions, DirsROI, WeightedDirsROI);
end
if  SDE_Order==6
    [A, fvalIntra4] = GetATernarySeventh(ROIpositions, DirsROI, WeightedDirsROI);
end
if  SDE_Order==7
     [A, fvalIntra6] = GetATernaryEighth(ROIpositions, DirsROI, WeightedDirsROI);
    % [A7, fvalIntra6] = GetATernaryEighth(ROIpositions_INVERSE, DirROI_INVERSES, WeightedDirsROI_INVERSES);
end
if  SDE_Order==8
     [A, fvalIntra7] = GetATernaryTenth(ROIpositions, DirsROI, WeightedDirsROI);
    % [A7, fvalIntra6] = GetATernaryEighth(ROIpositions_INVERSE, DirROI_INVERSES, WeightedDirsROI_INVERSES);
end
Aall = cell(1,9); 
current_order = A;
Aall{1} = current_order; 
Aall{2} = current_order; 
Aall{3} = current_order; 
Aall{4} = current_order; 
Aall{5} = current_order; 
Aall{6} = current_order; 
Aall{7} = current_order; 
Aall{8} = current_order; 
Aall{9} = A; 

%%%%%%%%%%%%%%%%%%%%Save flowpeaks%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save_flowpeaks(mask,A,FiberCup,PeaksFile1,saveflowfilename);
% % flowpeaks = zeros(size(peaks));
% % maskind = find(mask==1);
% % [ROIx,ROIy,ROIz] = ind2sub(size(mask),maskind);
% % ROI = [ROIx,ROIy,ROIz];
% % Dirs = GetFlowPeaks(A,ROI,FiberCup);
% % for i=1:size(Dirs,1)
% % %         Dirs(i,1) = -Dirs(i,1);
% %     flowpeaks(ROI(i,1),ROI(i,2),ROI(i,3),1:3) = Dirs(i,:);
% % end
% % 
% % flowpeaks_img = Peaks_img;
% % flowpeaks_img.data = flowpeaks;
% % filename = '/media/brainplan/XLdata/CNs/test/100307/genereta/100307_flowpeaks.mif'; % must be 'XXX' rather than "XXX"
% % write_mrtrix(flowpeaks_img, filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get seeds
seeds = zeros(1,3);
SeedsNum = 0;
while SeedsNum<10000
    seed=get_seed(ROIpositions,DWIdata,mask);
    SeedsNum = SeedsNum+1;
    seeds(SeedsNum,:) = seed;
end
% seeds=get_seed_wjq(starts);
%% Tracking
str=['Preparing   Tracking ...........'];
disp(str);
Tractsall = cell(1,1); 
% wholemask = ones(size(mask));
% for k=1:size(Aall,2)
    Tracts = cell(1, FiberCount);
%     A = Aall{k}; 
    Num = 0;
    IC_NUM = 0;
    for FiberNum = 1:size(seeds,1)
        start_point = seeds(FiberNum,:);
        if ~isempty(A) && any(A(:)~=0)
            FTrace = ftrack1(Aall,start_point,step_size,mask);
%             BTrace = ftrack(Aall,start_point,step_size,mask);
%             BTrace = BTrace(end:-1:1,:);
        end

        % Except empty Trace
        if ~isempty(FTrace)
%             Tract = [BTrace;start_point;FTrace];
            Tract = FTrace;
        else
            Tract = [];
        end
        
        intTract = round(Tract);
        
%         if size(Tract, 1) <15
%              IC_NUM = IC_NUM +1;
%         end      
        
        if size(Tract, 1) <=75
            continue
%         if size(Tract, 1) <= 20
%             continue
%         elseif ~isempty(intersect(starts,squeeze(intTract),'rows'))
            elseif ~isempty(intersect(starts,squeeze(intTract),'rows'))
           Tracts{FiberNum} = Tract; 
            Num = Num + 1;
            fprintf('%5d/%d/%d\n', Num, FiberNum, FiberCount);
        else
            fprintf('%5d/%d/%d\n', Num, FiberNum, FiberCount);
        end 
    end
    Tracts(cellfun('length', Tracts)==0) = [];
    Tracts = Tracts';
%     fprintf('\n The residual error of A is: %.4f\n', min(fvalIntra));
    Tractsall{1} = Tracts;
% end
str=['Saving  Track ...........'];
disp(str);
streamlines_saves = transform(Tracts, DWIaffine);
save_img_vtk_copy.data = streamlines_saves     
save_img_vtk_copy.count = size(streamlines_saves,1)   
save_img_vtk_copy.total_count = size(streamlines_saves,1)      
write_mrtrix_tracks(save_img_vtk_copy,path_saved) 
% str=['Showing  Track ...........'];
% disp(str);
% for i = 1:size(Tractsall,2)
%     Tracts = Tractsall{i};
%     if ~isempty(Tracts)
%         figure
%         DWI = squeeze(DWIdata(:,:,:,1));
%         DWI = DWI-min(DWI(:)); DWI = DWI/max(DWI(:)); 
%         % affine = get_affine(img); affine = affine^-01;
% %          Tracts = transform(Tracts, affine);
%         ReTracts = Streamline_resampling(Tracts,4);
%         VisTrack(ReTracts, 2); hold on; 
% %         VisDWI(DWI,3,80,-10);
%     end
% end











