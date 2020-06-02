% Correlation analysis between RSS variance and distance, and between beacon 
% variance and percentage of beacons detected and distance
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

% -----------------------------------------

% Correlation Zone Geotec, phone A5, each power, all beacons

zone = fDefs.zones.geo;
phone = fDefs.geo.phones.a5;

powerLevel = fDefs.geo.powers.p04;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[sdc,adc] = getDistCorr(data, bcCoords);
[~,posM] = max(abs(sdc.rhos));
fprintf('STD    Zone: %s, Power: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.geo, fDefs.powers.names.p04, sdc.rhos(posM), sdc.pvals(posM),posM);
[~,posM] = max(abs(adc.rhos));
fprintf('AMOUNT Zone: %s, Power: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.geo, fDefs.powers.names.p04, sdc.rhos(posM), sdc.pvals(posM),posM);

powerLevel = fDefs.geo.powers.p12;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[sdc,adc] = getDistCorr(data, bcCoords);
[~,posM] = max(abs(sdc.rhos));
fprintf('STD    Zone: %s, Power: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.geo, fDefs.powers.names.p12, sdc.rhos(posM), sdc.pvals(posM),posM);
[~,posM] = max(abs(adc.rhos));
fprintf('AMOUNT Zone: %s, Power: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.geo, fDefs.powers.names.p12, adc.rhos(posM), adc.pvals(posM),posM);

powerLevel = fDefs.geo.powers.p20;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[sdc,adc] = getDistCorr(data, bcCoords);
[~,posM] = max(abs(sdc.rhos));
fprintf('STD    Zone: %s, Power: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.geo, fDefs.powers.names.p20, sdc.rhos(posM), sdc.pvals(posM),posM);
[~,posM] = max(abs(adc.rhos));
fprintf('AMOUNT Zone: %s, Power: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.geo, fDefs.powers.names.p20, adc.rhos(posM), adc.pvals(posM),posM);


fprintf('\n\n');
% -----------------------------------------

% Correlation Zone Library, power -12, each phone, all beacons

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;

phone = fDefs.lib.phones.a5;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[sdc,adc] = getDistCorr(data, bcCoords);
[~,posM] = max(abs(sdc.rhos));
fprintf('STD    Zone: %s, Phone: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.lib, fDefs.phones.names.a5, sdc.rhos(posM), sdc.pvals(posM),posM);
[~,posM] = max(abs(adc.rhos));
fprintf('AMOUNT Zone: %s, Phone: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.lib, fDefs.phones.names.a5, adc.rhos(posM), adc.pvals(posM),posM);

phone = fDefs.lib.phones.bq;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[sdc,adc] = getDistCorr(data, bcCoords);
[~,posM] = max(abs(sdc.rhos));
fprintf('STD    Zone: %s, Phone: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.lib, fDefs.phones.names.bq, sdc.rhos(posM), sdc.pvals(posM),posM);
[~,posM] = max(abs(adc.rhos));
fprintf('AMOUNT Zone: %s, Phone: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.lib, fDefs.phones.names.bq, adc.rhos(posM), adc.pvals(posM),posM);

phone = fDefs.lib.phones.s6;
[data,bcCoords] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[sdc,adc] = getDistCorr(data, bcCoords);
[~,posM] = max(abs(sdc.rhos));
fprintf('STD    Zone: %s, Phone: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.lib, fDefs.phones.names.s6, sdc.rhos(posM), sdc.pvals(posM),posM);
[~,posM] = max(abs(adc.rhos));
fprintf('AMOUNT Zone: %s, Phone: %s -> farther rho: %f, p-value: %f, beacon: %d \n',...
    fDefs.zones.names.lib, fDefs.phones.names.s6, adc.rhos(posM), adc.pvals(posM),posM);

% -----------------------------------------

% Correlation Zone Geotec, phone A5, power -20

beaconNumber = 18;

zone = fDefs.zones.geo;
powerLevel = fDefs.geo.powers.p20;
phone = fDefs.geo.phones.a5;

[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

[M, S, pos] = getMeanAndStd(data.rss(:,beaconNumber), data.coords);
drawRssBars(pos(:,1), pos(:,2), barWidth, M, S, [fDefs.zones.names.geo,[' - Beacon ' string(beaconNumber)]]);

% -----------------------------------------

% Correlation Zone Library, phone A5, power -12
beaconNumber = 1;

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;

[data,~] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);

[M, S, pos] = getMeanAndStd(data.rss(:,beaconNumber), data.coords);
drawRssBars(pos(:,1), pos(:,2), barWidth, M, S, [fDefs.zones.names.lib,[' - Beacon ' string(beaconNumber)]]);

% -----------------------------------------

function [sdc,adc] = getDistCorr(data, bcCoords)
    nbeacons = size(data.rss, 2);

    sdc = struct;
    sdc.rhos = zeros(1,nbeacons);
    sdc.pvals = zeros(1,nbeacons);

    adc = struct;
    adc.rhos = zeros(1,nbeacons);
    adc.pvals = zeros(1,nbeacons);

    singleValuesNan = true;
    for beaconNumber =(1:nbeacons)
        [M, S, pos, A] = getMeanAndStd(data.rss(:,beaconNumber), data.coords, singleValuesNan);

        beaconCoords = bcCoords(beaconNumber,:);
        dists = sqrt(sum((pos-beaconCoords).^2,2));

        [rho,pval] = corr(S,dists,'Rows','complete');
        sdc.rhos(beaconNumber) = rho;
        sdc.pvals(beaconNumber) = pval;

        [rho,pval] = corr(A,dists,'Rows','complete');
        adc.rhos(beaconNumber) = rho;
        adc.pvals(beaconNumber) = pval;
    end
end