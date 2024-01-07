 
% function [ FIBER_NUM,IC_NUM,seeds_number_w] = SDE_Tractography(cluster_nunber,subject_ID,SDE_Order,HEMI_NAME_LRC)
%write by wjq  2021-6-26
% %% Parameter 
str=['begin SDE ...........'];
disp(str);
step_size = 0.2;
FiberCount = 5000;
number_points_fiber =10000;
FiberCup = 0;
multi = 1; 
%% File path
% cluster_nunber = '764';
% subject_ID = '108323';
SDE_Order = 7;
% current_segments_location_index = 30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1closing_mask_ 
%4_times_binary_dilation_mask_
%indispace_hemisphere_clusters
%atlas_to_native_space
path = ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID,'/T1w/Diffusion/wma/atlas_to_native_space'];
MaskFile =  [path ,'/mask_bundle_atlas/',HEMI_NAME_LRC,'_4_times_binary_dilation_mask_',cluster_nunber,'.nii.gz'];
ukf_fiber =  ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID,'/T1w/Diffusion/wma/indispace_hemisphere_clusters'];
atlas_fiber = ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID,'/T1w/Diffusion/wma/atlas_to_native_space'];
%tracts_commissural
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if  HEMI_NAME_LRC=='L'
    hemi_left_right_commi =  'left'
end
if  HEMI_NAME_LRC=='R'
    hemi_left_right_commi =  'right'
end

if  HEMI_NAME_LRC=='C'
    hemi_left_right_commi =  'commic'
end


%C_364_end_closing_mask    C_664_exclude_end_mask
start_mask_exclude =   ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID, ...
    '/T1w/Diffusion/wma/atlas_to_native_space/mask_bundle_atlas/',HEMI_NAME_LRC,'_',cluster_nunber,'_exclude_start_mask.nii.gz'];
end_mask_exclude =   ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/', ...
    subject_ID,'/T1w/Diffusion/wma/atlas_to_native_space/mask_bundle_atlas/',HEMI_NAME_LRC,'_',cluster_nunber,'_exclude_end_mask.nii.gz'];

start_mask_tom =   ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID, ...
    '/T1w/Diffusion/wma/atlas_to_native_space/endings_segmentations/','CST_',hemi_left_right_commi,'_b.nii.gz'];
end_mask_tom =   ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/', ...
    subject_ID,'/T1w/Diffusion/wma/atlas_to_native_space/endings_segmentations/','CST_',hemi_left_right_commi,'_e.nii.gz'];

% start_mask_tom =   ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID, ...
%     '/T1w/Diffusion/wma/atlas_to_native_space/endings_segmentations/','CC','_b.nii.gz'];
% end_mask_tom =   ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/', ...
%     subject_ID,'/T1w/Diffusion/wma/atlas_to_native_space/endings_segmentations/','CC','_e.nii.gz'];



start_mask_exclude_data =  niftiread(start_mask_exclude); 
end_mask_exclude_data =  niftiread(end_mask_exclude); 

%%%%%%%%%%%%%%%%%%%%%
start_cst_mask =  niftiread(start_mask_tom); 
end_cst_mask =  niftiread(end_mask_tom); 

[maskx,masky,maskz] = ind2sub(size(start_cst_mask),find(start_cst_mask==1));
start_cst_maskposition = [maskx,masky,maskz];

[maskx,masky,maskz] = ind2sub(size(end_cst_mask),find(end_cst_mask==1));
end_cst_maskposition = [maskx,masky,maskz];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tracts_left_hemisphere
if  HEMI_NAME_LRC=='L'
    hemi_left_right_commi =  'tracts_left_hemisphere';
end
if  HEMI_NAME_LRC=='R'
    hemi_left_right_commi =  'tracts_right_hemisphere';
end
if  HEMI_NAME_LRC=='C'
    hemi_left_right_commi =  'tracts_commissural';
end

vtkFiles_atlas = [ atlas_fiber,'/',hemi_left_right_commi,'/','cluster_00',cluster_nunber,'.tck'];
vtkFiles_ukf = [ atlas_fiber,'/',hemi_left_right_commi,'/','cluster_00',cluster_nunber,'.tck'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path_fa = ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID,'/T1w/Diffusion'];
DWIFile  =  [path_fa , '/FA_image.nii'];
PeaksFile =  [path_fa ,  '/peaks.mif'];
whole_brain_mask_path =  [path_fa ,  '/Brain_mask_mask.nii.gz'];
%%%%%%%%%%%%%%%%%%%%%
whole_brain_mask =  niftiread(whole_brain_mask_path); 
DWIdata = niftiread(DWIFile); 
DWIinfo = niftiinfo(DWIFile);
DWIaffine = DWIinfo.Transform.T; 
DWIaffine = DWIaffine'; 
DWIaffineInv = DWIaffine^-1;
Peaks_img = read_mrtrix(PeaksFile); 
peaks = Peaks_img.data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T1dim = size(DWIdata);
T1dim = T1dim(1:3);
DWIdim = size(DWIdata);
DWIdim = T1dim(1:3);
mask = niftiread(MaskFile);

vtkimg_atlas=read_mrtrix_tracks(vtkFiles_atlas);
vtkimg_ukf=read_mrtrix_tracks(vtkFiles_ukf);
[maskx,masky,maskz] = ind2sub(size(mask),find(mask==1));
maskposition = [maskx,masky,maskz];
starts=zeros(1,3);
ends=zeros(1,3);
num=1;
num_e=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%  
%  for i=1:size(maskposition)
%     start=maskposition(i,:);
%          if (start(3)< 52)
%                 start_location(num,:)=start;
%                  starts(num,:)=start;
%                 num=num+1;
%          end
% % %       if(start(3) < 45 )
% % %             ends(num_e,:)=start;
% % %             num_e=num_e+1;
% %    %  end
%  end

starts = start_cst_maskposition;
ends = end_cst_maskposition;
%  starts = end_cst_maskposition;
% ends = start_cst_maskposition;

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:size(maskposition)
%     start=maskposition(i,:);
%       icon_start = start*start_plane_normal' -  d_start
%       icon_end = start*end_plane_normal'- d_end
%          if icon_start <0
%         starts(num,:)=start;
%         num=num+1;
%          end
%       if icon_end< 0
%         ends(num_e,:)=start;
%         num_e=num_e+1;
%      end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
streamlines1 = cell(1,1); 
vtkdata_atlas = vtkimg_atlas.data;
vtkdata_ukf = vtkimg_ukf.data;
 
icon_ukf =0;
if  icon_ukf ==1
        for i=1:size(vtkdata_ukf,2)
             streamlines1{i  } = vtkdata_ukf{i};
        end
        for i=1:size(vtkdata_atlas,2)
             streamlines1{i +size(vtkdata_ukf,2)} = vtkdata_atlas{i};
        end
end

if    icon_ukf ==0           
        for i=1:size(vtkdata_atlas,2)
             streamlines1{i } = vtkdata_atlas{i};
        end
end

% for i=1:size(vtkdata,2)
%      streamlines1{i } = vtkdata{i};
% end

%T1affineInv    DWIaffineInv
streamlines = transform(streamlines1, DWIaffineInv);
for i=1:size(streamlines,1)
    Tract = streamlines{i};
    intTract = round(Tract);
    intstartTract = intTract(1:10,:);
    if isempty(intersect(intstartTract,starts,'rows'))
        streamlines{i} = Tract(end:-1:1,:);
    end
end
%% Preproces00s peaks
[peaks, WeightedPeaks] = PreparingPeaks(peaks, 0.1, 0.3, 1);
str=['Preparing   Peaks ...........'];
disp(str);
%% Convert streamlines,startposition,endposition to DWI coordinate
%affine = DWIaffineInv*(DWIaffineInv^-1);
% Get peaks
BundlePeaks = zeros(size(mask,1),size(mask,2),size(mask,3),1,3);
BundlePeaks_INVERSE = zeros(size(mask,1),size(mask,2),size(mask,3),1,3);

size_strmeanlines = size(streamlines,1);
TractVectors=zeros(0,3);
bundleposition=zeros(0,3);
for current_line_nim = 1: size_strmeanlines
      currlines = streamlines{current_line_nim};
      cur_line_points = size(currlines,1);
      for curr_poi = 1: cur_line_points
          
          if curr_poi < cur_line_points
                cur_poins_coor = currlines(curr_poi,:);
                cur_poins_post = currlines(curr_poi + 1,:);
                directions_voxel = cur_poins_post -  cur_poins_coor       ;
                int_current_point_cor = round(cur_poins_coor);
                   if ( int_current_point_cor(3)<=0)
                       continue
                   end

               TractVector = directions_voxel/norm(directions_voxel);
                TractVectors=[TractVectors;TractVector];
                bundleposition=[bundleposition;int_current_point_cor];  
                
                try
                  BundlePeaks(int_current_point_cor(1,1),int_current_point_cor(1,2),int_current_point_cor(1,3),1,:) = -TractVector;
                catch
                    fff = current_line_nim
                    
                end
                
                BundlePeaks_INVERSE(int_current_point_cor(1,1),int_current_point_cor(1,2),int_current_point_cor(1,3),1,:) = TractVector;
          else
               cur_poins_coor = currlines(curr_poi-1,:);
                cur_poins_post = currlines(curr_poi ,:);
                directions_voxel = cur_poins_post -  cur_poins_coor   ;    
                int_current_point_cor = round(cur_poins_coor);
                if ( int_current_point_cor(3)<=0)
                       continue
                end
               TractVector = directions_voxel/norm(directions_voxel);
                TractVectors=[TractVectors;TractVector];
                bundleposition=[bundleposition;int_current_point_cor];  
                BundlePeaks(int_current_point_cor(1,1),int_current_point_cor(1,2),int_current_point_cor(1,3),1,:) = -TractVector;
                BundlePeaks_INVERSE(int_current_point_cor(1,1),int_current_point_cor(1,2),int_current_point_cor(1,3),1,:) = TractVector;
          end     
      end  
end

str=['Preparing   BundlePeaks ...........'];
disp(str);
DirsROI = zeros(0,3);
DirROI_INVERSES= zeros(0,3);
WeightedDirsROI = zeros(0,3); 
ROIpositions = zeros(0,3);
ROIpositions_INVERSE= zeros(0,3);
WeightedDirsROI_INVERSES = zeros(0,3); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for i = 1:size(maskposition,1)
    position = maskposition(i,:);
%     tic
    [DirROI,WeightedDirROI] = DirectCorrectbyStream(position,peaks,WeightedPeaks,BundlePeaks);
%     toc
    
    if any(DirROI(:)~=0) &&( ~isnan(DirROI(1)))
        ROIpositions = [ROIpositions; repmat(position,size(DirROI,1),1)];
        DirsROI = [DirsROI;DirROI]; 
        WeightedDirsROI = [WeightedDirsROI;WeightedDirROI];        
    end
end
%%%%%%%%%%%%%%%%%   INVERSE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:size(maskposition,1)
    position = maskposition(i,:);
%     tic
%     [DirROI_INVERSE,WeightedDirROI_inver] = DirectCorrectbyStream_INVERSE(position,peaks,WeightedPeaks,BundlePeaks_INVERSE);
% %     toc   
%     if any(DirROI_INVERSE(:)~=0) &&( ~isnan(DirROI_INVERSE(1)))
%         ROIpositions_INVERSE = [ROIpositions_INVERSE; repmat(position,size(DirROI_INVERSE,1),1)];
%         DirROI_INVERSES = [DirROI_INVERSES;DirROI_INVERSE]; 
%          WeightedDirsROI_INVERSES = [WeightedDirsROI_INVERSES;WeightedDirROI_inver];   
%     end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% iteration
% for iter = 1:10
% Get A
% [A1, fvalIntra1] = GetATernaryMonomial(ROIpositions, DirsROI, WeightedDirsROI);
%[A1, fvalIntra2] = GetATernaryQuadratic(ROIpositions, DirsROI, WeightedDirsROI);
%[A2, fvalIntra1] = GetATernaryCubic(ROIpositions, DirsROI, WeightedDirsROI);
%[A3, fvalIntra1] = GetATernaryForth(ROIpositions, DirsROI, WeightedDirsROI);
%[A4, fvalIntra1] = GetATernaryFifth(ROIpositions, DirsROI, WeightedDirsROI);
% [A5, fvalIntra3] = GetATernarySixth(ROIpositions, DirsROI, WeightedDirsROI);
% [A6, fvalIntra4] = GetATernarySeventh(ROIpositions, DirsROI, WeightedDirsROI);
% [A7, fvalIntra6] = GetATernaryEighth(ROIpositions, DirsROI, WeightedDirsROI);
% [A8, fvalIntra7] = GetATernaryTenth(ROIpositions, DirsROI, WeightedDirsROI);
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
% new_seeds=intersect(startposition1,squeeze(intTract),'rows','first');
%% Get seeds
seeds = zeros(1,3);
SeedsNum = 0;
SeedsNum_inverse = 0;


% while SeedsNum < number_points_fiber
%     seed=get_seed(ends,DWIdata,mask);   
%     SeedsNum = SeedsNum+1;
%     seeds(SeedsNum,:) = seed;
% end

seeds=get_seed_wjq(ends,DWIdata,mask);   



seeds_inverse = zeros(1,3);
while SeedsNum_inverse < number_points_fiber
    seed=get_seed(starts,DWIdata,mask);    
    SeedsNum_inverse = SeedsNum_inverse+1;
    seeds_inverse(SeedsNum_inverse,:) = seed;
end
%% Tracking
str=['Preparing   seeds ...........'];
disp(str);
Tractsall = cell(1,1);   
wholemask = ones(size(mask));
% for k=1:size(Aall,2)
    Tracts = cell(1, 20000);
%     A = Aall{k}; 
Num = 0;
IC_NUM = 0;
str=['Preparing   tracking ...........'];
disp(str);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% for FiberNum = 1:size(seeds,1)
%         start_point_inverse = seeds_inverse(FiberNum,:);
%         if ~isempty(current_order) && any(current_order(:)~=0)
%             FTrace_from_inverse_orintion = ftrack_inverse(Aall,start_point_inverse,0.3,mask,ends,DWIdata,whole_brain_mask);
%         end
% %%%%%%%%%%%%%%%%%        
%         if ~isempty(FTrace_from_inverse_orintion)
%         Tract_inverse = FTrace_from_inverse_orintion;       
%         else
%         Tract_inverse = [];
%          end     
% %%%%%%%%%%%%%%        
%         intTract = round(Tract_inverse);        
%         if size(Tract_inverse, 1) <=150
%            continue
%         elseif ~isempty(intersect(starts,squeeze(intTract),'rows'))
%             %Tracts{FiberNum} = Tract_inverse; 
%             Num = Num + 1;
%             fprintf('%5d/%d/%d\n', Num, FiberNum, FiberCount);
%         else
%             fprintf('%5d/%d/%d\n', Num, FiberNum, FiberCount);
%         end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for FiberNum = 1:size(seeds,1)
        start_point = seeds(FiberNum,:);      
        if ~isempty(current_order) && any(current_order(:)~=0)
            FTrace = ftrack(Aall,start_point,step_size,mask,starts,DWIdata,whole_brain_mask,start_mask_exclude_data,end_mask_exclude_data);      
        end
        if ~isempty(FTrace)
            Tract = FTrace;       
        else
            Tract = [];
        end      
%%%%%%%%%%%%%%        
        intTract = round(Tract);     
        
         if size(Tract, 1) <120
              IC_NUM = IC_NUM +1;
         end      
        
        if size(Tract, 1) <=120
            continue

        elseif ~isempty(intersect(starts,squeeze(intTract),'rows'))
           Tracts{FiberNum + FiberCount +FiberCount } = Tract; 
            Num = Num + 1;
            fprintf('%5d/%d/%d\n', Num, FiberNum, Num/FiberNum);
        else
            fprintf('%5d/%d/%d\n', Num, FiberNum, Num/FiberNum);
        end  
 
   end 
   
   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
Tracts(cellfun('length', Tracts)==0) = [];
Tracts = Tracts';
Tractsall{1} = Tracts; 
 streamlines_saves = transform(Tracts, DWIaffine);
 save_img_vtk_copy.data = streamlines_saves     
 save_img_vtk_copy.count = size(streamlines_saves,1)   
 save_img_vtk_copy.total_count = size(streamlines_saves,1)      
 path_saved = ['/media/wjq/brain4/high_order_SDE_2021_6_25/hcp_test2/',subject_ID,'/T1w/Diffusion/wma/atlas_to_native_space/SDE_tractography/',HEMI_NAME_LRC,'_',cluster_nunber,'_fiber.tck']
 write_mrtrix_tracks(save_img_vtk_copy,path_saved)    
 FIBER_NUM =   size(streamlines_saves,1)  
 seeds_number_w =  size(seeds,1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


