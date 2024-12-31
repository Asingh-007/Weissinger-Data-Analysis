function[CL_non_linear, total_CL_non_linear, aoa_sectional, iteration, non_linear_circulation] = calc_non_linear_CL(CL, LHS_lift_matrix, chord, aoa_0_dist, twist, aoa, wing_span, wing_reference_area, freestream_velocity, panel_number, airfoil_name, dihedral_angle, reynolds_CL_max, airfoil_database_path, decambering_threshold, max_decambering_iterations)

iteration = 0;

delta_CL = ones(1,panel_number);

damping_factor = 0.5;

aoa_sectional = zeros(1, panel_number);
CL_interpl = zeros(1, panel_number);
decambering_angle =  zeros(1, panel_number);
RHS_non_linear_matrix = zeros(1, panel_number);

while max(delta_CL) > decambering_threshold

    for i = 1:panel_number

        aoa_sectional(i) = (CL(i) / (2*pi)) + deg2rad(aoa_0_dist(i));

        CL_interpl(i) = interpolate_CL(rad2deg(aoa_sectional(i)), i, reynolds_CL_max, airfoil_database_path, airfoil_name);

        delta_CL(i) = CL(i) - CL_interpl(i);

        decambering_angle(i) = -(1 / (damping_factor+1)) * (delta_CL(i)) / (2*pi);

        aoa_0_dist(i) = aoa_0_dist(i) - rad2deg(decambering_angle(i));

    end

    delta_CL = abs(delta_CL);

    for i = 1:panel_number

        RHS_non_linear_matrix(i) = -freestream_velocity * sind(aoa - aoa_0_dist(i) + twist(i)) * cosd(dihedral_angle);

    end

    if size(RHS_non_linear_matrix, 1) ~= panel_number

        RHS_non_linear_matrix = RHS_non_linear_matrix';

    end

    non_linear_circulation = LHS_lift_matrix \ RHS_non_linear_matrix;

    non_linear_lift = zeros(1, panel_number);
    CL = zeros(1, panel_number);

    for i = 1:panel_number

        non_linear_lift(i) = 1.225 * freestream_velocity * non_linear_circulation(i);
        CL(i) = non_linear_lift(i) / (0.5 * 1.225 * chord(i) * freestream_velocity^2);

    end

    total_non_linear_lift = 1.225 * freestream_velocity * (wing_span/panel_number) * sum(non_linear_circulation);
    total_CL_non_linear = total_non_linear_lift / (0.5 * 1.225 * wing_reference_area * freestream_velocity^2);

    iteration = iteration + 1;

    if iteration > max_decambering_iterations

        delta_CL = 0;

    end

end

CL_non_linear = CL;





