
function[aoa_0, airfoil_name] = aoa_zero_regression(airfoil_path)


    [~,filename] = fileparts(airfoil_path);

    filename_parts = split(filename, '_');

    airfoil_name = filename_parts(1);

    airfoil = readtable(airfoil_path,MissingRule="omitrow");

    c1 = airfoil{1,"Var1"};
    c2 = airfoil{1,"Var2"};

    syms x;

    f(x) = c1*x + c2;

    g = finverse(f);

    aoa_0 = double(g(0));


end