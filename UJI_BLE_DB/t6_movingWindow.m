% Moving windows size effect positioing accuracy.
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
% clc;
addpath('data','load','utils','ips');

dataFolder = 'data';
fDefs = getFilterDefs();

nonValueToNan = true;

% ==============================================
% LIBRARY

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;
trnTstType = fDefs.lib.mlSets.fullTrnNoOutTst;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

% ---------------------
% Mean

summaryType = fDefs.buffering.summary.mean;

defKvalue = 32;% FP
libFPAccuMean = estAccKnnBuff(data, trnTstType, defKvalue, summaryType);

defKvalue = 10;% WC
libWCAccuMean = estAccWCBuff(data, trnTstType, defKvalue, summaryType, bcCoords);

% ---------------------
% Last

summaryType = fDefs.buffering.summary.last;

defKvalue = 32;% FP
libFPAccuLast = estAccKnnBuff(data, trnTstType, defKvalue, summaryType);

defKvalue = 10;% WC
libWCAccuLast = estAccWCBuff(data, trnTstType, defKvalue, summaryType, bcCoords);

% ==============================================
% GEOTEC

zone = fDefs.zones.geo;
powerLevel = fDefs.geo.powers.p12;
phone = fDefs.geo.phones.a5;
trnTstType = fDefs.geo.mlSets.fullLimits;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

% ---------------------
% Mean

summaryType = fDefs.buffering.summary.mean;

defKvalue = 72;% FP
geoFPAccuMean = estAccKnnBuff(data, trnTstType, defKvalue, summaryType);

defKvalue = 10;% WC
geoWCAccuMean = estAccWCBuff(data, trnTstType, defKvalue, summaryType, bcCoords);

% ---------------------
% Last

summaryType = fDefs.buffering.summary.last;

defKvalue = 72;% FP
geoFPAccuLast = estAccKnnBuff(data, trnTstType, defKvalue, summaryType);

defKvalue = 10;% WC
geoWCAccuLast = estAccWCBuff(data, trnTstType, defKvalue, summaryType, bcCoords);

% ==============================================

rowNames = {'None'}; 
for i = fDefs.buffering.window.allSizes
    rowNames = [rowNames;sprintf('%d',i)]; 
end
varNames = ['libFPAccuMean,','libWCAccuMean,','geoFPAccuMean,','geoWCAccuMean,',...
     'libFPAccuLast,','libWCAccuLast,','geoFPAccuLast,','geoWCAccuLast'];
 
fprintf('\n%s\n',varNames);
for i = (1:numel(fDefs.buffering.window.allSizes)+1)
    fprintf('%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',rowNames{i},...
        libFPAccuMean(i),libWCAccuMean(i),geoFPAccuMean(i),geoWCAccuMean(i),...
        libFPAccuLast(i),libWCAccuLast(i),geoFPAccuLast(i),geoWCAccuLast(i));
end

function [estAcc] = estAccKnnBuff(data, trnTstType, k, summaryType)
    fDefs = getFilterDefs();
    
    estAcc = zeros(1+numel(fDefs.buffering.window.allSizes),1);
    
    [trnData,tstData] = splitTrnTst(data, trnTstType);
    [prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, k);
    errors = customError(prediction, tstData.coords);
    estAcc(1) = getMetric(errors);

    for i = fDefs.buffering.window.allSizes
        bufData = rssBuffering(data, i, summaryType);

        [trnData,tstData] = splitTrnTst(bufData, trnTstType);
        [prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, k);
        errors = customError(prediction, tstData.coords);
        estAcc(i) = getMetric(errors);
    end
end

function [estAcc] = estAccWCBuff(data, trnTstType, k, summaryType, bcCoords)
    fDefs = getFilterDefs();
    
    estAcc = zeros(1+numel(fDefs.buffering.window.allSizes),1);
    
    [~,tstData] = splitTrnTst(data, trnTstType);
    [prediction,~] = wCEstimation(bcCoords, tstData.rss, k);
    errors = customError(prediction, tstData.coords);
    estAcc(1) = getMetric(errors);

    for i = fDefs.buffering.window.allSizes
        bufData = rssBuffering(data, i, summaryType);

        [~,tstData] = splitTrnTst(bufData, trnTstType);
        [prediction,~] = wCEstimation(bcCoords, tstData.rss, k);
        errors = customError(prediction, tstData.coords);
        estAcc(i) = getMetric(errors);
    end
end

function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end