

function[ x_mesh, y_mesh, z_mesh] = plot_wake_master(x_grid_number, y_grid_number, z_grid_number, wing_span, wake_alignment, aoa_vector, x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, panel_number, aoa_0_dist, circulation, freestream_velocity, aoa_index, array_index, wing_name, export_name, export_wake)

f = figure;

x_wake = 10 * wing_span;

if wake_alignment == WakeAlignment.Freestream

    z_interval = [(-wing_span/8 + x_wake * sind(max(aoa_vector))); (wing_span/8 + x_wake * sind(max(aoa_vector)))];

else

    z_interval = [-wing_span/8; wing_span/8];

end

y_interval = [(-1.2 * wing_span/2); (1.2 * wing_span/2)];

x_interval = [-x_wake/64 ; x_wake/8];

y_grid = linspace(y_interval(1), y_interval(2), y_grid_number)';
z_grid = linspace(z_interval(1), z_interval(2), z_grid_number)';
x_grid = linspace(x_interval(1), x_interval(2), x_grid_number)';
[x_mesh, y_mesh, z_mesh] = meshgrid(x_grid, y_grid, z_grid);

    for j = 1:y_grid_number

        for k = 1:z_grid_number

            for w = 1:x_grid_number

                [x_velocity(j,k,w), y_velocity(j,k,w), z_velocity(j,k,w)] = calc_wake_grid(x_vortex_1, x_vortex_2, y_vortex_1, y_vortex_2, z_vortex_1, z_vortex_2, x_mesh(j,k,w), y_mesh(j,k,w), z_mesh(j,k,w), panel_number, aoa_vector(array_index), aoa_0_dist, wake_alignment, circulation{array_index}, freestream_velocity);

            end

        end

    end

hold on;
wake_title = append('Wake Plot of ', wing_name, ' at ', num2str(aoa_index), '° Angle of Attack');
title(wake_title);
quiverC3D(x_mesh, y_mesh, z_mesh, x_velocity, y_velocity, z_velocity, 1.5);
view(-30,30);
xlabel('X');
ylabel('Y');
zlabel('Z');

set(f,'Position',[0 0 2000 1000]);
set(f,'PaperSize',[2 1],'PaperPosition',[0 0 2 1]); 

if export_wake

     exportgraphics(f,  strcat(['Output\', export_name,'_Wake_Plot.png']));

end




 
















