function plot_CD(f, y_control, induced_aoa, elliptic_aoa, induced_kutta_CD, total_induced_kutta_CD, total_CL, total_induced_treffz_plane_CD, wing_name, aoa_vector, index, array_index, is_looped)

if is_looped

    index_name = append([' from ', num2str(aoa_vector(1)), '° to ', num2str(aoa_vector(end))]);

else

    index_name = append([' at ', num2str(index)]);

end


hold on
subplot(131);
plot(y_control, induced_aoa{array_index}, 'k', y_control, elliptic_aoa{array_index}, '-r');
xlabel('Span (m)');
ylabel('Induced Angle of Attack (°)');
induced_aoa_title = append(['Induced Angle of Attack Distribution of ', wing_name, index_name, '° Angle of Attack']);
legend('Induced Angle of Attack', 'Ideal Elliptic')
title(induced_aoa_title);

hold on
subplot(132);
plot(y_control, induced_kutta_CD{array_index}, 'k');
xlabel('Span (m)');
ylabel('C_D');
kutta_CD_title = append(['Kutta Joukowski Coefficent of Drag of ', wing_name, index_name, '° Angle of Attack']);
title(kutta_CD_title);

if size(aoa_vector, 2) > 1

    hold on
    subplot(133);
    plot(total_CL, total_induced_treffz_plane_CD, 'k', total_CL, total_induced_kutta_CD, '-r');
    xlabel('C_L');
    ylabel('C_D')
    legend('Treffz Plane', 'Kutta Joukowski');
    drag_polar_title = append('Drag Polar of ', wing_name);
    title(drag_polar_title);

end

set(f,'Position',[0 0 2000 1000]);
set(f,'PaperSize',[2 1],'PaperPosition',[0 0 2 1]); 






