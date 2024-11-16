function [LHS_drag_matrix, LHS_drag_matrix_x, LHS_drag_matrix_y, LHS_drag_matrix_z] = calc_induced_drag_matrix(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, sweep_angle, dihedral_angle, panel_number, aoa, aoa_0_dist, wake_alignment)

LHS_drag_matrix_x = zeros(panel_number, panel_number);
LHS_drag_matrix_y = LHS_drag_matrix_x;
LHS_drag_matrix_z = LHS_drag_matrix_x;

x_induced = 0.5 * (x_vortex_1 + x_vortex_2);
y_induced = 0.5 * (y_vortex_1 + y_vortex_2);
z_induced = 0.5 * (z_vortex_1 + z_vortex_2);

if wake_alignment == WakeAlignment.Freestream

    u_inf = [cosd(aoa - aoa_0_dist(panel_number/2)); 0; sind(aoa - aoa_0_dist(panel_number/2))];

else

    u_inf = [1; 0; 0];

end

x_horseshoe = cell(panel_number, panel_number);
x_horseshoe(:,:) = {[0;0;0]};
y_horseshoe_1 = x_horseshoe;
y_horseshoe_2 = x_horseshoe;
LHS_drag_matrix = x_horseshoe;

if sweep_angle == 0 && dihedral_angle == 0

    for i = 1:panel_number

        for j = 1:panel_number

            r_bound_1 = [(x_induced(i) - x_vortex_1(j)); (y_induced(i) - y_vortex_1(j)); (z_induced(i) - z_vortex_1(j))];
            r_bound_2 = [(x_induced(i) - x_vortex_2(j)); (y_induced(i) - y_vortex_2(j)); (z_induced(i) - z_vortex_2(j))];

            y_horseshoe_1{i,j} = cross(u_inf, r_bound_1) / (norm(r_bound_1) * norm(r_bound_1) - dot(u_inf, r_bound_1));
            y_horseshoe_2{i,j} = cross(u_inf, r_bound_2) / (norm(r_bound_2) * norm(r_bound_2) - dot(u_inf, r_bound_2));

            LHS_drag_matrix{i,j} = (1/(4*pi)) * (x_horseshoe{i,j} - y_horseshoe_1{i,j} + y_horseshoe_2{i,j});
            LHS_drag_matrix_x(i,j) = LHS_drag_matrix{i,j}(1);
            LHS_drag_matrix_y(i,j) = LHS_drag_matrix{i,j}(2);
            LHS_drag_matrix_z(i,j) = LHS_drag_matrix{i,j}(3);

        end

    end

else

    for i = 1:panel_number/2

        for j = 1:panel_number/2

            rx_horseshoe = [(x_vortex_2(j + (panel_number/2)) - x_vortex_1(j + (panel_number/2))); ...
                (y_vortex_2(j + (panel_number/2)) - y_vortex_1(j + (panel_number/2))); ...
                (z_vortex_2(j + (panel_number/2)) - z_vortex_1(j + (panel_number/2)))];

            r_bound_1 = [(x_induced(i) - x_vortex_1(j + (panel_number/2)));...
                (y_induced(i) - y_vortex_1(j + (panel_number/2)));...
                (z_induced(i) - z_vortex_1(j + (panel_number/2)))];

            r_bound_2 = [(x_induced(i) - x_vortex_2(j + (panel_number/2)));...
                (y_induced(i) - y_vortex_2(j + (panel_number/2)));...
                (z_induced(i) - z_vortex_2(j + (panel_number/2)))];

            x_horseshoe{i,j + panel_number/2} = (cross(r_bound_1, r_bound_2) / norm(cross(r_bound_1, r_bound_2))) ^ 2 ...
                * (dot(rx_horseshoe, ((r_bound_1 / norm(r_bound_1)) - (r_bound_2 / norm(r_bound_2)))));

        end

    end

    for i = panel_number/2+1:panel_number

        for j = panel_number/2+1:panel_number

            rx_horseshoe = [(x_vortex_2(j - (panel_number/2)) - x_vortex_1(j - (panel_number/2))); ...
                (y_vortex_2(j - (panel_number/2)) - y_vortex_1(j - (panel_number/2))); ...
                (z_vortex_2(j - (panel_number/2)) - z_vortex_1(j - (panel_number/2)))];

            r_bound_1 = [(x_induced(i) - x_vortex_1(j - (panel_number/2)));...
                (y_induced(i) - y_vortex_1(j - (panel_number/2)));...
                (z_induced(i) - z_vortex_1(j - (panel_number/2)))];

            r_bound_2 = [(x_induced(i) - x_vortex_2(j - (panel_number/2)));...
                (y_induced(i) - y_vortex_2(j - (panel_number/2)));...
                (z_induced(i) - z_vortex_2(j - (panel_number/2)))];

            x_horseshoe{i,j - panel_number/2} = (cross(r_bound_1, r_bound_2) / norm(cross(r_bound_1, r_bound_2))) ^ 2 ...
                * (dot(rx_horseshoe, ((r_bound_1 / norm(r_bound_1)) - (r_bound_2 / norm(r_bound_2)))));

        end

    end

    for i = 1:panel_number

        for j = 1:panel_number

            r_bound_1 = [(x_induced(i) - x_vortex_1(j)); (y_induced(i) - y_vortex_1(j)); (z_induced(i) - z_vortex_1(j))];
            r_bound_2 = [(x_induced(i) - x_vortex_2(j)); (y_induced(i) - y_vortex_2(j)); (z_induced(i) - z_vortex_2(j))];

            y_horseshoe_1{i,j} = cross(u_inf, r_bound_1) / (norm(r_bound_1) * norm(r_bound_1) - dot(u_inf, r_bound_1));
            y_horseshoe_2{i,j} = cross(u_inf, r_bound_2) / (norm(r_bound_2) * norm(r_bound_2) - dot(u_inf, r_bound_2));

            LHS_drag_matrix{i,j} = (1/(4*pi)) * (x_horseshoe{i,j} - y_horseshoe_1{i,j} + y_horseshoe_2{i,j});
            LHS_drag_matrix_x(i,j) = LHS_drag_matrix{i,j}(1);
            LHS_drag_matrix_y(i,j) = LHS_drag_matrix{i,j}(2);
            LHS_drag_matrix_z(i,j) = LHS_drag_matrix{i,j}(3);

        end

    end

end








