function varargout = Registeration(varargin)
% REGISTERATION MATLAB code for Registeration.fig
%      REGISTERATION, by itself, creates a new REGISTERATION or raises the existing
%      singleton*.
%
%      H = REGISTERATION returns the handle to a new REGISTERATION or the handle to
%      the existing singleton*.
%
%      REGISTERATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTERATION.M with the given input arguments.
%
%      REGISTERATION('Property','Value',...) creates a new REGISTERATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Registeration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Registeration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Registeration

% Last Modified by GUIDE v2.5 23-Mar-2018 22:29:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Registeration_OpeningFcn, ...
                   'gui_OutputFcn',  @Registeration_OutputFcn, ...
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


% --- Executes just before Registeration is made visible.
function Registeration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Registeration (see VARARGIN)

% Choose default command line output for Registeration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Registeration wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Registeration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function username_Callback(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of username as text
%        str2double(get(hObject,'String')) returns contents of username as a double


% --- Executes during object creation, after setting all properties.
function username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function password_Callback(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of password as text
%        str2double(get(hObject,'String')) returns contents of password as a double


% --- Executes during object creation, after setting all properties.
function password_CreateFcn(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_reg.
function btn_reg_Callback(hObject, eventdata, handles)
user_function(handles)
% hObject    handle to btn_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function [ msg ] = user( username, password )
%DB Service Port, Username, Password
host = 'localhost:3306';
user = 'root';
psw = '';

%Database Name
dbname = 'test';

%JDBC Parameters
jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbname);
jdbcDriver = 'com.mysql.jdbc.Driver';

%Path to mysql Connector
javaaddpath = ('mysql-connector-java-5.1.46-bin.jar');

%Now making DB connection Object
dbConn = database(dbname, user, psw, jdbcDriver, jdbcString);

%checking Connection Status
dbStatus = isopen(dbConn);
if (dbStatus==0)
    msg = sprintf('Error to estabilish the connection.\nReason: %s', dbConn.Message);
    msgbox(msg);
    return
end
%Register user 
userName = username;
password = password;
%MD5 =mMD5(password);
colnames = {'userName','password'};
data={username,password,};
datainsert(dbConn,'login',colnames,data);
msg=1;
%closing connection
close(dbConn);
function user_function(handles)
    UserName = get(handles.username, 'String');
    Password = get(handles.password, 'String');
    %Password= mMD5(get(handles.password, 'String'));
    
    if isempty(UserName) && isempty(Password)
        msgbox('Please fill the User Name and Password', 'Error','error');
    else
    msg = user(UserName, Password);
    
        if msg == 1
            close ('Registeration');

            run('login');

        else
            msgbox('Please Register hear', 'Error','error');
        end
    
    end


% --- Executes on button press in btn_ext.
function btn_ext_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close ('Registeration');
run('login');
