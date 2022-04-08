
% shift cells in MIS session by the mean rotation angle and generate correlation matrix


%% STD1 x MIS

%select units matching criteria. quality criteria need to be applied
%across the two sessions being compared
    
% with information criteria
xx = AI_prox90; 

EitherSTD1metrix = xx.STD1metrix(((xx.STD1lininfo>0.75 & xx.STD1lininfop < 0.01 & xx.STD1nspksontracks >50  )|( xx.MISlininfo>0.75 & xx.MISlininfop < 0.01 & xx.MISnspksontracks >50  )),:);
EitherMISmetrix = xx.MISmetrix(((xx.STD1lininfo>0.75 & xx.STD1lininfop < 0.01 & xx.STD1nspksontracks >50  )|( xx.MISlininfo>0.75 & xx.MISlininfop < 0.01 & xx.MISnspksontracks >50 )),:);

[STD1metrix_norm, MISmetrix_norm] = norm_fields(EitherSTD1metrix, EitherMISmetrix); % normalize field
[E_peak_corr, E_ang, E_res] = field_correlation(EitherMISmetrix, EitherSTD1metrix);

angs = deg2rad(E_ang);
idx = isnan(angs);
angs = angs(~idx);

mu = circ_mean(angs);
meanang = rad2deg(mu); %mean rotation angle

for i=1:length(E_ang)
    shiftMISmetrix{i} = circshift(MISmetrix_norm(i,:),360-round(meanang)); %shift cells in MIS session by mean rotation angle
end
shiftMISmetrix = shiftMISmetrix';
shiftMISmetrix_norm = cell2mat(shiftMISmetrix);


%linearised fields count angle clockwise from 0-360, as against the
%conventional CCW 0-360, to match with the rat running CW. 
%fliplr should take care of this.  

SMselSTD1metrix = fliplr(STD1metrix_norm);
SMselMISmetrix = fliplr(shiftMISmetrix_norm);

[rhoSM] = plotcorrelationmetrix(SMselSTD1metrix, SMselMISmetrix);

figure
imagesc(rhoSM);
axis xy
colormap(jet);
colorbar
caxis([-.4 1])
hold on
line45 = [1:1:360];
plot(line45, line45,  '--r')

%%
function [f1, f2] = norm_fields(f1, f2)

peak1 = nanmax(f1, [], 2);
peak2 = nanmax(f2, [], 2);
peak = [peak1, peak2];
peak = max(peak, [], 2);
for k = 1:size(peak)
    f1(k, :) = f1(k, :)/peak(k);
    f2(k, :) = f2(k, :)/peak(k);
end
end


function [rho] = plotcorrelationmetrix(STD1metrixx, MISmetrixx)


%correlation matrix calculation 
[rho]  = corr(STD1metrixx, MISmetrixx);
rho=rho.';
rho=fliplr(rho);
rho=flipud(rho);


end

function [peak_corr, ang, res] = field_correlation(f1, f2)


if min(size(f1)) ~= 1
    if size(f1, 2) ~= 360
        error('each row has to be a 360-bin vector');
    end
    ncell = size(f1, 1);
    peak_corr = zeros(ncell, 1);
    ang = zeros(ncell, 1);
    res = zeros(ncell, 360);
    for c = 1:ncell
        [peak_corr(c), ang(c), res(c, :)] = field_correlation(f1(c, :), f2(c, :));
    end
    return;
end
% ============================================================
if all(f1 == 0)
    peak_corr = 2;
    ang = nan;
    res = zeros(1, 360);
    return;
end
if all(f2 == 0)
    peak_corr = 3;
    ang = nan;
    res = zeros(1, 360);
    return;
end
  

angles = 0:359;
if length(f1) ~= 360
    error('field has to be of length 360');
end

[idx, res] = circ_corr_helper(f1, f2);
% find the angle of highest correlation
peak_corr = res(idx);
ang = angles(idx);

end

function [idx, res] = circ_corr_helper(f1, f2)
% shift f1
nbin = length(f1);
idx = 1:nbin;
res = zeros(nbin, 1);
count = 1;
for i = -1:-1:-nbin
    nidx = circ_add(idx, i, [1, nbin]);
    r = corrcoef(f1, f2(nidx));
    res(count) = r(1, 2);
    count = count + 1;
end
[~, idx] = max(res);
end
