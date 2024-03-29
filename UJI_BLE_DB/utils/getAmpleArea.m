% GETAMPLEAREA Get the bounding box of all positions.
%
%	[XMIN,XMAX,YMIN,YMAX] = GETAMPLEAREA(DATA,BCCOORDS,POLYGONS,BYD)
%	returns the bounding box that include all positions from DATA (rss
%	measurements) BCCOORDS (beacons) and POLYGONS (obstacles), buffered out
%	by BYD units.
%
%   See Also PLOTTHEMALL.
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

function [xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,polygons,byD)
    allData = [data.coords;bcCoords;cat(1,polygons{:,1})];
    xMin = min(allData(:,1))-byD;
    xMax = max(allData(:,1))+byD;
    yMin = min(allData(:,2))-byD;
    yMax = max(allData(:,2))+byD;
end