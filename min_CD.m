function area_curve = min_CD(var)

global panel_number aoa_vector root_chord elliptical_planform wake_alignment dihedral_twist_correction freestream_velocity

aspect_ratio = var(1);
taper_ratio = var(2);
geo_twist_angle = var(3);
sweep_angle = var(4);
dihedral_angle = var(5);
flap_percent = var(6);
flap_angle = var(7);
aoa_tip_0 = var(8);
aoa_root_0 = var(9);

mach = 0;

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

[circulation, ~, ~, total_CL] = calc_CL(aoa_vector, LHS_lift_matrix, RHS_lift_matrix, freestream_velocity, panel_number, mach, chord, wing_reference_area, wing_span);

LHS_kutta_drag_matrix_z = cell(1, size(aoa_vector,2));

for i = 1:size(aoa_vector, 2)  

    [~, ~, LHS_kutta_drag_matrix_z{i}] = calc_induced_kutta_drag_matrix(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, sweep_angle, dihedral_angle, panel_number, aoa_vector(1), aoa_0_dist, wake_alignment);

end

treffz_plane_x_wake = cell(1, size(aoa_vector,2));
z_velocity = cell(1, size(aoa_vector,2));

total_induced_treffz_plane_drag = zeros(1,size(aoa_vector, 2));
total_induced_treffz_plane_CD = zeros(1,size(aoa_vector, 2));

for i = 1:size(aoa_vector,2)

    treffz_plane_x_wake{i} = 0 * x_control{i} + 100 * wing_span;

    for j = 1:panel_number

        [~, ~, z_velocity{i}(j)] = calc_induced_treffz_drag_velocity(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, treffz_plane_x_wake{i}(j), y_control{i}(j), z_control{i}(j), panel_number, aoa_vector(i), aoa_0_dist, wake_alignment, circulation{i});

    end

    [total_induced_treffz_plane_drag(i), total_induced_treffz_plane_CD(i)] = calc_induced_treffz_drag(circulation{i}, z_velocity{i}, wing_span, panel_number, mach, wing_reference_area, freestream_velocity);

end

coefficient = polyfit(total_CL, total_induced_treffz_plane_CD, 2);
x = 0:0.05:1;
y = coefficient(1)*x.^2 + coefficient(2)*x + coefficient(3);

area_curve = trapz(x,y);
