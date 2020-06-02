% INOBST Indicates which obstacle a point lies on.
%
%	[NUMBERS] = INOBST(POLYGONS, POINTS) returns in NUMBERS the positions
%	in the POLYGONS cell array of the polygons that contains the positions
%	of POINTS. If a position does not lie in a polygon, is associated
%	valued in NUMBERS is zero.
%
%   See Also LOADZONE and PLOTOBST.
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

function [numbers] = inObst(polygons, points)

    numbers = zeros(size(points,1),1);
    for i = (1:size(polygons,1))
        polygon = polygons{i,1};
        in = inpolygon(points(:,1), points(:,2), polygon(:,1), polygon(:,2));
        numbers(in) = i;
    end
end