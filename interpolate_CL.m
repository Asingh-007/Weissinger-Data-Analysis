function[CL_interpl] = interpolate_CL(aoa_sectional, i, reynolds_CL_max, airfoil_database_path, airfoil_name)

airfoil_database = readtable(airfoil_database_path,'Sheet', airfoil_name);

aoa_exp = rmmissing(airfoil_database.AOA_exp);

CL_exp = rmmissing(airfoil_database.CL_exp);

delta_CL = reynolds_CL_max(i) - max(CL_exp);

delta_aoa = delta_CL / ((CL_exp(size(CL_exp, 1)/2 + 1) - CL_exp(size(CL_exp, 1)/2)) /...
    (aoa_exp(size(aoa_exp, 1)/2 + 1) - aoa_exp(size(aoa_exp, 1)/2)));


aoa_exp = aoa_exp + delta_aoa;
CL_exp = CL_exp + delta_CL;


max(CL_exp);

if aoa_sectional > max(aoa_exp)

    aoa_sectional = max(aoa_exp);

end

CL_interpl = interp1(aoa_exp, CL_exp, aoa_sectional);