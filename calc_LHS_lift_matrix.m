function[LHS_lift_matrix] = calc_LHS_lift_matrix(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, x_control, y_control, z_control, panel_number, aoa, aoa_0_dist, twist, dihedral_angle, dihedral_twist_correction, wake_alignment)

x_horseshoe = cell(panel_number, panel_number); % Horseshoe Vortices in the x-direction
y_horseshoe_1 = x_horseshoe;                    % Horseshoe Vortices in the y-direction left of the control point
y_horseshoe_2 = x_horseshoe;                    % Horseshoe Vortices in the y-direction right of the control point

LHS_prelimary_matrix = x_horseshoe;
LHS_preliminary_matrix_x = zeros(panel_number, panel_number);
LHS_preliminary_matrix_y = LHS_preliminary_matrix_x;
LHS_preliminary_matrix_z = LHS_preliminary_matrix_x;

LHS_lift_matrix = LHS_preliminary_matrix_x;


if wake_alignment == WakeAlignment.Freestream

    u_inf = [cosd(aoa - aoa_0_dist(panel_number/2)); 0; sind(aoa - aoa_0_dist(panel_number/2))];

else

    u_inf = [1; 0; 0];

end

for i = 1:panel_number

    for j = 1:panel_number

        % Position vectors for Horsesoe Vortices
        rx_horseshoe = [(x_vortex_2(j) - x_vortex_1(j)); (y_vortex_2(j) - y_vortex_1(j)); (z_vortex_2(j) - z_vortex_1(j))];
        r_bound_1 = [(x_control(i) - x_vortex_1(j)); (y_control(i) - y_vortex_1(j)); (z_control(i) - z_vortex_1(j))];
        r_bound_2 = [(x_control(i) - x_vortex_2(j)); (y_control(i) - y_vortex_2(j)); (z_control(i) - z_vortex_2(j))];

        x_horseshoe{i,j} = (cross(r_bound_1, r_bound_2) / norm(cross(r_bound_1, r_bound_2))^2) * ...
            (dot(rx_horseshoe, ((r_bound_1 / norm(r_bound_1)) - (r_bound_2 / norm(r_bound_2)))));
        y_horseshoe_1{i,j} = cross(u_inf, r_bound_1) / (norm(r_bound_1) * (norm(r_bound_1) - dot(u_inf, r_bound_1)));
        y_horseshoe_2{i,j} = cross(u_inf, r_bound_2) / (norm(r_bound_2) * (norm(r_bound_2) - dot(u_inf, r_bound_2)));

        LHS_prelimary_matrix{i,j} = (1/(4*pi)) * (x_horseshoe{i,j} - y_horseshoe_1{i,j} + y_horseshoe_2{i,j});
        LHS_preliminary_matrix_x(i,j) = LHS_prelimary_matrix{i,j}(1);
        LHS_preliminary_matrix_y(i,j) = LHS_prelimary_matrix{i,j}(2);
        LHS_preliminary_matrix_z(i,j) = LHS_prelimary_matrix{i,j}(3);

    end
    
end

if dihedral_twist_correction % Corrects Vortex Coefficients for Twist and Dihedral Angle

    for i = 1:panel_number

        for j = 1:panel_number/2

            LHS_lift_matrix(i,j) = -LHS_preliminary_matrix_x(i,j) * sind(-twist(i)) * cosd(dihedral_angle)...
                - LHS_preliminary_matrix_y(i,j) * cosd(-twist(i)) * sind(dihedral_angle)...
                + LHS_preliminary_matrix_z(i,j) * cosd(-twist(i)) * cosd(dihedral_angle);

        end

        for j = (panel_number/2+1):panel_number

            LHS_lift_matrix(i,j) = -LHS_preliminary_matrix_x(i,j) * sind(twist(i)) * cosd(-dihedral_angle)...
                - LHS_preliminary_matrix_y(i,j) * cosd(twist(i)) * sind(-dihedral_angle)...
                + LHS_preliminary_matrix_z(i,j) * cosd(twist(i)) * cosd(-dihedral_angle);

        end
        
    end

else

    LHS_lift_matrix = LHS_preliminary_matrix_z(:,:);

end






    




