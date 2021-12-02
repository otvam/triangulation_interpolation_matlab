function val_mat = get_interpolation_grid(tri_obj, val, x_vec, y_vec)
% Linear interpolation on a triangulation (ndgrid query).
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        val - value of the vertices (float / row vector)
%        x_vec - vector with x query points  (float / row vector)
%        y_vec - vector with y query points  (float / row vector)
%
%    Returns:
%        val_mat - interpolated value in ndgrid format (float / matrix)
%
%    A grid is formed with the query points (x_vec, y_vec).
%    The ndgrid format is used (and not meshgrid).
%
%    The following values are returned:
%        - inside the triangulation: linear interpolation
%        - outside the triangulation: NaN
%
%    Thomas Guillod.
%    2021 - BSD License.

% check query
validateattributes(x_vec, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(y_vec, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});

% create the grid
[x_mat, y_mat] = ndgrid(x_vec, y_vec);
x_mat = x_mat(:).';
y_mat = y_mat(:).';

% interpolate
val_mat = get_interpolation_vec(tri_obj, val, x_mat, y_mat);
val_mat = reshape(val_mat, length(x_vec), length(y_vec));

end
