function [tri_obj, idx] = get_triangulation_create(x, y, tolerance, make_plot)
% Create a Delaunay triangulation and remove ill-conditioned triangles.
%
%    Parameters:
%        x - vertices for the x axis  (float / row vector)
%        y - vertices for the y axis  (float / row vector)
%        tolerance - parameters for detecting ill-conditioned triangles (struct)
%            tolerance.scale_x - stretching factor in the x direction (float / scalar)
%            tolerance.scale_y - stretching factor in the y direction (float / scalar)
%            tolerance.tol_angle - angle threshold for ill-conditioned triangles (float / scalar)
%        make_plot - plot the obtained triangulation  (boolean / scalar)
%
%    Returns:
%        tri_obj - created triangulation (object)
%        idx - indices of the vertices (indices / vector)
%
%    Remove ill-conditioned triangles with the following strategy:
%        - ill-conditioned triangles are on the exterior boundary
%        - ill-conditioned triangles are skinny (small angle)
%
%    The angles of the triangles are computed as follow:
%        - the vertices are normalized into [0, 1]
%        - the scaled triangulation is stretched with the specified factors
%        - the angles are computed with the stretched triangulation
%        - the obtained angles are compared to the specified threshold
%
%    During the removal of ill-conditioned triangles, vertices can be removed.
%    The removed vertices are tracked can be tracked with the indices vector.
%
%    Thomas Guillod.
%    2021 - BSD License.

% check vertice
validateattributes(x, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(y, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert((length(x)==length(y)), 'vertice vectors have different lengths')
assert((length(x)>=3)&&(length(y)>=3), 'at least three vertices are required')

% extract tolerance
scale_x = tolerance.scale_x;
scale_y = tolerance.scale_y;
tol_angle = tolerance.tol_angle;

% normalize the vertices into [0, 1]
x_scale = (x-min(x))./(max(x)-min(x));
y_scale = (y-min(y))./(max(y)-min(y));

% stretch the vertices
x_scale = scale_x.*x_scale;
y_scale = scale_y.*y_scale;

% create the triangulation
tri_raw_obj = delaunayTriangulation(x_scale.', y_scale.');

% ill-conditioned triangles
[tri_filter_obj, idx] = get_remove(tri_raw_obj, tol_angle);

% create final triangulation (original axis)
x = x(idx);
x = x(idx);
tri = tri_filter_obj.ConnectivityList;
tri_obj = triangulation(tri, x.', y.');

% plot the triangulation
if make_plot==true
    % get the angles
    angle_tri = get_triangulation_angle(tri_raw_obj);
    angle_tri = rad2deg(angle_tri);
    
    % plot the angles (scaled axis)
    figure()
    plot_triangulation_face(tri_raw_obj, angle_tri)
    grid('on')
    axis('equal')
    view(2)
    xlabel('x / scaled')
    ylabel('y / scaled')
    h = colorbar();
    set(get(h, 'label'), 'string', 'Angle (deg)');
    title('Triangulation / Angle')
    
    % plot both triangulations (scaled axis)
    figure()
    plot_triangulation_geom(tri_raw_obj, 'r')
    hold('on')
    plot_triangulation_geom(tri_filter_obj, 'g')
    grid('on')
    axis('equal')
    view(2)
    xlabel('x / scaled')
    ylabel('y / scaled')
    title('Triangulation / Comparison')

    % plot the triangulation and indices (original axis)
    figure()
    hold('on')
    plot_triangulation_idx(tri_obj, 'g')
    grid('on')
    xlabel('x')
    ylabel('y')
    title('Triangulation / Results')
end

end

function [tri_obj, idx] = get_remove(tri_obj, tol_angle)
% Remove ill-conditioned triangles.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        tol_angle - angle threshold for ill-conditioned triangles (float / scalar)
%
%    Returns:
%        tri_obj - triangulation object (object)
%        idx - indices of the vertices (indices / vector)

% at the beginning, all the vertices are part of the triangulation
idx = 1:size(tri_obj.Points, 1);

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
[tri_obj, idx] = get_triangulation_remove(tri_obj, idx, idx_rm, false);

% done if nothing to remove
is_done = isempty(idx_rm);

end
