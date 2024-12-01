function [circulation, lift, CL, total_CL] = calc_CL(aoa_vector, LHS_lift_matrix, RHS_lift_matrix, freestream_velocity, panel_number, mach, chord, wing_reference_area, wing_span)

circulation = cell(1,size(aoa_vector,2));
lift = cell(1,size(aoa_vector,2));
CL = cell(1,size(aoa_vector,2));
total_lift = zeros(1,size(aoa_vector,2));
total_CL = zeros(1,size(aoa_vector,2));

for i = 1:size(aoa_vector,2)

    circulation{i} = LHS_lift_matrix{i} \ RHS_lift_matrix{i}';

    for j = 1:panel_number

        lift{i}(j) = 1.225 * freestream_velocity * circulation{i}(j) / sqrt(1-mach^2);
        CL{i}(j) = lift{i}(j) / (0.5 * 1.225 * chord(i) * freestream_velocity^2);

    end

    total_lift(i) = 1.225 * freestream_velocity * (wing_span / panel_number) * sum(circulation{i}/ sqrt(1-mach^2));
    total_CL(i) = total_lift(i) / (0.5 * 1.225 * wing_reference_area * freestream_velocity^2);

end



