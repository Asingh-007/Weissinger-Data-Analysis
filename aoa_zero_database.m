
function[aoa_0, airfoil_name] = aoa_zero_database(af_data_name, airfoil_database_path)

    airfoil_database = readtable(airfoil_database_path);

    row_number = find(strcmp(airfoil_database.Airfoil, af_data_name));

    aoa_0 = airfoil_database{row_number, 'AOA_Zero'}; 

    airfoil_name = af_data_name;


end