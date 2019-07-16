function traverseimg(fileroot)

% function traverseimg(fileroot)
% Sarmad Siddiqui, 3/30/2016.
% This function goes through the Varian directory for an imaging session 
% (fileroot), looks for reconstructed images folder (.img), reads the fdf
% files, and saves the data as a img.mat file in the same directory as the
% fdf files of an image

fsep = filesep; %to chose *nix or win / or \
suffix = '*.img';
fullpath = strcat(fileroot, filesep, suffix);

dirnames = dir(fullpath);
[ml, ~] = size(dirnames);

for n = 1:ml
    dirnames2{n,:} = dirnames(n).name;
end

cd(fileroot);

for n = 1:ml
    datafolder = strcat(fileroot, fsep, dirnames2{n});
    img = fdfstack(datafolder);
    cd(datafolder) % added 4-12-16
    %plotmri(img, 1) removed this on 4/3/16
    save('img.mat', 'img');
end

end