function[reynolds_CL_max] = calc_reynolds_max_CL(taper_ratio, root_chord, mean_chord_reynolds, chord, panel_number, airfoil_database_path, airfoil_name)

mean_aerodynamic_chord = (2/3) * root_chord * (1 + taper_ratio + taper_ratio^2) / (1 + taper_ratio);

airfoil_database = readtable(airfoil_database_path,'Sheet', airfoil_name);

reynolds = rmmissing(airfoil_database.Reynolds);

CL_max = rmmissing(airfoil_database.CL_max);

reynolds_number = zeros(1,panel_number);
reynolds_CL_max = zeros(1,panel_number);

for i = 1:panel_number

    reynolds_number(i) = mean_chord_reynolds * chord(i) * mean_aerodynamic_chord;
    reynolds_CL_max(i) = spline(reynolds, CL_max, reynolds_number(i));

end

