function varargout = count(varargin)
% COUNT MATLAB code for count.fig
%      COUNT, by itself, creates a new COUNT or raises the existing
%      singleton*.
%
%      H = COUNT returns the handle to a new COUNT or the handle to
%      the existing singleton*.
%
%      COUNT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COUNT.M with the given input arguments.
%
%      COUNT('Property','Value',...) creates a new COUNT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before count_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to count_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help count

% Last Modified by GUIDE v2.5 08-Apr-2018 10:14:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @count_OpeningFcn, ...
                   'gui_OutputFcn',  @count_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


0220
% --- Executes just before count is made visible.
function count_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to count (see VARARGIN)

% Choose default command line output for count
handles.output = hObject;
axes(handles.axes1);
imshow('blank.jpg');
axis off;
set(handles.text2,'string','0');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes count wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = count_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global vid     % making the variable global
 vid = videoinput('winvideo' , 1, 'MJPG_1280x720');% Create a video input with YUY2 format and 640X480 resolution
 h = waitbar(0,'Starting Web Cam Please wait....');
steps = 3000;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h);
%% Train a User-defined Classifier function
% how to train a new
% vision.CascadeObjectDetector. The whole process should only take 5-10
% minutes (if positive labeling is done with a pre-trained detector). 
% Specifically we will train a classifier to detect the user's face using a
% webcam.
%
% Process outline:
%   1) Take video which includes object of interest (the user's face).
%   2) Label (manually or autonomously) objects from the video in (1).
%   3) Take video which does NOT include object of interest.
%   4) Train classifier using trainCascadeObjectDetector.
%   5) Test classifier on live video.

%% Step 0 - Preliminaries
%
% We start off by making two directories in which to store images, one for
% positive image examples and one for negative examples.

mkdir(pwd, 'Positive Images'); addpath([pwd '\Positive Images'])
mkdir(pwd, 'Negative Images'); addpath([pwd '\Negative Images'])

%% Step 1 - Take positive video example
%
% We will take a video using the included function takeSnapshots.m. This
% function will use a webcam to take video and save individual jpg images.
% When taking the video make sure the user's face is in every frame and
% approximately facing forward. Trying to turn your face to get a too wide
% a range of images is likely to make training fail.

% Set options
options.runtime = 30;  % Total runtime to collect video (in seconds)
options.numImgs = 200; % Total number of images to save
options.vid = videoinput('winvideo', 1, 'MJPG_1280x720'); % Change this line
                       % to use different camera settings
%options.vid = videoinput('winvideo', 2, 'MJPG_640x480');                        
options.filename = [pwd '\Positive Images\']; % Location of the positive 
                       % image directory

% Take video
takeSnapshots(options);

%% Step 2 - Label objects
%
% We need to go through the images we just saved and label the user's face.
% We can do the labeling either autonomously using a pretrained detector or
% manually (using the function CascadeTrainGUI available from
% MatlabCentral). 

% Set the method to use
method = 'autonomous'; % {'autonomous', 'manual'}

%****************************************%
% Method 1 - Using a pretrained detector %
%****************************************%
if strcmp(method, 'autonomous')
    % Set options
    options.usePretrainedObjectDetector = true;
    options.detector = vision.CascadeObjectDetector('FrontalFaceCART');

    % Label faces using the included function labelPositiveExamples.m
    data = labelPositiveExamples(options);
end

%**************************************%
% Method 2 - Manually labeling objects %
%**************************************%
if strcmp(method, 'manual')
    % Load the CascadeTrainGUI. 
    % 
    % Once in the GUI hit the 'Load Directory' in the bottom left; select 
    % the 'Positive Images' directory. All of the images from the video 
    % should pop up automatically. For each frame, click on the image to 
    % change the mouse cursor from 'pointer' mode to 'select' mode, then 
    % drag a bounding box around the user's face; once you are happy with 
    % the bounding box hit the 'right arrow' below the image to move onto 
    % the next frame; repeat for all frames in the directory.
    %
    % After labeling every frame, go to "File>>Save/Export Session As", at 
    % the prompt save the results as 'data'. 
    CascadeTrainGUI
    
    % Full session info will be saved as a mat file in the 
    % 'cascadetraingui' directory; you can delete this mat file as we won't
    % be using it. What we will use is the 'data' struct that appears in 
    % the workspace. We save it:
    save(options.filename, 'data');
end

%% Step 3 - Take negative video example
%
% Next we take a video explicitly WITHOUT the user. Make sure not to be in
% the video. As the video is taking move the camera to give slight 
% variation in the captured images.

% Set options
options.runtime = 30;
options.numImgs = 250; 
options.filename = [pwd '\Negative Images\'];

% Take video
takeSnapshots(options);

%% Step 4 - Train classifier
%
% Next we train a classifier using trainCascadeObjectDetector.

% Load the bounding box data (if it's not already in the workspace). Note:
% the 'data' struct has the location of the positive image locations.
load('data.mat')

% Set the negative image directory
negativeFolder = [pwd '\Negative Images\'];

% Note: the following command can take several minutes
trainCascadeObjectDetector( ...
    'userDefinedFaceDetector.xml', ...
    data, ...
    negativeFolder, ...
    'FalseAlarmRate', 0.2, ...
    'NumCascadeStages', 5);
    

%% Step 5 - Test classifier on live video
%
% Finally we test our classifier on live video.

% Load the newly-trained detector
options.detector = vision.CascadeObjectDetector('userDefinedFaceDetector.xml');

% Test classifier on video
testClassifier(options)



% --- Executes on button press in count.
function count_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid 
vid = videoinput('winvideo' , 1, 'YUY2_640X480');% Create a video input with YUY2 format and 640X480 resolution
%Set the parameters for video
triggerconfig( vid,'manual');                                      % the trigger occurs only after the trigger function
set(vid, 'FramesPerTrigger',1);                                     % one frame acquired per trigger
set(vid, 'TriggerRepeat',Inf);                                      % Keep executing the trigger every time the trigger condition is met until the stop function is called 
set(vid,'ReturnedColorSpace','rgb');                                % to get the rgb colour image 
%vid.Timeout = 30;
set(vid,'Timeout',50); 
start(vid);
%bool = isrunning(vid);
while (1)
options.detector = vision.CascadeObjectDetector('userDefinedFaceDetector.xml');
options.detector = vision.CascadeObjectDetector;                            % Create a cascade detector object
options.detector.MergeThreshold =10;
trigger(vid);                                                               %trigger to get the frame from the video
%image = getdata(vid,1,'uint8');                                             %store that frame in 'image'b
image=getdata(vid);
bbox = step(options.detector, image);                                       % position of face in 'bbox' (x, y, width and height)
insert_object = insertObjectAnnotation(image,'rectangle',bbox,'Face');      % Draw the bounding box around the detected face.
imshow(insert_object);hold on
%testClassifier(options)
axis off;                                                                   % invisible the axis from GUI
no_rows =size(bbox,1);                                                    % get the number of rows (which will be equal to number of people)
X = sprintf('%d', no_rows);
set(handles.text2,'string',X);                                              %display the value of X in GUI
hold off;
end
%hold off;
% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
%stop(vid),clear vid %stop the running video
%stoppreview(vid);
%vid.timerFcn={'stop'};
clc; clear;
%close all;
vid = imaqfind %find video input objects in memory
delete(vid);
%closepreview(vid);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid     % making the variable global
vid = videoinput('winvideo' , 1, 'YUY2_640X480');% Create a video input with YUY2 format and 640X480 resolution
h = waitbar(0,'Starting Web Cam Please wait....');
steps = 500;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h);
%Set the parameters for video
 triggerconfig( vid ,'manual');                                      % the trigger occurs only after the trigger function
 set(vid, 'FramesPerTrigger',1);                                     % one frame acquired per trigger
 set(vid, 'TriggerRepeat',Inf);                                      % Keep executing the trigger every time the trigger condition is met until the stop function is called 
 set(vid,'ReturnedColorSpace','rgb');                                % to get the rgb colour image 
 set(vid,'Timeout',50); 
 set(vid,'Timeout',50); 
 start(vid);
axes(handles.axes1);
hImage=image(zeros(400,600,3),'Parent',handles.axes1); 
preview(vid,hImage);
 %stop(vid),clear vid 


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid     % making the variable global
vid = videoinput('winvideo' , 1, 'YUY2_640X480');% Create a video input with YUY2 format and 640X480 resolution
h = waitbar(0,'Starting Web Cam Please wait....');
steps = 500;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h);
%Set the parameters for video
 triggerconfig( vid ,'manual');                                      % the trigger occurs only after the trigger function
 set(vid, 'FramesPerTrigger',1);                                     % one frame acquired per trigger
 set(vid, 'TriggerRepeat',Inf);                                      % Keep executing the trigger every time the trigger condition is met until the stop function is called 
 set(vid,'ReturnedColorSpace','rgb');                                % to get the rgb colour image 
 set(vid,'Timeout',50); 
 set(vid,'Timeout',50); 
 start(vid);
axes(handles.axes1);
hImage=image(zeros(400,600,3),'Parent',handles.axes1); 
preview(vid,hImage);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid     % making the variable global
 vid = videoinput('winvideo' , 1, 'YUY2_640X480');% Create a video input with YUY2 format and 640X480 resolution
 h = waitbar(0,'Starting Web Cam Please wait....');
steps = 3000;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h);
%% Train a User-defined Classifier function
% how to train a new
% vision.CascadeObjectDetector. The whole process should only take 5-10
% minutes (if positive labeling is done with a pre-trained detector). 
% Specifically we will train a classifier to detect the user's face using a
% webcam.
%
% Process outline:
%   1) Take video which includes object of interest (the user's face).
%   2) Label (manually or autonomously) objects from the video in (1).
%   3) Take video which does NOT include object of interest.
%   4) Train classifier using trainCascadeObjectDetector.
%   5) Test classifier on live video.

%% Step 0 - Preliminaries
%
% We start off by making two directories in which to store images, one for
% positive image examples and one for negative examples.

mkdir(pwd, 'Positive Images'); addpath([pwd '\Positive Images'])
mkdir(pwd, 'Negative Images'); addpath([pwd '\Negative Images'])

%% Step 1 - Take positive video example
%
% We will take a video using the included function takeSnapshots.m. This
% function will use a webcam to take video and save individual jpg images.
% When taking the video make sure the user's face is in every frame and
% approximately facing forward. Trying to turn your face to get a too wide
% a range of images is likely to make training fail.

% Set options
options.runtime = 30;  % Total runtime to collect video (in seconds)
options.numImgs = 200; % Total number of images to save
options.vid = videoinput('winvideo', 1, 'YUY2_640X480'); % Change this line
                       % to use different camera settings
%options.vid = videoinput('winvideo', 2, 'MJPG_640x480');                        
options.filename = [pwd '\Positive Images\']; % Location of the positive 
                       % image directory

% Take video
takeSnapshots(options);

%% Step 2 - Label objects
%
% We need to go through the images we just saved and label the user's face.
% We can do the labeling either autonomously using a pretrained detector or
% manually (using the function CascadeTrainGUI available from
% MatlabCentral). 

% Set the method to use
method = 'autonomous'; % {'autonomous', 'manual'}

%****************************************%
% Method 1 - Using a pretrained detector %
%****************************************%
if strcmp(method, 'autonomous')
    % Set options
    options.usePretrainedObjectDetector = true;
    options.detector = vision.CascadeObjectDetector('FrontalFaceCART');

    % Label faces using the included function labelPositiveExamples.m
    data = labelPositiveExamples(options);
end

%**************************************%
% Method 2 - Manually labeling objects %
%**************************************%
if strcmp(method, 'manual')
    % Load the CascadeTrainGUI. 
    % 
    % Once in the GUI hit the 'Load Directory' in the bottom left; select 
    % the 'Positive Images' directory. All of the images from the video 
    % should pop up automatically. For each frame, click on the image to 
    % change the mouse cursor from 'pointer' mode to 'select' mode, then 
    % drag a bounding box around the user's face; once you are happy with 
    % the bounding box hit the 'right arrow' below the image to move onto 
    % the next frame; repeat for all frames in the directory.
    %
    % After labeling every frame, go to "File>>Save/Export Session As", at 
    % the prompt save the results as 'data'. 
    CascadeTrainGUI
    
    % Full session info will be saved as a mat file in the 
    % 'cascadetraingui' directory; you can delete this mat file as we won't
    % be using it. What we will use is the 'data' struct that appears in 
    % the workspace. We save it:
    save(options.filename, 'data');
end

%% Step 3 - Take negative video example
%
% Next we take a video explicitly WITHOUT the user. Make sure not to be in
% the video. As the video is taking move the camera to give slight 
% variation in the captured images.

% Set options
options.runtime = 30;
options.numImgs = 250; 
options.filename = [pwd '\Negative Images\'];

% Take video
takeSnapshots(options);

%% Step 4 - Train classifier
%
% Next we train a classifier using trainCascadeObjectDetector.

% Load the bounding box data (if it's not already in the workspace). Note:
% the 'data' struct has the location of the positive image locations.
load('data.mat')

% Set the negative image directory
negativeFolder = [pwd '\Negative Images\'];

% Note: the following command can take several minutes
trainCascadeObjectDetector( ...
    'userDefinedFaceDetector.xml', ...
    data, ...
    negativeFolder, ...
    'FalseAlarmRate', 0.2, ...
    'NumCascadeStages', 5);
    

%% Step 5 - Test classifier on live video
%
% Finally we test our classifier on live video.

% Load the newly-trained detector
options.detector = vision.CascadeObjectDetector('userDefinedFaceDetector.xml');

% Test classifier on video
testClassifier(options)



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid 
vid = videoinput('winvideo' , 1, 'YUY2_640X480');% Create a video input with YUY2 format and 640X480 resolution
%Set the parameters for video
triggerconfig( vid,'manual');                                      % the trigger occurs only after the trigger function
set(vid, 'FramesPerTrigger',1);                                     % one frame acquired per trigger
set(vid, 'TriggerRepeat',Inf);                                      % Keep executing the trigger every time the trigger condition is met until the stop function is called 
set(vid,'ReturnedColorSpace','rgb');                                % to get the rgb colour image 
%vid.Timeout = 30;
set(vid,'Timeout',50); 
start(vid);
%bool = isrunning(vid);
while (1)
options.detector = vision.CascadeObjectDetector('userDefinedFaceDetector.xml');
options.detector = vision.CascadeObjectDetector;                            % Create a cascade detector object
options.detector.MergeThreshold =8;
trigger(vid);                                                               %trigger to get the frame from the video
%image = getdata(vid,1,'uint8');                                             %store that frame in 'image'b
image=getdata(vid);
bbox = step(options.detector, image);                                       % position of face in 'bbox' (x, y, width and height)
insert_object = insertObjectAnnotation(image,'rectangle',bbox,'Face');      % Draw the bounding box around the detected face.
imshow(insert_object);hold on
%testClassifier(options)
axis off;                                                                   % invisible the axis from GUI
no_rows =size(bbox,1);                                                    % get the number of rows (which will be equal to number of people)
X = sprintf('%d', no_rows);
set(handles.text2,'string',X);                                              %display the value of X in GUI
hold off;
end
