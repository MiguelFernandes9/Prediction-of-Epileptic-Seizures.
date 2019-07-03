function varargout = New_GUI(varargin)
% NEW_GUI MATLAB code for New_GUI.fig
%      NEW_GUI, by itself, creates a new NEW_GUI or raises the existing
%      singleton*.
%
%      H = NEW_GUI returns the handle to a new NEW_GUI or the handle to
%      the existing singleton*.
%
%      NEW_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEW_GUI.M with the given input arguments.
%
%      NEW_GUI('Property','Value',...) creates a new NEW_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before New_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to New_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help New_GUI

% Last Modified by GUIDE v2.5 08-Nov-2018 23:44:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @New_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @New_GUI_OutputFcn, ...
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


% --- Executes just before New_GUI is made visible.
function New_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to New_GUI (see VARARGIN)

% Choose default command line output for New_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes New_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global FileName;
global FilePath;
FileName = "null";
global trainingf;
global testingf;
global training_sets;
global type_classifier;
global network;
global train_func;


disp("Hello")

% --- Outputs from this function are returned to the command line.
function varargout = New_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in dataset_box.
function dataset_box_Callback(hObject, eventdata, handles)
% hObject    handle to dataset_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataset_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataset_box


% --- Executes during object creation, after setting all properties.
function dataset_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataset_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testing_box_Callback(hObject, eventdata, handles)
% hObject    handle to testing_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testing_box as text
%        str2double(get(hObject,'String')) returns contents of testing_box as a double


% --- Executes during object creation, after setting all properties.
function testing_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testing_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function training_box_Callback(hObject, eventdata, handles)
% hObject    handle to training_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of training_box as text
%        str2double(get(hObject,'String')) returns contents of training_box as a double


% --- Executes during object creation, after setting all properties.
function training_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to training_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Results_button.
function Results_button_Callback(hObject, eventdata, handles)
% hObject    handle to Results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global trainingf;
global testingf;
global training_sets;
global type_classifier;
global network;
global train_func;
global FileName;
val = get(handles.dataset_box,'Value');
aux = get(handles.Group_dataset,'Value');
if(aux == 1)
   if (val == 1)
    FileName = '54802.mat';
   elseif (val == 2)
    FileName = '112502.mat';
   end 
end
%choose network simply feed foward
trainingf =  get(handles.training_box,'String');%return string Tarinnig 
testingf = get(handles.testing_box,'String');%return string Testing
training_sets = get(handles.TrainingSets,'Value');%1 Classes balanceadas, 0 RawData
network = get(handles.Network, 'Value');%0 Normal, 1 recurrent ,2 Cnn,3 lstm
train_func = get(handles.Train_func, 'Value'); %0 traincgp, 1 trainscg, 2 traincgb
trainingf = "" + trainingf;
testingf = "" + testingf;
main(training_sets,FileName,double(trainingf),double(testingf),network,0,train_func);

function BestIctal_Callback(hObject, eventdata, handles)
% hObject    handle to BestIctal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global trainingf;
global testingf;
global training_sets;
global type_classifier;
global network;
global train_func;
global FileName;
val = get(handles.dataset_box,'Value');
aux = get(handles.Group_dataset,'Value');
disp(aux);
if(aux == 1)
   if (val == 1)
    FileName = '54802.mat';
   elseif (val == 2)
    FileName = '112502.mat';
   end 
end
testingf = get(handles.testing_box,'String');%return string
trainingf =  get(handles.training_box,'String');%return string
training_sets = get(handles.TrainingSets,'Value');%0 Classes balanceadas, 1 RawData
network = get(handles.Network, 'Value');%0 Normal, 1 recurrent ,2 Cnn,3 lstm
train_func = get(handles.Train_func, 'Value'); %0 traincgp, 1 trainscg, 2 traincgb
trainingf = "" + trainingf;
testingf = "" + testingf;
close;
main(3,FileName,double(trainingf),double(testingf),5,2,train_func);
% --- Executes on button press in Best_PreIctal.
function Best_PreIctal_Callback(hObject, eventdata, handles)
% hObject    handle to Best_PreIctal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global trainingf;
global testingf;
global training_sets;
global type_classifier;
global network;
global train_func;
global FileName;
val = get(handles.dataset_box,'Value');
aux = get(handles.Group_dataset,'Value');
if(aux == 1)
   if (val == 1)
    FileName = '54802.mat';
   elseif (val == 2)
    FileName = '112502.mat';
   end 
end
testingf = get(handles.testing_box,'String');%return string
trainingf =  get(handles.training_box,'String');%return string
training_sets = get(handles.TrainingSets,'Value');%0 Classes balanceadas, 1 RawData
network = get(handles.Network, 'Value');%0 Normal, 1 recurrent ,2 Cnn,3 lstm
train_func = get(handles.Train_func, 'Value'); %0 traincgp, 1 trainscg, 2 traincgb
trainingf = "" + trainingf;
testingf = "" + testingf;
main(3,FileName,double(trainingf),double(testingf),5,1,train_func);
% --- Executes on button press in Best_two.
function Best_two_Callback(hObject, eventdata, handles)
% hObject    handle to Best_two (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global trainingf;
global testingf;
global training_sets;
global type_classifier;
global network;
global train_func;
global FileName;
val = get(handles.dataset_box,'Value');
aux = get(handles.Group_dataset,'Value');
if(aux == 1)
   if (val == 1)
    FileName = '54802.mat';
   elseif (val == 2)
    FileName = '112502.mat';
   end 
end

testingf = get(handles.testing_box,'String');%return string
trainingf =  get(handles.training_box,'String');%return string
training_sets = get(handles.TrainingSets,'Value');%0 Classes balanceadas, 1 RawData
network = get(handles.Network, 'Value');%0 Normal, 1 recurrent ,2 Cnn,3 lstm
train_func = get(handles.Train_func, 'Value'); %0 traincgp, 1 trainscg, 2 traincgb
trainingf = "" + trainingf;
testingf = "" + testingf;
main(3,FileName,double(trainingf),double(testingf),5,3,train_func);
% --- Executes on selection change in TrainingSets.
function TrainingSets_Callback(hObject, eventdata, handles)
% hObject    handle to TrainingSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns TrainingSets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TrainingSets


% --- Executes during object creation, after setting all properties.
function TrainingSets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrainingSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typeofclassifier.
function typeofclassifier_Callback(hObject, eventdata, handles)
% hObject    handle to typeofclassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typeofclassifier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typeofclassifier


% --- Executes during object creation, after setting all properties.
function typeofclassifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typeofclassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Network.
function Network_Callback(hObject, eventdata, handles)
% hObject    handle to Network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Network contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Network


% --- Executes during object creation, after setting all properties.
function Network_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BestIctal.


% --- Executes on selection change in Train_func.
function Train_func_Callback(hObject, eventdata, handles)
% hObject    handle to Train_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Train_func contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Train_func


% --- Executes during object creation, after setting all properties.
function Train_func_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Train_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Dataset.
function Dataset_Callback(hObject, eventdata, handles)
% hObject    handle to Dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Dataset,'Value',1);
set(handles.Group_dataset,'Value',0);
global groupdataset;
groupdataset = 0;
global userdataset;
userdataset = 1;
global FileName;
global FilePath;
[FileName,FilePath]= uigetfile();
% Hint: get(hObject,'Value') returns toggle state of Dataset


% --- Executes on button press in Group_dataset.
function Group_dataset_Callback(hObject, eventdata, handles)
% hObject    handle to Group_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Dataset,'Value',0);
set(handles.Group_dataset,'Value',1);
global groupdataset;
groupdataset = 1;
global userdataset;
userdataset = 0;
global FileName;
global FilePath;
FileName = "null";
FilePath = "null";
% Hint: get(hObject,'Value') returns toggle state of Group_dataset
