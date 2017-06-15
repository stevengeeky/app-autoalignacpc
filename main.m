function main( config )
% Automatically align an T1-weighted image to AC-PC plane
% 
% INPUTS:
%  config.t1 - full path to nifti file that needs to be aligned
%  config.coords - [0,0,0; 0,-16,0; 0,-8,40]
%
% Copyright 2017 Franco Pestilli, Indiana University, frakkopesto@gmail.com

switch getenv('ENV')
case 'IUHPC'
    disp('loading paths (HPC)')
    addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
case 'VM'
    disp('loading paths (VM)')
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
end

% load my own config.json
config = loadjson('config.json');

% Load the file from disk
ni = niftiRead(config.t1);

% Make sure the file is aligned properly
ni = niftiApplyCannonicalXform(ni);

% Load a standard template from vistasoft
MNI_template =  fullfile(mrDiffusionDir, 'templates', 'MNI_T1.nii.gz');

% Compute the spatial normalization to align the current raw data to the template
SpatialNormalization = mrAnatComputeSpmSpatialNorm(ni.data, ni.qto_xyz, MNI_template);

% Assume that the AC-PC coordinates in the template are in a specific location:
% X, Y, Z = [0,0,0; 0,-16,0; 0,-8,40]
% Use this assumption and the spatial normalization to extract the corresponding AC-PC location on the raw data
coords = [0,0,0; 0,-16,0; 0,-8,40]
if isprop(config, 'coords')
    coords = config.coords
end
ImageCoords = mrAnatGetImageCoordsFromSn(SpatialNormalization, tal2mni(coords)', true)';

% Now we assume that ImageCoords contains the AC-PC coordinates that we need for the Raw data. 
% We will use them to compute the AC_PC alignement automatically. The new file will be saved to disk. 
% Check the alignement.
mrAnatAverageAcpcNifti(ni, 't1.nii.gz', ImageCoords, [], [], [], false);

return
