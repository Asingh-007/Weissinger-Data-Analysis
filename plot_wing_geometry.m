function plot_wing_geometry(panel_number, wing_span, root_chord, tip_chord, geo_twist_angle, twist, chord, x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, x_control, y_control, z_control, aoa_index, aoa_0_dist, wake_alignment, wake_length, run_name, export_geometry)

y_vortex_3 = y_vortex_1;
y_vortex_4 = y_vortex_2;

x_vortex_3 = x_vortex_1 + wake_length;
x_vortex_4 = x_vortex_2 + wake_length;

if wake_alignment == WakeAlignment.Freestream

    for i = 1:panel_number
        
           z_vortex_3(i) = z_vortex_1(i) + wake_length.*sind(aoa_index - aoa_0_dist(i));
           z_vortex_4(i) = z_vortex_2(i) + wake_length.*sind(aoa_index - aoa_0_dist(i));
         
    end

else

    z_vortex_3 = z_vortex_1;
    z_vortex_4 = z_vortex_2;

end

%% Trailing and Leading Edges

x_leading_edge = [(x_vortex_1(1) - (1/4)* tip_chord * cosd(twist(1)))...
                   (x_control(1:panel_number/2) - (3/4) * chord(1:panel_number/2).*cosd(twist(1:panel_number/2)))...
                   0 (x_control((panel_number/2+1):panel_number) - (3/4) * chord((panel_number/2+1):panel_number).*cosd(twist((panel_number/2+1):panel_number)))...
                   (x_vortex_2(end) - (1/4) * tip_chord * cosd(twist(end)))];

x_trailing_edge = x_leading_edge + [(tip_chord * cosd(geo_twist_angle)) (chord(1:panel_number/2).*cosd(twist(1:panel_number/2))) root_chord...
                                    (chord((panel_number/2+1):panel_number).*cosd(twist((panel_number/2+1):panel_number))) (tip_chord * cosd(geo_twist_angle))];

y_leading_edge = [y_vortex_1(1) y_control(1:panel_number/2) 0 y_control((panel_number/2+1):panel_number) y_vortex_2(end)];
y_trailing_edge = y_leading_edge;

z_leading_edge = zeros(1, size(x_leading_edge,2));
z_trailing_edge = z_leading_edge;
z_leading_edge(1) = (z_vortex_1(1) + (1/4) * tip_chord * sind(geo_twist_angle));
z_leading_edge(end) = (z_vortex_2(end) + (1/4) * tip_chord * sind(geo_twist_angle));
z_leading_edge(panel_number/2+2) = 0;

for i = 2:(panel_number/2+1) % Z Leading Edge for the Right Wing

    if wake_alignment == WakeAlignment.Freestream 

        z_leading_edge(i) = z_control(i-1) + (3/4) * chord(i-1) * sind(twist(i-1)) + (chord(i-1)/2) * (sind(-twist(i-1)) - sind(aoa_index - aoa_0_dist(i-1) - twist(i-1)));

    else

         z_leading_edge(i) = z_control(i-1) + (3/4) * chord(i-1) * sind(twist(i-1));

    end

end

z_leading_edge((panel_number/2+3):(panel_number+2)) = flip(z_leading_edge(2:(panel_number/2+1))); % Flip for Left Wing

z_trailing_edge(1) = (z_vortex_1(1) - (3/4) * tip_chord * sind(geo_twist_angle));
z_trailing_edge(end) = (z_vortex_2(end) - (3/4) * tip_chord * sind(geo_twist_angle));
z_trailing_edge(panel_number/2+2) = 0;

for i = 2:(panel_number/2+1) % Z Trailing Edge for the Right Wing

    if wake_alignment == WakeAlignment.Freestream 

        z_trailing_edge(i) = z_control(i-1) - (1/4) * chord(i-1) * sind(twist(i-1)) + (chord(i-1)/2) * (sind(-twist(i-1)) - sind(aoa_index - aoa_0_dist(i-1)  - twist(i-1)));

    else

        z_trailing_edge(i) = z_control(i-1) - (1/4) * chord(i-1) * sind(twist(i-1));

    end

end

z_trailing_edge((panel_number/2+3):(panel_number+2)) = flip(z_trailing_edge(2:(panel_number/2+1)));

%% Plot Wing Geometry

f = figure;

subplot(121);
plot3([x_trailing_edge flip(x_leading_edge) x_trailing_edge(1)], [y_trailing_edge flip(y_leading_edge) y_trailing_edge(1)], [z_trailing_edge flip(z_leading_edge) z_trailing_edge(1)]); grid;
xlabel('X Axis (Meters)');
ylabel('Y Axis (Meters)');
zlabel('Z Axis (Meters)');
wing_plot_title = append([run_name, ' Geometry']);
title(wing_plot_title);
xlim([-2* wing_span/2 2*wing_span/2]);
ylim([-wing_span/2 wing_span/2]);
zlim([-wing_span/2 wing_span/2]);

subplot(122);
plot3([x_trailing_edge flip(x_leading_edge) x_trailing_edge(1)], [y_trailing_edge flip(y_leading_edge) y_trailing_edge(1)], [z_trailing_edge flip(z_leading_edge) z_trailing_edge(1)]); grid;
hold on
for i=1:panel_number
    plot3([x_vortex_3(i) x_vortex_1(i) x_vortex_2(i) x_vortex_4(i) ], [y_vortex_3(i) y_vortex_1(i) y_vortex_2(i) y_vortex_4(i)], [z_vortex_3(i) z_vortex_1(i) z_vortex_2(i) z_vortex_4(i)],'k');
end

plot3(x_control, y_control, z_control, 'r.'); 
xlabel('X Axis (Meters)');
ylabel('Y Axis (Meters)');
zlabel('Z Axis (Meters)');
wake_plot_title = append([run_name,' Control Points and Wake at ',  num2str(aoa_index) , '° Angle of Attack']);
title(wake_plot_title);
xlim([-wing_span wing_span]);
ylim([-wing_span/2 wing_span/2]);
zlim([-wing_span/2 wing_span/2]);

set(f,'Position',[0 0 2000 1000]);
set(f,'PaperSize',[2 1],'PaperPosition',[0 0 2 1]); 

if export_geometry

    exportgraphics(f, strcat(['Output\', run_name, '_Geometry_Plot.png']));

end

