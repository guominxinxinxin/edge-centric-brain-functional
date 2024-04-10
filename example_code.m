% clean up env for clean run
clearvars; close all; clc

% define directory with .mat files
directory = 'D:\jiankang'; % replace with your directory path

% get list of all .mat files in the directory
files = dir(fullfile(directory, '*.mat'));

% preallocate cell array to store enorm results
enorm_results = cell(length(files), 1);

% iterate over each file in the directory
for i = 1:length(files)
    % load the file
    load(fullfile(directory, files(i).name))
    
    % make sure the variable 'ctime_series' exists in the file
    if exist('ctime_series', 'var')
        ts = ctime_series;
        ts = double(ts);

        % create edge time series from regional time series
        [T,N] = size(ts);
        M = N*(N - 1)/2;
        ets = fcn_edgets(ts);

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
        mat = mat + mat';

        %% calculate community similarity
        s = fcn_profilesim(mat);

        %% calculate normalized entropy
        [u,v] = find(triu(ones(N),1));
        [~,enorm] = fcn_node_entropy(ci,u,v,N);
        
        % save the resulting enorm in the cell array
        enorm_results{i} = enorm;
    else
        fprintf('Variable ctime_series does not exist in file: %s\n', files(i).name);
    end
end

% save the enorm results to a .mat file
save('enorm_results.mat', 'enorm_result')
