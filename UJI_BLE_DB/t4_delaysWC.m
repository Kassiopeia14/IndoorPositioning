% Effect of parameter k value on WC accuracy across the phones.
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

% Weighted centroid

% Libray

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;

% Variables for table
defKerror = zeros(fDefs.lib.phonesAmount, 1);
enoughKerror = zeros(fDefs.lib.phonesAmount, 1);
enoughPercent = zeros(fDefs.lib.phonesAmount, 1);
noKerror = zeros(fDefs.lib.phonesAmount, 1);

defKvalue = 10;

% -----------------------
phone = fDefs.lib.phones.a5;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

% --------
[prediction,ks] = wCEstimation(bcCoords, data.rss, defKvalue);
errors = customError(prediction, data.coords);
defKerror(phone) = getMetric(errors);
enoughKerror(phone) = getMetric(errors(ks==defKvalue));
enoughPercent(phone) = sum(ks==defKvalue)/numel(ks);

% --------
[prediction,~] = wCEstimation(bcCoords, data.rss);
errors = customError(prediction, data.coords);
noKerror(phone) = getMetric(errors);

% -----------------------
phone = fDefs.lib.phones.bq;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

% --------
[prediction,ks] = wCEstimation(bcCoords, data.rss, defKvalue);
errors = customError(prediction, data.coords);
defKerror(phone) = getMetric(errors);
enoughKerror(phone) = getMetric(errors(ks==defKvalue));
enoughPercent(phone) = sum(ks==defKvalue)/numel(ks);

% --------
[prediction,~] = wCEstimation(bcCoords, data.rss);
errors = customError(prediction, data.coords);
noKerror(phone) = getMetric(errors);

% -----------------------
phone = fDefs.lib.phones.s6;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

% --------
[prediction,ks] = wCEstimation(bcCoords, data.rss, defKvalue);
errors = customError(prediction, data.coords);
defKerror(phone) = getMetric(errors);
enoughKerror(phone) = getMetric(errors(ks==defKvalue));
enoughPercent(phone) = sum(ks==defKvalue)/numel(ks);

[prediction,~] = wCEstimation(bcCoords, data.rss);
errors = customError(prediction, data.coords);
noKerror(phone) = getMetric(errors);
% --------

rowNames = {}; 
rowNames{fDefs.lib.phones.a5} = fDefs.phones.names.a5;
rowNames{fDefs.lib.phones.bq} = fDefs.phones.names.bq;
rowNames{fDefs.lib.phones.s6} = fDefs.phones.names.s6;
T = table(noKerror,defKerror,enoughKerror,enoughPercent,...
    'VariableNames',{'all_detected','k_or_less','only_achiev_k','perc_achiev_k'},...
    'RowNames',rowNames);


fprintf("\n\n<strong>------------------------------------------------------------------------------</strong>");
fprintf("\n\n<strong>Influence of Number (k) of detected beacons for WC accuracy:</strong> \n\n");
fprintf("<strong>all_detected</strong> -> All detected beacons are used \n");
fprintf("<strong>k_or_less</strong> -> A k value (%d) is pre-selected (sometimes is not reached)\n", defKvalue);
fprintf("<strong>only_achiev_k</strong> -> Error Metric is only for estimations when k was achieved \n");
fprintf("<strong>perc_achiev_k</strong> -> Percentage of times that k was achieved \n\n");
disp(rows2vars(T));
fprintf("<strong>----------------------------------------------------------------------------------</strong> \n\n");

function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end