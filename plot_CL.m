function [cl_aoa] = plot_CL(y_control, lift_distribution, cl_distribution, total_cl_distribution, aoa_vector, freestream_velocity, wing_reference_area, wing_span, panel_number, array_index, wing_name, aoa_index, export_lift, plot_aoa_all)


% Prandt Lifting Line Theory 
elliptic_lift = cell(1, size(aoa_vector,2));

cl_aoa = (total_cl_distribution(end) - total_cl_distribution(1)) / (aoa_vector(end) - aoa_vector(1));

for i = 1:size(aoa_vector, 2)

    circulation_0(i) = 2 * freestream_velocity * wing_reference_area * total_cl_distribution(i) / (wing_span * pi);

    
    for j = ((panel_number/2)+1):panel_number

        elliptic_lift{i}(j) = 1.225 * freestream_velocity * circulation_0(i) * sqrt(1 - (2 * y_control(j) / wing_span)^2);

    end

    elliptic_lift{i}(1:panel_number/2) = flip(elliptic_lift{i}(((panel_number/2)+1):panel_number));

end

if plot_aoa_all

    f = figure(3); 
    g = figure(4);
    h = figure(5);
    
    for i = 1:size(aoa_vector, 2)

        figure(3); 
        hold on
        grid;
        plot(y_control, cl_distribution{i}, 'k');
        xlabel('Span (m)');
        ylabel('C_L');
        cl_distribution_title =  append(['C_L Distribution of ', wing_name]);
        title(cl_distribution_title);
        
        figure(4);
        hold on
        grid;
        plot(y_control, lift_distribution{i}, 'k', y_control, elliptic_lift{i}, '--r');
        xlabel('Span (m)');
        ylabel('Lift')
        legend('Lift Distribution', 'Ideal Elliptic Lift Distribution')
        lift_distribution_title =  append(['Lift and Ideal Elliptic Distribution of ', wing_name]);
        title(lift_distribution_title);
        
        if size(aoa_vector,2) > 1
            
            figure(5);
            hold on
            grid;
            plot(aoa_vector, total_cl_distribution);
            xlabel('Angle of Attack [°]')
            ylabel('C_L')
            legend(['Total Wing Coefficent of Lift = ', num2str(cl_aoa)]);
            cl_aoa_title =  append(['Coefficent of Lift of ', wing_name, ' over Angle of Attack']);
            title(cl_aoa_title);

        end

    end

else    

    f = figure;
    grid;
    plot(y_control, cl_distribution{array_index}, 'k');
    xlabel('Span (m)');
    ylabel('C_L');
    cl_distribution_title =  append(['C_L Distribution of ', wing_name, ' at ', num2str(aoa_index), '° Angle of Attack']);
    title(cl_distribution_title);
    
    g = figure;
    grid;
    plot(y_control, lift_distribution{array_index}, 'k', y_control, elliptic_lift{array_index}, '--r');
    xlabel('Span (m)');
    ylabel('Lift')
    legend('Lift Distribution', 'Ideal Elliptic Lift Distribution')
    lift_distribution_title =  append(['Lift and Ideal Elliptic Distribution of ', wing_name, ' at ', num2str(aoa_index), '° Angle of Attack']);
    title(lift_distribution_title);
    
    if size(aoa_vector,2) > 1
        
        h = figure;
        grid;
        plot(aoa_vector, total_cl_distribution);
        xlabel('Angle of Attack [°]')
        ylabel('C_L')
        legend(['Total Wing Coefficent of Lift = ', num2str(cl_aoa)]);
        cl_aoa_title =  append(['Coefficent of Lift of ', wing_name, ' over ', num2str(aoa_index), '° Angle of Attack']);
        title(cl_aoa_title);
    
    end

end

if export_lift

    exportgraphics(f,  strcat(['Output\', cl_distribution_title, '_Plot.png']));

    exportgraphics(g,  strcat(['Output\', lift_distribution_title, '_Plot.png']));

    exportgraphics(h,  strcat(['Output\', cl_aoa_title, '_Plot.png']));

end



