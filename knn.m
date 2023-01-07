clc
clear all
close all
warning off
data=readtable('News.csv');
k=["true","fake"];
l=[1,0];
g=data.target;
number=zeros(length(g),1);
for i=1:length(k)
    rs=ismember(g,k(i));
    number(rs)=l(i);
end
%%
data.class=number;
data.target=[];
data.date=[];
data.title=[];
data.text=[];
data.subject=[];
cv=cvpartition(data.class,"holdout",0.2)
datatrain=data(training(cv),:);
datatest=data(test(cv),:);
datatrain_x=removevars(datatrain,'class');
datatrain_y=datatrain.class;
datatest_x=removevars(datatest,'class');
datatest_y=datatest.class;
model_knn = fitcknn(datatrain_x,datatrain_y);
tahminknn = predict(model_knn,datatest_x);
iscorrectknn =(tahminknn == datatest_y);
accuknn=sum(iscorrectknn)/numel(iscorrectknn);

figure;
confusionchart(tahminknn,datatest_y);
title(sprintf('Knn Confusion Matrix (Accuracy: %.2f%%)',accuknn*100));
xlabel('Predicted Class');
ylabel('True Class');


