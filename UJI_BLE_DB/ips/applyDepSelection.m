% APPLYDEPSELECTION Remove references to beacons not found in a selection.
%
%	[SELDATA,SELBCCOORDS] = APPLYDEPSELECTION(DATA, BCCOORDS, BEACONS)
%	Removes the columns from rss measurements and times in DATA and the
%	rows in BCCOORDS that are not found in BEACONS.
%
%   See Also DEPLOYMENTSELECTION.
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

function [selData,selBcCoords] = applyDepSelection(data, bcCoords, beacons)
    selData = struct;
    selData.rss = data.rss(:,beacons);
    selData.coords = data.coords;
    selData.time = data.time(:,beacons);
    selData.ids = data.ids;
    
    selBcCoords = bcCoords(beacons,:);
end