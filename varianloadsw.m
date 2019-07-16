function sw = varianloadsw(filepath)

% Written by Sarmad Siddiqui, 10/27/2015. Remove the '.fid' from the path
% before entering pathname.

st = filesep; % slash type
%procpar = strcat(filepath,'.fid', st,'procpar'); %delete it after test
procpar = strcat(filepath, st,'procpar');
param = fileread(procpar);
expression1 = 'sw\s.{1,50}?\n';

% I based the regex snippet from some stackoverflow question (lost the URL).
% 'sw' is literally the characters 's' 'w'. '\s' is space '.' is any
% character and {1,50} denotes upto 50 characters. I don't know what the
% question mark is. the '\n' is a new line character

[~, endindex] = regexp(param, expression1);
param2 = param(endindex+1:endindex+31);

% I'm interested in the line after the query. +31 should normally be larger
% than that line.

expression2 = '\d\s.{1,30}?\n';

% wrote this myself based on the previous 2. Added the '\d' to restrict the
% first character to a number, followed by '\s' for space and then '.' for any
% character. If I'm being cavalier, I should make that restricted to
% digits. I terminate at \n. Again, no idea what '?' is for.

[startindex, endindex] =  regexp(param2, expression2);
sw_line = param2(startindex:endindex);
sw_line = str2num(sw_line);
sw = sw_line(2);

if sw < 100
    error('Bandwidth seems too low. Double check this value');
end

if sw > 1e6
    error('Bandwidth seems too high. Double check this value');
end
