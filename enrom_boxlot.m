clc;
clear;
close all;
%% edge color
load("enorm_nc.mat");
load("enorm_si.mat");
load("enorm_NSI.mat");
NC=enorm_nc;
SI=enorm_sa;
FSI=enorm;
% data3=enorm;
edgecolor1=[0,0,0]; % black color
edgecolor2=[0,0,0]; % black color
% edgecolor3=[0,0,0]; % black color
fillcolor1=[206, 85, 30]/255; % fillcolors = rand(24, 3);
fillcolor2=[46, 114, 188]/255;
fillcolors=[repmat(fillcolor1,16,1);repmat(fillcolor2,16,1)];
position_1 = [0.3:1:15.3];  % define position for first group boxplot
position_2 = [0.3:1:15.3];  % define position for second group boxplot 
position_3 = [0.7:1:15.7];
%  boxplot(NC,lab,'labels',net,"Positions",position_2,'colors',fillcolor2,'width',0.2,'labelorientation','inline','MedianStyle','target'); 
hold on;

 boxplot(SI,lab,'labels',net,"Positions",position_1,'colors',fillcolor1,'width',0.2,'labelorientation','inline','MedianStyle','target'); 
 boxplot(FSI,lab,'labels',net,"Positions",position_3,'colors',fillcolor2,'width',0.2,'labelorientation','inline','MedianStyle','target'); 
hold off;
% figure,
% box_1 = boxplot(data1,'positions',position_1,'colors',edgecolor1,'width',0.2,'notch','on','symbol','r+','outliersize',5);
% hold on;
% box_2 = boxplot(data2,'positions',position_2,'colors',edgecolor2,'width',0.2,'notch','on','symbol','r+','outliersize',5);
% box_3 = boxplot(data3,'positions',position_3,'colors',edgecolor3,'width',0.2,'notch','on','symbol','r+','outliersize',5);
 
boxobj = findobj(gca,'Tag','Box');
for j=1:length(boxobj)
    patch(get(boxobj(j),'XData'),get(boxobj(j),'YData'),fillcolors(j,:),'FaceAlpha',0.5);
end
set(gca,'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16],'Xlim',[0 16]);
boxchi = get(gca, 'Children');
legend([boxchi(1),boxchi(4)], ["SI", "NC"] );
