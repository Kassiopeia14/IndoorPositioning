% General description of each collection zone.
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

% Preamble and common parameters
% -----------------------------------------
clear;
close all;
clc;
addpath('data','load','utils','ips');

dataFolder = 'data';
fDefs = getFilterDefs();

nonValueToNan = true;
transfTime = false;

% -----------------------------------------

nBeacons = zeros(1,2);
nSamples = zeros(1,2);
nCampaigns = zeros(1,2);
nPhones = zeros(1,2);
nPowers = zeros(1,2);
totalArea = zeros(1,2);
obstArea = zeros(1,2);
samplesArea = zeros(1,2);
beaconsArea = zeros(1,2);
distSamples = zeros(1,2);
distBeacons = zeros(1,2);

% ----------------- Library ------------------------ %

zone = fDefs.zones.lib;

[data,bcCoords,obstPolys] = loadZone(zone, dataFolder);

plotThemAll(data, bcCoords, obstPolys,fDefs.zones.names.lib);

[xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,obstPolys,0);
totalArea(zone) = (xMax-xMin)*(yMax-yMin);
obstArea(zone) = getPolysArea(obstPolys);

nBeacons(zone) = fDefs.lib.nBeacons;
nSamples(zone) = size(data.rss,1);
nCampaigns(zone) = fDefs.lib.campaignsAmount;
nPhones(zone) = fDefs.lib.phonesAmount;
nPowers(zone) = fDefs.lib.powersAmount;
samplesArea(zone) = getArea(data.coords);
beaconsArea(zone) = getArea(bcCoords);
distSamples(zone) = getMaxMinDistance(data.coords);
distBeacons(zone) = getMaxMinDistance(bcCoords);

% ----------------- Geotec ------------------------ %

zone = fDefs.zones.geo;

[data,bcCoords,obstPolys] = loadZone(zone, dataFolder);

plotThemAll(data, bcCoords, obstPolys, fDefs.zones.names.geo);

[xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,obstPolys,0);
totalArea(zone) = (xMax-xMin)*(yMax-yMin);
obstArea(zone) = getPolysArea(obstPolys);

nBeacons(zone) = fDefs.geo.nBeacons;
nSamples(zone) = size(data.rss,1);
nCampaigns(zone) = fDefs.geo.campaignsAmount;
nPhones(zone) = fDefs.geo.phonesAmount;
nPowers(zone) = fDefs.geo.powersAmount;
samplesArea(zone) = getArea(data.coords);
beaconsArea(zone) = getArea(bcCoords);
distSamples(zone) = getMaxMinDistance(data.coords);
distBeacons(zone) = getMaxMinDistance(bcCoords);

% ----------------- Table ------------------------ %

varNames = cell(1,2);
varNames{fDefs.zones.lib} = fDefs.zones.names.lib;
varNames{fDefs.zones.geo} = fDefs.zones.names.geo;
rowNames = {'nBeacons','nSamples','nCampaigns','nPhones','nPowers',...
    'totalArea','obstArea','samplesArea','beaconsArea','distSamples','distBeacons'};
allData = [nBeacons;nSamples;nCampaigns;nPhones;nPowers;totalArea;...
    obstArea;samplesArea;beaconsArea;distSamples;distBeacons];
T = table(allData(:,fDefs.zones.lib),allData(:,fDefs.zones.geo),...
    'VariableNames',varNames, 'RowNames',rowNames);

disp(T);

% Maximum distance to the closest neighbour
function [dist] = getMaxMinDistance(coords)
    D = squareform(pdist(unique(coords,'rows')));
    D(D==0) = inf;
    dist = max(min(D));
end

function [allArea] = getPolysArea(polygons)
    allArea = 0;
    for i = (1:size(polygons,1))
        polygon = polygons{i,1};
        allArea = allArea + polyarea(polygon(:,1),polygon(:,2));
    end
end

function [a] = getArea(coords)
    inds = convhull(coords(:,1),coords(:,2));
    a = polyarea(coords(inds,1),coords(inds,2));
end
