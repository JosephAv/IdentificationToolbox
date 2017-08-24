
function [frame] = createFrame(rel_data)

n = size(rel_data.values,2); %number of frames

framest = single(zeros(n,60));
frame = single(zeros(n,61));

for i=1:size(rel_data.values,2)
   for j=1:size(rel_data.values{i},1)
       
       framest(i,rel_data.values{i}(j,1)*3-2:rel_data.values{i}(j,1)*3)= rel_data.values{i}(j,3:5);
       j=j+1;
   end
   i=i+1;
end
frame= [rel_data.time(:,1) framest];

end
       
       
       

