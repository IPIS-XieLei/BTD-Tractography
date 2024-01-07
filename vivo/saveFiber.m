function saveFiber(savefiber_path, fg_clean)

fiber_id = fopen(savefiber_path, 'w');

for ii = 1:20
  
    [faber_rows,~] = size(fg_clean(ii).fibers);

    for i=1:faber_rows
        point = fg_clean(ii).fibers{i,1};
        [cell_rows,cell_cols] = size(point);
        for j=1:cell_cols
            for k=1:cell_rows    
                point_now = point(k,j);
                fprintf(fiber_id,'%f ', point_now);
            end
        end
        fprintf(fiber_id,'\n');
    end
    fprintf(fiber_id,'\n');
    fprintf(fiber_id,'\n');
end
fclose(fiber_id);

return

% function saveFiber(savefiber_path, fg_clean)
% 
% fiber_id = fopen(savefiber_path, 'w');
% 
% for ii = 1:20
%   
%     [faber_rows,~] = size(fg_clean(ii).fibers);
% 
%     for i=1:faber_rows
%         point = fg_clean(ii).fibers{i,1};
%         [cell_rows,cell_cols] = size(point);
%         for j=1:cell_cols
%             for k=1:cell_rows    
%                 point_now = point(k,j);
%                 fprintf(fiber_id,'%f ', point_now);
%             end
%         end
%         fprintf(fiber_id,'\n');
%     end
%     fprintf(fiber_id,'\n');
%     fprintf(fiber_id,'\n');
% end
% fclose(fiber_id);
% 
% return

