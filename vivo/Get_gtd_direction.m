 
% %% Parameter
str=['begin TGN ...........'];
disp(str);
SDE_Order = 4
step_size = 0.3;
FiberCount = 10000;
FiberCup = 0;
multi = 1;
N = 4;

%% File path

MaskFile = '/media/brainplan/XLdata/CNs/test/100307/test/RR_mask-expand-2.nii.gz';
DWIFile = '/media/brainplan/XLdata/CNs/test/100307/fa.nii.gz';
T1File = '/media/brainplan/XLdata/CNs/test/100307/T1w_acpc_dc_restore_1.25.nii.gz';
PeaksFile = '/media/brainplan/XLdata/CNs/test/100307/test/peaks.nii.gz';

vtkFiles = '/media/brainplan/XLdata/CNs/test/100307/fiber/CNII/ON_RR.tck';
saveflowfilename = '/media/brainplan/XLdata/CNs/test/100307/test/peaks_GTD_RR_expand2-1.nii';
saveselectpeaksfilename = '/media/brainplan/XLdata/CNs/test/100307/test/save_peaks_new_LL_expand1-3.nii';

%% Read file
T1data = niftiread(T1File); T1info = niftiinfo(T1File);
T1affine = T1info.Transform.T; T1affine = T1affine'; T1affineInv = T1affine^-1;
DWIdata = niftiread(DWIFile); DWIinfo = niftiinfo(DWIFile);
DWIaffine = DWIinfo.Transform.T; DWIaffine = DWIaffine'; DWIaffineInv = DWIaffine^-1;
peaks = niftiread(PeaksFile);
% infopeaks = niftiinfo(PeaksFile1);
T1dim = size(T1data); T1dim = T1dim(1:3);
DWIdim = size(DWIdata);DWIdim = T1dim(1:3);
mask = niftiread(MaskFile);


%% OR streamlines for directions guidence
str=['Preparing   seedpoints ...........'];
disp(str);

vtkimg=read_mrtrix_tracks(vtkFiles);
[maskx,masky,maskz] = ind2sub(size(mask),find(mask>0));
maskposition = [maskx,masky,maskz];

        
streamlines = cell(1,1); 
vtkdata = vtkimg.data;
for i=1:size(vtkdata,2), streamlines{i} = vtkdata{i}; end
streamlines = transform(streamlines, DWIaffineInv);

% Change start point if streamlines(1) not in the start ROI
for i=1:size(streamlines,1)
    Tract = streamlines{i};
    intTract = round(Tract);
    intstartTract = intTract(1:10,:);
    if isempty(intersect(intstartTract,starts,'rows'))
        streamlines{i} = Tract(end:-1:1,:);
    end
end

%% Preprocess peaks
[peaks, WeightedPeaks] = PreparingPeaks(peaks, 0.1, 0.3, 1);

str=['Preparing   peaks ...........'];
disp(str);
%% Convert streamlines,startposition,endposition to DWI coordinate
affine = DWIaffineInv*T1affine;
DWIstreamlines = transform(streamlines, affine);


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
save_selectedpeaks(DirsROI,ROIpositions,PeaksFile,saveselectpeaksfilename)

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
save_flowpeaks(mask,A,FiberCup,PeaksFile,saveflowfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










