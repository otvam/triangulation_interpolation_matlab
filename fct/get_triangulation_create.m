function [tri_obj, idx] = get_triangulation_create(x, y, scale, tolerance, make_plot)
% Create a Delaunay triangulation with alpha shapes.
%
%    Parameters:
%        x - vertices for the x axis  (float / row vector)
%        y - vertices for the y axis  (float / row vector)
%        scale - streching factors for the triangulation (struct)
%            scale.scale_x - stretching factor in the x direction (float / scalar)
%            scale.scale_y - stretching factor in the y direction (float / scalar)
%        tolerance - parameters for detecting ill-conditioned triangles (struct)
%            tolerance.alpha = 0.2; % alpha radius (see alphaShape, 'Inf' for full triangulation)
%            tolerance.hole_threshold = 0; % maximum interior holes (see alphaShape, '0' for desactivating)
%            tolerance.region_threshold = 0; % maximum regions (see alphaShape, '0' for desactivating)
%        make_plot - plot the obtained triangulation (boolean / scalar)
%
%    Returns:
%        tri_obj - created triangulation (object)
%        idx - indices of the vertices (indices / vector)
%
%    Use the alpha shapes for removing ill-conditioned triangles:
%        - the alpha radius of the resulting shape can be controlled
%        - the maximum hole size can be controlled.
%        - the maximum region size can be controlled.
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
validateattributes(x, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(y, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert((length(x)==length(y)), 'vertice vectors have different lengths')
assert((length(x)>=3)&&(length(y)>=3), 'at least three vertices are required')

% extract tolerance
alpha = tolerance.alpha;
hole_threshold = tolerance.hole_threshold;
region_threshold = tolerance.region_threshold;

% normalize the vertices
[x_scale, y_scale] = get_triangulation_scale(x, y, scale);

% create the complete triangulation
tri_raw_obj = delaunayTriangulation(x_scale.', y_scale.');

% create the reduced triangulation
shp_obj = alphaShape(x_scale.', y_scale.', alpha, 'HoleThreshold', hole_threshold, 'RegionThreshold', region_threshold);
tri = shp_obj.alphaTriangulation;

% get the vertice index
idx = 1:size(shp_obj.Points, 1);

% clean the unused vertices
[tri, idx_miss] = get_triangulation_clean(tri, idx);
idx(idx_miss) = [];
x_scale(idx_miss) = [];
y_scale(idx_miss) = [];
x(idx_miss) = [];
y(idx_miss) = [];

% create the final triangulation (scaled)
tri_filter_obj = triangulation(tri, x_scale.', y_scale.');

% create the final triangulation (original)
tri_obj = triangulation(tri, x.', y.');

% plot the triangulation
get_triangulation_plot(tri_raw_obj, tri_filter_obj, make_plot)

end

