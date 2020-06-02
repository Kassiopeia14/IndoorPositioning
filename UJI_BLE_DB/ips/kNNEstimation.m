% KNNESTIMATION Estimate a position for each query element using kNN.
%
%	[PREDICTION, KS] = KNNESTIMATION(SAMPLES, QUERY, POSITIONS, K) creates
%	a position prediction in PREDICTION for each row in QUERY. A prediction
%	is computed as the centroid of the positions in POSITIONS associated to
%	the K rows in SAMPLES closest in the Euclidean space to the query row.
%	The mean amount of matching non-absent values between the query and its
%	closest neighbours is returned in KS.
%
%   See Also WCESTIMATION.
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

function [prediction, ks] = kNNEstimation(samples, query, positions, k)
    [samplRows, ~] = size(samples);
    [queryRows,~] = size(query);

    prediction = zeros(queryRows, 2);
    ks = zeros(queryRows, 1);
    
    if (k > samplRows)
        k = samplRows;  % First k adjustment
    end

    samplesNans = isnan(samples);
    
    for i = (1:queryRows)
        qv = query(i,:);
        qvNans = isnan(qv);

        if(sum(~qvNans) == 0)
            prediction(i,:) = nan;
        else
            anyNans = samplesNans | qvNans;
            dists = sqrt(sum((samples - qv).^2,2,'omitnan'));
            dists(sum(~anyNans,2)==0) = nan;   % address row with all nans 
            tt = [dists,sum(~anyNans,2)]; % for tie cases, to choose those with less nans
            [~, indices] = sortrows(tt, 'ascend', 'MissingPlacement', 'last');

            IDX = indices(1:k);
            ks(i) = mean(tt(IDX,2));
            prediction(i,:) = mean(positions(IDX,:),1);
        end
    end
end

