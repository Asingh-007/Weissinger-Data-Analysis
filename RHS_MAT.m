function [RHS_matrix] = RHS_MAT(aoa, aoa_0_dist, twist, dihedral_angle, freestream_velocity, panel_number)

RHS_matrix = zeros(1, panel_number);

for i = 1:panel_number

    RHS_matrix(i) = -freestream_velocity * sind(aoa - aoa_0_dist(i) + twist(i)) * cosd(dihedral_angle);

end