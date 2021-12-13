function get_triangulation_plot(tri_raw_obj, tri_filter_obj, tri_obj, make_plot)
% Plot the triangulation before/after removal of ill-conditioned triangles.
%
%    Parameters:
%        tri_raw_obj - original (scaled axis) triangulation object (object)
%        tri_filter_obj - updated (scaled axis) triangulation object (object)
%        tri_obj - updated (original axis) triangulation object (object)
%        make_plot - plot the obtained triangulation (boolean / scalar)
%
%    Thomas Guillod.
%    2021 - BSD License.

% plot the triangulation
if make_plot==true
    % get the angles
    angle_tri = get_triangulation_angle(tri_raw_obj);
    angle_tri = rad2deg(angle_tri);
    
    % plot the angles (scaled axis)
    figure()
    plot_triangulation_face(tri_raw_obj, angle_tri)
    grid('on')
    axis('equal')
    view(2)
    xlabel('x / scaled')
    ylabel('y / scaled')
    h = colorbar();
    set(get(h, 'label'), 'string', 'Angle (deg)');
    title('Triangulation / Angle')
    
    % plot both triangulations (scaled axis)
    figure()
    plot_triangulation_geom(tri_raw_obj, 'r')
    hold('on')
    plot_triangulation_geom(tri_filter_obj, 'g')
    grid('on')
    axis('equal')
    view(2)
    xlabel('x / scaled')
    ylabel('y / scaled')
    title('Triangulation / Removed Triangles')

    % plot the triangulation and indices (original axis)
    figure()
    hold('on')
    plot_triangulation_idx(tri_obj, 'g')
    grid('on')
    xlabel('x')
    ylabel('y')
    title('Triangulation / Output')
end

end