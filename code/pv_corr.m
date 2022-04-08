
% calcualte population vector correlation for same shape and different shape 

% same shape (sessions 1 and 4) and (sessions 2 and 3)
% diff shape (sessions 1 and 2) and (sessions 3 and 4)

%%
% %sessions 1-4

map = ai_prox_metrix; %define group

same_map = [map(:,1), map(:,4); map(:,2), map(:,3)];
diff_map = [map(:,1), map(:,2); map(:,3), map(:,4)];

same1_map = [{same_map{:,1}}'];
same2_map = [{same_map{:,2}}'];

diff1_map = [{diff_map{:,1}}'];
diff2_map = [{diff_map{:,2}}'];

%stack rate maps and calculate pv corr

tempxsamemap1=zeros(48,64,length(same1_map));
for k=1:length(same1_map)
tempxsamemap1(:,:,k)=same1_map{k,1};
end
xsamemap1=tempxsamemap1;

tempxsamemap2=zeros(48,64,length(same2_map));
for k=1:length(same2_map)
tempxsamemap2(:,:,k)=same2_map{k,1};
end
xsamemap2=tempxsamemap2;

tempxdiffmap1=zeros(48,64,length(diff1_map));
for k=1:length(diff1_map)
tempxdiffmap1(:,:,k)=diff1_map{k,1};
end
xdiffmap1=tempxdiffmap1;

tempxdiffmap2=zeros(48,64,length(diff2_map));
for k=1:length(diff2_map)
tempxdiffmap2(:,:,k)=diff2_map{k,1};
end
xdiffmap2=tempxdiffmap2;

[samemap1, samemap2] = comparemaps(xsamemap1, xsamemap2); %stack all maps and change unoccupied to NaN
[diffmap1, diffmap2] = comparemaps(xdiffmap1, xdiffmap2); 


[ssame1] = findcorr(samemap1, samemap2); %find correlation coefficents of z vector for each x_y pixel
[sdiff1] = findcorr(diffmap1, diffmap2); 

ssame1t = ~isnan(ssame1(:));
allsame = ssame1(ssame1t); %pv correlations in same shape

sdiff1t = ~isnan(sdiff1(:));
alldiff = sdiff1(sdiff1t); %pv correlations in different shape

figure;
cdfplot(allsame)
hold on
cdfplot(alldiff)
legend({'same','diff'})

%%
function [out_map1, out_map2] = comparemaps(map1, map2)

% take two maps and convert unoccupied pixels in both maps to NaN

for i = 1:size(map1,1) 
    for j=1:size(map1,2)
        for k = 1:size(map1,3)
                if map1(i,j,k) < 0 | map2(i,j,k) < 0
                    out_map1(i,j,k) = NaN; 
                    out_map2(i,j,k) = NaN;
                else
                    out_map1(i,j,k) = map1(i,j,k); 
                    out_map2(i,j,k) = map2(i,j,k); 
                end
         end
    end
end
end


function [corrmap] = findcorr(map1, map2)

% take two maps and find correlation coeffient along z dimension for each
% x_y pixel

for i = 1:size(map1,1) 
    for j=1:size(map1,2)
        s1 = corrcoef(map1(i,j,:), map2(i,j,:),'Rows','complete');
        x(i,j).s1 = s1;
        clear s1
    end
    
end

for i=1:size(x,1)
    for j=1:size(x,2)
        if ~isnan(x(i,j).s1)
            corrmap(i,j) = x(i,j).s1(1,2);
        else
            corrmap(i,j) = NaN;
        end
    end
end
end