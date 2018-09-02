function varargout = peoplecount(varargin)
% PEOPLECOUNT MATLAB code for peoplecount.fig
%      PEOPLECOUNT, by itself, creates a new PEOPLECOUNT or raises the existing
%      singleton*.
%
%      H = PEOPLECOUNT returns the handle to a new PEOPLECOUNT or the handle to
%      the existing singleton*.
%
%      PEOPLECOUNT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEOPLECOUNT.M with the given input arguments.
%
%      PEOPLECOUNT('Property','Value',...) creates a new PEOPLECOUNT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before peoplecount_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to peoplecount_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help peoplecount

% Last Modified by GUIDE v2.5 04-Apr-2018 10:41:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @peoplecount_OpeningFcn, ...
                   'gui_OutputFcn',  @peoplecount_OutputFcn, ...
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


% --- Executes just before peoplecount is made visible.
function peoplecount_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to peoplecount (see VARARGIN)

% Choose default command line output for peoplecount
handles.output = hObject;
axes(handles.axes1);
imshow('blank.jpg');
axis off;
set(handles.text6,'string','0');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes peoplecount wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = peoplecount_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_stcam.
function btn_stcam_Callback(hObject, eventdata, handles)
% hObject    handle to btn_stcam (see GCBO)
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


% --- Executes on button press in btn_cp.
function btn_cp_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cp (see GCBO)
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
%options.detector = vision.CascadeObjectDetector('userDefinedFaceDetector.xml');
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
set(handles.text6,'string',X);                                              %display the value of X in GUI
hold off;
end


% --- Executes on button press in btn_sc.
function btn_sc_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
%stop(vid),clear vid %stop the running video
%stoppreview(vid);
%vid.timerFcn={'stop'};
clc; clear;
%close all;
vid = imaqfind; %find video input objects in memory
delete(vid);


% --- Executes on button press in btn_menu.
function btn_menu_Callback(hObject, eventdata, handles)
% hObject    handle to btn_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close('peoplecount');
run('center');
