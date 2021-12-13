function [tri_obj, idx] = get_triangulation_remove(tri_obj, idx, scale, tolerance, make_plot)
% Remove ill-conditioned triangles.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        idx - indices of the vertices (indices / vector)
%        scale - streching factors for the triangulation (struct)
%            scale.scale_x - stretching factor in the x direction (float / scalar)
%            scale.scale_y - stretching factor in the y direction (float / scalar)
%        tolerance - parameters for detecting ill-conditioned triangles (struct)
%            tolerance.type - removal type ('angle' pr 'idx')
%            tolerance.tol_angle - angle threshold for ill-conditioned triangles (float / scalar)
%            tolerance.idx_rm - indices of the triangles to be removed (indices / vector)
%        make_plot - plot the obtained triangulation (boolean / scalar)
%
%    Returns:
%        tri_obj - created triangulation (object)
%        idx - indices of the vertices (indices / vector)
%
%    Remove ill-conditioned triangles with the following strategy:
%        - 'angle' - skinny triangles on the exterior boundary
%        - 'idx' - triangles specified with a list of indices
%
%    The triangulation is scaled as follow:
%        - the vertices are normalized into [0, 1]
%        - the scaled triangulation is stretched with the specified factors
%
%    During the removal of ill-conditioned triangles, vertices can be removed.
%    The removed vertices are tracked with the indices vector.
%
%    Thomas Guillod.
%    2021 - BSD License.

% check vertice
validateattributes(idx, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert(length(idx)==size(tri_obj.Points, 1), 'invalid size of the value vector')

% extract points
x = tri_obj.Points(:, 1).';
y = tri_obj.Points(:, 2).';
tri = tri_obj.ConnectivityList;

% normalize the vertices
[x_scale, y_scale] = get_triangulation_scale(x, y, scale);

% create the triangulation
tri_raw_obj = triangulation(tri, x_scale.', y_scale.');

% remove ill-conditioned triangles
switch tolerance.type
    case 'angle'
        [tri_filter_obj, idx] = get_remove(tri_raw_obj, idx, tolerance.tol_angle);
    case 'idx'
        [tri_filter_obj, idx] = get_triangulation_idx(tri_raw_obj, idx, tolerance.idx_rm);
    otherwise
        error('invalid type')
end

% create final triangulation (original axis)
x = x(idx);
y = y(idx);
tri = tri_filter_obj.ConnectivityList;
tri_obj = triangulation(tri, x.', y.');

% plot the triangulation
get_triangulation_plot(tri_raw_obj, tri_filter_obj, tri_obj, make_plot)

end

function [tri_obj, idx] = get_remove(tri_obj, idx, tol_angle)
% Remove ill-conditioned triangles.
%
%    Returns:
%        x - vertices for the x axis  (float / row vector)
%        y - vertices for the y axis  (float / row vector)

% as long as ill-conditioned triangles are on the exterior boundary, remove them
is_done = false;
while is_done==false
    [tri_obj, is_done, idx] = get_remove_sub(tri_obj, idx, tol_angle);
end

end

function [tri_obj, is_done, idx] = get_remove_sub(tri_obj, idx, tol_angle)
% Remove ill-conditioned triangles at the exterior boundary.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        idx - indices of the vertices (indices / vector)
%        tol_angle - angle threshold for ill-conditioned triangles (float / scalar)
%
%    Returns:
%        tri_obj - triangulation object (object)
%        is_done - indicate that ill-conditioned triangles are not found (boolean / scalar)
%        idx - indices of the vertices (indices / vector)

% detect the ill-conditioned triangles
angle_tri = get_triangulation_angle(tri_obj);
idx_angle = find(angle_tri<tol_angle);

% detect which triangles are at the exterior boundary
edge_bnd = tri_obj.freeBoundary();
idx_bnd = tri_obj.edgeAttachments(edge_bnd);
idx_bnd = [idx_bnd{:}];

% remove the ill-conditioned triangles at the exterior boundary
idx_rm = intersect(idx_bnd, idx_angle);

% remove the corresponding triangles
[tri_obj, idx] = get_triangulation_idx(tri_obj, idx, idx_rm);

% done if nothing to remove
is_done = isempty(idx_rm);

end
