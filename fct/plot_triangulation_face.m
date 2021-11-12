function plot_triangulation_face(tri_obj, val)
% Plot a triangulation with given face color values .
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        val - color value of the faces (float / row vector)
%
%    Thomas Guillod.
%    2021 - BSD License.

% check value
validateattributes(val, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert(length(val)==size(tri_obj.ConnectivityList, 1), 'invalid size of the value vector')

% get the triangulation data
x = tri_obj.Points(:,1).';
y = tri_obj.Points(:,2).';
n_pts = size(tri_obj.Points, 1);
tri = tri_obj.ConnectivityList;

% plot
z = zeros(1, n_pts);
hh = trisurf(tri, x, y, z, z);
set(hh, 'FaceColor', 'flat')
set(hh, 'CDataMapping', 'scaled')
set(hh, 'FaceVertexCData', val.')

end
