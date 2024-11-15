function [cl_aoa] = plot_CL(y_control, lift_distribution, cl_distribution, total_cl_distribution, aoa_vector, freestream_velocity, wing_reference_area, wing_span, panel_number, array_index)


% Prandt Lifting Line Theory 
for i = 1:size(aoa_vector, 2)

    circulation_0(i) = 2 * freestream_velocity * wing_reference_area * total_cl_distribution(i) / (wing_span * pi);

    elliptic_lift = zeros(1, panel_number);

    for j = ((panel_number/2)+1):panel_number

        elliptic_lift(j) = 1.225 * freestream_velocity * circulation_0(i) * sqrt(1-(2 * y_control(j) / wing_span)^2);

    end

    elliptic_lift(1:panel_number/2) = flip(elliptic_lift(((panel_number/2)+1):panel_number));

end

f = figure;
grid;
plot(y_control((panel_number/2+1):end) * 2 / wing_span, cl_distribution{array_index}((panel_number/2+1):end) / total_cl_distribution(array_index), 'k');
xlabel('Half Span (m)');
ylabel('C_L Ratio');

g = figure;
grid;
plot(y_control, cl_distribution{array_index}, 'k');
xlabel('Span (m)');
ylabel('C_L');

h = figure;
grid;
plot(y_control((panel_number/2)+1:end) * 2 / wing_span, cl_distribution{array_index}((panel_number/2+1):end), 'k');
xlabel('Half Span (m)');
ylabel('C_L');

k = figure;
grid;
plot(y_control, lift_distribution{array_index}, 'k', y_control, elliptic_lift, '--r');
xlabel('Span (m)');
ylabel('Lift')
legend('Lift Distribution', 'Elliptic Lift Distribution')

cl_aoa = (total_cl_distribution(end) - total_cl_distribution(1)) / (aoa_vector(end) - aoa_vector(1));

if size(aoa_vector,2) > 1
    
    l = figure;
    grid;
    plot(aoa_vector, total_cl_distribution);
    xlabel('Angle of Attack [°]')
    ylabel('C_L')
    legend(['Coefficent of Lift = ', num2str(cl_aoa)]);
end


