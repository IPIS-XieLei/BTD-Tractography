% % % clear;
% % % addpath(genpath('curve_compare_data'));
% % % % load CSA_detr_CCtoM1.mat;
% % % load CSA_flow_CCtoM1.mat;
% % % load CSD_detr_CCtoM1.mat;
% % % load CSD_prob_CCtoM1.mat
% % % load Qball_Gibbs_CCtoM1.mat;
% % %%%%%%HD
% image=load('track2/100307_R_6.mat');
% streamlines_2=image.Tracts;
% % streamlines_2=ICTracts;
% streamlines_2(cellfun('length', streamlines_2)==0) = [];
% % streamlines_2=streamlines';
% mean_curve=zeros(size(streamlines_2,1),2);
% var_curve=zeros(size(streamlines_2,1),2);
% comp_streamlines{:,1}=Streamline_resampling(streamlines_2,100);
% % comp_streamlines{:,2}=Streamline_resampling(streamlines_1,100);
% max=size(streamlines_2{1},1);
% for j=1:1
%     for i=1:size(streamlines_2,1)
%         mean_curve(i,j)=mean(Get_Curve(comp_streamlines{1,j}{i}));
%         if max<size(streamlines_2{i},1)
%         cure=Get_Curve(comp_streamlines{1,j}{i});
%         max=size(streamlines_2{1},i);
%         end
%         var_curve(i,j)=var(Get_Curve(comp_streamlines{1,j}{i}));
%     end
% end
% %iFOD%%%%
% image=load('track/ifod_R.mat');
% streamlines_1=image.Tracts;
% % streamlines_1=streamlines';
% mean_curve1=zeros(size(streamlines_1,1),2);
% var_curve1=zeros(size(streamlines_1,1),2);
% comp_streamlines1{:,1}=Streamline_resampling(streamlines_1,100);
% % comp_streamlines{:,2}=Streamline_resampling(streamlines_1,100);
% max1=size(streamlines_1{1},1);
% for j=1:1
%     for i=1:size(streamlines_1,1)
%         mean_curve1(i,j)=mean(Get_Curve(comp_streamlines1{1,j}{i}));
%         if max1<size(streamlines_1{i},1)
%         cure1=Get_Curve(comp_streamlines1{1,j}{i});
%         max1=size(streamlines_1{1},i);
%         end
%         var_curve1(i,j)=var(Get_Curve(comp_streamlines1{1,j}{i}));
%     end
% end
% %SD
% image=load('track/SD_R.mat');
% streamlines_3=image.Tracts;
% % streamlines_1=streamlines';
% mean_curve3=zeros(size(streamlines_3,1),2);
% var_curve3=zeros(size(streamlines_3,1),2);
% comp_streamlines3{:,1}=Streamline_resampling(streamlines_3,100);
% % comp_streamlines{:,2}=Streamline_resampling(streamlines_1,100);
% max3=size(streamlines_3{1},1);
% for j=1:1
%     for i=1:size(streamlines_3,1)
%         mean_curve3(i,j)=mean(Get_Curve(comp_streamlines3{1,j}{i}));
%         if max3<size(streamlines_3{i},1)
%         cure3=Get_Curve(comp_streamlines3{1,j}{i});
%         max3=size(streamlines_3{1},i);
%         end
%         var_curve3(i,j)=var(Get_Curve(comp_streamlines3{1,j}{i}));
%     end
% end
% % 
% % % figure;
% % % x1 = 1:1:size(streamlines_2,1);
% % % y1 = mean_curve(:,1)-0.01;
% % % y2=mean_curve(:,2);
% % % stem(x1,y1,'fill','r');hold on;
% % % stem(x1,y2,'fill','b');
% % % set(gca,'YLim',[0 0.06]);
% % % xlabel('Number of streamlines in one bundle ','fontsize',18),
% % % ylabel('Mean curvature','fontsize',18),
% % % title('Curvature distribution of conectome using two tracking method.','fontsize',20)
% % % m=mean(mean_curve);
% % % 
% % mean_max1=max(mean_curve1);
% mean_max2=var_curve(1);
% my_curve=var_curve;
% for i=1:size(my_curve,1)
%     if mean_max2<my_curve(i)
%         mean_max2=my_curve(i);
%     end
% end
% mean_min2=var_curve(1);
% for i=1:size(my_curve,1)
%     if mean_min2>my_curve(i)
%         mean_min2=my_curve(i);
%     end
% end
% 
% fprintf('%5d\n', mean_max2);
% fprintf('%5d\n', mean_min2);
% SD_thr = cure;
% threshold = ['0p05';'0p10';'0p15';'0p20';'0p25'];
% SD_thr1 = cure1;
% SD_thr3 = cure3;
% figure
% for i=1:100
%     h=scatter(i,SD_thr(i,:),'filled','MarkerEdgeColor',[110/255. 225/255. 255/255.],...
%         'MarkerFaceColor',[110/255. 180/255. 255/255.]);
%     set(gca,'FontSize',16);
%     h2=scatter(i,SD_thr1(i,:),'filled','MarkerEdgeColor',[30/255. 225/255. 0/255.],...
%         'MarkerFaceColor',[30/255. 225/255. 0/255.]);
%     set(gca,'FontSize',16);
%     h3=scatter(i,SD_thr3(i,:),'filled','MarkerEdgeColor',[225/255. 0/255. 30/255.],...
%         'MarkerFaceColor',[225/255. 0/255. 30/255.]);
%     set(gca,'FontSize',16);
%     hold on;
% %     h2=lsline;
% %     h2.LineWidth = 3;
% %     h2.Color = [0.3,0.3,0.3];
% %     [r, p] = corrcoef(SD_thr(:,6),SD_thr(:,i));
% %     pvalue = sprintf('%.4f',p(1,2));
% %     rvalue = sprintf('%.4f',r(1,2));
% %     ylabel("Tractography-based Volume");
% %     xlabel("MNI152-registered Volume");
% %     text(max(SD_thr(:,6))*0.9,max(SD_thr(:,i))*0.9,{strcat('r =  ',num2str(rvalue)),...
% %         strcat('p = ',num2str(pvalue))},'FontSize',16);
% 
% end
% 
% 
% %%输出数据至txt


fp=fopen('B.txt','a');
fprintf(fp,'%d,',SD_thr);%注意：%d后有逗号。
fclose(fp);

fp=fopen('C.txt','a');
fprintf(fp,'%d,',SD_thr1);%注意：%d后有逗号。
fclose(fp);

fp=fopen('D.txt','a');
fprintf(fp,'%d,',SD_thr3);%注意：%d后有逗号。
fclose(fp);