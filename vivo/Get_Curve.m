function [result]=Get_Curve(A)
%     if size(A,1)<size(A,2)
%        A=A';
%     end
%     if size(B,1)<size(B,2)
%        B=B';
%     end 
    result=zeros(size(A,1),1);

    for l=2:size(A)-1
%         compA = LinearInterp2(A{i,1}(:,1),A{i,1}(:,2),A{i,1}(:,3), N);
%         compB = LinearInterp2(B{i,1}(:,1),B{i,1}(:,2),B{i,1}(:,3), N);
% %         compA = Cubic_B_spline(A{i,1}, N);
% %         compB = Cubic_B_spline(B{i,1}, N);
%         dist1 = GetDist2(compA, compB);
%         dist2 = GetDist2(compA, flipud(compB));
%         
        tangentA=GettangentVEC(A);
        curveA=GetcurveVEC(A);
% 
%         tangtemp=0;
%         curvetemp=0;
        
%         tangtemp1=abs(acos(abs(dot(tangentA(l,:),tangentB1(l,:))))*180/pi);
%         tangtemp2=abs(acos(abs(dot(tangentA(l,:),tangentB2(l,:))))*180/pi);
%         tangtemp=min(tangtemp1,tangtemp2)+tangtemp;
        
         result(l)=sqrt(dot(cross(tangentA(l,:),curveA(l,:)),cross(tangentA(l,:),curveA(l,:))))/sqrt(dot(tangentA(l,:),tangentA(l,:)))^3;
%         curvetempB1=sqrt(dot(cross(tangentB1(l,:),curveB1(l,:)),cross(tangentB1(l,:),curveB1(l,:))))/sqrt(dot(tangentB1(l,:),tangentB1(l,:)))^3;
%         curvetempB2=sqrt(dot(cross(tangentB2(l,:),curveB2(l,:)),cross(tangentB2(l,:),curveB2(l,:))))/sqrt(dot(tangentB2(l,:),tangentB2(l,:)))^3;
%         curvetempB=min(curvetempB1,curvetempB2);
%         curvetemp=abs(curvetempA-curvetempB)+curvetemp;
       
                       
%         result(i,2)=tangtemp/(size(compA,1)-2);
%         result(i,3)=curvetemp/(size(compA,1)-2);
    end
end

% function [B] = Cubic_B_spline(A,N)
%     X=A(:,1)';Y=A(:,2)';Z=A(:,3)';
%     S=spline(linspace(0,1,length(X)),[X;Y;Z],linspace(0,1,N));
%     B(:,1)=S(1,:)';B(:,2)=S(2,:)';B(:,3)=S(3,:)';
% end

% function C = LinearInterp2(X,Y,Z,N)
% 
%     A = [X,Y,Z];
%     temp1 = [0,0,0;A(2:end,:)-A(1:end-1,:)];
%     temp2 = sqrt(temp1(:,1).^2+(temp1(:,2).^2+temp1(:,3).^2)); % 计算每两个点间的距离
%     temp3 = temp2;
%     for i = 1:length(temp2)
%         temp3(i) = sum(temp2(1:i)); % 每个样本点的长度
%     end
%     
%     % 开始插值
%     lenSum = sum(temp2); % 总长度
%     lenPoint = 0:lenSum/(N-1):lenSum; % 每个插值点出的长度
%     C = zeros(N,3);
%     C(1,:) = A(1,:); C(end,:) = A(end,:);
%     for i = 2:N-1
%         a = lenPoint(i);
%         b = a-temp3;
%         index = max(find(b>=0));
%         posi = A(index,:) + (a-temp3(index))*temp1(index+1,:)/norm(temp1(index+1,:),2);
%         C(i,:) = posi;
%     end
    
%     Xr = C(:,1);
%     Yr = C(:,2);
%     Zr = C(:,3);

% end
% 
% % ------------ 求距离 ------------
% function dist = GetDist2(A,B)
% 
% temp = A-B;
% dist = sqrt(sum(sqrt(temp(:,1).^2+temp(:,2).^2+temp(:,3).^2)));
% 
% end
function tanVEC=GettangentVEC(A)
    tanVEC=zeros(size(A,1),3);
    tanVEC(1,:)=zeros(1,3);
    tanVEC(end,:)=zeros(1,3);
    for i=2:size(A,1)-1
        temp=sqrt((A(i+1,1)-A(i-1,1))^2+(A(i+1,2)-A(i-1,2))^2+(A(i+1,3)-A(i-1,3))^2);
        tanVEC(i,1)=(A(i+1,1)-A(i-1,1))/temp;
        tanVEC(i,2)=(A(i+1,2)-A(i-1,2))/temp;
        tanVEC(i,3)=(A(i+1,3)-A(i-1,3))/temp;
    end
end

function curveVEC=GetcurveVEC(A)
    curveVEC=zeros(size(A,1),3);
    curveVEC(1,:)=zeros(1,3);
    curveVEC(end,:)=zeros(1,3);
    for i=2:size(A,1)-1
        temp=(A(i+1,1)-A(i-1,1))^2+(A(i+1,2)-A(i-1,2))^2+(A(i+1,3)-A(i-1,3))^2;
        curveVEC(i,1)=(A(i+1,1)-2*A(i,1)+A(i-1,1))/temp;
        curveVEC(i,2)=(A(i+1,2)-2*A(i,2)+A(i-1,2))/temp;
        curveVEC(i,3)=(A(i+1,3)-2*A(i,3)+A(i-1,3))/temp;
    end
end
