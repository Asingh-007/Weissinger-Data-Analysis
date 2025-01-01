function plot_CL_non_linear_master(y_control, CL, CL_non_linear, total_CL, total_CL_non_linear, aoa_vector, aoa_sectional, decambering_angle, array_index, wing_name, export_lift, plot_aoa_all, do_aoa_labels, export_name, do_non_linear_correction_for_all_aoa )

f = figure;

if plot_aoa_all && do_non_linear_correction_for_all_aoa

    for i = 1:size(aoa_vector, 2)

        plot_CL_non_linear(f, y_control, CL, CL_non_linear, total_CL, total_CL_non_linear, aoa_vector, aoa_sectional, decambering_angle, i, wing_name, do_aoa_labels, true);

    end

else

    plot_CL_non_linear(f, y_control, CL, CL_non_linear, total_CL, total_CL_non_linear, aoa_vector, aoa_sectional, decambering_angle, array_index, wing_name, do_aoa_labels, false);

end

if export_lift

    exportgraphics(f,  strcat(['Output\', export_name,'_Non_Linear_Lift_Plot.png']));

end



