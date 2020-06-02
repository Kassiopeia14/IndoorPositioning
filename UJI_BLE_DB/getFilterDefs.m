% GETFILTERDEFS Estimate a position for each query element using weighted
% centroid.
%
%	[DEFS] = GETFILTERDEFS() returns constants useful for filtering for
%	specific data or parameter options for some functions .
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

function [defs] = getFilterDefs()
    defs = struct;

    defs.zones.geo = 1;
    defs.zones.lib = 2;
    defs.zonesAmount = 2;
    
    defs.zones.names.geo = 'Geotec';
    defs.zones.names.lib = 'Library';
    
    % -----------------------------------

    defs.geo.powers.p04 = 1;
    defs.geo.powers.p12 = 2;
    defs.geo.powers.p20 = 3;
    defs.geo.powersAmount = 3;
    
    defs.geo.phones.a5 = 1;
    defs.geo.phonesAmount = 1;
    
    defs.geo.campaigns.c1 = 1;
    defs.geo.campaignsAmount = 1;

    defs.geo.mlSets.fullLimits = 1;
    defs.geo.mlSets.reducedLimits = 2;
    defs.geo.mlSets.triangles = 3;

    defs.geo.deploys.full = 1;
    defs.geo.deploys.reduced = 2;
    defs.geo.deploys.noBoundaries = 3;
    defs.geo.deploys.noMiddVertical = 4;
    defs.geo.deploys.boundariesAndCenter = 5;
    defs.geo.deploys.tiny = 6;
    defs.geo.nBeacons = 22;
    
    % -----------------------------------

    defs.lib.powers.p12 = 2;
    defs.lib.powersAmount = 1;
    
    defs.lib.phones.a5 = 1;
    defs.lib.phones.bq = 2;
    defs.lib.phones.s6 = 3;
    defs.lib.phonesAmount = 3;
    
    defs.lib.campaigns.c1 = 2;
    defs.lib.campaigns.c4 = 3;
    defs.lib.campaignsAmount = 2;

    defs.lib.mlSets.fullTrnTst = 4;
    defs.lib.mlSets.reducedTrnFullTst = 5;
    defs.lib.mlSets.fullTrnNoOutTst = 6;
    defs.lib.mlSets.reducedTrnNoOutTst = 7;
    
    defs.lib.deploys.full = 7;
    defs.lib.deploys.reduced = 8;
    defs.lib.deploys.noBoundaries = 9;
    defs.lib.deploys.noMiddHoriz = 10;
    defs.lib.deploys.noLimitsSide = 11;
    defs.lib.nBeacons = 24;
    
    % -----------------------------------

    defs.phones.names.a5 = 'A5';
    defs.phones.names.bq = 'Bq';
    defs.phones.names.s6 = 'S6';
    
    % -----------------------------------

    defs.powers.names.p04 = '-04dBm';
    defs.powers.names.p12 = '-12dBm';
    defs.powers.names.p20 = '-20dBm';
    
    % -----------------------------------
    
    defs.buffering.window.s2 = 2;
    defs.buffering.window.s3 = 3;
    defs.buffering.window.s4 = 4;
    defs.buffering.window.s5 = 5;
    defs.buffering.window.allSizes = (2:5);
    
    defs.buffering.summary.last = 1;
    defs.buffering.summary.mean = 2;
end

