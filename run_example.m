function run_example()

close('all');
addpath('fct')

%% load loss data
[x, y, val] = get_data();

%% get the triangulation

% tolerance for removing bad triangles
tolerance.tol_angle = deg2rad(20); % angle tolerance for defined bad triangles
tolerance.scale_x = 2.0; % stretching factor in x direction for computing the angles
tolerance.scale_y = 1.0; % stretching factor in y direction for computing the angles

% get the triangulation
[tri_obj, idx] = get_triangulation(x, y, tolerance, true);
x = x(idx);
y = y(idx);
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
y_vec = linspace(-0.75, +0.75, 100);

% interpolate (ndgrid format)
val_mat = get_interpolation_grid(tri_obj, val, x_vec, x_vec);

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
