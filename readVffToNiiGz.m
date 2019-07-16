clear all
% close all
clc

FS = filesep;
% / for linux
% \ for windows

%Change Rat# for BOTH
%ratlist = [65 66 68 70 71];
%for ratnum = 1:size(ratlist,2)
    
    %sprintf('Current rat: %.f',ratlist(ratnum))
    
    %base_path=['/home/sarmadsiddiqui/sarmad/data/lung_cancer/rat202/20160412_rat202_CT',num2str(ratlist(ratnum))];
    base_path='/home/sarmadsiddiqui/Downloads/syncing/Dropbox/work/ys_share/';
   
    %RatNum = ['Rat',num2str(ratlist(ratnum))];
    %RatNum = 'rat3';
    %%
    %addpath NIFTI;
    
    %Pname= [base_path,FS];
    %Pname = strcat(Pname,'*_m.vff');
    Pname = strcat(Pname, FS, '*.vff');
    Pfiles = dir(Pname);
    PnumFiles = length(Pfiles);
    
    for j = 1:PnumFiles
        
        sprintf('Current image is %s', Pfiles(j).name)
        tic
        dname = [base_path,FS,Pfiles(j).name];
        
        %clear Image;
        Image = vff3D_function(dname,0);
        
        spacing = [0.1996 0.1996 0.1996]; %200um images; adjust accordingly
        
        %clear nii;
        nii = make_nii(Image, spacing);
        fileName = [Pfiles(j).name(1:end-4) '.nii'];
        
        save_nii(nii, fileName);
        %gzip(fileName, [RatNum]);
        gzip(fileName);
        
        delete *.nii;
        
        t1 = toc;
        sprintf('%s took %1.2f seconds', Pfiles(j).name ,t1)
        
        %clear Image
        
        %figure,imagesc(Image(:,:,300))
        
    end
    
%end
