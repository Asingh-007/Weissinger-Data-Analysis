function[oswald_efficiency_factor] = plot_CD_master(y_control, induced_aoa, aoa_vector, induced_kutta_CD, total_induced_kutta_CD, total_induced_treffz_plane_CD, total_CL, freestream_velocity, aspect_ratio,  wing_span, wing_reference_area, panel_number, aoa_index, array_index, plot_aoa_all, wing_name, export_drag, do_aoa_labels, export_name)


for i = 1:size(aoa_vector,2)

    circulation_0_dist(i) = 2 * freestream_velocity * wing_reference_area * total_CL(i) / (wing_span * pi);

    for j = 1:panel_number

        elliptic_downward_velocity(j) = circulation_0_dist(i) / (2 * wing_span);

    end

    elliptic_aoa{i} = elliptic_downward_velocity./freestream_velocity;

end

 K = (total_CL.^2)' \ total_induced_kutta_CD';
 oswald_efficiency_factor = 1 / (pi * aspect_ratio * K);

f = figure;

if plot_aoa_all

    for i = 1:size(aoa_vector, 2)

     plot_CD(f, y_control, induced_aoa, elliptic_aoa, induced_kutta_CD, total_induced_kutta_CD, total_CL, total_induced_treffz_plane_CD, aspect_ratio, wing_name, aoa_vector, aoa_vector(i), i, do_aoa_labels, true);

    end

else

     plot_CD(f, y_control, induced_aoa, elliptic_aoa, induced_kutta_CD, total_induced_kutta_CD, total_CL, total_induced_treffz_plane_CD, aspect_ratio, wing_name, aoa_vector, aoa_index, array_index, do_aoa_labels, false);

end

subplot(313);
txt = append(['Oswald Efficiency Factor: ' num2str(oswald_efficiency_factor)]);
text(total_CL(round(end/2) - round(end/5)), total_induced_kutta_CD(round(end/2)) + 0.25 *  total_induced_kutta_CD(round(end/2)), txt);

if export_drag

    exportgraphics(f,  strcat(['Output\', export_name,'_Drag_Plot.png']));

end
