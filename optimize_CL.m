function[wing_parameters] = optimize_CL(aspect_ratio_interval,  taper_ratio_interval, geo_twist_angle_interval, sweep_angle_interval, dihedral_angle_interval, flap_percent_interval, flap_angle_interval, aoa_tip_0_interval, aoa_root_0_interval, root_chord_interval, max_iterations, aspect_ratio, taper_ratio, geo_twist_angle, sweep_angle, dihedral_angle, flap_percent, flap_angle, aoa_tip_0, aoa_root_0, root_chord, export_optimization)

options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval, 'MaxIter', max_iterations,'TolFun', 1e-4, 'TolX', 1e-2);

[wing_parameters, max_CL] = fminsearchbnd(@max_CL, [aspect_ratio; taper_ratio; geo_twist_angle; sweep_angle; dihedral_angle; flap_percent; flap_angle; aoa_tip_0; aoa_root_0; root_chord],...
        [aspect_ratio_interval(1); taper_ratio_interval(1); geo_twist_angle_interval(1); sweep_angle_interval(1); dihedral_angle_interval(1); flap_percent_interval(1); flap_angle_interval(1); aoa_tip_0_interval(1); aoa_root_0_interval(1); root_chord_interval(1)],...
        [aspect_ratio_interval(2); taper_ratio_interval(2); geo_twist_angle_interval(2); sweep_angle_interval(2); dihedral_angle_interval(2); flap_percent_interval(2); flap_angle_interval(2); aoa_tip_0_interval(2); aoa_root_0_interval(2); root_chord_interval(2)], options);

wing_parameter_labels = {'Aspect Ratio: ', 'Taper Ratio: ', 'Geometric Twist Angle [°]: ', 'Sweep Angle [°]: ', 'Dihedral Angle [°]: ', 'Flap Percent: ', 'Flap Angle [°]: ', 'Tip Angle of Attack [°] for Zero Lift: ', 'Root Angle of Attack [°] for Zero Lift: ', 'Root Chord [m]: '};
wing_parameter_labels = string(wing_parameter_labels);
wing_parameter_labels = transpose(wing_parameter_labels);

labeled_wing_parameters = wing_parameter_labels;

for i = 1:size(wing_parameters)

    labeled_wing_parameters(i) = append(wing_parameter_labels(i), num2str(wing_parameters(i)));

end

disp(labeled_wing_parameters);

if export_optimization

    optimize_file_name = append(['Optimize_CL_Run_', num2str(randi([1000000000 9999999999],1))]);
    export_wing_parameters(wing_parameters, optimize_file_name);

end