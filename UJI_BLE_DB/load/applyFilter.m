% APPLYFILTER Filters out all measurements that are not in a selection.
%
%	[DATA] = APPLYFILTER(DATA,SELECTION) modifies all components of DATA so
%	that it keeps measurements corresponding to true values in the logical
%	vector SELECTION.
%
%   See Also GETFILTERDEFS, GETFILTERFORPOWER, GETFILTERFORPHONE,
%   GETFILTERFORCAMPAIGN, GETFILTERFORPOINTS and LOADZONE.
%
%   Copyright � 2018 Universitat Jaume I (UJI)

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

function [data] = applyFilter(data,selection)
    data.rss = data.rss(selection,:);
    data.ids = data.ids(selection,:);
    data.coords = data.coords(selection,:);
    data.time = data.time(selection,:);
end

