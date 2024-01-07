function save_flowpeaks(mask,A,FiberCup,PeaksFile,filename)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
peaks = niftiread(PeaksFile);
flowpeaks = zeros(size(peaks));
maskind = find(mask==1);
[ROIx,ROIy,ROIz] = ind2sub(size(mask),maskind);
ROI = [ROIx,ROIy,ROIz];
Dirs = GetFlowPeaks(A,ROI,FiberCup);
for i=1:size(Dirs,1)
    Dirs(i,1) = -Dirs(i,1);
    flowpeaks(ROI(i,1),ROI(i,2),ROI(i,3),1:3) = Dirs(i,:);
end
% flowpeaks(:,:,:,1) = -flowpeaks(:,:,:,1);
info = niftiinfo(PeaksFile);

info.Description = 'Modified using MATLAB R2018a';
%     selectfilename = strcat(ftrackname,'_flowpeaks'); % must be 'XXX' rather than "XXX"
info.Datatype = 'double';
% filename = '/media/brainplan/XLdata/CNs/test/100307/test/peaks_GTD_LL_expand1.nii';
niftiwrite(flowpeaks,filename,info);
% flowpeaks_img = Peaks_img;
% flowpeaks_img.data = flowpeaks;
% filename = '/media/xl/data4/TGN_project/100307/T1w/gen_files/100307_flowpeaks.mif'; % must be 'XXX' rather than "XXX"
% write_mrtrix(flowpeaks_img, filename)
end

