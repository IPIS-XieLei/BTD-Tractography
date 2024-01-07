function save_selected_mask_peaks(selectedpeaks,info)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

info.Description = 'Modified using MATLAB R2018a';
%     selectfilename = strcat(ftrackname,'_flowpeaks'); % must be 'XXX' rather than "XXX"
info.Datatype = 'double';
filename = '/media/brainplan/XLdata/CNs/test/100307/genereta/100307_select_mask_peaks.nii';
niftiwrite(selectedpeaks,filename,info);
% selectpeaks_img = Peaks_img;
% selectpeaks_img.data = selectedpeaks;
% filename = '/media/xl/data4/TGN_project/100307/T1w/gen_files/100307_selectpeaks.mif'; % must be 'XXX' rather than "XXX"
% write_mrtrix(selectpeaks_img, filename)
end


