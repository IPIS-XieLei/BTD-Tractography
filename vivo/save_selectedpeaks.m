function save_selectedpeaks(DirsROI,ROIpositions,PeaksFile,filename)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
peaks = niftiread(PeaksFile);
selectedpeaks = zeros(size(peaks));
for i=1:size(DirsROI,1)
    DirsROI(i,1) = -DirsROI(i,1);
    selectedpeaks(ROIpositions(i,1),ROIpositions(i,2),ROIpositions(i,3),1:3) = DirsROI(i,:);   
end
info = niftiinfo(PeaksFile);

info.Description = 'Modified using MATLAB R2018a';
%     selectfilename = strcat(ftrackname,'_flowpeaks'); % must be 'XXX' rather than "XXX"
info.Datatype = 'double';
% filename = '/media/brainplan/XLdata/CNs/test/100307/test/save_peaks_new_LL_expand1.nii';
niftiwrite(selectedpeaks,filename,info);
% selectpeaks_img = Peaks_img;
% selectpeaks_img.data = selectedpeaks;
% filename = '/media/xl/data4/TGN_project/100307/T1w/gen_files/100307_selectpeaks.mif'; % must be 'XXX' rather than "XXX"
% write_mrtrix(selectpeaks_img, filename)
end

