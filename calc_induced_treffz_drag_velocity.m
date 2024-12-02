function[x_velocity, y_velocity, z_velocity] = calc_induced_treffz_drag_velocity(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, treffz_plane_x_wake, y_control, z_control, panel_number, aoa, aoa_0_dist, wake_alignment, circulation)

LHS_wake_drag_matrix_x = zeros(1,panel_number);
LHS_wake_drag_matrix_y = LHS_wake_drag_matrix_x;
LHS_wake_drag_matrix_z = LHS_wake_drag_matrix_x;

if wake_alignment == WakeAlignment.Freestream

    freestream_velocity_vector = [cosd(aoa - aoa_0_dist(panel_number/2)); 0 ; sind(aoa - aoa_0_dist(panel_number/2))];

else

    freestream_velocity_vector = [1; 0 ; 0];

end

x_horseshoe = cell(panel_number, panel_number);
LHS_wake_drag_matrix = x_horseshoe;
y_horseshoe_1 = x_horseshoe;
y_horseshoe_2 = x_horseshoe;

for i = 1:panel_number

    rx_horseshoe = [(x_vortex_2(i) - x_vortex_1(i)); (y_vortex_2(i) - y_vortex_1(i)); (z_vortex_2(i) - z_vortex_1(i))];
    r_bound_1 = [(treffz_plane_x_wake(1) - x_vortex_1(i)); (y_control(1) - y_vortex_1(i)); (z_control(1) - z_vortex_1(i))];
    r_bound_2 = [(treffz_plane_x_wake(1) - x_vortex_2(i)); (y_control(1) - y_vortex_2(i)); (z_control(1) - z_vortex_2(i))];

    x_horseshoe{1,i} = (cross(r_bound_1, r_bound_2) / norm(cross(r_bound_1, r_bound_2))^2)...
        * (dot(rx_horseshoe, ((r_bound_1 / norm(r_bound_1)) - (r_bound_2 / norm(r_bound_2)))));
    y_horseshoe_1{1,i} = cross(freestream_velocity_vector, r_bound_1) / (norm(r_bound_1) * (norm(r_bound_1) - dot(freestream_velocity_vector, r_bound_1)));
    y_horseshoe_2{1,i} = cross(freestream_velocity_vector, r_bound_2) / (norm(r_bound_2) * (norm(r_bound_2) - dot(freestream_velocity_vector, r_bound_2)));

    LHS_wake_drag_matrix{1,i} = (1/(4*pi)) * (x_horseshoe{1,i} - y_horseshoe_1{1,i} + y_horseshoe_2{1,i});
    LHS_wake_drag_matrix_x(1,i) = LHS_wake_drag_matrix{1,i}(1);
    LHS_wake_drag_matrix_y(1,i) = LHS_wake_drag_matrix{1,i}(2);
    LHS_wake_drag_matrix_z(1,i) = LHS_wake_drag_matrix{1,i}(3);

end

x_velocity = LHS_wake_drag_matrix_x * circulation;
y_velocity = LHS_wake_drag_matrix_y * circulation;
z_velocity = LHS_wake_drag_matrix_z * circulation;