% GETDIRCONTENT List files or directories that a folder contains.
%
%	[LIST] = GETDIRCONTENT(DIRPATH, DIRORFILE) Get listing from folder
%	DIRPATH. Set DIRORFILEto 1 to get name of directories or to 0 to get
%	name of files.
%
%   See Also LOADZONE.
%
%   Copyright � 2018 Universitat Jaume I (UJI)

% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

function [list] = getDirContent(dirPath, dirOrFile)

    oldFolder = cd(dirPath);
    listing = dir('.');
    cd(oldFolder);
    list = {listing.name};
    if (dirOrFile == 1) % dir
        list(~[listing.isdir])=[];
        list(startsWith(list,'.') | startsWith(list,'..')) = [];
    else
        list([listing.isdir])=[];
    end
end