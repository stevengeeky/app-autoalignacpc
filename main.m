function t1w_acpcfile = main( config )
% Automatically align an T1-weighted image to AC-PC plane
% 
% INPUTS:
%  config.rawT1File   - full path to nifti file that needs to be aligned
%  config.t1w_acpc    - string used as name for the AC-PC aligned file 
%  config.acpc_coords - [0,0,0; 0,-16,0; 0,-8,40]
%
% Copyright 2017 Franco Pestilli, Indiana University, frakkopesto@gmail.com

% Load the file from disk
ni = readFileNifti(config.rawT1file);

% Make sure the file is aligned properly
ni = niftiApplyCannonicalXform(ni);

% Load a standard template from vistasoft
MNI_template =  fullfile(mrDiffusionDir, 'templates', 'MNI_T1.nii.gz');

% Compute the spatial normalization to align the current raw data to the template
SpatialNormalization = mrAnatComputeSpmSpatialNorm(ni.data, ni.qto_xyz, MNI_template);

% Assume that the AC-PC coordinates int he template are in a specific location:
% X, Y, Z = [0,0,0; 0,-16,0; 0,-8,40]
% Use this assumption and the spatial normalization to extract the corresponding AC-PC location on the raw data
ImageCoords = mrAnatGetImageCoordsFromSn(SpatialNormalization, tal2mni(config.acpc_coords)', true)';

% Now we assume that ImageCoords contains the AC-PC coordinates that we need for the Raw data. 
% We will use them to compute the AC_PC alignement automatically. The new file will be saved to disk. 
% Check the alignement.
mrAnatAverageAcpcNifti(ni, t1w_acpcfile, ImageCoords, [], [], [], false);

return
