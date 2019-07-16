function [fid_lb, sw] = varian_load_broaden(datapath, lb)

%Sarmad Siddiqui, 10/27/2015. Provide fid and line broadening
% Changed on 11/9. Added sweepwidth as an output parameter

[rp,ip, points] = varianloadfid(datapath(1:end-4),1,1);
fid = rp +i*ip;

sw = varianloadsw(datapath);

[points2, acquisitions] =size(fid);

if points ~= points2
    error('Something is wrong; points not matching')
end

t=(1:points)';
lbf = exp(-t*(1/sw)*lb); %line broadening function

if acquisitions > 1
    lbf = repmat(lbf,1,acquisitions);
end

fid_lb = fid.*lbf;

end
