function VisDWI(Signal, perspective, slice, dis)

if nargin == 3
    dis = 0; 
end

if perspective == 1
    d = squeeze(Signal(slice,:,:));
    d = d / max(max(d));
    slicexg = im2uint8(d)';
    slicex=ind2rgb(slicexg, gray(256));
elseif perspective == 2
    d = squeeze(Signal(:,slice,:));
    d = d / max(max(d));
    sliceyg = im2uint8(d)';
    slicey=ind2rgb(sliceyg, gray(256));
else
    d = squeeze(Signal(:,:,slice));
    d = d / max(max(d));
    slicezg = im2uint8(d)';
    slicez=ind2rgb(slicezg, gray(256));
end

% if perspective == 1
% sliDWI(z,x) = squeeze(tmpDWI);
% elseif perspective == 2
% sliDWI(UniqueNewCurr(end-2,i),UniqueNewCurr(end,i),UniqueNewCurr(end-1,i),:) = tmpDWI;   
% elseif perspective == 3
% sliDWI(UniqueNewCurr(end-2,i),UniqueNewCurr(end-1,i),UniqueNewCurr(end,i),:) = tmpDWI;
% end

% end
%     sliDWI90 = flip(rot90(squeeze(sliDWI)));
% imagesc(flip(rot90(squeeze(sliDWI)))); colormap('gray');

if perspective == 1
    slicex_x = [slice slice;slice slice]; slicex_y=[1 size(Signal,2);1 size(Signal,2)]; slicex_z=[1 1;size(Signal,3) size(Signal,3)];
    surface(slicex_x+dis,slicex_y,slicex_z, slicex,'FaceColor','texturemap', 'EdgeColor','none', 'CDataMapping','direct','FaceAlpha',1);    
elseif perspective == 2
    slicey_x = [1 size(Signal,1);1 size(Signal,1)]; slicey_y=[slice slice;slice slice]; slicey_z=[1 1;size(Signal,3) size(Signal,3)];
    surface(slicey_x,slicey_y+dis,slicey_z, slicey, 'FaceColor','texturemap', 'EdgeColor','none', 'CDataMapping','direct','FaceAlpha',1);
else
    slicez_x=[1 size(Signal,1);1 size(Signal,1)]; slicez_y=[1 1;size(Signal,2) size(Signal,2)]; slicez_z=[slice slice;slice slice];
    surface(slicez_x,slicez_y,slicez_z+dis, slicez,'FaceColor','texturemap', 'EdgeColor','none', 'CDataMapping','direct','FaceAlpha',1);    

colormap('gray');

end