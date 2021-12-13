function [x_scale, y_scale] = get_triangulation_scale(x, y, scale)
% Normalize and stretch the vertices of a triangulation.
%
%    Parameters:
%        x - vertices for the x axis  (float / row vector)
%        y - vertices for the y axis  (float / row vector)
%        scale - streching factors for the triangulation (struct)
%            scale.scale_x - stretching factor in the x direction (float / scalar)
%            scale.scale_y - stretching factor in the y direction (float / scalar)
%
%    Returns:
%        x_scale - scaled vertices for the x axis  (float / row vector)
%        y_scale - scaled vertices for the y axis  (float / row vector)
%
%    Thomas Guillod.
%    2021 - BSD License.

% extract
scale_x = scale.scale_x;
scale_y = scale.scale_y;

% normalize the vertices into [0, 1]
x_scale = (x-min(x))./(max(x)-min(x));
y_scale = (y-min(y))./(max(y)-min(y));

% stretch the vertices
x_scale = scale_x.*x_scale;
y_scale = scale_y.*y_scale;

end