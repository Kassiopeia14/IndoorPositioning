% Accuracy analysis for different zone, phone and power configurations.
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

% -----------------------------------------
% TODO: Automatically choose a proper k value for each environment
% -----------------------------------------

lineWidth = 2;

% Weighted centroid and kNN

defFPKvalue = 72;
defWCKvalue = 6;

errorWC = {};
errorFP = {};

% PHONE COMPARISON, LIBRARY ZONE


zone = fDefs.zones.lib;
power = fDefs.lib.powers.p12;

% -----------------------

phone = fDefs.lib.phones.a5;
[data,bcCoords] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan);

[prediction,~] = wCEstimation(bcCoords, data.rss, defWCKvalue);
errorWC{phone} = customError(prediction, data.coords);

[trnData,tstData] = splitTrnTst(data, fDefs.lib.mlSets.fullTrnNoOutTst);
[prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defFPKvalue);
errorFP{phone} = customError(prediction, tstData.coords);

% -----------------------

phone = fDefs.lib.phones.bq;
[data,bcCoords] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan);

[prediction,~] = wCEstimation(bcCoords, data.rss, defWCKvalue);
errorWC{phone} = customError(prediction, data.coords);

[trnData,tstData] = splitTrnTst(data, fDefs.lib.mlSets.fullTrnNoOutTst);
[prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defFPKvalue);
errorFP{phone} = customError(prediction, tstData.coords);

% -----------------------

phone = fDefs.lib.phones.s6;
[data,bcCoords] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan);

[prediction,~] = wCEstimation(bcCoords, data.rss, defWCKvalue);
errorWC{phone} = customError(prediction, data.coords);

[trnData,tstData] = splitTrnTst(data, fDefs.lib.mlSets.fullTrnNoOutTst);
[prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defFPKvalue);
errorFP{phone} = customError(prediction, tstData.coords);

figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
h = cdfplot(errorWC{fDefs.lib.phones.a5}); 
set(h, 'LineStyle', '-', 'Color', 'r', 'LineWidth', lineWidth);
h = cdfplot(errorWC{fDefs.lib.phones.bq});
set(h, 'LineStyle', '--', 'Color', 'g', 'LineWidth', lineWidth);
h = cdfplot(errorWC{fDefs.lib.phones.s6});
set(h, 'LineStyle', ':', 'Color', 'b', 'LineWidth', lineWidth);
legend(fDefs.phones.names.a5,fDefs.phones.names.bq,fDefs.phones.names.s6);
title('');

figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
h = cdfplot(errorFP{fDefs.lib.phones.a5}); 
set(h, 'LineStyle', '-', 'Color', 'r', 'LineWidth', lineWidth);
h = cdfplot(errorFP{fDefs.lib.phones.bq}); 
set(h, 'LineStyle', '--', 'Color', 'g', 'LineWidth', lineWidth);
h = cdfplot(errorFP{fDefs.lib.phones.s6}); 
set(h, 'LineStyle', ':', 'Color', 'b', 'LineWidth', lineWidth);
legend(fDefs.phones.names.a5,fDefs.phones.names.bq,fDefs.phones.names.s6);
title('');

% ===================================================


% POWER COMPARISON, GEOTEC ZONE
% Weighted centroid and kNN

zone = fDefs.zones.geo;
phone = fDefs.geo.phones.a5;

% -----------------------

power = fDefs.geo.powers.p04;
[data,bcCoords] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan);

[prediction,~] = wCEstimation(bcCoords, data.rss, defWCKvalue);
errorWC{power} = customError(prediction, data.coords);

[trnData,tstData] = splitTrnTst(data, fDefs.geo.mlSets.fullLimits);
[prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defFPKvalue);
errorFP{power} = customError(prediction, tstData.coords);

% -----------------------

power = fDefs.geo.powers.p12;
[data,bcCoords] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan);

[prediction,~] = wCEstimation(bcCoords, data.rss, defWCKvalue);
errorWC{power} = customError(prediction, data.coords);

[trnData,tstData] = splitTrnTst(data, fDefs.geo.mlSets.fullLimits);
[prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defFPKvalue);
errorFP{power} = customError(prediction, tstData.coords);

% -----------------------

power = fDefs.geo.powers.p20;
[data,bcCoords] = getDataForSet(dataFolder, zone, power, phone, nonValueToNan);

[prediction,~] = wCEstimation(bcCoords, data.rss, defWCKvalue);
errorWC{power} = customError(prediction, data.coords);

[trnData,tstData] = splitTrnTst(data, fDefs.geo.mlSets.fullLimits);
[prediction, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defFPKvalue);
errorFP{power} = customError(prediction, tstData.coords);


figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
h = cdfplot(errorWC{fDefs.geo.powers.p04}); 
set(h, 'LineStyle', '-', 'Color', 'r', 'LineWidth', lineWidth);
h = cdfplot(errorWC{fDefs.geo.powers.p12});
set(h, 'LineStyle', '--', 'Color', 'g', 'LineWidth', lineWidth);
h = cdfplot(errorWC{fDefs.geo.powers.p20});
set(h, 'LineStyle', ':', 'Color', 'b', 'LineWidth', lineWidth);
legend(fDefs.powers.names.p04,fDefs.powers.names.p12,fDefs.powers.names.p20);
title('');

figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
h = cdfplot(errorFP{fDefs.geo.powers.p04}); 
set(h, 'LineStyle', '-', 'Color', 'r', 'LineWidth', lineWidth);
h = cdfplot(errorFP{fDefs.geo.powers.p12}); 
set(h, 'LineStyle', '--', 'Color', 'g', 'LineWidth', lineWidth);
h = cdfplot(errorFP{fDefs.geo.powers.p20}); 
set(h, 'LineStyle', ':', 'Color', 'b', 'LineWidth', lineWidth);
legend(fDefs.powers.names.p04,fDefs.powers.names.p12,fDefs.powers.names.p20);
title('');

% --------------------

