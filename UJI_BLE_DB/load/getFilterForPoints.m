% GETFILTERFORPOINTS Identifies the ids that correspond to specific
% campaign point numbers.
%
%	[RESULT] = GETFILTERFORPOINTS(IDS, POINTS) return the logical vector
%	RESULT that identifies which values from IDS correspond to campaign
%	point numbers that belong to the set POINTS.
%
%   See Also LOADZONE and APPLYFILTER.
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

function [result] = getFilterForPoints(ids, points)
    digits = rem(floor(ids./10^2), 10^3);
    result = false(numel(ids),1);
    for i = (1:numel(points))
        result = result | (digits == points(i)); 
    end
end
