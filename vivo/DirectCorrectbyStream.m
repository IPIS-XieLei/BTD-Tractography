function [DirsROI,WeightedDirsROI] = DirectCorrectbyStream(position,peaks,WeightedPeaks,BundlePeaks)
DirsROI = 0; WeightedDirsROI = 0;
% Get peaks



vectors = squeeze(peaks(position(1),position(2),position(3),:,:));
Weightedvectors = squeeze(WeightedPeaks(position(1),position(2),position(3),:,:));
% Get Dir
if any(squeeze(BundlePeaks(position(1),position(2),position(3),1,:))~=0)
    TractVector = squeeze(BundlePeaks(position(1),position(2),position(3),1,:));
    [~,num] = max(abs(vectors*TractVector));
    vector = vectors(num,:); Weightedvector = Weightedvectors(num,:);
    if vector*TractVector<0
        vector = -vector; Weightedvector = -Weightedvector;
        DirsROI = vector; WeightedDirsROI = Weightedvector;
    else
        DirsROI = vector; WeightedDirsROI = Weightedvector;
    end
%     if position(1)<95&&position(2)>75
%         TractVector=squeeze(BundlePeaks(88,78,54,1,:));
%         if DirsROI*TractVector<0
%         DirsROI =-DirsROI; WeightedDirsROI = -WeightedDirsROI;
%         end
%     end
 else
	k = 0; N = 0;
    while(1)
        N = N+1;
        MatrixNeighbor = GetNeighbor(N,1);
        positions = position+MatrixNeighbor;
        for j = 1:size(MatrixNeighbor,1)
            if any(squeeze(BundlePeaks(positions(j,1),positions(j,2),positions(j,3),1,:))~=0)
                TractVector = squeeze(BundlePeaks(positions(j,1),positions(j,2),positions(j,3),1,:));
                [~,num] = max(abs(vectors*TractVector));
                vector = vectors(num,:); Weightedvector = Weightedvectors(num,:);
                if vector*TractVector<0
                    vector = -vector; Weightedvector = -Weightedvector;
                    DirsROI = vector; WeightedDirsROI = Weightedvector;
                end
%         if position(1)<92&&position(2)>77
%             TractVector=squeeze(BundlePeaks(89,76,57,1,:));
%             if DirsROI*TractVector<0
%                 DirsROI = -DirsROI; WeightedDirsROI = -WeightedDirsROI;
%             end
%         end
                k = 1;
                break;
            end
            
        end

        if k==1 || N==4
            break;
        end
    end             
end


end