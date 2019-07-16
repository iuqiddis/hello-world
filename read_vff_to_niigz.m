function img_out = read_vff_to_niigz(base_path, spacing)

% READ_VFF_TO_NIIGZ(base_path) Input is directory name containing vff 
% file(s), or a single vff file. 
%
% READ_VFF_TO_NIIGZ(base_path, [x y z]) The second input is a vector  with
% the voxel size. If the voxel size is not [0.1996 0.1996 0.1996] mm^3, the
% size can be entered as a vector with the correct dimensions.
%
% 2016-11-18: function made from a script file that Yi Xin made to convert
% vff to nii.gz files -sms 
%
% 2017-07-18: Modified it to accept single vff files, and custom voxel
% sizes.

if nargin ==1
    spacing = [0.1996 0.1996 0.1996]; %200um images; adjust accordingly
end

display(sprintf('\n The spacing used is %.4f x %.4f x %.4f mm^3', spacing))

FS = filesep;

if base_path(end-3:end) == '.vff'
    Pname = base_path;
    last_slash = strfind(base_path, '/');
    base_path = base_path(1:last_slash(end)-1);
else
    Pname = strcat(base_path, FS, '*.vff');
end

Pfiles = dir(Pname);
PnumFiles = length(Pfiles);

old_dir = pwd;
cd(base_path);

for j = 1:PnumFiles
    
    display(sprintf('\n Current image is %s', Pfiles(j).name))
    
    tic
    dname = [base_path,FS,Pfiles(j).name];
    
    Image = vff3D_function(dname,0);
    
    nii = make_nii(Image, spacing);
    fileName = [Pfiles(j).name(1:end-4) '.nii'];
    
    save_nii(nii, fileName);
    gzip(fileName);
    
    delete *.nii;
    
    t1 = toc;
    display(sprintf('\n %s took %1.2f seconds', Pfiles(j).name ,t1))
    
end

cd(old_dir);

end