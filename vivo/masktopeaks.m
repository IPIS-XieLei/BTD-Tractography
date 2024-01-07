%%%%%%%%%%%%%%%
clear;clc;
MaskFile = '/media/brainplan/XLdata/CNs/test/100307/fiber/CNII/100307_ON-label-expand.nii.gz';
PeaksFile = '/media/brainplan/XLdata/CNs/test/100307/Diffusion/peaks.mif';
mask = niftiread(MaskFile);
Peaks_img = read_mrtrix(PeaksFile); peaks = Peaks_img.data;
maskSize = size(mask);
% Bundlemask = zeros(maskSize(1),maskSize(2),maskSize(3),9);
% Bundlemask(maskSize(1),maskSize(2),maskSize(3),:)=mask(maskSize(1),maskSize(2),maskSize(3));
% BundlePeaksSize = size(Bundlemask);
% % peaksSize = size(peaks);
% % [x,y,z]=find(BundlePeaks==0);
% peaks(find(Bundlemask(maskSize(1),maskSize(2),maskSize(3),:)==0))=0;
% % find(mask==1)
% % BundlePeaks(x,y,z,9) = peaks;
% % % [x,y,z]=find(mask==0);
index=find(mask==0);
peaks(index,9)=0;
selectpeaks_img = Peaks_img;
selectpeaks_img.data = peaks;
write_mrtrix (selectpeaks_img, '/media/brainplan/XLdata/CNs/test/100307/genereta/mask_peaks.mif')
