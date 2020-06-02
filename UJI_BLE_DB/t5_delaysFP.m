% FP accuracy across the phones.
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

% Fingerprinting

% Libray

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;

% Variables for table

% maxMatchAmount: The largest values of time a query and sample fp had 
% coincident beacons (columns) non absent rss in query and sample fps.
% to that presented for WC because the amount of detected beacons in
% the query fp is not an indicator of the amount that will be matched
% with fp from training.
% rhos,pValues: correlation between the amount of fps that have a specific 
% amount of concidents (columns with non absent values in query and sample 
% fps) with the errors computed for those with a specific amount of concidents.

defError = zeros(fDefs.lib.phonesAmount, 1);
maxMatchAmount = zeros(fDefs.lib.phonesAmount, 1);
rhos = zeros(fDefs.lib.phonesAmount, 1);
pValues = zeros(fDefs.lib.phonesAmount, 1);

defKvalue = 72;

% -----------------------
phone = fDefs.lib.phones.a5;
[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[trnData,tstData] = splitTrnTst(data, fDefs.lib.mlSets.fullTrnNoOutTst);

% trnData.rss(isnan(trnData.rss)) = -100; % This produce errors larger than using nan values.
% tstData.rss(isnan(tstData.rss)) = -100;

[prediction, ks] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defKvalue);
errors = customError(prediction, tstData.coords);

nKs = floor(max(ks));
ksAmount = zeros(nKs,1);
ksAccuracy = zeros(nKs,1);

for i = (1:nKs)
    ksAccuracy(i) = getMetric(errors(ks>i));
    ksAmount(i) = sum(ks>i);
end

[r,p] = corr(ksAccuracy, (1:nKs)');

defError(phone) = getMetric(errors);
maxMatchAmount(phone) = nKs;
rhos(phone) = r;
pValues(phone) = p;

% -----------------------
phone = fDefs.lib.phones.bq;
[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[trnData,tstData] = splitTrnTst(data, fDefs.lib.mlSets.fullTrnNoOutTst);

[prediction, ks] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defKvalue);
errors = customError(prediction, tstData.coords);

nKs = floor(max(ks));
ksAmount = zeros(nKs,1);
ksAccuracy = zeros(nKs,1);

for i = (1:nKs)
    ksAccuracy(i) = getMetric(errors(ks>i));
    ksAmount(i) = sum(ks>i);
end

[r,p] = corr(ksAccuracy, (1:nKs)');

defError(phone) = getMetric(errors);
maxMatchAmount(phone) = nKs;
rhos(phone) = r;
pValues(phone) = p;

% -----------------------
phone = fDefs.lib.phones.s6;
[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[trnData,tstData] = splitTrnTst(data, fDefs.lib.mlSets.fullTrnNoOutTst);

[prediction, ks] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, defKvalue);
errors = customError(prediction, tstData.coords);

nKs = floor(max(ks));
ksAmount = zeros(nKs,1);
ksAccuracy = zeros(nKs,1);

for i = (1:nKs)
    ksAccuracy(i) = getMetric(errors(ks>i));
    ksAmount(i) = sum(ks>i);
end

figure; yyaxis left; plot(ksAccuracy); ylabel('Error for coincidents');
yyaxis right; plot(ksAmount); ylabel('Number of fp with that amount of coincidents');
xlabel('Selected number of coincidents'); title(['Library-',fDefs.phones.names.s6]);

[r,p] = corr(ksAccuracy, (1:nKs)');

defError(phone) = getMetric(errors);
maxMatchAmount(phone) = nKs;
rhos(phone) = r;
pValues(phone) = p;

% -----------------------

rowNames = {}; 
rowNames{fDefs.lib.phones.a5} = fDefs.phones.names.a5;
rowNames{fDefs.lib.phones.bq} = fDefs.phones.names.bq;
rowNames{fDefs.lib.phones.s6} = fDefs.phones.names.s6;
T = table(defError,maxMatchAmount,rhos,pValues,...
    'VariableNames',{'defError','maxMatchAmount','rhos','pValues'},...
    'RowNames',rowNames);

fprintf("\n\n<strong>------------------------------------------------------------------------------</strong>");
fprintf("\n\n<strong>Influence of coincident columns with non-absent rss value in query and db:</strong> \n\n");
fprintf("<strong>defError</strong> -> 75 pctile error (no filtering) \n");
fprintf("<strong>maxMatchAmount</strong> -> Largest number of coincident columns \n");
fprintf("<strong>rhos</strong> -> rho of correlation error and number of coincident columns \n");
fprintf("<strong>pValues</strong> -> pvalue of correlation  error and number of coincident columns \n\n");
disp(rows2vars(T));
fprintf("<strong>------------------------------------------------------------------------------</strong>\n\n");

function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end