function h = barareaneg(x, y, type, orient)
%BARAREANEG Stacked bar or area plot, positive/negative separated
%
% h = barareaneg(x, y, type)
%
% Matlab's native stacked bar and area plots don't really make sense when
% you need to visualize both positive and negative data.  This function
% instead separates out always-postive and always-negative series, and
% plots them in opposite-facing bar/area plots.
%
% Input variables:
%
%   x:      vector of x coordinates of each bar or point (always refers to
%           independant variable, regardless of orientation)
%
%   y:      nx x nstack values to be plotted.  Each column represents a
%           stacked box/patch in.  For area option, columns must be either 
%           entirely positive or negative.  (always refers to dependant
%           variable, regardless of orientation)
%
%   type:   'bar' or 'area' (default 'bar')
%
%   orient: 'v': vertical (y axis is dependant variable)
%           'h': horizontal (x axis is dependant variable)
%           Note that the order of x,y (with x referring to the location of
%           each bar/area stack, and y to the quantities in each) remains
%           the same regardless of orientation
%
% Output variables:
%
%   h:      structure of handles 
%
%           pos:    1 x nstack array, handles corresponding to positive
%                   side of each data column
%
%           neg:    1 x nstack array, handles corresponding to negative
%                   side of each data column
%
%           sum:    1 x 1 array, handle to line/bar showing sum of both
%                   postive and negative components

if ~isvector(x)
    error('x must be vector');
end
x = x(:);

nx = length(x);

sz = size(y);
if nx ~= sz(1)
    error('length(x) must equal size(y,1)');
end

if nargin < 3 || isempty(type)
    type = 'bar';
end

if nargin < 4 || isempty(orient)
    orient = 'v';
end

if any(isnan(y(:)))
    warning('BAN:nantozero', 'NaNs being treated as 0');
    y(isnan(y)) = 0;
end
    

allpos = all(y >= 0, 1);
allneg = all(y <= 0, 1) & ~allpos; % all 0 treat as pos

% if ~all(allpos | allneg)
%     error('Can''t handle y with mixed pos-neg columns yet');
% end

ypos = zeros(size(y));
yneg = zeros(size(y));

ypos(y >= 0) = y(y >= 0);
yneg(y < 0) = y(y < 0);

% ypos(:,allpos) = y(:,allpos);
% yneg(:,allneg) = y(:,allneg);

% ypos = y(:,allpos);
% yneg = y(:,allneg);
% 
% szp = size(ypos);
% 
% ypos = [ypos zeros(size(yneg))];
% yneg = [zeros(szp) yneg];
ysum = sum(y, 2);

if nx == 1
    x = [x x+1];
    ypos = [ypos; zeros(1,sz(2))];
    yneg = [yneg; zeros(1,sz(2))];
end
    
if strcmp(type, 'bar')
    if strcmp(orient, 'v')
        h.pos = bar(x, ypos, 'stacked');
        hold on;
        h.neg = bar(x, yneg, 'stacked');
        h.sum = bar(x, ysum, 'facecolor', 'none', 'edgecolor', [.5 .5 .5]);
    else
        h.pos = barh(x, ypos, 'stacked');
        hold on;
        h.neg = barh(x, yneg, 'stacked');
        h.sum = barh(x, ysum, 'facecolor', 'none', 'edgecolor', [.5 .5 .5]);
    end
elseif strcmp(type, 'area')
    if strcmp(orient, 'v')
        h.pos = area(x, ypos);
        hold on;
        h.neg = area(x, yneg);
        h.sum = plot(x, ysum, 'color', [.5 .5 .5]);
    else
        error('Can''t do horizontal area plots yet');
    end
end



