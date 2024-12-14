function plot_CL(f, y_control, CL, wing_name, index, lift, elliptic_lift, array_index, CL_aoa, aoa_vector, total_CL, do_aoa_labels, is_looped)

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
plt = plot(y_control, CL{array_index}, 'k');
plt.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), CL{array_index}(txt_index), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
end
xlabel('Span (m)');
ylabel('C_L');
CL_title =  append(['C_L Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(CL_title);
    
subplot(312);
hold on
grid;
plt = plot(y_control, lift{array_index}, 'k');
plt2 = plot(y_control, elliptic_lift{array_index}, '--r');
plt.DataTipTemplate.DataTipRows(end+1) = row;
plt2.DataTipTemplate.DataTipRows(end+1) = row;
if is_looped && do_aoa_labels
    txt = num2str(index);
    txt_index = randi([(numel(y_control)/2)-(numel(y_control)/10) (numel(y_control)/2)+(numel(y_control)/10)]);
    texti = text(y_control(txt_index), lift{array_index}(txt_index), txt);
    textj = text(y_control(txt_index), elliptic_lift{array_index}(txt_index), txt);
    texti.FontSize = 7;
    texti.Color = 'r';
    textj.FontSize = 7;
    textj.Color = 'k';
end
xlabel('Span (m)');
ylabel('Lift')
lg = legend('Lift Distribution', 'Ideal Elliptic Lift Distribution');
lg.Location = 'south';
lift_title =  append(['Lift and Ideal Elliptic Distribution of ', wing_name, index_name, '° Angle of Attack']);
title(lift_title);
    
if size(aoa_vector,2) > 1
        
    subplot(313); 
    hold on
    grid;
    plot(aoa_vector, total_CL);
    xlabel('Angle of Attack [°]')
    ylabel('C_L')
    lg = legend(['Total Wing Coefficent of Lift = ', num2str(CL_aoa)]);
    lg.Location = 'northwest';
    CL_aoa_title =  append(['Coefficent of Lift of ', wing_name, ' over Angle of Attack']);
    title(CL_aoa_title);
    
end

set(f,'Position',[0 0 2000 1000]);
set(f,'PaperSize',[2 1],'PaperPosition',[0 0 2 1]); 