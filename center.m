function varargout = center(varargin)
% CENTER MATLAB code for center.fig
%      CENTER, by itself, creates a new CENTER or raises the existing
%      singleton*.
%
%      H = CENTER returns the handle to a new CENTER or the handle to
%      the existing singleton*.
%
%      CENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CENTER.M with the given input arguments.
%
%      CENTER('Property','Value',...) creates a new CENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before center_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to center_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help center

% Last Modified by GUIDE v2.5 04-Apr-2018 09:30:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @center_OpeningFcn, ...
                   'gui_OutputFcn',  @center_OutputFcn, ...
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


% --- Executes just before center is made visible.
function center_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to center (see VARARGIN)

% Choose default command line output for center
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes center wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = center_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_count.
function btn_count_Callback(hObject, eventdata, handles)
% hObject    handle to btn_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close('center');
run('peoplecount');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('center');
run('count')


% --- Executes on button press in btn_singout.
function btn_singout_Callback(hObject, eventdata, handles)
% hObject    handle to btn_singout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('center');
run('login')
