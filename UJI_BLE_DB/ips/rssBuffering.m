% RSSBUFFERING Transform each fingerprint batch (those taken consecutively
% at a point) applying a moving mean or taking the last detected value.
%
%	[BUFDATA] = RSSBUFFERING(DATA, WINDOWSIZE, LASTORMEAN) transform each
%	fingerprint batch considering moving windows of size WINDOWSIZE and
%	taking from each column either the mean or the last value.
%
%   See Also GETFILTERDEFS and LOADZONERSS.
%
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

function [bufData] = rssBuffering(data, windowSize, lastOrMean)
    defs = getFilterDefs();
    
    ids = getByPoint(data.ids);
    [uids, ~, ic] = unique(ids, 'rows');
    nRows = size(uids,1);
    
    bufData = struct;
    bufData.rss = [];
    bufData.time = [];
    bufData.coords = [];
    bufData.ids = [];
        
    summary = @getLastSummary; % defs.buffering.summary.last;
    if (lastOrMean == defs.buffering.summary.mean)
        summary = @getMeanSummary;
    end
    
    for i = (1:nRows)
        indexes = ic == i;
            
        [sRss,sTime] = getWindowSummaries(data, indexes, windowSize, summary);
        bufData.rss = [bufData.rss;sRss];
        bufData.time = [bufData.time;sTime];
        
        selCoords = data.coords(indexes,:);
        bufData.coords = [bufData.coords;repmat(selCoords(1,:),size(sRss,1),1)];
        selIds = data.ids(indexes,:);
        bufData.ids = [bufData.ids;repmat(floor(selIds(1)/100)*100,size(sRss,1),1)];
    end
end

function [sRss,sTime] = getWindowSummaries(data, indexes, windowSize, getSummary)
    vRss = data.rss(indexes,:);
    vTime = data.time(indexes,:);
    [nRows,nCols] = size(vRss);
    if (nRows <= windowSize)
        sRss = vRss;
        sTime = vTime;
    else
        nWindows = nRows - windowSize + 1;
        sRss = zeros(nWindows,nCols);
        sTime = zeros(nWindows,nCols);
        for i = (1:nWindows)
            [wsRss,wsTime] = getSummary(vRss,vTime,(i:i+(windowSize-1)));
            sRss(i,:) = wsRss;
            sTime(i,:) = wsTime;
        end
    end
end

function [wsRss,wsTime] = getMeanSummary(vRss,vTime,indexes)
    wsRss = mean(vRss(indexes,:),1,'omitnan');
    wsTime = mean(vTime(indexes,:),1,'omitnan');
end

function [wsRss,wsTime] = getLastSummary(vRss,vTime,indexes)
    [B,I] = sort(vTime(indexes,:),1,'descend','MissingPlacement','last');
    wsTime = B(1,:);
    tmpRss = vRss(indexes,:);
    wsRss = zeros(1,numel(wsTime));
    for i = (1:numel(wsTime))
        wsRss(i) = tmpRss(I(1,i),i);
    end
end
