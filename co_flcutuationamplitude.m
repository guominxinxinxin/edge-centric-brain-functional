% clean up env for clean run
clearvars; close all; clc
mat1=zeros(200,16);
%% make edge time series, eFC, and related concepts

% add helper functions to path
addpath(genpath('fcn'));

% load example time series, system labels, and names
load D:\首发抑郁\MDD114.mat
% ts = double(ts);
% 
% % create edge time series from regional time series
% [T,N] = size(ts);
% M = N*(N - 1)/2;
% ets = fcn_edgets(ts);
ets=mean_mat;
N=200;
% uncomment to calculate efc - memory intensive
efc = fcn_edgets2edgecorr(ets);

% run kmeans -- note that in principle any clustering algorithm can be
% applied to edge time series or the efc matrix
k = 16;
ci = kmeans(ets',k,...
    'distance','sqeuclidean',...
    'maxiter',1000);

% map edge communities into matrixbrain
mat = zeros(N);
mat(triu(ones(N),1) > 0) = ci;
% disp(mat);
mat = mat + mat';

%% calculate community similarity

s = fcn_profilesim(mat);

%% calculate normalized entropy

[u,v] = find(triu(ones(N),1));
[~,enorm] = fcn_node_entropy(ci,u,v,N);

% calculate co-fluctuation amplitude at each frame
rss = sum(ets.^2,2).^0.5;

% %% Extract high/low-RSS FC components and display
inds1 = find(triu(ones(N),1));

[rssordered,rssindices] = sort(rss,'descend');
FChi_ets = mean(ets(rssindices(1:110),:));  % top 10% RSS frames
temp = zeros(N); temp(inds1) = FChi_ets; FChi = temp+temp';
FClo_ets = mean(ets(rssindices(end-110+1:end),:));  % bottom 10% RSS frames
temp = zeros(N); temp(inds1) = FClo_ets; FClo = temp+temp';