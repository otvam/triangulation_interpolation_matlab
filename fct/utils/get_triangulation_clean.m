function [tri, idx_miss] = get_triangulation_clean(tri, idx)
% Remove vertices with are not part of a triangulation.
%
%    Parameters:
%        tri - triangulation matrix (indices / matrix)
%        idx - indices of the vertices (indices / vector)
%
%    Returns:
%        tri - cleaned triangulation matrix (indices / matrix)
%        idx_miss - indices of the orphaned vertices (indices / vector)
%
%    Thomas Guillod.
%    2021 - BSD License.

% find which vertices are not part of the new triangulation
idx_all = 1:length(idx);
idx_tri = unique(tri(:));
idx_miss = setdiff(idx_all, idx_tri);

% indices of the original and new triangulation matrix
idx_old = setdiff(1:length(idx), idx_miss);
idx_new = 1:(length(idx)-length(idx_miss));

% shift the indices of the triangulation matrix
tri_new = tri;
for i=1:numel(idx_new)
    tri_new(tri==idx_old(i)) = idx_new(i);
end
tri = tri_new;

% check that the created triangulation is not empty
if size(tri, 1)==0
    error('empty triangulation')
end

end
