function goal = max_CL(var)

global panel_number aoa_vector elliptical_planform wake_alignment dihedral_twist_correction non_linear_correction compressibility_correction freestream_velocity airfoil_name mean_chord_reynolds airfoil_database_path decambering_threshold max_decambering_iterations

aspect_ratio = var(1);
taper_ratio = var(2);
geo_twist_angle = var(3);
sweep_angle = var(4);
dihedral_angle = var(5);
flap_percent = var(6);
flap_angle = var(7);
aoa_tip_0 = var(8);
aoa_root_0 = var(9);
root_chord = var(10);

mach = 0.8;

if compressibility_correction == false
    mach = 0.0;
end

if elliptical_planform                               % Tip Chord is zero if wing is elliptical

    tip_chord = 0;

else

    tip_chord = taper_ratio * root_chord;

end

wing_span = cosd(dihedral_angle) * aspect_ratio * root_chord * (1 + taper_ratio)/2;

wing_reference_area = (1+taper_ratio) * root_chord * wing_span/2;

x_control = cell(1, size(aoa_vector, 2));
y_control = cell(1, size(aoa_vector, 2));
z_control = cell(1, size(aoa_vector, 2));

for i = 1:size(aoa_vector, 2)

    [x_vortex_1, y_vortex_1, z_vortex_1,x_vortex_2, y_vortex_2, z_vortex_2, x_control{i}, y_control{i}, z_control{i}, chord, twist, aoa_0_dist] = generate_wing_geometry(panel_number, wing_span, root_chord, tip_chord, sweep_angle, geo_twist_angle, dihedral_angle, elliptical_planform, aoa_tip_0, aoa_root_0, aoa_vector(i), flap_percent, flap_angle, wake_alignment);

end

LHS_lift_matrix = cell(1, size(aoa_vector,2));

for i = 1:size(aoa_vector, 2)

    LHS_lift_matrix{i}  = calc_LHS_lift_matrix(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, x_control{i}, y_control{i}, z_control{i}, panel_number, aoa_vector(i), aoa_0_dist, twist, dihedral_angle, dihedral_twist_correction, wake_alignment);

end

RHS_lift_matrix = cell(1, size(aoa_vector,2));

for i = 1:size(aoa_vector, 2)

    RHS_lift_matrix{i} = calc_RHS_lift_matrix(aoa_vector(i), aoa_0_dist, twist, dihedral_angle, freestream_velocity, panel_number);

end

[~, ~, CL, total_CL] = calc_CL(aoa_vector, LHS_lift_matrix, RHS_lift_matrix, freestream_velocity, panel_number, mach, chord, wing_reference_area, wing_span);


if non_linear_correction && ~compressibility_correction

    [reynolds_CL_max] = calc_reynolds_max_CL(taper_ratio, root_chord, mean_chord_reynolds, chord, panel_number, airfoil_database_path, airfoil_name);

    non_linear_circulation = cell(1, size(aoa_vector, 2));
    CL_non_linear = cell(1, size(aoa_vector, 2));
    aoa_sectional = cell(1, size(aoa_vector, 2));
    decambering_angle = cell(1, size(aoa_vector, 2));
    total_CL_non_linear = zeros(1, size(aoa_vector, 2));
    iteration = zeros(1, size(aoa_vector, 2));

     for i = 1:size(aoa_vector,2)
    
            [CL_non_linear{i}, total_CL_non_linear(i), aoa_sectional{i}, iteration(i), non_linear_circulation{i}] = calc_non_linear_CL(CL{i}, LHS_lift_matrix{i}, chord, aoa_0_dist, twist, aoa_vector(i), wing_span, wing_reference_area, freestream_velocity, panel_number, airfoil_name, dihedral_angle, reynolds_CL_max, airfoil_database_path, decambering_threshold, max_decambering_iterations);
    
            decambering_angle{i} = -(CL_non_linear{i} - CL{i}) / (2 * pi);
    
     end

     goal = -max(total_CL_non_linear);

else

     goal = -max(total_CL);

end


