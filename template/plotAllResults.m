% Function from plotting all results from a file
% File is assumed to hold a description header of the configurational meanings in
% the first row (unused), an empty second row, and parameter values and
% a number of resulting data in the second row, as seen in
% test_results.txt, produced by the testing loop implemented in tspgui.m

% To be used with newer Matlab versions (>=2017).
% For older Matlab versions, use plotAllResultsOld.m (at the call in tspgui.m)

function plotAllResults(filePath)

table = readtable(filePath);


result_arr = table2array(table(:,12));
cell_holder ={};
for i = 1:size(result_arr,1)
    cell_holder{i} = split(result_arr{i},' ');
end
x = linspace(1,size(cell_holder{1},1),size(cell_holder{1},1));
plot_legend = [];
for j = 1:size(result_arr,1)
    table_num_str = split(num2str(table{j,[2,3,5,7,10,11]}));
    plot_legend = [plot_legend,strcat('Data:', table{j,1},' Ind:',table_num_str{1},' Gen:',table_num_str{2},...
    ' Mut:',table{j,4},table_num_str{3},' Xover:',table{j,6},table_num_str{4},...
    ' Sel:',table{j,8}, ' Surv:',table{j,9},table_num_str{5},' Loop:',table_num_str{6})];
    
    mat_str = cell2mat(cell_holder{j});
    int_str = str2num(mat_str);
    
    plot(x,int_str);
    hold on;
end
legend(plot_legend, 'Location','southoutside', 'Interpreter', 'none')

end