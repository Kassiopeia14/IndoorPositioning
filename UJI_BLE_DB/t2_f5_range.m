% Beacon detection range analyses.
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
addpath('data','load','utils','ips');

dataFolder = 'data';
fDefs = getFilterDefs();

nonValueToNan = true;

barWidth = 0.25;
beaconNumber = 1;

% Zone Lib
zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;

[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[M, S, pos] = getMeanAndStd(data.rss(:,beaconNumber), data.coords);
drawRssBars(pos(:,1), pos(:,2), barWidth, M, S, sprintf('%s beacon %d',fDefs.zones.names.lib,beaconNumber));

% Zone Geo
zone = fDefs.zones.geo;
powerLevel = fDefs.geo.powers.p12;
phone = fDefs.geo.phones.a5;

[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[M, S, pos] = getMeanAndStd(data.rss(:,beaconNumber), data.coords);
drawRssBars(pos(:,1), pos(:,2), barWidth, M, S, sprintf('%s beacon %d',fDefs.zones.names.geo,beaconNumber));


% ===============================================================

cutOffSeen = 1/2;
cutOffPow = -70;

% libS6Data = zeros(3,1);
% libA5Data = zeros(3,1);
% geoA5Data = zeros(3,1);

% Zone library, power 12

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;

fprintf('\n<strong>Zone %s: Phone Comparison</strong>\n',fDefs.zones.names.lib);

% phone A5
phone = fDefs.lib.phones.a5;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[pos,seenData,maxPData] = getDistAndMaps(data, bcCoords, cutOffSeen, cutOffPow);
maxRss =  max(data.rss(:),[],'omitnan');

fprintf('\n<strong>Phone %s</strong>\n',fDefs.phones.names.a5);
fprintf('Max distance for beacon spotted over %.2f times: %.2f m\n', cutOffSeen, seenData.maxD);
fprintf('Max distance for beacon with power over %d dBm: %.2f m\n', cutOffPow, maxPData.maxD);
fprintf('Max RSS %.1f\n', maxRss);

% figure;scatter(pos(:,1),pos(:,2),120,seenData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;
% figure;scatter(pos(:,1),pos(:,2),120,maxPData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;

% phone S6
phone = fDefs.lib.phones.s6;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[pos,seenData,maxPData] = getDistAndMaps(data, bcCoords, cutOffSeen, cutOffPow);
maxRss =  max(data.rss(:),[],'omitnan');

fprintf('\n<strong>Phone %s</strong>\n',fDefs.phones.names.s6);
fprintf('Max distance for beacon spotted over %.2f times: %.2f m\n', cutOffSeen, seenData.maxD);
fprintf('Max distance for beacon with power over %d dBm: %.2f m\n', cutOffPow, maxPData.maxD);
fprintf('Max RSS %.1f\n', maxRss);

libS6Data = [seenData.maxD;maxPData.maxD;maxRss];

% figure;scatter(pos(:,1),pos(:,2),120,seenData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;
% figure;scatter(pos(:,1),pos(:,2),120,maxPData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;

fprintf('\n<strong>Phone %s, Power %s: Zone Comparison</strong>\n',fDefs.phones.names.a5...
    ,fDefs.powers.names.p12);

% zone library
zone = fDefs.zones.lib;
phone = fDefs.lib.phones.a5;
powerLevel = fDefs.lib.powers.p12;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[pos,seenData,maxPData] = getDistAndMaps(data, bcCoords, cutOffSeen, cutOffPow);
maxRss =  max(data.rss(:),[],'omitnan');

fprintf('\n<strong>Zone %s</strong>\n',fDefs.zones.names.lib);
fprintf('Max distance for beacon spotted over %.2f times: %.2f m\n', cutOffSeen, seenData.maxD);
fprintf('Max distance for beacon with power over %d dBm: %.2f m\n', cutOffPow, maxPData.maxD);
fprintf('Max RSS %.1f\n', maxRss);

libA5Data = [seenData.maxD;maxPData.maxD;maxRss];

% figure;scatter(pos(:,1),pos(:,2),120,seenData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;
% figure;scatter(pos(:,1),pos(:,2),120,maxPData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;


% zone geotec
zone = fDefs.zones.geo;
phone = fDefs.geo.phones.a5;
powerLevel = fDefs.geo.powers.p12;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[pos,seenData,maxPData] = getDistAndMaps(data, bcCoords, cutOffSeen, cutOffPow);
maxRss =  max(data.rss(:),[],'omitnan');

fprintf('\n<strong>Zone %s</strong>\n',fDefs.zones.names.geo);
fprintf('Max distance for beacon spotted over %.2f times: %.2f m\n', cutOffSeen, seenData.maxD);
fprintf('Max distance for beacon with power over %d dBm: %.2f m\n', cutOffPow, maxPData.maxD);
fprintf('Max RSS %.1f\n', maxRss);

geoA5Data = [seenData.maxD;maxPData.maxD;maxRss];

% figure;scatter(pos(:,1),pos(:,2),120,seenData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;
% figure;scatter(pos(:,1),pos(:,2),120,maxPData.map,'filled');colormap(jet);caxis([0,size(bcCoords,1)]);colorbar;axis image;

% ----------------- Table ------------------------ %

varNames = {...
    [fDefs.zones.names.lib,'_',fDefs.phones.names.s6],...
    [fDefs.zones.names.lib,'_',fDefs.phones.names.a5],...
    [fDefs.zones.names.geo,'_',fDefs.phones.names.a5],...
};

rowNames = {...
    sprintf('Max dist. beacon spotted over %.2f times\n', cutOffSeen),...
    sprintf('Max dist. beacon power over %.2f dBm\n', cutOffPow),...
    'Max RSS'...
};
T = table(libS6Data,libA5Data,geoA5Data,...
    'VariableNames',varNames, 'RowNames',rowNames);

disp(T);



% -----------------------------------------

function [pos,seenData,maxPData] = getDistAndMaps(data, bcCoords, cutOffSeen, cutOffPow)
    nbeacons = size(data.rss, 2);

    [pos,~,~] = unique(data.coords, 'rows');
    seen = false(size(pos,1),nbeacons);
    maxP = false(size(pos,1),nbeacons);
    distSeen = zeros(size(pos,1),nbeacons);
    distMaxP = zeros(size(pos,1),nbeacons);
    
    singleValuesNan = false;
    for beaconNumber =(1:nbeacons)
        [M, ~, ~, A] = getMaxAndSeen(data.rss(:,beaconNumber), data.coords, singleValuesNan);
        seen(:,beaconNumber) = A >= cutOffSeen;
        distSeen(:,beaconNumber) = sqrt(sum((pos-bcCoords(beaconNumber,:)).^2,2));
        distSeen(~seen(:,beaconNumber),beaconNumber) = 0;
        
        maxP(:,beaconNumber) = M >= cutOffPow;
        distMaxP(:,beaconNumber) = sqrt(sum((pos-bcCoords(beaconNumber,:)).^2,2));
        distMaxP(~maxP(:,beaconNumber),beaconNumber) = 0;
    end
    mapAmountSeen = sum(seen,2);
    mapAmountMaxP = sum(maxP,2);
    meanDseen = mean(distSeen(:));
    meanDMaxP = mean(distMaxP(:));
    
    seenData = struct('map',mapAmountSeen,'maxD',meanDseen);
    maxPData = struct('map',mapAmountMaxP,'maxD',meanDMaxP);
end
