function varargout = Protodrive2GUI(varargin)
% PROTODRIVE2GUI M-file for Protodrive2GUI.fig
%      PROTODRIVE2GUI, by itself, creates a new PROTODRIVE2GUI or raises the existing
%      singleton*.
%
%      H = PROTODRIVE2GUI returns the handle to a new PROTODRIVE2GUI or the handle to
%      the existing singleton*.
%
%      PROTODRIVE2GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROTODRIVE2GUI.M with the given input arguments.
%
%      PROTODRIVE2GUI('Property','Value',...) creates a new PROTODRIVE2GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Protodrive2GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Protodrive2GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Protodrive2GUI

% Last Modified by GUIDE v2.5 17-Apr-2014 15:04:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Protodrive2GUI_OpeningFcn, ...
    'gui_OutputFcn',  @Protodrive2GUI_OutputFcn, ...
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


% --- Executes just before Protodrive2GUI is made visible.
function Protodrive2GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Protodrive2GUI (see VARARGIN)

% Choose default command line output for Protodrive2GUI
handles.output = hObject;

% Update handles structure
handles.isDone = 1;
guidata(hObject, handles);

% UIWAIT makes Protodrive2GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Protodrive2GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TIMEOUT = 5;    %time to wait for data before aborting
n=0;
i=1;
set(handles.startButton,'UserData',0);
%set(handles.EditSpeed, 'UserData',0.6);

try
    
    %create serial object to represent connection to mbed
    mbed = serial('/dev/tty.usbmodem1422');       %change depending on mbed configuration
    set(mbed,'Timeout',TIMEOUT);        %adjust timeout to ensure fast response when mbed disconnected
    
    fopen(mbed);        %open serial connection
    
    
    while(n < 10000)
        t(i) = fscanf(mbed, '%f');
        disp(t(i));
        i=i+1;
        
        set(gcf,'color','white');
        drawnow;
        plot(handles.currentAxes,t,'-.dk','linewidth',1.8)
        title(handles.currentAxes,'Current vs. time');
        xlabel(handles.currentAxes,'Time (s/10)');
        ylabel(handles.currentAxes,'Current (Amps)');
        n = n+1;
        %pause(0.1);       
        %fprintf(mbed, '%fn', get(handles.EditSpeed,'UserData'));
        disp(get(handles.EditSpeed,'UserData'));
        %drawnow; %force event queue update
        if get(handles.startButton,'UserData')
            break;
        end
    end
    
    fclose(mbed);   %close connection (this should never be reached when using while(1), but included for completeness)
    
catch exception
    %in case of error or mbed being disconnected
    disp(getReport(exception,'extended'));
    fclose(mbed);   %close connection to prevent COM port being lokced open
end






% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Stop button pressed');
set(handles.startButton,'UserData',1);



function EditSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to EditSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of EditSpeed as text
%        str2double(get(hObject,'String')) returns contents of EditSpeed as a double
set(handles.EditSpeed, 'UserData',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function EditSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DriveCycleSelector.
function DriveCycleSelector_Callback(hObject, eventdata, handles)
% hObject    handle to DriveCycleSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DriveCycleSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DriveCycleSelector


% --- Executes during object creation, after setting all properties.
function DriveCycleSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DriveCycleSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
