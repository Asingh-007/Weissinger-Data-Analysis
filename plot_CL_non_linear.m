function plot_CL_non_linear(f, y_control, CL, CL_non_linear, total_CL, total_CL_non_linear, aoa_vector, aoa_sectional, decambering_angle, array_index, wing_name, index, do_aoa_labels, is_looped)

if is_looped

    index_name = append([' from ', num2str(aoa_vector(1)), '° to ', num2str(aoa_vector(end))]);

else

    index_name = append([' at ', num2str(index)]);

end

aoa = cellstr(num2str(index));
row = dataTipTextRow('Angle of Attack', repelem(aoa,1,numel(y_control)));

subplot(221);
hold on;
grid;

plt1 = plot(y_control, CL{array_index}, 'k');
plt2 = plot(y_control, CL_non_linear{array_index},'-b');
plt1.DataTipTemplate.DataTipRows(end+1) = row;
plt2.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), CL{array_index}(txt_index), txt);
    textj = text(y_control(txt_index), CL_non_linear{array_index}(txt_index), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
    textj.FontSize = 7;
    textj.Color = 'k';
end

xlabel('Span (m)');
ylabel('C_L');
lg = legend('Linear C_L Distribution', 'Non-Linear C_L Distribution');
lg.Location = 'south';

lift_title =  append(['Linear and Non-Linear Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(lift_title);

subplot(222);
hold on;
grid;

plt = plot(y_control, rad2deg(aoa_sectional{array_index}), 'k');
plt.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), rad2deg(aoa_sectional{array_index}(txt_index)), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
end

xlabel('Span (m)');
ylabel('Section Angle of Attack [°]')

section_aoa_title  = append(['Section Angle of Attack Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(section_aoa_title);

subplot(223);
hold on;
grid;

plt = plot(y_control, rad2deg(decambering_angle{array_index}));
plt.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), rad2deg(decambering_angle{array_index}(txt_index)), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
end

xlabel('Span (m)');
ylabel('Decambering Angle [°]');

decambering_angle_title = append(['Decambering Angle Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(decambering_angle_title);

if size(aoa_vector,2) > 1 && size(nonzeros(total_CL_non_linear),1) > 1

    subplot(224);
    hold on;
    grid;

    plot(aoa_vector, total_CL, '--k', aoa_vector, total_CL_non_linear, 'b');
    xlabel('Angle of Attack [°]');
    ylabel('C_L');
    lg = legend('Linear C_L', 'Non-Linear C_L');
    lg.Location = 'northwest';

    CL_aoa_title =  append(['Coefficent of Lift of ', wing_name, ' over Angle of Attack']);
    title(CL_aoa_title);

end

set(f,'Position',[0 0 2000 2000]);
set(f,'PaperSize',[2 2],'PaperPosition',[0 0 2 2]); 

