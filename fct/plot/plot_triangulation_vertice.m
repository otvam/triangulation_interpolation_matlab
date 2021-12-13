function plot_triangulation_vertice(tri_obj, val)
% Plot a triangulation with given vertice color values.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        val - color value of the vertices (float / row vector)
%
%    Thomas Guillod.
%    2021 - BSD License.

% check value
validateattributes(val, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert(length(val)==size(tri_obj.Points, 1), 'invalid size of the value vector')

% get the triangulation data
x = tri_obj.Points(:,1).';
y = tri_obj.Points(:,2).';
tri = tri_obj.ConnectivityList;

% plot
trisurf(tri, x, y, val, val);

end
