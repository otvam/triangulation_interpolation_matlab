function [tri_new_obj, idx] = get_triangulation_remove(tri_obj, idx, idx_rm, make_plot)
% Create a Delaunay triangulation and remove ill-conditionned triangles.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        idx - indices of the vertices (indices / vector)
%        idx_rm - indices of the triangles to remove (indices / vector)
%        make_plot - plot the obtained triangulation  (boolean / scalar)
%
%    Returns:
%        tri_new_obj - new triangulation (object)
%        idx - indices of the vertices (indices / vector)
%
%    During the removal of triangles, vertices can also be removed.
%    The removed vertices are tracked can be tracked with the indices vector.
%
%    Thomas Guillod.
%    2021 - BSD License.

% check data
validateattributes(idx, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(idx_rm, {'double'},{'row', 'nonnan', 'real','finite'});
assert(length(idx)==size(tri_obj.Points, 1), 'invalid size of the value vector')

% get the triangulation data
x = tri_obj.Points(:,1).';
y = tri_obj.Points(:,2).';
n_pts = size(tri_obj.Points, 1);
tri = tri_obj.ConnectivityList;

% remove the specified triangles
tri(idx_rm,:) = [];

% find which vertices are not part of the new triangulation
idx_all = 1:n_pts;
idx_tri = unique(tri(:));
idx_miss = setdiff(idx_all, idx_tri);

% indices of the original and new triangulation matrix
idx_old = setdiff(1:length(idx), idx_miss);
idx_new = 1:(length(idx)-length(idx_miss));

% shift the indices of the triangular matrix
tri_new = tri;
for i=1:numel(idx_new)
    tri_new(tri==idx_old(i)) = idx_new(i);
end
tri = tri_new;

% remove the unused vertices
x(idx_miss) = [];
y(idx_miss) = [];
idx(idx_miss) = [];

% check size
if size(tri, 1)==0
    error('empty triangulation')
end

% create the new triangulation
tri_new_obj = triangulation(tri, x.', y.');

% plot the triangulation
if make_plot==true    
    % plot both triangulations
    figure()
    plot_triangulation_geom(tri_obj, 'r')
    hold('on')
    plot_triangulation_geom(tri_new_obj, 'g')
    grid('on')
    axis('equal')
    view(2)
    xlabel('x')
    ylabel('y')
    title('Triangulation / Removed Triangles')

    % plot the triangulation and indices (original axis)
    figure()
    hold('on')
    plot_triangulation_idx(tri_new_obj, 'g')
    grid('on')
    xlabel('x')
    ylabel('y')
    title('Triangulation / Output')
end

end
