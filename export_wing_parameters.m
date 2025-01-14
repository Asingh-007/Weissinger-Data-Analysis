function export_wing_parameters(wing_parameters, export_name)

wing_parameter_labels = {'Aspect Ratio: ', 'Taper Ratio: ', 'Geometric Twist Angle [°]: ', 'Sweep Angle [°]: ', 'Dihedral Angle [°]: ', 'Flap Percent: ', 'Flap Angle [°]: ', 'Tip Angle of Attack [°] for Zero Lift: ', 'Root Angle of Attack [°] for Zero Lift: ', 'Root Chord [m]: '};
wing_parameter_labels = string(wing_parameter_labels);
wing_parameter_labels = transpose(wing_parameter_labels);

file_name = append(['Output\', export_name,'.xlsx']);
writematrix(wing_parameter_labels, file_name, 'Sheet', 1, 'Range','A1');
writematrix(wing_parameters, file_name, 'Sheet', 1, 'Range','B1');

