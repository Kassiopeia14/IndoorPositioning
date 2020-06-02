% Variation of positioning accuracy when several beacons stop functioning.
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

% -----------------------------------------

rng('default'); % Reproducibility
nReps = 4*10^2;
minNout = 1;
maxNout = 6;

libFPAllErrors = zeros(nReps,1);
libWCAllErrors = zeros(nReps,1);
geoFPAllErrors = zeros(nReps,1);
geoWCAllErrors = zeros(nReps,1);

summaryType = fDefs.buffering.summary.mean;
wSize = fDefs.buffering.window.s2;

% ----------------   Zone Library ------------------------- %

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data = rssBuffering(data, wSize, summaryType);

trnTstType = fDefs.lib.mlSets.fullTrnNoOutTst;
[trnData,tstData] = splitTrnTst(data, trnTstType);

nBeacons = fDefs.lib.nBeacons;

% Fingerprinting knn

defKvalue = 32;
for i = (1:nReps)
    beacons = getNout(nBeacons, minNout, maxNout);
    [selTrnData,selBcCoords] = applyDepSelection(trnData, bcCoords, beacons);
    [selTstData,~] = applyDepSelection(tstData, bcCoords, beacons);
    
    [prediction, ks] = kNNEstimation(selTrnData.rss, selTstData.rss, selTrnData.coords, defKvalue);
    errors = customError(prediction, selTstData.coords);
    libFPAllErrors(i) = getMetric(errors);
end

% Weighted Centroid

defKvalue = 10;
for i = (1:nReps)
    beacons = getNout(nBeacons, minNout, maxNout);
    [selTrnData,selBcCoords] = applyDepSelection(trnData, bcCoords, beacons);
    [selTstData,~] = applyDepSelection(tstData, bcCoords, beacons);
    
    [prediction,ks] = wCEstimation(selBcCoords, selTstData.rss, defKvalue);
    errors = customError(prediction, tstData.coords);
    libWCAllErrors(i) = getMetric(errors);
end

fprintf('\n Zone %s done \n', fDefs.zones.names.lib);

% ----------------   Zone Geotec ------------------------- %

zone = fDefs.zones.geo;
powerLevel = fDefs.geo.powers.p12;
phone = fDefs.geo.phones.a5;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data = rssBuffering(data, wSize, summaryType);

trnTstType = fDefs.geo.mlSets.fullLimits;
[trnData,tstData] = splitTrnTst(data, trnTstType);

nBeacons = fDefs.geo.nBeacons;

% Fingerprinting knn

defKvalue = 72;

for i = (1:nReps)
    beacons = getNout(nBeacons, minNout, maxNout);
    [selTrnData,selBcCoords] = applyDepSelection(trnData, bcCoords, beacons);
    [selTstData,~] = applyDepSelection(tstData, bcCoords, beacons);
    
    [prediction, ks] = kNNEstimation(selTrnData.rss, selTstData.rss, selTrnData.coords, defKvalue);
    errors = customError(prediction, selTstData.coords);
    geoFPAllErrors(i) = getMetric(errors);
end

% Weighted Centroid

defKvalue = 10;
for i = (1:nReps)
    beacons = getNout(nBeacons, minNout, maxNout);
    [selTrnData,selBcCoords] = applyDepSelection(trnData, bcCoords, beacons);
    [selTstData,~] = applyDepSelection(tstData, bcCoords, beacons);
    
    [prediction,ks] = wCEstimation(selBcCoords, selTstData.rss, defKvalue);
    errors = customError(prediction, tstData.coords);
    geoWCAllErrors(i) = getMetric(errors);
end

fprintf('\n Zone %s done \n', fDefs.zones.names.geo);

allE = [libFPAllErrors;libWCAllErrors;geoFPAllErrors;geoWCAllErrors];
allG = [ones(nReps,1)*1;ones(nReps,1)*2;ones(nReps,1)*3;ones(nReps,1)*4];
figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
boxplot(allE,allG,'Labels',{'libFP','libWC','geoFP','geoWC'});
ylabel('Error (m)');

function [beacons] = getNout(nBeacons, minN, maxN)
    n = minN + randi(maxN - minN + 1, 1) - 1;
    beacons = sort(randperm(nBeacons,nBeacons-n));
end

function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end