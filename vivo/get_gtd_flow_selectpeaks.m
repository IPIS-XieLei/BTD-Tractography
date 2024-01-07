 
% %% Private function

% 
% %% Parameter
clear;clc;
str=['begin TGN ...........'];
disp(str);
SDE_Order = 4
step_size = 0.3;
FiberCount = 10000;
FiberCup = 0;
multi = 1;
N = 4;

%% File path
% path = 'D:\stream_tracking_5_25\144226';
MaskFile = '/media/brainplan/XLdata/CNs/test/100307/test/LL_mask.nii.gz';
DWIFile = '/media/brainplan/XLdata/CNs/test/100307/fa.nii.gz';
T1File = '/media/brainplan/XLdata/CNs/test/100307/T1w_acpc_dc_restore_1.25.nii.gz';
% PeaksFile1 = '/media/brainplan/XLdata/CNs/test/100307/peaks.nii.gz';
PeaksFile = '/media/brainplan/XLdata/CNs/test/100307/test/selectpeaks1.nii.gz';
normalPeaksFile = '/media/brainplan/XLdata/CNs/test/100307/test/selectpeaks_normal1.nii.gz';



%% Read file
T1data = niftiread(T1File); T1info = niftiinfo(T1File);
T1affine = T1info.Transform.T; T1affine = T1affine'; T1affineInv = T1affine^-1;
DWIdata = niftiread(DWIFile); DWIinfo = niftiinfo(DWIFile);
DWIaffine = DWIinfo.Transform.T; DWIaffine = DWIaffine'; DWIaffineInv = DWIaffine^-1;
peaks = niftiread(PeaksFile);
normalpeaks = niftiread(normalPeaksFile);
% Peaks_img = read_mrtrix(PeaksFile); peaks = Peaks_img.data;
% infopeaks = niftiinfo(PeaksFile1);
T1dim = size(T1data); T1dim = T1dim(1:3);
DWIdim = size(DWIdata);DWIdim = T1dim(1:3);
mask = niftiread(MaskFile);

% [startpoint, endpoint, wmpoint, notinpoint] = get_label(StructinfoFile, path, dim);

%% OR streamlines for directions guidence
str=['Preparing   seedpoints ...........'];
disp(str);
[maskx,masky,maskz] = ind2sub(size(mask),find(mask>0));
maskposition = [maskx,masky,maskz];

DataSize = size(peaks);
peaks(isnan(peaks)) = 0;
peaks = reshape(peaks, DataSize(1), DataSize(2), DataSize(3), 3, DataSize(4)/3);
peaks = permute(peaks, [1,2,3,5,4]);%��������
peaks = peaks(:,:,:,1:3,:);
DirsROI = zeros(0,3); WeightedDirsROI = zeros(0,3); ROIpositions = zeros(0,3);
for i = 1:size(maskposition,1)
    position = maskposition(i,:);
%     T1_value = squeeze(T1data(position(0),position(1),position(2),:))
%     peaks(position(1),position(2),position(3),1:3);
    vectors = squeeze(peaks(position(1),position(2),position(3),:,:));
    Weightedvectors = squeeze(normalpeaks(position(1),position(2),position(3),:,:));
    DirROI = vectors(1,:); WeightedDirROI = Weightedvectors(1,:);
%     tic
%     [DirROI,WeightedDirROI] = DirectCorrectbyStream(position,peaks,WeightedPeaks,BundlePeaks);
%     toc
    if any(DirROI(:)~=0) && any(WeightedDirROI(:)~=0)
        ROIpositions = [ROIpositions;repmat(position,size(DirROI,1),1)];
        DirsROI = [DirsROI;DirROI]; WeightedDirsROI = [WeightedDirsROI;WeightedDirROI];
    end
end
       
% %%%%%%%%%%%%Save Peaks%%%%%%%%%%%%

%% iteration
str=['Preparing   fitting ...........'];
disp(str);
if  SDE_Order==3
   [A, fvalIntra1] = GetATernaryForth(ROIpositions, DirsROI, WeightedDirsROI);
end
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
save_flowpeaks(mask,A,FiberCup,PeaksFile);
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










