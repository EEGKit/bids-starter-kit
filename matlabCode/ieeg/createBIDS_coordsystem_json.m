%% Template Matlab script to create an BIDS compatible _electrodes.json file
% For BIDS-iEEG
% This example lists all required and optional fields.
% When adding additional metadata please use CamelCase
%
% DHermes, 2017
% modified Jaap van der Aar 30.11.18

% Writing json files relies on the JSONio library
% https://github.com/bids-standard/bids-matlab
%
% Make sure it is in the matab/octave path
try
    bids.bids_matlab_version;
catch
    warning('%s\n%s\n%s\n%s', ...
            'Writing the JSON file seems to have failed.', ...
            'Make sure that the following library is in the matlab/octave path:', ...
            'https://github.com/bids-standard/bids-matlab');
end

%%
clear;

this_dir = fileparts(mfilename('fullpath'));
root_dir = fullfile(this_dir, '..', filesep, '..');

project = 'templates';

sub_label = '01';
ses_label = '01';

name_spec.modality = 'ieeg';
name_spec.suffix = 'coordsystem';
name_spec.ext = '.json';
name_spec.entities = struct('sub', sub_label, ...
                            'ses', ses_label);

% using the 'use_schema', true
% ensures that the entities will be in the correct order
bids_file = bids.File(name_spec, 'use_schema', true);

% Contrust the fullpath version of the filename
json_name = fullfile(root_dir, project, bids_file.bids_path, bids_file.filename);

%% Required fields

json.iEEGCoordinateSystem = ''; % Defines the coordinate system for the iEEG electrodes.
% For example, "ACPC". See Appendix VIII: preferred names of Coordinate systems.
% If "Other" (for example: individual subject MRI), provide definition of the coordinate system
% in iEEGCoordinateSystemDescription.
% If positions correspond to pixel indices in a 2D image (of either a volume-rendering,
% surface-rendering, operative photo, or operative drawing), this must be "pixels".
% See section 3.4.1: Electrode locations for more information on electrode locations.

json.iEEGCoordinateUnits = ''; % Units of the _electrodes.tsv, MUST be "m", "mm", "cm" or "pixels".

%% Recommended fields

json.iEEGCoordinateProcessingDescripton = ''; % Freeform text description or link to document
% describing the iEEG coordinate system system in detail (for example: "Coordinate system with the origin
% at anterior commissure (AC), negative y-axis going through the posterior commissure (PC), z-axis
% going to a mid-hemisperic point which lies superior to the AC-PC line, x-axis going to the right")

json.IndendedFor = ''; % This can be an MRI/CT or a file containing the operative photo, x-ray
% or drawing with path relative to the project folder. If only a surface reconstruction is available,
% this should point to the surface reconstruction file. Note that this file should have the same coordinate
% system specified in iEEGCoordinateSystem. (for example: "sub-<label>/ses-<label>/anat/sub-01_T1w.nii.gz")
% for example
% T1: "/sub-<label>/ses-<label>/anat/sub-01_T1w.nii.gz"
% Surface: "/derivatives/surfaces/sub-<label>/ses-<label>/anat/sub-01_T1w_pial.R.surf.gii"
% Operative photo: "/sub-<label>/ses-<label>/ieeg/sub-0001_ses-01_acq-photo1_photo.jpg"
% Talairach: "/derivatives/surfaces/sub-Talairach/ses-01/anat/sub-Talairach_T1w_pial.R.surf.gii"

json.iEEGCoordinateProcessingDescription = ''; % Has any projection been done on the electrode positions
% (for example: "surface_projection", "none").

json.iEEGCoordinateProcessingReference = ''; % A reference to a paper that defines in more detail
% the method used to project or localize the electrodes

%% Write JSON
% Make sure the directory exists
bids.util.mkdir(fileparts(json_name));
bids.util.jsonencode(json_name, json);
