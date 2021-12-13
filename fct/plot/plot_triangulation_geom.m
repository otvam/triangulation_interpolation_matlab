function plot_triangulation_geom(tri_obj, color)
% Plot a triangulation (edges and faces).
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        color - color of the edges and faces (string)
%
%    Thomas Guillod.
%    2021 - BSD License.

% get the triangulation data
x = tri_obj.Points(:,1).';
y = tri_obj.Points(:,2).';
n_pts = size(tri_obj.Points, 1);
tri = tri_obj.ConnectivityList;

% plot
z = zeros(1, n_pts);
trisurf(tri, x, y, z, 'FaceColor', color, 'FaceAlpha', 0.1, 'EdgeColor', color)

end
