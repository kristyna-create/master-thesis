clc;
clear;

cd 'C:\Users\Kristyna\Disk Google\Diplomka\Code_data_revision\data'
load ydata.mat;

mGDP = xlsread('MA_monthly_GDP.xlsx', 'Data','C2:C310');
a = mGDP(85:end-8,1);

plot(a,'-.k','LineWidth',1.5)
hold on
plot(ydata(:,1),'k','LineWidth',1.5)
legend('Monthly estimates of GDP','GDP interpolated from quarterly values','Location','southeast')