function [DirROI,WeightedDirROI] = getclosevector(position,peaks,WeightedPeaks,mask,bundlepeaks)

DirROI = 0; WeightedDirROI = 0;
vectors = squeeze(peaks(position(1),position(2),position(3),:,:));
Weightedvectors = squeeze(WeightedPeaks(position(1),position(2),position(3),:,:));
bundlevectors = squeeze(bundlepeaks(position(1),position(2),position(3),:,:));

value = abs(vectors * bundlevectors');
[maxvalue,~] = max(value,[],2);
sortmax = sort(maxvalue);

if all(bundlevectors(:))==0 && mask(position(1),position(2),position(3)) == 1
    DirROI = vectors(1,:); WeightedDirROI = Weightedvectors(1,:);
elseif max(sortmax) <= 0.3
    DirROI = 0; WeightedDirROI = 0;
elseif abs(acos(sortmax(end))/pi*180-acos(sortmax(end-1))/pi*180)<5 && sortmax(end) ~= 0
    DirROI = vectors(maxvalue>=sortmax(end-1),:);
    WeightedDirROI = Weightedvectors(maxvalue>=sortmax(end-1),:);
elseif any(maxvalue(:)>=0.707) && any(maxvalue(:)<=0.9)
    [~, index] = max(maxvalue);
    DirROI = vectors(index,:);
    WeightedDirROI = Weightedvectors(index,:);
end

end