function [Trace,stopreason] = ftrack1(Aall,start_point,step_size,mask)

% Parameter
detaT = 0.1;
stop = 0; notstop = 0;
p0 = start_point;
Trace = zeros(0,3); 
stopTrace = zeros(0,3);
oldvector = [0 0 0];
A=Aall{4};
% Tracking
while(1)
    intp0 = round(p0);
%     if(intp0(2)<35)
%         A=Aall{2};
%     end
%     if(intp0(2)>35)
%         A=Aall{4};      
%     end
    if size(Trace,1)>100/step_size
        break
    end
    % Out of size
    if any(intp0(:,3)<1) || any(intp0(:,3)>size(mask,3)) || ...
            any(intp0(:,2)<1) || any(intp0(:,2)>size(mask,2)) || ...
            any(intp0(:,1)<1) || any(intp0(:,1)>size(mask,1))
%         Trace = [Trace;stopTrace;p0]; stopTrace = [];
        break;
    end
% %     if(intp0(1)<92)
%     % Out of mask
        if mask(intp0(1),intp0(2),intp0(3)) == 0
% %           Trace = [Trace;stopTrace;p0]; stopTrace = [];
            break;
        end
%     end
% %     else
%         if endmask(intp0(1),intp0(2),intp0(3)) == 1
% %           Trace = [Trace;stopTrace;p0]; stopTrace = [];
%             break;
%         end
%     en
    % Cal A
    if size(A,2) == 4
        f = @(p) (A*[p(1), p(2), p(3), 1]')';
    elseif size(A,2) == 6
        f = @(p) (A*[p(1)^2, p(2)^2, p(1)*p(2), p(1), p(2), 1]')';
    elseif size(A,2) == 10
        f = @(p) (A*[p(1)^2, p(2)^2, p(3)^2, p(1)*p(2), p(1)*p(3), p(2)*p(3), p(1), p(2), p(3), 1]')';
    elseif size(A,2) == 11
        f = @(p) (A*[p(1)^3, p(2)^3, (p(1)^2)*p(2), p(1)*(p(2)^2), p(1)^2, p(2)^2, p(1)*p(2), p(1), p(2), 1]')';
    elseif size(A,2) == 15
        f = @(p) (A*[p(1)^4, p(2)^4, (p(1)^3)*p(2), p(1)*(p(2)^3), (p(1)^2)*(p(2)^2),p(1)^3, p(2)^3, (p(1)^2)*p(2), p(1)*(p(2)^2), p(1)^2, p(2)^2, ...
                    p(1)*p(2), p(1), p(2), 1]')';  
    elseif size(A,2) == 20
        f = @(p) (A*[p(1)^3, p(2)^3, p(3)^3, (p(1)^2)*p(2), (p(1)^2)*p(3), (p(2)^2)*p(1), (p(2)^2)*p(3), (p(3)^2)*p(1), (p(3)^2)*p(2), p(1)*p(2)*p(3), ...
                    p(1)^2, p(2)^2, p(3)^2, p(1)*p(2), p(1)*p(3), p(2)*p(3), p(1), p(2), p(3), 1]')';
    elseif size(A,2) == 35
        f = @(p) (A*[p(1)^4, p(2)^4, p(3)^4, (p(1)^3)*p(2), (p(1)^3)*p(3), (p(2)^3)*p(1), (p(2)^3)*p(3), (p(3)^3)*p(1), (p(3)^3)*p(2), (p(1)^2)*(p(2)^2), (p(1)^2)*(p(3)^2), (p(2)^2)*(p(3)^2), (p(1)^2)*p(2)*p(3), (p(2)^2)*p(1)*p(3), (p(3)^2)*p(1)*p(2), ...
                    p(1)^3, p(2)^3, p(3)^3, (p(1)^2)*p(2), (p(1)^2)*p(3), (p(2)^2)*p(1), (p(2)^2)*p(3), (p(3)^2)*p(1), (p(3)^2)*p(2), p(1)*p(2)*p(3), ...
                    p(1)^2, p(2)^2, p(3)^2, p(1)*p(2), p(1)*p(3), p(2)*p(3), ...
                    p(1), p(2), p(3), 1]')';
    elseif size(A,2) == 56
        f = @(p) (A*[p(1)^5, p(2)^5, p(3)^5, (p(1)^4)*p(2), (p(1)^4)*p(3), (p(2)^4)*p(1), (p(2)^4)*p(3), (p(3)^4)*p(1), (p(3)^4)*p(2), (p(1)^3)*(p(2)^2), (p(1)^3)*(p(3)^2), (p(2)^3)*(p(1)^2), (p(2)^3)*(p(3)^2), (p(3)^3)*(p(1)^2), (p(3)^3)*(p(2)^2), (p(1)^3)*p(2)*p(3), (p(2)^3)*p(1)*p(3), (p(3)^3)*p(1)*p(2), (p(1)^2)*(p(2)^2)*p(3), (p(1)^2)*p(2)*(p(3)^2), p(1)*(p(2)^2)*(p(3)^2), ...
                    p(1)^4, p(2)^4, p(3)^4, (p(1)^3)*p(2), (p(1)^3)*p(3), (p(2)^3)*p(1), (p(2)^3)*p(3), (p(3)^3)*p(1), (p(3)^3)*p(2), (p(1)^2)*(p(2)^2), (p(1)^2)*(p(3)^2), (p(2)^2)*(p(3)^2), (p(1)^2)*p(2)*p(3), (p(2)^2)*p(1)*p(3), (p(3)^2)*p(1)*p(2), ...
                    p(1)^3, p(2)^3, p(3)^3, (p(1)^2)*p(2), (p(1)^2)*p(3), (p(2)^2)*p(1), (p(2)^2)*p(3), (p(3)^2)*p(1), (p(3)^2)*p(2), p(1)*p(2)*p(3), ...
                    p(1)^2, p(2)^2, p(3)^2, p(1)*p(2), p(1)*p(3), p(2)*p(3), ...
                    p(1), p(2), p(3), 1]')';
    elseif size(A,2) == 84
        f = @(p) (A*[p(1), p(1)^2, p(1)^3, p(1)^4, p(1)^5, p(1)^6, p(2), p(1)*p(2), p(1)^2*p(2), p(1)^3*p(2), p(1)^4*p(2), p(1)^5*p(2), ...
                    p(2)^2, p(1)*p(2)^2, p(1)^2*p(2)^2, p(1)^3*p(2)^2, p(1)^4*p(2)^2, p(2)^3, p(1)*p(2)^3, p(1)^2*p(2)^3, p(1)^3*p(2)^3, ...
                    p(2)^4, p(1)*p(2)^4, p(1)^2*p(2)^4, p(2)^5, p(1)*p(2)^5, p(2)^6, p(3), p(1)*p(3), p(1)^2*p(3), p(1)^3*p(3), p(1)^4*p(3), p(1)^5*p(3), ...
                    p(2)*p(3), p(1)*p(2)*p(3), p(1)^2*p(2)*p(3), p(1)^3*p(2)*p(3), p(1)^4*p(2)*p(3), p(2)^2*p(3), p(1)*p(2)^2*p(3), p(1)^2*p(2)^2*p(3), p(1)^3*p(2)^2*p(3), ...
                    p(2)^3*p(3), p(1)*p(2)^3*p(3), p(1)^2*p(2)^3*p(3), p(2)^4*p(3), p(1)*p(2)^4*p(3), p(2)^5*p(3), p(3)^2, p(1)*p(3)^2, p(1)^2*p(3)^2, p(1)^3*p(3)^2, ...
                    p(1)^4*p(3)^2, p(2)*p(3)^2, p(1)*p(2)*p(3)^2, p(1)^2*p(2)*p(3)^2, p(1)^3*p(2)*p(3)^2, p(2)^2*p(3)^2, p(1)*p(2)^2*p(3)^2, p(1)^2*p(2)^2*p(3)^2, ...
                    p(2)^3*p(3)^2, p(1)*p(2)^3*p(3)^2, p(2)^4*p(3)^2, p(3)^3, p(1)*p(3)^3, p(1)^2*p(3)^3, p(1)^3*p(3)^3, p(2)*p(3)^3, p(1)*p(2)*p(3)^3, p(1)^2*p(2)*p(3)^3, ...
                    p(2)^2*p(3)^3, p(1)*p(2)^2*p(3)^3, p(2)^3*p(3)^3,p(3)^4, p(1)*p(3)^4, p(1)^2*p(3)^4, p(2)*p(3)^4, p(1)*p(2)*p(3)^4, p(2)^2*p(3)^4, p(3)^5, p(1)*p(3)^5, p(2)*p(3)^5, p(3)^6, 1]')';
    elseif size(A,2) == 120
        f = @(p) (A*[p(1), p(1)^2, p(1)^3, p(1)^4, p(1)^5, p(1)^6, p(1)^7, p(2), p(1)*p(2), p(1)^2*p(2), p(1)^3*p(2), p(1)^4*p(2), p(1)^5*p(2), p(1)^6*p(2), p(2)^2, p(1)*p(2)^2, ...
                    p(1)^2*p(2)^2, p(1)^3*p(2)^2, p(1)^4*p(2)^2, p(1)^5*p(2)^2, p(2)^3, p(1)*p(2)^3, p(1)^2*p(2)^3, p(1)^3*p(2)^3, p(1)^4*p(2)^3, p(2)^4, p(1)*p(2)^4, p(1)^2*p(2)^4, ...
                    p(1)^3*p(2)^4, p(2)^5, p(1)*p(2)^5, p(1)^2*p(2)^5, p(2)^6, p(1)*p(2)^6, p(2)^7, p(3), p(1)*p(3), p(1)^2*p(3), p(1)^3*p(3), p(1)^4*p(3), p(1)^5*p(3), p(1)^6*p(3), p(2)*p(3), ...
                    p(1)*p(2)*p(3), p(1)^2*p(2)*p(3), p(1)^3*p(2)*p(3), p(1)^4*p(2)*p(3), p(1)^5*p(2)*p(3), p(2)^2*p(3), p(1)*p(2)^2*p(3), p(1)^2*p(2)^2*p(3), p(1)^3*p(2)^2*p(3), p(1)^4*p(2)^2*p(3), ...
                    p(2)^3*p(3), p(1)*p(2)^3*p(3), p(1)^2*p(2)^3*p(3), p(1)^3*p(2)^3*p(3), p(2)^4*p(3), p(1)*p(2)^4*p(3), p(1)^2*p(2)^4*p(3), p(2)^5*p(3), p(1)*p(2)^5*p(3), p(2)^6*p(3), p(3)^2, ...
                    p(1)*p(3)^2, p(1)^2*p(3)^2, p(1)^3*p(3)^2, p(1)^4*p(3)^2, p(1)^5*p(3)^2, p(2)*p(3)^2, p(1)*p(2)*p(3)^2, p(1)^2*p(2)*p(3)^2, p(1)^3*p(2)*p(3)^2, p(1)^4*p(2)*p(3)^2, ...
                    p(2)^2*p(3)^2, p(1)*p(2)^2*p(3)^2, p(1)^2*p(2)^2*p(3)^2, p(1)^3*p(2)^2*p(3)^2, p(2)^3*p(3)^2, p(1)*p(2)^3*p(3)^2, p(1)^2*p(2)^3*p(3)^2, p(2)^4*p(3)^2, p(1)*p(2)^4*p(3)^2, ...
                    p(2)^5*p(3)^2, p(3)^3, p(1)*p(3)^3, p(1)^2*p(3)^3, p(1)^3*p(3)^3, p(1)^4*p(3)^3, p(2)*p(3)^3, p(1)*p(2)*p(3)^3, p(1)^2*p(2)*p(3)^3, p(1)^3*p(2)*p(3)^3, p(2)^2*p(3)^3, ...
                    p(1)*p(2)^2*p(3)^3, p(1)^2*p(2)^2*p(3)^3, p(2)^3*p(3)^3, p(1)*p(2)^3*p(3)^3, p(2)^4*p(3)^3, p(3)^4, p(1)*p(3)^4, p(1)^2*p(3)^4, p(1)^3*p(3)^4, p(2)*p(3)^4, p(1)*p(2)*p(3)^4, ...
                    p(1)^2*p(2)*p(3)^4, p(2)^2*p(3)^4, p(1)*p(2)^2*p(3)^4, p(2)^3*p(3)^4, p(3)^5, p(1)*p(3)^5, p(1)^2*p(3)^5, p(2)*p(3)^5, p(1)*p(2)*p(3)^5, p(2)^2*p(3)^5, p(3)^6, p(1)*p(3)^6, ...
                    p(2)*p(3)^6, p(3)^7, 1]')';
    elseif size(A,2) == 165
        f = @(p) (A*[p(1), p(1)^2, p(1)^3, p(1)^4, p(1)^5, p(1)^6, p(1)^7, p(1)^8, p(2), p(1)*p(2), p(1)^2*p(2), p(1)^3*p(2), p(1)^4*p(2), p(1)^5*p(2), p(1)^6*p(2), p(1)^7*p(2), ...
                    p(2)^2, p(1)*p(2)^2, p(1)^2*p(2)^2, p(1)^3*p(2)^2, p(1)^4*p(2)^2, p(1)^5*p(2)^2, p(1)^6*p(2)^2, p(2)^3, p(1)*p(2)^3, p(1)^2*p(2)^3, p(1)^3*p(2)^3, p(1)^4*p(2)^3, ...
                    p(1)^5*p(2)^3, p(2)^4, p(1)*p(2)^4, p(1)^2*p(2)^4, p(1)^3*p(2)^4, p(1)^4*p(2)^4, p(2)^5, p(1)*p(2)^5, p(1)^2*p(2)^5, p(1)^3*p(2)^5, p(2)^6, p(1)*p(2)^6, p(1)^2*p(2)^6, ...
                    p(2)^7, p(1)*p(2)^7, p(2)^8, p(3), p(1)*p(3), p(1)^2*p(3), p(1)^3*p(3), p(1)^4*p(3), p(1)^5*p(3), p(1)^6*p(3), p(1)^7*p(3), p(2)*p(3), p(1)*p(2)*p(3), p(1)^2*p(2)*p(3), ...
                    p(1)^3*p(2)*p(3), p(1)^4*p(2)*p(3), p(1)^5*p(2)*p(3), p(1)^6*p(2)*p(3), p(2)^2*p(3), p(1)*p(2)^2*p(3), p(1)^2*p(2)^2*p(3), p(1)^3*p(2)^2*p(3), p(1)^4*p(2)^2*p(3), p(1)^5*p(2)^2*p(3), ...
                    p(2)^3*p(3), p(1)*p(2)^3*p(3), p(1)^2*p(2)^3*p(3), p(1)^3*p(2)^3*p(3), p(1)^4*p(2)^3*p(3), p(2)^4*p(3), p(1)*p(2)^4*p(3), p(1)^2*p(2)^4*p(3), p(1)^3*p(2)^4*p(3), p(2)^5*p(3), ...
                    p(1)*p(2)^5*p(3), p(1)^2*p(2)^5*p(3), p(2)^6*p(3), p(1)*p(2)^6*p(3), p(2)^7*p(3), p(3)^2, p(1)*p(3)^2, p(1)^2*p(3)^2, p(1)^3*p(3)^2, p(1)^4*p(3)^2, p(1)^5*p(3)^2, p(1)^6*p(3)^2, ...
                    p(2)*p(3)^2, p(1)*p(2)*p(3)^2, p(1)^2*p(2)*p(3)^2, p(1)^3*p(2)*p(3)^2, p(1)^4*p(2)*p(3)^2, p(1)^5*p(2)*p(3)^2, p(2)^2*p(3)^2, p(1)*p(2)^2*p(3)^2, p(1)^2*p(2)^2*p(3)^2, ...
                    p(1)^3*p(2)^2*p(3)^2, p(1)^4*p(2)^2*p(3)^2, p(2)^3*p(3)^2, p(1)*p(2)^3*p(3)^2, p(1)^2*p(2)^3*p(3)^2, p(1)^3*p(2)^3*p(3)^2, p(2)^4*p(3)^2, p(1)*p(2)^4*p(3)^2, ...
                    p(1)^2*p(2)^4*p(3)^2, p(2)^5*p(3)^2, p(1)*p(2)^5*p(3)^2, p(2)^6*p(3)^2, p(3)^3, p(1)*p(3)^3, p(1)^2*p(3)^3, p(1)^3*p(3)^3, p(1)^4*p(3)^3, p(1)^5*p(3)^3, p(2)*p(3)^3, ...
                    p(1)*p(2)*p(3)^3, p(1)^2*p(2)*p(3)^3, p(1)^3*p(2)*p(3)^3, p(1)^4*p(2)*p(3)^3, p(2)^2*p(3)^3, p(1)*p(2)^2*p(3)^3, p(1)^2*p(2)^2*p(3)^3, p(1)^3*p(2)^2*p(3)^3, p(2)^3*p(3)^3, ...
                    p(1)*p(2)^3*p(3)^3, p(1)^2*p(2)^3*p(3)^3, p(2)^4*p(3)^3, p(1)*p(2)^4*p(3)^3, p(2)^5*p(3)^3, p(3)^4, p(1)*p(3)^4, p(1)^2*p(3)^4, p(1)^3*p(3)^4, p(1)^4*p(3)^4, p(2)*p(3)^4, ...
                    p(1)*p(2)*p(3)^4, p(1)^2*p(2)*p(3)^4, p(1)^3*p(2)*p(3)^4, p(2)^2*p(3)^4, p(1)*p(2)^2*p(3)^4, p(1)^2*p(2)^2*p(3)^4, p(2)^3*p(3)^4, p(1)*p(2)^3*p(3)^4, p(2)^4*p(3)^4, p(3)^5, ...
                    p(1)*p(3)^5, p(1)^2*p(3)^5, p(1)^3*p(3)^5, p(2)*p(3)^5, p(1)*p(2)*p(3)^5, p(1)^2*p(2)*p(3)^5, p(2)^2*p(3)^5, p(1)*p(2)^2*p(3)^5, p(2)^3*p(3)^5, p(3)^6, p(1)*p(3)^6, ...
                    p(1)^2*p(3)^6, p(2)*p(3)^6, p(1)*p(2)*p(3)^6, p(2)^2*p(3)^6, p(3)^7, p(1)*p(3)^7, p(2)*p(3)^7, p(3)^8, 1]')';
    elseif size(A,2) == 286
        f = @(p) (A*[p(1), p(1)^2, p(1)^3, p(1)^4, p(1)^5, p(1)^6, p(1)^7, p(1)^8, p(1)^9, p(1)^10, p(2), p(1)*p(2), p(1)^2*p(2), p(1)^3*p(2), ...
                    p(1)^4*p(2), p(1)^5*p(2), p(1)^6*p(2), p(1)^7*p(2), p(1)^8*p(2), p(1)^9*p(2), p(2)^2, p(1)*p(2)^2, p(1)^2*p(2)^2, p(1)^3*p(2)^2, ...
                    p(1)^4*p(2)^2, p(1)^5*p(2)^2, p(1)^6*p(2)^2, p(1)^7*p(2)^2, p(1)^8*p(2)^2, p(2)^3, p(1)*p(2)^3, p(1)^2*p(2)^3, p(1)^3*p(2)^3, ...
                    p(1)^4*p(2)^3, p(1)^5*p(2)^3, p(1)^6*p(2)^3, p(1)^7*p(2)^3, p(2)^4, p(1)*p(2)^4, p(1)^2*p(2)^4, p(1)^3*p(2)^4, p(1)^4*p(2)^4, ...
                    p(1)^5*p(2)^4, p(1)^6*p(2)^4, p(2)^5, p(1)*p(2)^5, p(1)^2*p(2)^5, p(1)^3*p(2)^5, p(1)^4*p(2)^5, p(1)^5*p(2)^5, p(2)^6, p(1)*p(2)^6, ...
                    p(1)^2*p(2)^6, p(1)^3*p(2)^6, p(1)^4*p(2)^6, p(2)^7, p(1)*p(2)^7, p(1)^2*p(2)^7, p(1)^3*p(2)^7, p(2)^8, p(1)*p(2)^8, p(1)^2*p(2)^8, ...
                    p(2)^9, p(1)*p(2)^9, p(2)^10, p(3), p(1)*p(3), p(1)^2*p(3), p(1)^3*p(3), p(1)^4*p(3), p(1)^5*p(3), p(1)^6*p(3), p(1)^7*p(3), ...
                    p(1)^8*p(3), p(1)^9*p(3), p(2)*p(3), p(1)*p(2)*p(3), p(1)^2*p(2)*p(3), p(1)^3*p(2)*p(3), p(1)^4*p(2)*p(3), p(1)^5*p(2)*p(3), ...
                    p(1)^6*p(2)*p(3), p(1)^7*p(2)*p(3), p(1)^8*p(2)*p(3), p(2)^2*p(3), p(1)*p(2)^2*p(3), p(1)^2*p(2)^2*p(3), p(1)^3*p(2)^2*p(3), ...
                    p(1)^4*p(2)^2*p(3), p(1)^5*p(2)^2*p(3), p(1)^6*p(2)^2*p(3), p(1)^7*p(2)^2*p(3), p(2)^3*p(3), p(1)*p(2)^3*p(3), p(1)^2*p(2)^3*p(3), ...
                    p(1)^3*p(2)^3*p(3), p(1)^4*p(2)^3*p(3), p(1)^5*p(2)^3*p(3), p(1)^6*p(2)^3*p(3), p(2)^4*p(3), p(1)*p(2)^4*p(3), p(1)^2*p(2)^4*p(3), ...
                    p(1)^3*p(2)^4*p(3), p(1)^4*p(2)^4*p(3), p(1)^5*p(2)^4*p(3), p(2)^5*p(3), p(1)*p(2)^5*p(3), p(1)^2*p(2)^5*p(3), p(1)^3*p(2)^5*p(3), ...
                    p(1)^4*p(2)^5*p(3), p(2)^6*p(3), p(1)*p(2)^6*p(3), p(1)^2*p(2)^6*p(3), p(1)^3*p(2)^6*p(3), p(2)^7*p(3), p(1)*p(2)^7*p(3), ...
                    p(1)^2*p(2)^7*p(3), p(2)^8*p(3), p(1)*p(2)^8*p(3), p(2)^9*p(3), p(3)^2, p(1)*p(3)^2, p(1)^2*p(3)^2, p(1)^3*p(3)^2, p(1)^4*p(3)^2, ...
                    p(1)^5*p(3)^2, p(1)^6*p(3)^2, p(1)^7*p(3)^2, p(1)^8*p(3)^2, p(2)*p(3)^2, p(1)*p(2)*p(3)^2, p(1)^2*p(2)*p(3)^2, p(1)^3*p(2)*p(3)^2, ...
                    p(1)^4*p(2)*p(3)^2, p(1)^5*p(2)*p(3)^2, p(1)^6*p(2)*p(3)^2, p(1)^7*p(2)*p(3)^2, p(2)^2*p(3)^2, p(1)*p(2)^2*p(3)^2, ...
                    p(1)^2*p(2)^2*p(3)^2, p(1)^3*p(2)^2*p(3)^2, p(1)^4*p(2)^2*p(3)^2, p(1)^5*p(2)^2*p(3)^2, p(1)^6*p(2)^2*p(3)^2, p(2)^3*p(3)^2, ...
                    p(1)*p(2)^3*p(3)^2, p(1)^2*p(2)^3*p(3)^2, p(1)^3*p(2)^3*p(3)^2, p(1)^4*p(2)^3*p(3)^2, p(1)^5*p(2)^3*p(3)^2, p(2)^4*p(3)^2, ...
                    p(1)*p(2)^4*p(3)^2, p(1)^2*p(2)^4*p(3)^2, p(1)^3*p(2)^4*p(3)^2, p(1)^4*p(2)^4*p(3)^2, p(2)^5*p(3)^2, p(1)*p(2)^5*p(3)^2, ...
                    p(1)^2*p(2)^5*p(3)^2, p(1)^3*p(2)^5*p(3)^2, p(2)^6*p(3)^2, p(1)*p(2)^6*p(3)^2, p(1)^2*p(2)^6*p(3)^2, p(2)^7*p(3)^2, ...
                    p(1)*p(2)^7*p(3)^2, p(2)^8*p(3)^2, p(3)^3, p(1)*p(3)^3, p(1)^2*p(3)^3, p(1)^3*p(3)^3, p(1)^4*p(3)^3, p(1)^5*p(3)^3, ...
                    p(1)^6*p(3)^3, p(1)^7*p(3)^3, p(2)*p(3)^3, p(1)*p(2)*p(3)^3, p(1)^2*p(2)*p(3)^3, p(1)^3*p(2)*p(3)^3, p(1)^4*p(2)*p(3)^3, ...
                    p(1)^5*p(2)*p(3)^3, p(1)^6*p(2)*p(3)^3, p(2)^2*p(3)^3, p(1)*p(2)^2*p(3)^3, p(1)^2*p(2)^2*p(3)^3, p(1)^3*p(2)^2*p(3)^3, ...
                    p(1)^4*p(2)^2*p(3)^3, p(1)^5*p(2)^2*p(3)^3, p(2)^3*p(3)^3, p(1)*p(2)^3*p(3)^3, p(1)^2*p(2)^3*p(3)^3, p(1)^3*p(2)^3*p(3)^3, ...
                    p(1)^4*p(2)^3*p(3)^3, p(2)^4*p(3)^3, p(1)*p(2)^4*p(3)^3, p(1)^2*p(2)^4*p(3)^3, p(1)^3*p(2)^4*p(3)^3, p(2)^5*p(3)^3, ...
                    p(1)*p(2)^5*p(3)^3, p(1)^2*p(2)^5*p(3)^3, p(2)^6*p(3)^3, p(1)*p(2)^6*p(3)^3, p(2)^7*p(3)^3, p(3)^4, p(1)*p(3)^4, p(1)^2*p(3)^4, ...
                    p(1)^3*p(3)^4, p(1)^4*p(3)^4, p(1)^5*p(3)^4, p(1)^6*p(3)^4, p(2)*p(3)^4, p(1)*p(2)*p(3)^4, p(1)^2*p(2)*p(3)^4, p(1)^3*p(2)*p(3)^4, ...
                    p(1)^4*p(2)*p(3)^4, p(1)^5*p(2)*p(3)^4, p(2)^2*p(3)^4, p(1)*p(2)^2*p(3)^4, p(1)^2*p(2)^2*p(3)^4, p(1)^3*p(2)^2*p(3)^4, ...
                    p(1)^4*p(2)^2*p(3)^4, p(2)^3*p(3)^4, p(1)*p(2)^3*p(3)^4, p(1)^2*p(2)^3*p(3)^4, p(1)^3*p(2)^3*p(3)^4, p(2)^4*p(3)^4, ...
                    p(1)*p(2)^4*p(3)^4, p(1)^2*p(2)^4*p(3)^4, p(2)^5*p(3)^4, p(1)*p(2)^5*p(3)^4, p(2)^6*p(3)^4, p(3)^5, p(1)*p(3)^5, p(1)^2*p(3)^5, ...
                    p(1)^3*p(3)^5, p(1)^4*p(3)^5, p(1)^5*p(3)^5, p(2)*p(3)^5, p(1)*p(2)*p(3)^5, p(1)^2*p(2)*p(3)^5, p(1)^3*p(2)*p(3)^5, ...
                    p(1)^4*p(2)*p(3)^5, p(2)^2*p(3)^5, p(1)*p(2)^2*p(3)^5, p(1)^2*p(2)^2*p(3)^5, p(1)^3*p(2)^2*p(3)^5, p(2)^3*p(3)^5, ...
                    p(1)*p(2)^3*p(3)^5, p(1)^2*p(2)^3*p(3)^5, p(2)^4*p(3)^5, p(1)*p(2)^4*p(3)^5, p(2)^5*p(3)^5, p(3)^6, p(1)*p(3)^6, p(1)^2*p(3)^6, ...
                    p(1)^3*p(3)^6, p(1)^4*p(3)^6, p(2)*p(3)^6, p(1)*p(2)*p(3)^6, p(1)^2*p(2)*p(3)^6, p(1)^3*p(2)*p(3)^6, p(2)^2*p(3)^6, ...
                    p(1)*p(2)^2*p(3)^6, p(1)^2*p(2)^2*p(3)^6, p(2)^3*p(3)^6, p(1)*p(2)^3*p(3)^6, p(2)^4*p(3)^6, p(3)^7, p(1)*p(3)^7, ...
                    p(1)^2*p(3)^7, p(1)^3*p(3)^7, p(2)*p(3)^7, p(1)*p(2)*p(3)^7, p(1)^2*p(2)*p(3)^7, p(2)^2*p(3)^7, p(1)*p(2)^2*p(3)^7, ...
                    p(2)^3*p(3)^7, p(3)^8, p(1)*p(3)^8, p(1)^2*p(3)^8, p(2)*p(3)^8, p(1)*p(2)*p(3)^8, p(2)^2*p(3)^8, p(3)^9, p(1)*p(3)^9, p(2)*p(3)^9, ...
                    p(3)^10, 1]')';
    end
    
    % Disturbed flow
    disturbed_vector = runge_kutta_4_vector(f, p0, detaT);
%     disturbed_vector(3) = 0;
    p0 = p0 + (step_size*disturbed_vector(:)/norm(disturbed_vector))' ;
%     p1 = p0-1.25;
    p1 = p0-0.5;
    
%     new_vector = runge_kutta_4_vector(f, p0, detaT);
%     if isnan(new_vector)
%         break
%     end
%     
%     if size(mask,3) <= 3 % FiberCup
%         disturbed_vector = ArtificialPotentialFieldsXY(p0, new_vector, mask, startpoint, endpoint);
%     else
%         disturbed_vector = ArtificialPotentialFieldsXYZ(p0, new_vector, mask, startpoint, endpoint);
%     end
%     p0 = p0 + (step_size*disturbed_vector(:)/norm(disturbed_vector))';
    
    % Angle thr
    if ~all(oldvector==0)
        if oldvector*disturbed_vector'<0.1
%             Trace = [Trace;stopTrace;p0]; stopTrace = [];
%             stopreason{fibernum+1, num} = 'Angle';
            break;
        else
            Trace = [Trace;p1];
        end
    end
    oldvector = disturbed_vector;
end

end