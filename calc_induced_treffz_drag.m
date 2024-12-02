function[total_induced_treffz_plane_drag, total_induced_treffz_plane_CD] = calc_induced_treffz_drag(circulation, z_velocity, wing_span, panel_number, mach, wing_reference_area, freestream_velocity)

total_induced_treffz_plane_drag = -0.5 * 1.225 * sum(circulation.*z_velocity' * (wing_span / panel_number) / sqrt(1-mach^2));
total_induced_treffz_plane_CD = total_induced_treffz_plane_drag / (0.5 * 1.225 * wing_reference_area * freestream_velocity^2);