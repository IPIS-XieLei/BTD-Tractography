function result = Streamline_resampling(streamlines,N)

result = cell(1,1);

% Reshape
if size(streamlines,1) < size(streamlines,2)
    streamlines=streamlines';
end

% Resample
for i=1:size(streamlines,1)
     number = round(size(streamlines{i},1)/N);
%     number=N;
    result{i,1}=Cubic_B_spline(streamlines{i},number);
end

end

function B = Cubic_B_spline(A,number)
X=A(:,1)';Y=A(:,2)';Z=A(:,3)';
S=spline(linspace(0,1,length(X)),[X;Y;Z],linspace(0,1,number));
B(:,1)=S(1,:)';B(:,2)=S(2,:)';B(:,3)=S(3,:)';

end
