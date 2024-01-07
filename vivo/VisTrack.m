function VisTrack(streamlines, ColorEncode, rgb)
    if ColorEncode == 1
        for r = 1:size(streamlines,2)
            fTract=squeeze(streamlines{r});
            plot3(fTract(:,1),fTract(:,2),fTract(:,3),'Color',rgb); 
            hold on;
        end
    elseif ColorEncode == 2
        for r = 1:size(streamlines,1)
            fTract=squeeze(streamlines{r});
            p = patch([(fTract(:,1))' NaN],[(fTract(:,2))' NaN],[(fTract(:,3))' NaN],0); 
            joint = ([fTract(2:end,:); NaN NaN NaN]-fTract);
            joint(end,:) = joint(end-1,:);
            temp_joint = joint;
            joint(:,1) = temp_joint(:,2);
            joint(:,2) = temp_joint(:,1);
            cdata = [abs(joint./1); NaN NaN NaN];
            cdata = reshape(cdata,length(cdata),1,3);
            set(p,'CData', cdata, 'EdgeColor','interp','SpecularColorReflectance',1)
            hold on;
        end
    end
%     direction = [0 1 0];
%     rotate(RA,direction,90)
    set(gca,'XTick',[],'YTick',[],'ZTick',[],'Color',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0]);
    set(gcf,'Color',[0 0 0]);
    xlabel('Anterior - Posterior');ylabel('Right - Left');zlabel('Inferior - Superior');
%     scrsz = get(groot,'ScreenSize');
%     figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
    axis equal;hold off;
end