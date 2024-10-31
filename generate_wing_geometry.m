function[x_vortex_1, y_vortex_1, z_vortex_1,x_vortex_2, y_vortex_2, z_vortex_2, x_control, y_control, z_control, chord, twist, aoa_0_dist] = generate_wing_geometry(panel_number, wing_span, root_chord, tip_chord, sweep_angle, geo_twist_angle, dihedral_angle, elliptical_planform, aoa_tip_0, aoa_root_0, aoa, flap_percent, flap_angle, wake_alignment)

    %% Y Control Points
    y_control = zeros(1, panel_number);
    y_control(1) = -(wing_span/2) + (wing_span/(2*panel_number));

    for i = 2:panel_number

        y_control(i) = y_control(i-1) + wing_span / panel_number;

    end

    %% Chord Distribution

    if elliptical_planform ~= 1

        for i = 1:panel_number
            
            if y_control(i) >= -wing_span/2  && y_control(i) < 0 % Left Wing 

                chord(i) = ((root_chord - tip_chord) / (wing_span/2)) * y_control(i) + root_chord;

            else % Right Wing
                
                chord(i) = ((tip_chord - root_chord) / (wing_span/2)) * y_control(i) + root_chord;
              
             
            end
           
        end

    else

        for i = 1:panel_number 

            chord(i) = root_chord * sqrt((1 - (y_control(i) / (wing_span / 2))^2));
           

        end

    end


    %% Geometric Twist

    twist = zeros(1,panel_number);

    for i = 1:panel_number/2

        twist(i) = deg2rad((-2 * geo_twist_angle / wing_span) * y_control(i)); % Compute Twist for Left Wing

    end

    twist(((panel_number/2) + 1):panel_number) = flip(twist(1:panel_number/2)); %Flip for Right Wing


    %% Airfoil Twist

    aoa_0_dist = zeros(1,panel_number);

    for i = ((panel_number/2)+1):panel_number % Airfoil Twist for Right Wing

        aoa_0_dist(i) = ((aoa_tip_0 - aoa_root_0) / (wing_span / 2)) * y_control(i) + aoa_root_0;

    end

    if flap_percent > 0 

        for i = round(((panel_number/2) + 1) + (panel_number/4) * (1 - (flap_percent * 0.01))):round(panel_number - (panel_number/4) * (1 - (flap_percent * 0.01))) % Account for Flap Angle

            aoa_0_dist(i) = aoa_0_dist(i) - flap_angle;

        end
      
    end

    aoa_0_dist(1:panel_number/2) = flip(aoa_0_dist(((panel_number/2)+1):panel_number)); % Flip for Left Wing


    
    %% X Vortex Positions

    x_vortex_1 = zeros(1,panel_number);
    x_vortex_2 = zeros(1,panel_number);

    % Vortex Positions at the Middle of the Wing
    x_vortex_1(panel_number/2+1) = 1/4 * root_chord; 
    x_vortex_2(panel_number/2+1) = x_vortex_1(panel_number/2+1) + (wing_span/panel_number) * tan(deg2rad(sweep_angle));

    for i = ((panel_number/2)+2):panel_number % X Vortex Positions for Right Wing

        x_vortex_1(i) = x_vortex_1(i-1) + (wing_span/panel_number) * tan(deg2rad(sweep_angle));
        x_vortex_2(i) = x_vortex_2(i-1) + (wing_span/panel_number) * tan(deg2rad(sweep_angle));

    end

    % Flip for Left Wing
    x_vortex_1(1:panel_number/2) = flip(x_vortex_2(panel_number/2+1:panel_number));  
    x_vortex_2(1:panel_number/2) = flip(x_vortex_1(panel_number/2+1:panel_number));

    
    %% Y Vortex Positions

    y_vortex_1 = zeros(1,panel_number);
    y_vortex_2 = zeros(1,panel_number);

    y_vortex_1(1) = -wing_span/2;
    y_vortex_2(1) = y_vortex_1(1) + wing_span / panel_number;

    for i = 2:panel_number/2 % Y Vortex Positions for the Left Wing

        y_vortex_1(i) = y_vortex_1(i-1) + wing_span / panel_number;
        y_vortex_2(i) = y_vortex_2(i-1) + wing_span / panel_number;

    end

    % Flip for the Right Wing
    y_vortex_1((panel_number/2+1):panel_number) = -flip(y_vortex_2(1:panel_number/2));
    y_vortex_2((panel_number/2+1):panel_number) = -flip(y_vortex_1(1:panel_number/2));


    %% X Control Points

    x_control = zeros(1,panel_number);

    for i = 1:panel_number

        if wake_alignment == WakeAlignment.Freestream

            x_control(i) = 0.5 * (x_vortex_1(i) + x_vortex_2(i)) + (chord(i)/2) * cosd(aoa - aoa_0_dist(i) - rad2deg(twist(i)));
        
        else

            x_control(i) = 0.5 * (x_vortex_1(i) + x_vortex_2(i)) + (chord(i)/2) * cos(-twist(i));

        end

    end


    %% Z Vortex Positions and Control Points

    z_vortex_1 = zeros(1,panel_number);
    z_vortex_2 = zeros(1,panel_number);
    z_control = zeros(1,panel_number);

    for i = (panel_number/2+1):panel_number 

        % Z Vortex Positions for Right Wing
        z_vortex_1(i) = y_vortex_1(i) * tan(deg2rad(dihedral_angle));
        z_vortex_2(i) = y_vortex_2(i) * tan(deg2rad(dihedral_angle));

        % Z Control Points for Right Wing
        if wake_alignment == WakeAlignment.Freestream

            z_control(i) = y_control(i) * tan(deg2rad(dihedral_angle)) + (chord(i)/2) * sind(aoa - aoa_0_dist(i)  - rad2deg(twist(i)));

        else

            z_control(i) = y_control(i) * tan(deg2rad(dihedral_angle)) + (chord(i)/2) * sin(-twist(i));

        end

    end

   z_vortex_1(1:panel_number/2) = flip(z_vortex_2(panel_number/2+1:panel_number));
   z_vortex_2(1:panel_number/2) = flip(z_vortex_1(panel_number/2+1:panel_number));
   z_control(1:panel_number/2) = flip(z_control(panel_number/2+1:panel_number));

end