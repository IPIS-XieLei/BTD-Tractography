function [AIntra, fvalIntra] = GetATernaryCubicXY(ROIpositions, DirsROI, WeightedDirsROI)

% Weight
Nvalues = sqrt(sum(WeightedDirsROI.^2,2)); Nvalues = double(Nvalues);

% Define Items x and Scalar-Valued u
u = DirsROI'; u = double(u);
X = ones(10, size(ROIpositions,1));
X(1,:) = (ROIpositions(:,1).^3);
X(2,:) = (ROIpositions(:,2).^3);
X(3,:) = (ROIpositions(:,1).^2).*ROIpositions(:,2);
X(4,:) = (ROIpositions(:,2).^2).*ROIpositions(:,1);
X(5,:) = (ROIpositions(:,1).^2);
X(6,:) = (ROIpositions(:,2).^2);
X(7,:) = ROIpositions(:,1).*ROIpositions(:,2);
X(8,:) = ROIpositions(:,1);
X(9,:) = ROIpositions(:,2);

% Initial A
AInversion = u*pinv(X);
AInitial = [AInversion(1,:), AInversion(2,:), AInversion(3,:)];

% Subject to ...
Aeq = zeros(6,30);
Aeq(1,1) = 3; Aeq(1,13) = 1;
Aeq(2,4) = 1; Aeq(2,12) = 3;
Aeq(3,3) = 1; Aeq(3,14) = 1;
Aeq(4,5) = 2; Aeq(4,17) = 1; 
Aeq(5,7) = 1; Aeq(5,16) = 2;
Aeq(6,8) = 1; Aeq(6,19) = 1;
Beq = zeros(6,1);

% Optimation
options = optimoptions('fmincon', 'Display', 'off');
[AIntra, fvalIntra] = fmincon(@fun, AInitial, [], [], Aeq, Beq, [], [], [], options);
% [AIntra, fvalIntra] = fmincon(@fun, AInitial, [], [], [], [], [], [], [], options);
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

