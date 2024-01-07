function [AIntra, fvalIntra] = GetATernaryQuadratic(ROIpositions, DirsROI, WeightedDirsROI)

% Weight
Nvalues = sqrt(sum(WeightedDirsROI.^2,2));

% Define Items x and Scalar-Valued u
u = DirsROI';
X = ones(10, size(ROIpositions,1));
X(1,:) = (ROIpositions(:,1).^2);
X(2,:) = (ROIpositions(:,2).^2);
X(3,:) = (ROIpositions(:,3).^2);
X(4,:) = ROIpositions(:,1).*ROIpositions(:,2);
X(5,:) = ROIpositions(:,1).*ROIpositions(:,3);
X(6,:) = ROIpositions(:,2).*ROIpositions(:,3);
X(7,:) = ROIpositions(:,1);
X(8,:) = ROIpositions(:,2);
X(9,:) = ROIpositions(:,3);

% Initial A
AInversion = u*pinv(X);
AInitial = [AInversion(1,:), AInversion(2,:), AInversion(3,:)];
x=0;
y=0;
z=0;
for i=1:size(ROIpositions,1)
    x=x+ROIpositions(i,1);
    y=y+ROIpositions(i,2);
    z=z+ROIpositions(i,3);
end
% Subject to ...
Aeq = zeros(1,30);
Aeq(1,1) = 2*x; Aeq(1,14) = 1*x; Aeq(1,25) = 1*x;
Aeq(1,4) = 1*y; Aeq(1,12) = 2*y; Aeq(1,26) = 1*y;
Aeq(1,5) = 1*z; Aeq(1,16) = 1*z; Aeq(1,23) = 2*z;
Aeq(1,7) = 1; Aeq(1,18) = 1; Aeq(1,29) = 1;
Beq = zeros(1,1);
% Optimation
options = optimoptions('fmincon','Display','off');
[AIntra, fvalIntra] = fmincon(@fun, AInitial, [], [], Aeq, Beq, [], [], [], options);
AIntra = reshape(AIntra, 10, 3)';
% Optimation function
function f = fun(x)
f = 0;
for i = 1:size(X,2)
    f = f + ((u(1,i)-X(1,i)*x(1)-X(2,i)*x(2)-X(3,i)*x(3)-X(4,i)*x(4)-X(5,i)*x(5)-X(6,i)*x(6)-X(7,i)*x(7)-X(8,i)*x(8)-X(9,i)*x(9)-X(10,i)*x(10))*norm(Nvalues(i)))^2+...
            ((u(2,i)-X(1,i)*x(11)-X(2,i)*x(12)-X(3,i)*x(13)-X(4,i)*x(14)-X(5,i)*x(15)-X(6,i)*x(16)-X(7,i)*x(17)-X(8,i)*x(18)-X(9,i)*x(19)-X(10,i)*x(20))*norm(Nvalues(i)))^2+...
            ((u(3,i)-X(1,i)*x(21)-X(2,i)*x(22)-X(3,i)*x(23)-X(4,i)*x(24)-X(5,i)*x(25)-X(6,i)*x(26)-X(7,i)*x(27)-X(8,i)*x(28)-X(9,i)*x(29)-X(10,i)*x(30))*norm(Nvalues(i)))^2;
end
    
end

end

