
function[aoa_0, airfoil_name] = aoa_zero_database(af_data_name, airfoil_database_path)

    airfoil_database = readtable(airfoil_database_path,'Sheet',af_data_name);

    aoa_0 = rmmissing(airfoil_database.AOA_zero);

    airfoil_name = af_data_name;

end