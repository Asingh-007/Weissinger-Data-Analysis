function [CL_aoa] = plot_CL_master(y_control, lift, CL, total_CL, aoa_vector, freestream_velocity, wing_reference_area, wing_span, panel_number, array_index, wing_name, aoa_index, export_lift, plot_aoa_all)


% Prandt Lifting Line Theory 
elliptic_lift = cell(1, size(aoa_vector,2));

CL_aoa = (total_CL(end) - total_CL(1)) / (aoa_vector(end) - aoa_vector(1));

for i = 1:size(aoa_vector, 2)

    circulation_0(i) = 2 * freestream_velocity * wing_reference_area * total_CL(i) / (wing_span * pi);

    
    for j = ((panel_number/2)+1):panel_number

        elliptic_lift{i}(j) = 1.225 * freestream_velocity * circulation_0(i) * sqrt(1 - (2 * y_control(j) / wing_span)^2);

    end

    elliptic_lift{i}(1:panel_number/2) = flip(elliptic_lift{i}(((panel_number/2)+1):panel_number));

end


f = figure;

if plot_aoa_all
    
    for i = 1:size(aoa_vector, 2)

        plot_CL(f, y_control, CL, wing_name, aoa_vector(i), lift, elliptic_lift, i, CL_aoa, aoa_vector, total_CL, true);

    end

else    

   plot_CL(f, y_control, CL, wing_name, aoa_index, lift, elliptic_lift, array_index, CL_aoa, aoa_vector, total_CL, false);

end


if export_lift

    exportgraphics(f,  strcat(['Output\', wing_name,'_Lift_Plot.png']));

end



