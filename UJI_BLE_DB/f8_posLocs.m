% Variation of placement of position estimations according to beacon deployment.
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

% zone = fDefs.zones.geo;
% powerLevel = fDefs.geo.powers.p20;
% phone = fDefs.geo.phones.a5;
% summaryType = fDefs.buffering.summary.mean;
% window = fDefs.buffering.window.s2;
% 
% deployment = fDefs.geo.deploys.full;
% trnTstType = fDefs.geo.mlSets.fullLimits;
% 
% [data,bcCoords,obstPolys] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
% [xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,obstPolys,1);
% [selData,selBcCoords,bcNumbers] = deploymentSelection(data, bcCoords, deployment);
% bufData = rssBuffering(selData, window, summaryType);
% [trnData,tstData] = splitTrnTst(bufData, trnTstType);
% 
% showData(trnData, tstData, selBcCoords, bcNumbers, [xMin,xMax,yMin,yMax]);
% 
% kWC = 10;
% [predictionWC,~] = wCEstimation(selBcCoords, tstData.rss, kWC);
% errorsWC = customError(predictionWC, tstData.coords);
% fprintf('\nfull-WC:%.2f\n',getMetric(errorsWC));
% 
% kFP = 6;
% [predictionFP, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, kFP);
% errorsFP = customError(predictionFP, tstData.coords);
% fprintf('\nfull-FP:%.2f\n',getMetric(errorsFP));
% 
% figure;hold on;
% scatter(predictionWC(:,1),predictionWC(:,2),12,'ro','filled');
% scatter(predictionFP(:,1),predictionFP(:,2),12,'bo','filled');
% xlim([xMin,xMax]);ylim([yMin,yMax]);axis equal;
% xlabel('x');ylabel('y');legend('WC','FP');
% 
% return;

% =================================================================

zone = fDefs.zones.lib;
powerLevel = fDefs.lib.powers.p12;
phone = fDefs.lib.phones.a5;
summaryType = fDefs.buffering.summary.mean;
window = fDefs.buffering.window.s2;
trnTstType = fDefs.lib.mlSets.fullTrnNoOutTst;

% --------------------------
% Full deployment

deployment = fDefs.lib.deploys.full;

[data,bcCoords,obstPolys] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,obstPolys,1);
[selData,selBcCoords,bcNumbers] = deploymentSelection(data, bcCoords, deployment);
bufData = rssBuffering(selData, window, summaryType);
[trnData,tstData] = splitTrnTst(bufData, trnTstType);

showData(trnData, tstData, selBcCoords, bcNumbers, [xMin,xMax,yMin,yMax]);

kWC = 10;
[predictionWC,~] = wCEstimation(selBcCoords, tstData.rss, kWC);
errorsWC = customError(predictionWC, tstData.coords);

kFP = 12;
[predictionFP, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, kFP);
errorsFP = customError(predictionFP, tstData.coords);

showPredictions(predictionWC, predictionFP, [xMin,xMax,yMin,yMax]);
titleMsg = sprintf('WC:%.2fm, FP:%.2fm',getMetric(errorsWC),getMetric(errorsFP));
title(titleMsg,'FontSize',16);

% --------------------------
% Reduced deployment

deployment = fDefs.lib.deploys.reduced;

[data,bcCoords,obstPolys] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,obstPolys,1);
[selData,selBcCoords,bcNumbers] = deploymentSelection(data, bcCoords, deployment);
bufData = rssBuffering(selData, window, summaryType);
[trnData,tstData] = splitTrnTst(bufData, trnTstType);

showData(trnData, tstData, selBcCoords, bcNumbers, [xMin,xMax,yMin,yMax]);

kWC = 10;
[predictionWC,~] = wCEstimation(selBcCoords, tstData.rss, kWC);
errorsWC = customError(predictionWC, tstData.coords);

kFP = 12;
[predictionFP, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, kFP);
errorsFP = customError(predictionFP, tstData.coords);

showPredictions(predictionWC, predictionFP, [xMin,xMax,yMin,yMax]);
titleMsg = sprintf('WC:%.2fm, FP:%.2fm',getMetric(errorsWC),getMetric(errorsFP));
title(titleMsg,'FontSize',16);

% --------------------------
% No limits from sides deployment

deployment = fDefs.lib.deploys.noLimitsSide;

[data,bcCoords,obstPolys] = getDataForSet(dataFolder, zone, powerLevel, phone, nonValueToNan);
[xMin,xMax,yMin,yMax] = getAmpleArea(data,bcCoords,obstPolys,1);
[selData,selBcCoords,bcNumbers] = deploymentSelection(data, bcCoords, deployment);
bufData = rssBuffering(selData, window, summaryType);
[trnData,tstData] = splitTrnTst(bufData, trnTstType);

showData(trnData, tstData, selBcCoords, bcNumbers, [xMin,xMax,yMin,yMax]);

kWC = 10;
[predictionWC,~] = wCEstimation(selBcCoords, tstData.rss, kWC);
errorsWC = customError(predictionWC, tstData.coords);

kFP = 12;
[predictionFP, ~] = kNNEstimation(trnData.rss, tstData.rss, trnData.coords, kFP);
errorsFP = customError(predictionFP, tstData.coords);

showPredictions(predictionWC, predictionFP, [xMin,xMax,yMin,yMax]);
titleMsg = sprintf('WC:%.2fm, FP:%.2fm',getMetric(errorsWC),getMetric(errorsFP));
title(titleMsg,'FontSize',16);


return;

% barWidth = 0.25;
% fprintf('mean %.2f\n',mean(ks));

% disp(getMetric(errors))

% [MI, MA, pos, A] = getMinAndMax(errorsWC, tstData.coords);
% half = (MI+MA)./2; range =(MA-MI)./2;
% drawBars(pos(:,1), pos(:,2), barWidth, half, range, [fDefs.zones.names.geo,' - errors WC'],...
%     0,10,'error (m)','m',jet);
% axis image;

function showPredictions(predictionWC, predictionFP, lims)
    figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
    scatter(predictionWC(:,1),predictionWC(:,2),120,'ro','filled');
    scatter(predictionFP(:,1),predictionFP(:,2),120,'bo','filled');
    xlim([lims(1),lims(2)]);ylim([lims(3),lims(4)]);axis equal;
    xlabel('x(m)');ylabel('y(m)');
    % legend('WC','FP');
end

function showData(trnData, tstData, bcCoords, bcNumbers, lims)
    figure('PaperUnits','centimeters','PaperSize',[40,30],'PaperPosition',[0 0 40 30]); hold on;
    scatter(trnData.coords(:,1),trnData.coords(:,2),320,'mo','filled');
    scatter(tstData.coords(:,1),tstData.coords(:,2),320,'cs','filled');
    scatter(bcCoords(:,1),bcCoords(:,2),400,'gd','filled');
%     text(bcCoords(:,1),bcCoords(:,2),string(bcNumbers),'HorizontalAlignment','center','FontSize',6);
    xlim([lims(1),lims(2)]);ylim([lims(3),lims(4)]);axis equal;
%     legend({'training','test','beacons'},'location','northeastoutside');    
end

function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
