function angle_tri = get_triangulation_angle(tri_obj)
% Get the narrowest angle of the triangles composing a triangulation.
%
%    Parameters:
%        tri_obj - triangulation object (object)
%
%    Returns:
%        angle_tri - narrowest angle of triangles (float / row vector)
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

% get the area of the triangles
area_tri = get_triangulation_area(tri_obj);

% get the vertices vector
p_1 = [x_pts(:,1) y_pts(:,1)].';
p_2 = [x_pts(:,2) y_pts(:,2)].';
p_3 = [x_pts(:,3) y_pts(:,3)].';

% compute the angles
angle_1 = atan2(2.*area_tri, dot(p_2-p_1,p_3-p_1));
angle_2 = atan2(2.*area_tri, dot(p_1-p_2,p_3-p_2));
angle_3 = atan2(2.*area_tri, dot(p_2-p_3,p_1-p_3));

% get the narrowest angle
angle_tri = abs([angle_1 ; angle_2 ; angle_3]);
angle_tri = min(angle_tri, [], 1);

end
