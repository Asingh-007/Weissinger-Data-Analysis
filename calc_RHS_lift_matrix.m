function [RHS_Matrix] = calc_RHS_lift_matrix(aoa, aoa_0_dist, twist, dihedral_angle, freestream_velocity, panel_number)

RHS_Matrix = zeros(1, panel_number);

for i = 1:panel_number

    RHS_Matrix(i) = -freestream_velocity * sind(aoa - aoa_0_dist(i) + twist(i)) * cosd(dihedral_angle);

end