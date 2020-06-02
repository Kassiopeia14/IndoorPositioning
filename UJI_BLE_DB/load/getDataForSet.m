% GETDATAFORSET Loads all information of a zone, applying specific phone
% and power filters for the RSS measurements information.
%
%	[DATA,BCCOORDS,OBSTPOLYS] = GETDATAFORSET(DATAFOLDER, ZONE, POWER,
%	PHONE, NONVALUETONAN) returns the rss measurments information DATA, the
%	beacons positions BCCOORDS and the obstacles in the collection area
%	OBSTPOLYS of ZONE. The DATA is filtered so that only measurement
%	information corresponding to specific POWER and PHONE are
%	returned. Set NONVALUETONAN to true to replace the non-detection values
%	of RSS by NAN values. The information is loaded from folder DATAFOLDER.
%	
%   See Also GETFILTERDEFS and LOADZONE.
%
%   Copyright © 2018 Universitat Jaume I (UJI)

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

function [data,bcCoords,obstPolys] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan)
    [allData,bcCoords,obstPolys] = loadZone(zone, dataFolder);

    selectedPower = getFilterForPower(allData.ids,power);
    selectedPhone = getFilterForPhone(allData.ids,phone);

    data = applyFilter(allData,selectedPower&selectedPhone);

    if (nonValueToNan)
        data.rss(data.rss == 100) = nan;
    end
end
