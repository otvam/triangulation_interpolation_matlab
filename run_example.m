function run_example()

close('all');
addpath(genpath('fct'))

%% load dummy scattered data
[x, y, val] = get_data();

%% get the triangulation

% stretching factor
scale.scale_x = 2.0; % stretching factor in x direction for computing the triangulation
scale.scale_y = 1.0; % stretching factor in y direction for computing the triangulation

% tolerance for removing bad triangles

% get the triangulation
tolerance.alpha = 0.2; % alpha radius (see alphaShape, 'Inf' for full triangulation)
tolerance.hole_threshold = 0; % maximum interior holes (see alphaShape, '0' for desactivating)
tolerance.region_threshold = 0; % maximum regions (see alphaShape, '0' for desactivating)
[tri_obj, idx] = get_triangulation_create(x, y, scale, tolerance, true);

% remove triangles with bad angles
tolerance.type = 'angle'; % remove using the angles
tolerance.tol_angle = deg2rad(20); % angle tolerance for defined bad triangles
[tri_obj, idx] = get_triangulation_remove(tri_obj, idx, scale, tolerance, true);

% remove manually some triangles
tolerance.type = 'idx'; % remove using the indices
tolerance.idx_rm = 167; % indices of the bad triangles
[tri_obj, idx] = get_triangulation_remove(tri_obj, idx, scale, tolerance, true);

% if vertices have been removed, remove the corresponding data
val = val(idx);

%% plot triangulated data

figure()

plot_triangulation_vertice(tri_obj, val)
grid('on')
xlabel('x')
ylabel('y')
zlabel('val')
title('Triangulated Data')

%% interpolate

% query points
x_vec = linspace(-1.5, +1.5, 100);
y_vec = linspace(-0.75, +0.75, 150);

% interpolate (ndgrid format)
val_mat = get_interpolation_grid(tri_obj, val, x_vec, y_vec);

%% plot interpolated data

figure()
surf(x_vec, y_vec, val_mat.', val_mat.')
grid('on')
xlabel('x')
ylabel('y')
zlabel('val')
title('Interpolated Data')

end

function [x, y, val] = get_data()
% Create dummy scattered dataset.
%
%    Returns:
%        x - vertices for the x axis  (float / row vector)
%        y - vertices for the y axis  (float / row vector)
%        val - value of the vertices (float / row vector)

% grid points
x = -1.5:0.1:+1.5;
y = -0.75:0.1:+0.75;

% get function value
[x, y] = ndgrid(x, y);
val = peaks(x, y);

% flatten data
x = x(:).';
y = y(:).';
val = val(:).';

% remove an edge
idx = (x>=0)|(y>=0);
x = x(idx);
y = y(idx);
val = val(idx);

end
