function plot_triangulation_idx(tri_obj, color)
% Plot a triangulation with the triangle index.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        color - color of the edges and faces (string)
%
%    Thomas Guillod.
%    2021 - BSD License.

% plot
triplot(tri_obj, color)

% add the index
for i=1:size(tri_obj.ConnectivityList, 1)
   xy = tri_obj.incenter(i);
   text(xy(1), xy(2), num2str(i), 'HorizontalAlignment', 'center');
end

end
