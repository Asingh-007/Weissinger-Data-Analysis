function plot_CD(f, y_control, induced_aoa, elliptic_aoa, induced_kutta_CD, total_induced_kutta_CD, total_CL, total_induced_treffz_plane_CD, aspect_ratio, wing_name, aoa_vector, index, array_index, do_aoa_labels, is_looped)

if is_looped

    index_name = append([' from ', num2str(aoa_vector(1)), '° to ', num2str(aoa_vector(end))]);

else

    index_name = append([' at ', num2str(index)]);

end

aoa = cellstr(num2str(index));
row = dataTipTextRow('Angle of Attack', repelem(aoa,1,numel(y_control)));


subplot(311);
hold on
grid;
plt = plot(y_control, induced_aoa{array_index}, 'k');
plt2 = plot(y_control, elliptic_aoa{array_index}, '-r');
plt.DataTipTemplate.DataTipRows(end+1) = row;
plt2.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), induced_aoa{array_index}(txt_index), txt);
    textj = text(y_control(txt_index), elliptic_aoa{array_index}(txt_index), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
    textj.FontSize = 7;
    textj.Color = 'k';
end
xlabel('Span (m)');
ylabel('Induced Angle of Attack (°)');
induced_aoa_title = append(['Induced Angle of Attack Distribution of ', wing_name, index_name, '° Angle of Attack']);
lg = legend('Induced Angle of Attack', 'Ideal Elliptic');
lg.Location = "north";
title(induced_aoa_title);


subplot(312);
hold on
grid;
plt = plot(y_control, induced_kutta_CD{array_index}, 'k');
plt.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), induced_kutta_CD{array_index}(txt_index), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
end
xlabel('Span (m)');
ylabel('C_D');
kutta_CD_title = append(['Kutta Joukowski Coefficent of Drag of ', wing_name, index_name, '° Angle of Attack']);
title(kutta_CD_title);

if size(aoa_vector, 2) > 1
    K = (total_CL.^2)' \ total_induced_kutta_CD';
    oswald_efficiency_factor = 1 / (pi * aspect_ratio * K);
    subplot(313);
    hold on
    grid;
    plot(total_CL, total_induced_treffz_plane_CD, 'k', total_CL, total_induced_kutta_CD, '-r');
    xlabel('C_L');
    ylabel('C_D')
    lg = legend('Treffz Plane', 'Kutta Joukowski');
    lg.Location = 'northwest';
    drag_polar_title = append('Drag Polar of ', wing_name);
    title(drag_polar_title);

    txt = append(['Oswald Efficiency Factor: ' num2str(oswald_efficiency_factor)]);
    text(total_CL(round(end/2)), total_induced_kutta_CD(round(end/2)) + 0.25 *  total_induced_kutta_CD(round(end/2)), txt);

end

set(f,'Position',[0 0 2000 1000]);
set(f,'PaperSize',[2 1],'PaperPosition',[0 0 2 1]); 






