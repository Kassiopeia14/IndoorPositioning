% DEPLOYMENTSELECTION Leave references in rss data and beacons positions
% only to those beacons belonging to a specific configuration.
%
%	[SELDATA,SELBCCOORDS,BCNUMBERS] = DEPLOYMENTSELECTION(DATA, BCCOORDS,
%	CONFIGURATION) leaves in DATA and BCCOORDS only references to beacons
%	that belong to CONFIGURATION
%
%   See Also APPLYDEPSELECTION.
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

function [selData,selBcCoords,bcNumbers] = deploymentSelection(data, bcCoords, configuration)
    defs = getFilterDefs();

    geoAllLimits = [1,2,4,5,7,10,12,15,17,20,21,22];
    geoAllInner = [3,6,8,9,11,13,14,16,18,19];

    geoRedLimits = [1,2,7,10,12,20,22]; % No middle line points
    geoOnlyCenterInner = [6,11,16];
    
    geoTiny = [1,2,7,11,20,22];
    
    geoNoMiddleVert = [1,2,5,6,7,10,11,12,15,16,17,20,21,22];
    
    %[23,24,25,26,30,31,34,35,39,40,44,45,46]
    libAllLimits = [1,2,3,4,8,9,12,13,17,18,22,23,24];
    libLimitsNoSides = [8,9,12,13,17,18];
    libAllInner = [5,6,7,10,11,14,15,16,19,20,21];
    
    libRedLimits = [1,4,12,13,22,24];
    libOnlyCenterInner = [7,14,19];
    

    if (configuration == defs.geo.deploys.full)
        bcNumbers = sort([geoAllLimits,geoAllInner]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.geo.deploys.reduced)
        bcNumbers = sort([geoRedLimits,geoOnlyCenterInner]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.geo.deploys.noBoundaries)
        bcNumbers = sort(geoAllInner);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.geo.deploys.noMiddVertical)
        bcNumbers = sort(geoNoMiddleVert);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.geo.deploys.boundariesAndCenter)
         bcNumbers = sort([geoAllLimits,11]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.geo.deploys.tiny)
         bcNumbers = sort(geoTiny);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.lib.deploys.full)
        bcNumbers = sort([libAllLimits,libAllInner]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.lib.deploys.reduced)
        bcNumbers = sort([libRedLimits,libOnlyCenterInner]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.lib.deploys.noBoundaries)
        bcNumbers = sort(libAllInner);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.lib.deploys.noMiddHoriz)
        bcNumbers = sort([libAllLimits,libOnlyCenterInner]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
        
    elseif (configuration == defs.lib.deploys.noLimitsSide)
        bcNumbers = sort([libLimitsNoSides,libOnlyCenterInner]);
        [selData,selBcCoords] = applyDepSelection(data, bcCoords, bcNumbers);
    end
end