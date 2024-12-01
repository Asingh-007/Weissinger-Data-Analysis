function plot_CL(f, y_control, CL, wing_name, index, lift, elliptic_lift, array_index, CL_aoa, aoa_vector, total_CL, is_looped)

if is_looped

    index_name = append([' from ', num2str(aoa_vector(1)), '° to ', num2str(aoa_vector(end))]);

else

    index_name = append([' at ', num2str(index)]);

end


subplot(131); 
hold on
grid;
plot(y_control, CL{array_index}, 'k');
xlabel('Span (m)');
ylabel('C_L');
CL_title =  append(['C_L Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(CL_title);
    
subplot(132);
hold on
grid;
plot(y_control, lift{array_index}, 'k', y_control, elliptic_lift{array_index}, '--r');
xlabel('Span (m)');
ylabel('Lift')
legend('Lift Distribution', 'Ideal Elliptic Lift Distribution')
lift_title =  append(['Lift and Ideal Elliptic Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(lift_title);
    
if size(aoa_vector,2) > 1
        
    subplot(133); 
    hold on
    grid;
    plot(aoa_vector, total_CL);
    xlabel('Angle of Attack [°]')
    ylabel('C_L')
    legend(['Total Wing Coefficent of Lift = ', num2str(CL_aoa)]);
    CL_aoa_title =  append(['Coefficent of Lift of ', wing_name, ' over Angle of Attack']);
    title(CL_aoa_title);
    
end

set(f,'Position',[0 0 2000 1000]);
set(f,'PaperSize',[2 1],'PaperPosition',[0 0 2 1]); 