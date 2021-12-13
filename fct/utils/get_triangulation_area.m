function area_tri = get_triangulation_area(tri_obj)
% Get the area of the triangles composing a triangulation.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%
%    Returns:
%        area_tri - area of the triangles (float / row vector)
%
%    Thomas Guillod.
%    2021 - BSD License.

% get the triangulation data
x = tri_obj.Points(:,1).';
y = tri_obj.Points(:,2).';
tri = tri_obj.ConnectivityList;

% get the coordinate of the triangle
x_pts = x(tri);
y_pts = y(tri);

% get the vertices vector
p_1 = [x_pts(:,1) y_pts(:,1)].';
p_2 = [x_pts(:,2) y_pts(:,2)].';
p_3 = [x_pts(:,3) y_pts(:,3)].';

% get the direction vector
p_21 = [p_2-p_1 ; zeros(1, size(tri, 1))];
p_31 = [p_3-p_1 ; zeros(1, size(tri, 1))];

% compute the cross product
value = cross(p_21, p_31);
value = vecnorm(value, 2, 1);

% get the area
area_tri = value./2;

end
