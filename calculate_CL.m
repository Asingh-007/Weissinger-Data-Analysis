function [circulation, lift_distribution, cl_distribution, total_lift_distribution, total_cl_distribution] = calculate_CL(aoa_vector, LHS_Matrix, RHS_Matrix, freestream_velocity, panel_number, mach, chord, wing_reference_area, wing_span)

circulation = cell(1,size(aoa_vector,2));
lift_distribution = cell(1,size(aoa_vector,2));
cl_distribution = cell(1,size(aoa_vector,2));
total_lift_distribution = zeros(1,size(aoa_vector,2));
total_cl_distribution = zeros(1,size(aoa_vector,2));

for i = 1:size(aoa_vector,2)

    circulation{i} = LHS_Matrix{i} \ RHS_Matrix{i}';

    for j = 1:panel_number

        lift_distribution{i}(j) = 1.225 * freestream_velocity * circulation{i}(j) / sqrt(1-mach^2);
        cl_distribution{i}(j) = lift_distribution{i}(j) / (0.5 * 1.225 * chord(i) * freestream_velocity^2);

    end

    total_lift_distribution(i) = 1.225 * freestream_velocity * (wing_span / panel_number) * sum(circulation{i}/ sqrt(1-mach^2));
    total_cl_distribution(i) = total_lift_distribution(i) / (0.5 * 1.225 * wing_reference_area * freestream_velocity^2);

end



