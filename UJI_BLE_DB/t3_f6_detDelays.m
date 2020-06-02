% Beacon detection delay analysis.
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

removeOutliers = true;
transfTime = true;  % Transform time to milliseconds and be relative to dataset first time
nonValueToNan = false;

% -----------------------------------------

% Correlation Zone Geotec, phone A5, power -12

zone = fDefs.zones.geo;
powerLevel = fDefs.geo.powers.p12;
phone = fDefs.geo.phones.a5;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data.time = timeDiffMilli(data.time);

[rhos,pvals] = getDistTimeDiffCorr(data, bcCoords, removeOutliers);

[~,posM] = max(abs(rhos));
fprintf('Zone: %s -> farther rho: %.2f, p-value: %.2f, beacon: %d \n',fDefs.zones.names.geo,rhos(posM),pvals(posM),posM);

% -----------------------------------------

% Correlation Zone Library, phone A5, power -12

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data.time = timeDiffMilli(data.time);

[rhos,pvals] = getDistTimeDiffCorr(data, bcCoords, removeOutliers);

[~,posM] = max(abs(rhos));
fprintf('Zone: %s -> farther rho: %.2f, p-value: %.2f, beacon: %d \n',fDefs.zones.names.lib,rhos(posM),pvals(posM),posM);

% -----------------------------------------

% Example of detection detection delays pattern
exampleBeacon = 1;

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;

[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data.time = timeDiffMilli(data.time);

[diffTms,selIds] = getDiffTimes(data, (1:1), removeOutliers);
diffTimesA5 = diffTms{exampleBeacon};

maxDiffTime = max(diffTimesA5);
figure;histogram(diffTimesA5,(100:200:maxDiffTime));

figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
scatter((1:numel(diffTimesA5)),diffTimesA5,120,'filled');
hold on; yt = (200:200:maxDiffTime-rem(maxDiffTime,200)); yticks(yt);
for i = yt
    h = refline([0, i]); h.LineWidth = 0.1; h.Color = [0.2,0.2,0.2];
end
xlabel('Sample number');ylabel('Time elapsed (ms)');

% Difference between phones

phone = fDefs.lib.phones.bq;
[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data.time = timeDiffMilli(data.time);

[diffTms,~] = getDiffTimes(data, (1:1), removeOutliers);
diffTimesBq = diffTms{exampleBeacon};

phone = fDefs.lib.phones.s6;
[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
data.time = timeDiffMilli(data.time);

[diffTms,~] = getDiffTimes(data, (1:1), removeOutliers);
diffTimesS6 = diffTms{exampleBeacon};

figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
boxplot([diffTimesA5;diffTimesBq;diffTimesS6],...
    [ones(numel(diffTimesA5),1);ones(numel(diffTimesBq),1).*2;ones(numel(diffTimesS6),1).*3],...
    'Labels',{'A5','BQ','S6'} );
ylabel('Time elapsed (ms)');

% fprintf('Median for A5: %f, Median for Bq: %f, Median for S6: %f,beacon: %d \n',median(diffTimesA5),median(diffTimesBq),median(diffTimesS6),exampleBeacon);

% -----------------------------------------

% Computes correlation between advertisement reception time differences 
% and distances from collection points to beacons. 
function [rhos,pvals] = getDistTimeDiffCorr(data, bcCoords, removeOutliers)
    nbeacons = size(data.rss, 2);
    rhos = zeros(1,nbeacons);
    pvals = zeros(1,nbeacons);

    [diffTms,selIds] = getDiffTimes(data, (1:nbeacons), removeOutliers);

    for beaconNumber =(1:nbeacons)
        diffTimes = diffTms{beaconNumber};
        ids = selIds{beaconNumber};
        selCoords = data.coords(ismember(ids,data.ids),:);

        beaconCoords = bcCoords(beaconNumber,:);
        dists = sqrt(sum((selCoords-beaconCoords).^2,2));

        % Correlation between distance and detection delays
        [rho,pval] = corr(diffTimes,dists);
        rhos(beaconNumber) = rho;
        pvals(beaconNumber) = pval;
    end
end

% Computes advertisement reception time differences at each collection
% (samples collected consecutively at a point), movement time (no active
% collection process) is not considered.
function [diffTms,diffIds] = getDiffTimes(data, bNumbers, removeOutliers)
    nBeacons = numel(bNumbers);
    diffTms = cell(1,nBeacons);
    diffIds = cell(1,nBeacons);

    for bn =(1:nBeacons)
        beaconNumber = bNumbers(bn);

        toShow = ~isnan(data.time(:,beaconNumber));
        selTimes = data.time(toShow,beaconNumber);
        selIds = data.ids(toShow,:);

        pointIds = getByPoint(selIds);
        diffTimes = diffByGroups(selTimes, pointIds);

        if (removeOutliers)
            nonOutliers = findOutliers(diffTimes, true);
            diffTimes = diffTimes(nonOutliers);
            selIds = selIds(nonOutliers);
        end

        diffTms{bn} = diffTimes;
        diffIds{bn} = selIds;
    end
end

% Compute time diffs per group (zero value is attached to start)
function [diffs] = diffByGroups(times, groups)
    diffs = [];
    uq = unique(groups);
    for i=(1:numel(uq))
        group = times(groups==uq(i));
        diffs = [diffs;[0;group(2:end) - group(1:end-1)]];
    end
end
