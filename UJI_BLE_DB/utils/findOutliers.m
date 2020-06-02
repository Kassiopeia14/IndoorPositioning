% FINDOUTLIERS Determines which values are to be considered outliers.
%
%	[INDS] = FINDOUTLIERS(A,RMZEROS) return the logical vector INDS that
%	indicates which values from A are to considered outliers according to
%	Tukey's fences outlier criterion. Set RMZEROS to also remove zeros.
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

function [inds] = findOutliers(a,rmZeros)
    preFilter = true(size(a));
    if (rmZeros)
        preFilter = a~=0;
    end
    q25 = prctile(a(preFilter),25);
    q75 = prctile(a(preFilter),75);
    iqr = q75 - q25;
    k = 1.5;    % Tukey's fences outlier
    inds = preFilter & (a > (q25-k*iqr)) & (a < (q75+k*iqr));
end

