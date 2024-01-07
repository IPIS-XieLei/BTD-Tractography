function ShowPeaks(DirsROI, ROIpositions, slice, d, value)

if nargin == 4
    value = 0.5;
end

for i = 1:size(DirsROI,1)
    if ROIpositions(i,d) == slice
        u = DirsROI(i,1); v = DirsROI(i,2); w = DirsROI(i,3);
        vec = [u,v,w]/norm([u,v,w]); u = vec(1); v = vec(2); w = vec(3);
        quiver3(ROIpositions(i,1),ROIpositions(i,2),ROIpositions(i,3),u,v,w, value, 'r', 'MaxHeadSize', 0.5);
        hold on;
    end
end

end
