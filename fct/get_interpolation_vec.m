function val_vec = get_interpolation_vec(tri_obj, val, x_vec, y_vec)
% Linear interpolation on a triangulation (vector query).
%
%    Parameters:
%        tri_obj - triangulation object (object)
%        val - value of the vertices (float / row vector)
%        x_vec - vector with x query points  (float / row vector)
%        y_vec - vector with y query points  (float / row vector)
%
%    Returns:
%        val_vec - interpolated value (float / row vector)
%
%    The following values are returned:
%        - inside the triangulation: linear interpolation
%        - outside the triangulation: NaN
%
%    Thomas Guillod.
%    2021 - BSD License.

% check query
validateattributes(x_vec, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(y_vec, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert((length(x_vec)==length(y_vec)), 'query vertice vectors have different lengths')
validateattributes(val, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
assert(length(val)==size(tri_obj.Points, 1), 'invalid size of the value vector')

% find in which triangles the query points are located
[ti, bc] = tri_obj.pointLocation(x_vec.', y_vec.');

% interpolate the query points (if any)
if isempty(ti)
    val_vec = [];
else
    % which query points are inside the triangulation
    idx_ok = isfinite(ti);

    % get the barycentric coordinates
    ti_ok = ti(idx_ok,:);
    bc_ok = bc(idx_ok,:);
    
    % get the value at the triangle vertices
    idx_tri_ok = tri_obj.ConnectivityList(ti_ok,:);
    val_tri_ok = val(idx_tri_ok);
    
   % linear interpolation
    val_ok = dot(bc_ok', val_tri_ok')';
    
    % assign the data (NaN for query point located outside the triangulation)
    val_vec = NaN(1, length(idx_ok));
    val_vec(idx_ok) = val_ok;
end

end
