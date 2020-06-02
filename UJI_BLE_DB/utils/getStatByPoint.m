% GETSTATBYPOINT Computes two metrics for each measurement batch.
%
%	[ST1, ST2, POS, A] = GETSTATBYPOINT(SAMPLES, LOCATIONS,
%	SINGLEVALUESNAN, STATFN1, STATFN2, IDS). Computes two metrics for each
%	measurement batch in SAMPLES using the STATFN1 and STATFN2. If IDS is
%	supplied, batch membership is determined by IDS, otherwise is
%	determined by LOCATIONS. Set SINGLEVALUESNAN to true to have NAN values
%	produced for batches with only one non-NAN element.
%
%   See Also GETMEANANDSTD and GETMINANDMAX.
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

function [ST1, ST2, pos, A] = getStatByPoint(samples, locations, singleValuesNan, statFn1, statFn2, ids)

    if (exist('ids','var') && (numel(ids)>0))
        [uids, ~, ic] = unique(ids, 'rows');
    else
        [uids, ~, ic] = unique(locations, 'rows');
    end
    nCols = size(samples,2);
    nRows = size(uids,1);
    ST1 = zeros(nRows,nCols);
    ST2 = zeros(nRows,nCols);
    A = zeros(nRows,nCols);
    
    pos = zeros(nRows,2);
    
    for i = (1:nRows)
        indexes = ic == i;
        values = samples(indexes, :);
        ST1(i,:) = statFn1(values);
        ST2(i,:) = statFn2(values);
        A(i,:) = sum(~isnan(values))/numel(values);
        if (exist('singleValuesNan','var') && (singleValuesNan) && (sum(~isnan(values))<2))
            ST2(i,:) = nan;
        end
        pos(i,:) = mean(locations(indexes,:));
    end
end