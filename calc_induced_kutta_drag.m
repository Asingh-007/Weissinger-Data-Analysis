function [induced_aoa, induced_drag, induced_CD, total_induced_drag, total_induced_CD] = calc_induced_kutta_drag(aoa_vector, chord, LHS_drag_matrix_z, circulation, mach, freestream_velocity, wing_span, wing_reference_area, panel_number)

for i = 1:size(aoa_vector,2)

    downward_induced_velocity{i} = LHS_drag_matrix_z{i} * circulation{i};
    induced_aoa{i} = -downward_induced_velocity{i} / freestream_velocity;
    induced_drag{i} = -1.225 * freestream_velocity * downward_induced_velocity{i}.* circulation{i} / sqrt(1-mach^2);
    
    for j = 1:panel_number

        induced_CD{i}(j) = induced_drag{i}(j)./ (0.5 * 1.225 * chord(j) * freestream_velocity^2);

    end

    total_induced_drag(i) = -1.225 * freestream_velocity * (wing_span / panel_number) * sum(downward_induced_velocity{i}.* circulation{i}) / sqrt(1-mach^2);
    total_induced_CD(i) = total_induced_drag(i) / (0.5 * 1.225 * wing_reference_area * freestream_velocity^2);

end