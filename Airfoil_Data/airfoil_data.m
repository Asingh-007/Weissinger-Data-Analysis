
function[aoa_0, airfoil_name] = airfoil_data(airfoil_type)

if airfoil_type == 5
   
    %NACA 0012
    aoa_0 = 0;
    airfoil_name = '0012';
    
    else if airfoil == 4       
    %NACA 4418
    aoa_0 = -3.7124;
    airfoil_name = '4418';
    
    else if airfoil == 1     
    %NACA 23012
    aoa_0 = -1.1496;
    airfoil_name = '23012';

    
    else if airfoil == 2      
    %NACA 64210
    aoa_0 = -1.6957;
    airfoil_name = '64210';
   
    else if airfoil == 3
    %NACA 65210
    aoa_0 = -1.7150;
    airfoil_name = '65210';

    
    else if airfoil == 6     
    %NACA 4415
    aoa_0 = -4.2;
    airfoil_name = '4415';

       
        end
        end
        end
        end
end
