%% imports all the images in a study into one structure called images
% images has the fields 'img' for the image data, and 'pn' for ProtocolName

rootpath = '/khazaddum/data/z_temp/C13 Mice/20180216_Xe_19.16.2/';
fprintf('Study path is %s \n', rootpath')

scannames = dir(rootpath);
fsep = filesep;% / or \ for *nix or windows

m = 1;
for n = 1: numel(scannames)
    if scannames(n).isdir
        scandirs(m).name = scannames(n).name;
        m = m + 1;
    end
end

fprintf('Total scans in study: %d \n', numel(scandirs)-1) % subtract AdjResult directory

m = 1;
for n = 1:numel(scandirs)
    pathname = [rootpath scandirs(n).name fsep 'pdata' fsep '1' fsep 'dicom' fsep];
    if isdir(pathname)
        imgdirs(m).name = pathname;
        m = m + 1;
    end
end

fprintf('Total scans with dicoms present: %d \n', numel(imgdirs))

for n = 1:numel(imgdirs)
    imgpath = [imgdirs(n).name '*dcm'];
    filelist = dir(imgpath);
    for m = 1:numel(filelist)
        images(n).img(:,:,m) = dicomread([imgdirs(n).name filelist(m).name]);
        info = dicominfo([imgdirs(n).name filelist(1).name]); %just need to read the header from the first dicom file
        images(n).pn = info.ProtocolName;
        images(n).folder = imgdirs(n).name;
        % I'm just recopying imgdirs(n).name to images(n).folder; Wasted variable
    end
end

% To display where the images are in the folders, and to setup for plotting particular images

pn = {'1_Localizer', '1_Localizer_multi_slice', 'T2Map_Lungs_coronal' ,'T2Map_Lungs_axial', 'T2_TurboRARE'};

expression = [rootpath '(\d{1,3})'];

for n = 1:numel(pn)
    idx = find(strcmp({images.pn}, pn(n)));
    for m = 1:numel(idx)
        [captured, ~] = regexp(images(idx(m)).folder, expression, 'tokens','match');
        fprintf('%s is in scan folder %s \n', cell2mat(pn(n)), cell2mat(captured{1}));
    end
end

%% Plotting localizers
idx = find(strcmp({images.pn}, pn(1)));

for n = 1:numel(idx)
    figure(n)
    [~,~,z] = size(images(idx(n)).img);
    m = ceil(sqrt(z));
    p = round(sqrt(z));
    for q = 1:z
        subplot(m,p,q)
        imagesc(images(idx(n)).img(:,:,q))
        axis image
        colormap(gray)
    end
end

%% Plotting multislice localizers
idx = find(strcmp({images.pn}, pn(2)));

for n = 1:numel(idx)
    figure(100+n)
    [~,~,z] = size(images(idx(n)).img);
    m = ceil(sqrt(z));
    p = round(sqrt(z));
    for q = 1:z
        subplot(m,p,q)
        imagesc(images(idx(n)).img(:,:,q))
        axis image
        colormap(gray)
    end
end

%% Plotting T2 Maps
idx = find(strcmp({images.pn}, pn(3)));
% if you want to plot other t2 maps, change to pn(4) or pn(5). See 'pn'
% variable above.

for n = 1:numel(idx)
    figure(n*10+n)
    [~,~,z] = size(images(idx(n)).img);
    m = ceil(sqrt(z));
    p = round(sqrt(z));
    for q = 1:z
        subplot(m,p,q)
        imagesc(images(idx(n)).img(:,:,q))
        axis image
        colormap(gray)
    end
    
    echo_flag = 1    % for images with t echoes
    t = 2;           % number of echoes
    
    if echo_flag
        m = ceil(sqrt(z/t));
        p = round(sqrt(z/t));
        for q = 1:t
            figure(n*10+n+q);
            s = 1;          % subplot counter
            for r = q:t:z   % q is current echo; t is to skip to every t image
                subplot(m,p,s)
                s = s+1;
                imagesc(images(idx(n)).img(:,:,q))
                axis image
                colormap(gray)
            end
        end
        
    end
end