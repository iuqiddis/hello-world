function [proton] = proton_display2(proton_image_path, nslice, imtype, ax_limit, updown, save_file)
%  PROTON_DISPLAY    Loads a montage of the MRI images
%
% function [proton] = proton_display2(proton_image_path, nslice, imtype)
% 
% or optional forms:
%
% function [proton] = proton_display2(proton_image_path, nslice, imtype, ax_limit or updown)
%
% function [proton] = proton_display2(proton_image_path, nslice, imtype, ax_limit, updown)
% 
% function [proton] = proton_display2(proton_image_path, nslice, imtype, ax_limit, updown, save_file)
% 
% proton_image_path: directory path with / at the end of the name. Can be
%       fdf or dicom files.
% nslice : slice number used to select overlay slice
% imtype : options are either 'dicom' or 'fdf'
% 
% optional paramters:
%
% ax_limit : [min max] as a percentage of highest intensity pixel in image.
%       defaults to [0.01 0.4]
% updown : use 1 for flipping the image vertically; 0 or nothing otherwise.
% save_file: by default its 1 (saves montage to file). otherwise specify 0
%       to not save it

if nargin == 4
    if length(ax_limit) == 1
        updown = ax_limit;
        clear ax_limit;
    end
end

if exist('ax_limit', 'var')
    c0 = ax_limit(1);
    c1 = ax_limit(2);
else
    c0 = 0.01;
    c1 = 0.4;
end

if ~exist('updown', 'var')
    updown = 0;
end

if ~exist('save_file', 'var')
    save_file = 1;
end

jj = 0;
file_h = dir(proton_image_path);
for ii = 1:numel(file_h)
    if ~isempty(strfind(file_h(ii).name,'slice'))
        jj = jj + 1;  % if the file name included 'slice'
        %         disp(file_h(ii).name)
        path1 = [proton_image_path file_h(ii).name];
        if strcmp('fdf', imtype)
            h(:,:,jj) = fdf2(path1);
        elseif strcmp('dicom', imtype)
            h(:,:,jj) = dicomread(path1);
        end
    end
end

figure(123);

if updown
    montage(flipud(h));
else
    montage(h);
end

mh = max(h(:));
caxis([c0*mh c1*mh]);

proton = h(:,:,nslice);

if save_file
save_figure('proton_images',proton_image_path,0,1,0);
end

end