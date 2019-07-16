function img = fdfstack(datapath)

%function img = fdfstack(datapath)
% Importing stack of fdf file into matlab
% Sarmad Siddiqui, 3-26-2016
% datapath = path to folder
% dependency: fdf2.m (modified fdf.m by MP)

fsep = filesep; %to chose *nix or win / or \
suffix = '*.fdf';
fullpath = strcat(datapath, fsep, suffix);

filenames = dir(fullpath);
[ml, ~] = size(filenames);

for n = 1:ml
    filenames2{n,:} = filenames(n).name;
end

filenames2 = sort(filenames2)

cd(datapath);

for n = 1: ml
    img(:,:,n) = fdf2(filenames2{n,:});
end