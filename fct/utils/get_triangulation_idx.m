function [tri_new_obj, idx] = get_triangulation_idx(tri_obj, idx, idx_rm)
% Remove triangles from a triangulation.
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
%    The removed vertices are tracked with the indices vector.
%
%    Thomas Guillod.
%    2021 - BSD License.

% get the triangulation data
x = tri_obj.Points(:,1).';
y = tri_obj.Points(:,2).';
tri = tri_obj.ConnectivityList;

% remove the specified triangles
tri(idx_rm,:) = [];

% find which vertices are not part of the new triangulation
[tri, idx_miss] = get_triangulation_clean(tri, idx);

% remove the unused vertices
x(idx_miss) = [];
y(idx_miss) = [];
idx(idx_miss) = [];

% create the new triangulation
tri_new_obj = triangulation(tri, x.', y.');

end
