close all
clc
clear

addpath('./../src/core/')
disp('Testing Logger class ...')

%% Test1: open logger and add new data
x = 0:0.01:3;
f = @(x) 2*sin(x) + 3*cos(x).^2;
y = f(x);

debug = true;
log   = Logger(debug);
log.addNewData(y,'test');

%% Test2: plot the data

% no options
figNum = log.plotData('test');

% with options
plot_options.xValue   = x;
plot_options.yLabel   = 'f(x)';
plot_options.xLabel   = 'x';
plot_options.title    = 'My Test';
plot_options.lineSize = 4;
plot_options.fontSize = 12;
plot_options.legend   = 'myData';

log.plotData('test', plot_options, 10);

%% Test3: remove the data
log.removeData('test');

disp('Done!')
rmpath('./../src/core/')
