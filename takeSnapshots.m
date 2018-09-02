function varargout = takeSnapshots(options)
% This function takes a video for some length of time, every so often it
% takes a snapshot and saves the resulting images to file. 
%
% There is one optional input, options, which has the following (also
% optional) fields:
%   .runtime    Length of time to capture video (in seconds); def = 30s
%   .numImgs    Number of images to save; def = 100
%   .vid        videoinput object (camera); def =
%                                             ('winvideo',1,'MJPG_640x480')
%   .filename   Filename of folder to save output; def = pwd
%
% The complete 'options' output is given as the sole output of this
% function, which can be directly passed into labelPositiveExamples
% (required for training).

% Define default parameters
runtime = 30;
numImgs = 100;
vidDef.adaptorName = 'winvideo';
vidDef.deviceID    = 1;
vidDef.format      = 'YUY2_640X480';
%vidDef.format      = 'MJPG_640x480';
filename           = [pwd '\'];

% Parse input
if nargin==1
    if isfield(options,'runtime')
        runtime = options.runtime; end
    
    if isfield(options,'numImgs')
        numImgs = options.numImgs; end
    
    if isfield(options,'vid')
        vid = options.vid; end
    
    if isfield(options,'filename')
        filename = options.filename; end
end

if ~exist('vid','var')
    vid = videoinput(vidDef.adaptorName, ...
                     vidDef.deviceID,    ...
                     vidDef.format);
end

% Compute how often we should take a snapshot
delay = runtime / numImgs;

% Put camera in manual mode
triggerconfig(vid,'manual');
start(vid)
figure

% Compute the string format for saving images (use the least number of
% zeros in the image names to assure that we won't overwrite any images).
strFormat = ['%0' num2str(ceil(log10(numImgs))) 'd']; 

% Take video
for R = 0:numImgs-1
    % Take snapshot
    img = getsnapshot(vid);
    
    % Save image
    fullFilename = [filename 'Image_' sprintf(strFormat, R) '.jpg'];
    imwrite(img, fullFilename);

    % Display image
    imagesc(img); axis off
    title(['Captured Images: ' num2str(R+1) '/' num2str(numImgs)]);
    drawnow
    
    pause(delay)
end

% Release video object
stop(vid)

% Return output if desired
if nargout==1
    varargout{1} = options;
end
