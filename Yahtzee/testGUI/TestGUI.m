

function varargout = TestGUI(varargin)
% TESTGUI MATLAB code for TestGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*. in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TestGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TestGUI

% Last Modified by GUIDE v2.5 02-Dec-2017 15:40:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TestGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TestGUI_OutputFcn, ...
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
client_id = '1035835549229-384kn8b8qtkhpguq7rab3l2d2agasl9l.apps.googleusercontent.com';
    client_secret = '5ogg9dZ09nmo3lOIK66EB0DO';
    spreadsheetID = '1HVjyz4M1jU5bDsVdq7YbaI5K0Q_Oja0mYAE32CjCOFQ';
    sheetID = '0';
    
    % connect once
    RunOnce(client_id, client_secret); 
    
    %initiate: third column in the sheet reserved for player taking turn
    %i.e. next line means player 1 starts first
    mat2sheets(spreadsheetID, sheetID, [1 3], {'player1'}); 
    mat2sheets(spreadsheetID, sheetID, [2 3], {'player2'}); 
    
    %game info
    
    
    %request id: 1 for player1, 2 for player 2 
    playerID = input('-> Enter your ID: ');
    
    %current and other player data 
    playerName = [];
    otherPlayerID = [];
    if(playerID == 1)
        playerName = 'player1';
        otherPlayerID = 2;
    else
        playerName = 'player2';
        otherPlayerID = 1;
    end
    
    %game play: check whose turn it is then decide whether to play or wait
    %for the current player turn or end the game.
    
        % find whose turn it is
        gameData = GetGoogleSpreadsheet(spreadsheetID);
        currentPlayer = gameData{1,3};
        fprintf('you are %s ',playerName);
        
            fprintf(' your turn');
            if strcmp(playerName,'player1')
        	fprintf(' your turn');
            
            else fprintf('wait');
            
        end

% End initialization code - DO NOT EDIT

%  Academic Integrity Statement:
%
%      We have not used source code obtained from
%       any other unauthorized source, either modified
%       or unmodified.  Neither have we provided access
%       to our code to other teams. The project we are
%       submitting is our own original work.

% --- Executes just before TestGUI is made visible.
function TestGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TestGUI (see VARARGIN)
clc
blankDie = imread('Blank Square.png'); %start with blank squares before roll
for i = 1:6
    axes(handles.(sprintf('axes%i',i)))
    imshow(blankDie)
end
msgbox({'This game is played between 2 players. Each player has six dice to roll.' ...
    'The goal is to obtain the highest number of points with the restriction that one', ...
    'of the die must be a one and the other a four. Each roll, the player must keep at', ... 
    'least one of the dice and roll the rest, but they can keep more than one if desired.', ...
    'After the first player rolls, the second player rolls, and also chooses one or more', ...
    'dice to keep. Each player takes turns rolling until both players have no more dice to', ...
    'roll. Each player adds up their dice, setting aside the one and four (these don’t count', ...
    'as points). If one of the players does not have a one or four in their final outcome,', ...
    'they are disqualified and the other player wins the game. The player with the highest', ...
    'number of points wins the game.'}, 'How to Play MIDNIGHT')
% Choose default command line output for TestGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TestGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TestGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;








% --- Executes on button press in initialRoll1.
function initialRoll1_Callback(hObject, eventdata, handles)
% hObject    handle to initialRoll1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rolls = randi([1,6],1,6); %roll dice
%mat2sheets(spreadsheetID, sheetID, [1 1], {rolls});
set(handles.text2, 'UserData', rolls); %puts values in text box
%set(handles.text2,'string',mat2str(get(handles.text2,'UserData')));
if exist('dice1Blue', 'var') 
    
else
dice1Blue = imread('Dice 1 Blue.png');
dice2Blue = imread('Dice 2 Blue.png');
dice3Blue = imread('Dice 3 Blue.png');
dice4Blue = imread('Dice 4 Blue.png');
dice5Blue = imread('Dice 5 Blue.png');
dice6Blue = imread('Dice 6 Blue.png');
[amps, freq] = audioread('Dice Sound 3.mp3');
diceSound = audioplayer(amps, freq);  %load sounds and images
end
play(diceSound)
for i = 1:6
    axes(handles.(sprintf('axes%i',i))) %select each axes before showing each dice image
    randomThree = randi([1,6],1,3);   %generates random dice numbers before displaying actual roll
    for j = 1:3
        switch randomThree(j)
            case 1
                imshow(dice1Blue)
            case 2
                imshow(dice2Blue)
            case 3
                imshow(dice3Blue)
            case 4
                imshow(dice4Blue)
            case 5
                imshow(dice5Blue)
            case 6
                imshow(dice6Blue)
        end
        pause(.125)
    end
    switch rolls(i)   %shows actual rolls
        case 1
            imshow(dice1Blue)
        case 2
            imshow(dice2Blue)
        case 3
            imshow(dice3Blue)
        case 4
            imshow(dice4Blue)
        case 5
            imshow(dice5Blue)
        case 6
            imshow(dice6Blue)
    end
    
end
%disp(get(handles.text2,'UserData'))
set(handles.initialRoll1, 'Enable', 'off') %disables roll button

% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'Each player has six dice to roll.', 'In order to win you must have a',...
    'higher number of points than your opponent.', 'At least one die must be',...
    'a one and another a four', 'Each roll the player must keep', ...
    'at least one of their dice.', 'Once you have rolled and selected', ...
    'six dice, the player is done', 'and the total of their four',...
    'dice not including the four and one', 'are added together. If there is',...
    'no four and or one in their', 'final outcome, the player is disqualified.'}, 'Rules') %shows rules


% --- Executes on button press in reroll1.
function reroll1_Callback(hObject, eventdata, handles)
% hObject    handle to reroll1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dice1Blue = imread('Dice 1 Blue.png'); %make these global(?)
dice2Blue = imread('Dice 2 Blue.png');
dice3Blue = imread('Dice 3 Blue.png');
dice4Blue = imread('Dice 4 Blue.png');
dice5Blue = imread('Dice 5 Blue.png');
dice6Blue = imread('Dice 6 Blue.png');
storedValues = zeros(1,6);   %initialize stored values
rolls = get(handles.text2, 'UserData'); %retrieves rolls 
%handles not globals
numStored = length(get(handles.keptDice1, 'UserData'));
if numStored == 6
    set(handles.reroll1, 'Enable', 'off');  %disable reroll button
    checkNum1 = find(get(handles.keptDice1, 'UserData') == 1);
    checkNum4 = find(get(handles.keptDice1, 'UserData') == 4);
    if (length(checkNum1)~= 0) & (length(checkNum4) ~= 0)  %checks for a one and four
        score = sum(get(handles.keptDice1, 'UserData'))-5;
    else
        msgbox('You have been disqualified');
        score = 0;
    end
    set(handles.finalScore1, 'String', num2str(score))
    set(handles.finalScore1, 'UserData', score) %change finalScore to finalScore1, keptDice to keptDice1, etc (GUI elements)
else
    uncheckedEnabled = zeros(1,6);
for i = 1:6     %checks if any box is checked
   if (get(handles.(sprintf('checkbox%i',i)), 'Value') == 0) | strcmp(get(handles.(sprintf('checkbox%i',i)), 'Enable'), 'off') == 1 
       
   else
       uncheckedEnabled(i) = 1;
   end
end
%disp(uncheckedEnabled)
numChecked = sum(uncheckedEnabled); %total number of boxes checked by the user
if numChecked == 0
   msgbox('You must check at least one box.')
else
for i = 1:6
    if get(handles.(sprintf('checkbox%i',i)), 'Value') == 1 
       storedValues(i) = rolls(i);
       set(handles.(sprintf('checkbox%i',i)), 'Enable', 'off')   %storing checkboxed values
    end
end
%disp(storedValues)
set(handles.keptDice1, 'UserData', storedValues(storedValues~=0))
set(handles.keptDice1, 'String', num2str(storedValues(storedValues~=0))) %displays in textbox
numStored = length(get(handles.keptDice1, 'UserData'));
if numStored == 6
    number = get(handles.keptDice1, 'UserData');
    mat2sheets(spreadsheetID, sheetID, [1 1], {number});%upload the player1 outcome
    set(handles.reroll1, 'Enable', 'off');  %disable reroll button
    checkNum1 = find(get(handles.keptDice1, 'UserData') == 1);
    checkNum4 = find(get(handles.keptDice1, 'UserData') == 4);
    if (length(checkNum1)~= 0) & (length(checkNum4) ~= 0)  %checks for a one and four
        score = sum(get(handles.keptDice1, 'UserData'))-5;
         mat2sheets(spreadsheetID, sheetID, [1 2], {score});
    else
        msgbox('You have been disqualified.');
        score = 0;
    end
    set(handles.finalScore1, 'String', num2str(score))
    mat2sheets(spreadsheetID, sheetID, [1 3], {'player2'});
   
            set(handles.initialRoll2, 'Enable', 'on');
            set(handles.reroll2, 'Enable', 'on');
          
end
unchecked = zeros(1,6);
for i = 1:6     %checks if box is unchecked
    if get(handles.(sprintf('checkbox%i',i)), 'Value') == 0
        unchecked(i) = 1;
    end
end
%disp(unchecked)
for i = 1:6     %rerolls unchecked boxes
    if unchecked(i) == 1
        axes(handles.(sprintf('axes%i',i)))
        randomThree = randi([1,6],1,3);
        rolls = randi([1,6],1,6);
        oldRolls = get(handles.text2, 'UserData'); %replacing old rolls with new values
        oldRolls(i) = rolls(i);
        set(handles.text2, 'UserData', oldRolls);
        %disp(get(handles.text2, 'UserData'))
     for j = 1:3
        switch randomThree(j)
            case 1
                imshow(dice1Blue)
            case 2
                imshow(dice2Blue)
            case 3
                imshow(dice3Blue)
            case 4
                imshow(dice4Blue)
            case 5
                imshow(dice5Blue)
            case 6
                imshow(dice6Blue)
        end
        pause(.125)
    end
    switch rolls(i)
        case 1
            imshow(dice1Blue)
        case 2
            imshow(dice2Blue)
        case 3
            imshow(dice3Blue)
        case 4
            imshow(dice4Blue)
        case 5
            imshow(dice5Blue)
        case 6
            imshow(dice6Blue)
    end
    end
end
end
end


% --- Executes on button press in initialRoll2.
function initialRoll2_Callback(hObject, eventdata, handles)
% hObject    handle to initialRoll2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rolls = randi([1,6],1,6); %roll dice
%mat2sheets(spreadsheetID, sheetID, [1 1], {rolls});
set(handles.text2, 'UserData', rolls); %puts values in text box
%set(handles.text2,'string',mat2str(get(handles.text2,'UserData')));
if exist('dice1Blue', 'var') 
    
else
dice1Blue = imread('Dice 1 Blue.png');
dice2Blue = imread('Dice 2 Blue.png');
dice3Blue = imread('Dice 3 Blue.png');
dice4Blue = imread('Dice 4 Blue.png');
dice5Blue = imread('Dice 5 Blue.png');
dice6Blue = imread('Dice 6 Blue.png');
[amps, freq] = audioread('Dice Sound 3.mp3');
diceSound = audioplayer(amps, freq);  %load sounds and images
end
play(diceSound)
for i = 1:6
    axes(handles.(sprintf('axes%i',i))) %select each axes before showing each dice image
    randomThree = randi([1,6],1,3);   %generates random dice numbers before displaying actual roll
    for j = 1:3
        switch randomThree(j)
            case 1
                imshow(dice1Blue)
            case 2
                imshow(dice2Blue)
            case 3
                imshow(dice3Blue)
            case 4
                imshow(dice4Blue)
            case 5
                imshow(dice5Blue)
            case 6
                imshow(dice6Blue)
        end
        pause(.125)
    end
    switch rolls(i)   %shows actual rolls
        case 1
            imshow(dice1Blue)
        case 2
            imshow(dice2Blue)
        case 3
            imshow(dice3Blue)
        case 4
            imshow(dice4Blue)
        case 5
            imshow(dice5Blue)
        case 6
            imshow(dice6Blue)
    end
    
end
%disp(get(handles.text2,'UserData'))
set(handles.initialRoll2, 'Enable', 'off') %disables roll button


% --- Executes on button press in reroll2.
function reroll2_Callback(hObject, eventdata, handles)
% hObject    handle to reroll2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dice1Blue = imread('Dice 1 Blue.png'); %make these global(?)
dice2Blue = imread('Dice 2 Blue.png');
dice3Blue = imread('Dice 3 Blue.png');
dice4Blue = imread('Dice 4 Blue.png');
dice5Blue = imread('Dice 5 Blue.png');
dice6Blue = imread('Dice 6 Blue.png');
storedValues = zeros(1,6);   %initialize stored values
rolls = get(handles.text2, 'UserData'); %retrieves rolls 
%handles not globals
numStored = length(get(handles.keptDice1, 'UserData'));
if numStored == 6
    set(handles.reroll1, 'Enable', 'off');  %disable reroll button
    checkNum1 = find(get(handles.keptDice2, 'UserData') == 1);
    checkNum4 = find(get(handles.keptDice2, 'UserData') == 4);
    if (length(checkNum1)~= 0) & (length(checkNum4) ~= 0)  %checks for a one and four
        score = sum(get(handles.keptDice2, 'UserData'))-5;
    else
        msgbox('You have been disqualified');
        score = 0;
    end
    set(handles.finalScore2, 'String', num2str(score))
    set(handles.finalScore2, 'UserData', score) %change finalScore to finalScore1, keptDice to keptDice1, etc (GUI elements)
else
    uncheckedEnabled = zeros(1,6);
for i = 1:6     %checks if any box is checked
   if (get(handles.(sprintf('checkbox%i',i+7)), 'Value') == 0) | strcmp(get(handles.(sprintf('checkbox%i',i+7)), 'Enable'), 'off') == 1 
       
   else
       uncheckedEnabled(i) = 1;
   end
end
%disp(uncheckedEnabled)
numChecked = sum(uncheckedEnabled); %total number of boxes checked by the user
if numChecked == 0
   msgbox('You must check at least one box.')
else
for i = 1:6
    if get(handles.(sprintf('checkbox%i',i+7)), 'Value') == 1 
       storedValues(i) = rolls(i);
       set(handles.(sprintf('checkbox%i',i+7)), 'Enable', 'off')   %storing checkboxed values
    end
end
%disp(storedValues)
set(handles.keptDice2, 'UserData', storedValues(storedValues~=0))
set(handles.keptDice2, 'String', num2str(storedValues(storedValues~=0))) %displays in textbox
numStored = length(get(handles.keptDice2, 'UserData'));
if numStored == 6
    number = get(handles.keptDice2, 'UserData');
    mat2sheets(spreadsheetID, sheetID, [2 1], {number});%upload the player1 outcome
    set(handles.reroll2, 'Enable', 'off');  %disable reroll button
    checkNum1 = find(get(handles.keptDice2, 'UserData') == 1);
    checkNum4 = find(get(handles.keptDice2, 'UserData') == 4);
    if (length(checkNum1)~= 0) & (length(checkNum4) ~= 0)  %checks for a one and four
        score = sum(get(handles.keptDice2, 'UserData'))-5;
        mat2sheets(spreadsheetID, sheetID, [2 2], {score});
    else
        msgbox('You have been disqualified.');
        score = 0;
    end
    set(handles.finalScore2, 'String', num2str(score))
    mat2sheets(spreadsheetID, sheetID, [1 3], {'endGame'});
end
unchecked = zeros(1,6);
for i = 1:6     %checks if box is unchecked
    if get(handles.(sprintf('checkbox%i',i+7)), 'Value') == 0
        unchecked(i) = 1;
    end
end
%disp(unchecked)
for i = 1:6     %rerolls unchecked boxes
    if unchecked(i) == 1
        axes(handles.(sprintf('axes%i',i+6)))
        randomThree = randi([1,6],1,3);
        rolls = randi([1,6],1,6);
        oldRolls = get(handles.text2, 'UserData'); %replacing old rolls with new values
        oldRolls(i) = rolls(i);
        set(handles.text2, 'UserData', oldRolls);
        %disp(get(handles.text2, 'UserData'))
     for j = 1:3
        switch randomThree(j)
            case 1
                imshow(dice1Blue)
            case 2
                imshow(dice2Blue)
            case 3
                imshow(dice3Blue)
            case 4
                imshow(dice4Blue)
            case 5
                imshow(dice5Blue)
            case 6
                imshow(dice6Blue)
        end
        pause(.125)
    end
    switch rolls(i)
        case 1
            imshow(dice1Blue)
        case 2
            imshow(dice2Blue)
        case 3
            imshow(dice3Blue)
        case 4
            imshow(dice4Blue)
        case 5
            imshow(dice5Blue)
        case 6
            imshow(dice6Blue)
    end
    end
end
end
end


% --- Executes on button press in checkbox8.
function start_Callback(hObject, eventdata, handles)
 set(handles.initialRoll1, 'Enable', 'on');
 set(handles.reroll1, 'Enable', 'on');
            

           
        
  


