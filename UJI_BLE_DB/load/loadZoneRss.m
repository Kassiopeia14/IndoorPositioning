% LOADZONERSS Loads the RSS measurements information data.
%
%	[DATA] = LOADZONERSS(ZONE, DATAFOLDER) return all RSS measurements
%	information data corresponding to ZONE in the struct DATA. The
%	information is loaded from folder DATAFOLDER.
%
%   See Also GETFILTERDEFS, LOADZONE, LOADZONEDEP and LOADZONEOBS.
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

function [data] = loadZoneRss(zone, dataFolder)
    nDefs = getFileNameDefs();
    fDefs = getFilterDefs();
    
    zoneName = nDefs.lib;
    if(zone == fDefs.zones.geo)
        zoneName = nDefs.geo;
    end
    pName = [dataFolder,'/',nDefs.frss,'/',zoneName,'_'];
    
    data = struct;
    data.rss = csvread([pName,nDefs.rss,'.csv']);
    data.coords = csvread([pName,nDefs.coords,'.csv']);
    data.time = csvread([pName,nDefs.time,'.csv']);
    data.ids = csvread([pName,nDefs.ids,'.csv']);
end

