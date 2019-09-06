function varargout = FrameAnalyzer(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FrameAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @FrameAnalyzer_OutputFcn, ...
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


function FrameAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = FrameAnalyzer_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function NameBox_Callback(hObject, eventdata, handles)


function NameBox_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkFigureNumber()
    h = findobj('type','figure');
    n= length(h);
    if(n==1)
        figure(1);
        return;

    end


function initial_but_Callback(hObject, eventdata, handles)

%fileName = get(handles.NameBox,'String');
%folderName = get(handles.FolderName,'String');

[baseName, folder] = uigetfile('*.MOV');
filePath = fullfile(folder, baseName)
 
folderPath = uigetdir();
global frames_path;
global leg_counter;
global frames_path;
global counter;
global data;
global flag;
global flag_;
global flag_2;
global frames_num;

leg_counter =0;
frames_num =1;
counter =0;

set(handles.uitable1, 'Data', {});
data =zeros();
 
    frames_path = video2frame(filePath,folderPath);
   
frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));
set(handles.leg_numbox,'String',num2str(0));
I=imread(fullfile(frames_path,filename));

% function start here
SeperateView(I);

% end here

flag =1; % for curve
flag_ =0; % for save
flag_2 = 1;

function SeperateView(I)
hFig = figure('Toolbar','none',...
'Menubar','none');
hIm = imshow(I);
%hFig= figure(1);
hSP = imscrollpanel(hFig,hIm);
api = iptgetapi(hSP);
api.setMagnification(2) % 2X = 200%

hMagBox = immagbox(hFig, hIm);
boxPosition = get(hMagBox, 'Position');
set(hMagBox,'Position', [0, 0, boxPosition(3), boxPosition(4)])
imoverview(hIm)

% Get the scroll panel API to programmatically control the view.
api = iptgetapi(hSP);
% Get the current magnification and position.
mag = api.getMagnification();
r = api.getVisibleImageRect();
set(hIm,'ButtonDownFcn',@curve);
set(hFig,'KeyPressFcn',@press);

function curve(~,~)
% Init control polygon
%figure;
%axis([0 1 0 1]);
%imshow('frame3.jpg');
global flag;
global flag_;
global pts;
global c;
global canManipulatePts;
global h1;
global h0;
if(flag)

[x, y] = getpts();
x = x';
y = y';
canManipulatePts = false;



  
    % Plot control polygon
    hold on;
    h0 = plot(x, y, 'b-o');
    hold on;

    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);

    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);
    pts = [x; y];
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end

    % Plot curve
    %axis([0 1 0 1]);
    h1 = plot(c(1, :), c(2, :), '-r');
    canManipulatePts = true;

    % Manipulate points
    flag=0;
    
    
    
end

function press(hObject, eventdata, handles)
key_press = get(gcf,'currentKey');
global frames_path;
global flag_;
global flag_2;
global x;
global y;
global x_;
global y_;
global flag;
global frames_num;
global pts;
global c;
global counter;
global h1;
global h0;
h_box = findall(0,'tag','frame_numbox');
frames_num= str2num(get(h_box,'String'));
global leg_counter;
global data;

global canManipulatePts;
if((strcmp(key_press,'x')||strcmp(key_press,'X'))&&flag_2)
    handle_fig = figure(1);
    close(handle_fig);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
end
if((strcmp(key_press,'s')||strcmp(key_press,'S'))&&flag_2)
    
    flag=1;
    counter = counter + 1;
    leg_counter=leg_counter+1;
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =pts(1,i);
    end
    
    counter = counter+1;
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =pts(2,i);
    end
    handles_uitable  = findall(0,'tag','uitable1');
    set(handles_uitable,'data',data);
    
    
end
    

if((strcmp(key_press,'d')||strcmp(key_press,'D'))&&flag_2)
    
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num +1;
    leg_counter = 1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
end

if ((strcmp(key_press,'a')||strcmp(key_press,'A'))&&flag_2)
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num -1;
    leg_counter=1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
   
end
if((strcmp(key_press,'r')||strcmp(key_press,'R'))&&flag_2)
    if (canManipulatePts)
       
        pts = reposition(pts); 
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        x = pts(1, :);
        y = pts(2, :);
        hold on;
    h0 = plot(x, y, 'b-o');
    hold on;

    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);

    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);
    pts = [x; y];
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end

    h1 = plot(c(1, :), c(2, :), '-r');
    end
    
 
end
if((strcmp(key_press,'e')||strcmp(key_press,'E'))&&flag_2)
    if (canManipulatePts)
       
        pts = reposition_e(pts); 
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        x = pts(1, :);
        y = pts(2, :);
        hold on;
    h0 = plot(x, y, 'b-o');
    hold on;

    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);

    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);
    pts = [x; y];
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end

    h1 = plot(c(1, :), c(2, :), '-r');
    end
    
 
end

function click(~,~)
     global x;
     global y;
     global flag;
   
    if flag ==1 
    [x,y]=ginput(5); 
    flag =0;
    end
    
    global flag_;
    flag_=1;

function export_but_Callback(hObject, eventdata, handles)
data = get(handles.uitable1,'Data');
 name = datestr(now);
 FileName = uiputfile(strcat(name,'.xlsx'),'Save as');
 xlswrite(FileName,data);

function frame_numbox_Callback(hObject, eventdata, handles)

function frame_numbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function leg_numbox_Callback(hObject, eventdata, handles)

function leg_numbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function previous_but_Callback(hObject, eventdata, handles)

function calculate_but_Callback(hObject, eventdata, handles)

function next_but_Callback(hObject, eventdata, handles)




function FolderName_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function FolderName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frame_numbox_KeyPressFcn(hObject, eventdata, handles)
global frames_num;
global flag;
global frames_path;
global leg_counter;

%display('HelloWOrld');
key_press = get(gcf,'currentKey');

if(strcmp(key_press,'return'))
    pause(0.2);
    frames_num = str2num(get(handles.frame_numbox,'String'));
    handle_fig = figure(1);
    close(handle_fig);
    %display('HelloWOrld');
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    SeperateView(I);
    leg_counter =0;
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

%fileName = get(handles.NameBox,'String');
%folderName = get(handles.FolderName,'String');

folderPath = uigetdir();
global frames_path;
global leg_counter;
global frames_path;
global counter;
global data;
global flag;
global flag_;
global flag_2;
global frames_num;

leg_counter =0;
frames_num =1;
counter =0;

set(handles.uitable1, 'Data', {});
data =zeros();
 
    frames_path = folderPath;

frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));
set(handles.leg_numbox,'String',num2str(0));
I=imread(fullfile(frames_path,filename));

% function start here
SeperateView(I);

% end here

flag =1; % for curve
flag_ =0; % for save
flag_2 = 1;