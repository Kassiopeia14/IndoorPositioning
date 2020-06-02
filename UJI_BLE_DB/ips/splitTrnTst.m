% SPLITTRNTST Divides the rss measurements data into a training set and a
% test set accoding to a specific configuration.
%
%	[TRNDATA,TSTDATA] = SPLITTRNTST(DATA, CONFIGURATION) splits DATA into
%	TRNDATA and TSTDATA, according to CONFIGURATION.
%
%   See Also GETFILTERDEFS.
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

function [trnData,tstData] = splitTrnTst(data, configuration)
    [trnCampaign, tstCampaign, trnInds, tstInds] = getTrnTstSets(configuration);

    trnData = applyFilter(data, getFilterForCampaign(data.ids,trnCampaign));
    tstData = applyFilter(data, getFilterForCampaign(data.ids,tstCampaign));

    trnPoints = getFilterForPoints(trnData.ids, trnInds);
    tstPoints = getFilterForPoints(tstData.ids, tstInds);

    trnData = applyFilter(trnData, trnPoints);
    tstData = applyFilter(tstData, tstPoints);
end

% Geo configuration: 1 -> fullLimits, 2 -> reducedLimits, 3 -> triangles
% Lib configuration: 4 -> fullLimits, 5 -> reducedLimits

function [trnCampaign, tstCampaign, trnInds, tstInds] = getTrnTstSets(configuration)
    fDefs = getFilterDefs();

    geoPoints = (1:68);
    libC1 = (1:48);
    libC4 = (1:68);

    % Constants
    geoFullLimits = [1,2,3,4,5,9,10,14,15,19,20,24,25,29,30,31,32,33,34,35,36,37,38,39,40,44,45,49,50,54,55,59,60,64,65,66,67,68];
    geoAllHorizInnerMiddle = [7,12,17,22,27,42,47,52,57,62];
    geoReducHorizInnerMiddle = [12,22,47,57];
    geoPointsLimRemove = [2,3,10,14,20,24,25,29,31,33,36,38,40,44,45,49,55,59,66,67];
    geoTriangles = [1,3,5,7,9,11,11,13,15,17,19,21,23,25,27,29,31,33,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68];

    bibReducTrnRemove = [[2,8,14,20],[29,35,41,47]]; 
    bibNoOuterTstRemove = [1,17,18,34,35,51,52,68];

    trnInds = []; tstInds = [];

    
    if (configuration == fDefs.geo.mlSets.fullLimits)
        trnCampaign = fDefs.geo.campaigns.c1;
        tstCampaign = fDefs.geo.campaigns.c1;
        trnInds = sort([geoFullLimits,geoAllHorizInnerMiddle]);
        tstInds = geoPoints; tstInds(trnInds)=[];
    elseif (configuration == fDefs.geo.mlSets.reducedLimits)
        trnCampaign = fDefs.geo.campaigns.c1;
        tstCampaign = fDefs.geo.campaigns.c1;
        trnInds = sort(setdiff([geoFullLimits,geoReducHorizInnerMiddle],geoPointsLimRemove));
        tstInds = geoPoints; tstInds(trnInds)=[];
    elseif (configuration == fDefs.geo.mlSets.triangles)
        trnCampaign = fDefs.geo.campaigns.c1;
        tstCampaign = fDefs.geo.campaigns.c1;
        trnInds = sort(geoTriangles);
        tstInds = geoPoints; tstInds(trnInds)=[];
    elseif (configuration == fDefs.lib.mlSets.fullTrnTst)
        trnCampaign = fDefs.lib.campaigns.c1;
        tstCampaign = fDefs.lib.campaigns.c4;
        trnInds = libC1;
        tstInds = libC4;
    elseif (configuration == fDefs.lib.mlSets.reducedTrnFullTst)
        trnCampaign = fDefs.lib.campaigns.c1;
        tstCampaign = fDefs.lib.campaigns.c4;
        trnInds = libC1; trnInds(bibReducTrnRemove) = [];
        tstInds = libC4;
    elseif (configuration == fDefs.lib.mlSets.fullTrnNoOutTst)
        trnCampaign = fDefs.lib.campaigns.c1;
        tstCampaign = fDefs.lib.campaigns.c4;
        trnInds = libC1;
        tstInds = libC4; tstInds(bibNoOuterTstRemove) = [];
    elseif (configuration == fDefs.lib.mlSets.reducedTrnNoOutTst)
        trnCampaign = fDefs.lib.campaigns.c1;
        tstCampaign = fDefs.lib.campaigns.c4;
        trnInds = libC1; trnInds(bibReducTrnRemove) = [];
        tstInds = libC4; tstInds(bibNoOuterTstRemove) = [];
    end
end