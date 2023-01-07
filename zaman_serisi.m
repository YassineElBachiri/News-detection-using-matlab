
clc
clear 
close all
warning off

%%
trueTable = readtable('True.csv');
fakeTable = readtable('Fake.csv');
trueColumnNames = trueTable.Properties.VariableNames;
fakeColumnNames = fakeTable.Properties.VariableNames;

trueTable1 = addvars(trueTable, ones(height(trueTable),1), 'NewVariableNames', 'class');
fakeTable1 = addvars(fakeTable, zeros(height(fakeTable),1), 'NewVariableNames', 'class');


 head(trueTable1 ,10)


head(fakeTable1 ,10)

news_df = readtable('News.csv');

%% Time series analysis- Fake/True news
%Let's look at the timeline of true and fake news that were circulated in the media.
% Group the true news data by date and count the number of outputs for each date
trueCounts = groupcounts(trueTable, 'date');
% Convert the resulting data table to an array
trueCounts.date = datetime(trueCounts.date);
% Group the fake news data by date and count the number of outputs for each date
fakeCounts = groupcounts(fakeTable, 'date');
% Convert the resulting data table to an array
fakeCounts.date = datetime(fakeCounts.date);
% Create a new figure
fig = figure;
% Set the title and background color of the figure
fig.Name = 'True and Fake News';
fig.Color = [248 248 255]/255;
% Add a line plot of the true news count to the figure
plot(trueCounts.(trueCounts.Properties.VariableNames{1}), trueCounts.(trueCounts.Properties.VariableNames{2}), 'LineWidth', 2, 'Color', 'blue','DisplayName', 'Reel');
% Hold the figure to allow multiple plots to be added
hold on
% Add a line plot of the fake news count to the figure
plot(fakeCounts.(fakeCounts.Properties.VariableNames{1}), fakeCounts.(fakeCounts.Properties.VariableNames{2}), 'LineWidth', 2, 'Color', 'red','DisplayName', 'Fake');
% Set the y-axis label and title of the figure
ylabel('Count');
title('True and Fake News');
% Add a legend to the figure
legend('Location', 'northwest');

