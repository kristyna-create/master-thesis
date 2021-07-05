clc;
clear;

cd 'C:\Users\Kristyna\Disk Google\Diplomka\Code_data_revision\data'

%cubic spline interpolation to create monthly data from quarterly values
[data,quarterly_names] = xlsread('quarterly_variables_with_names.xlsx');

end_point = (length(data(:,1))-1)*2 + length(data(:,1)) + 1;
x = 2:3:end_point;
xx = 2:1:end_point;

x = x';
xx = xx';

data_monthly = zeros(length(xx),size(data,2));

for i=1:size(data,2)
    data_monthly(:,i) = spline(x,data(:,i),xx);
end

%attaching monthly data
[data2,monthly_names] = xlsread('monthly_variables_with_names.xlsx');

ydata = horzcat(data_monthly,data2);
ynames = horzcat(quarterly_names,monthly_names);
ynames = ynames';


save('ydata.mat','ydata')
save('ynames.mat','ynames')


%transformation codes
tcode = xlsread('Description_of_series.xlsx', 'Transformation_Codes','E5:E56');

save('tcode.mat','tcode')


%specifying each model's variables
vars = cell(3,1);
vars{1,1} = xlsread('Description_of_series.xlsx', 'ordering1','E3:E6');
vars{2,1} = xlsread('Description_of_series.xlsx', 'ordering1','G3:G8');
vars{3,1} = xlsread('Description_of_series.xlsx', 'ordering1','I3:I22');

save('vars.mat','vars')


