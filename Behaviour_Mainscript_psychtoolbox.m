% % % %Behavioural Script - Reaction time, finger tracing etc.
% % % % Based on MouseTraceDemo4 - Psychtoolbox
clear all
% % %% Code to connect to TPO .  Do not edit!
disp('Connecting to TPO....');
addpath('C:\toolbox\TPOcommands') % adds functions for issuing TPO commands to workspace
%USB communication code specific to device must be added here


%% BEHAVIOUR SCRIPT START%%
%skip sync test
Screen('Preference', 'SkipSyncTests', 0);
prompt = 'Please enter a unique filename ID:   ';
numba = input(prompt,'s');
numba = [numba date];
Behaviour_config;  %config file
filepath = 'C:\toolbox\';

excelname = [filepath numba];
timer1=0;
i = 1;
RTstart = 0;
DatSet1 = [];
DatSet2 = [];
DatSet3 = [];
M = []; % create blank matrix
powercount=1;


try
    % Open up a window on the screen and clear it.
    whichScreen = max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseVirtualFramebuffer');
    [theWindow,theRect] = PsychImaging('OpenWindow', whichScreen, 0);
    ShowCursor ('Arrow');
    
    trackM=0;
    while i<=MaxTrials
        Cond=Cond2(pp(i),:);
        
        
     %   xx= xxSet(i);
        
        timer1=0;
        
        Display;
        
        if trackM==1
            %find target location
            l = theX-Loc(Cond(2));   %%%theX-Loc(Xnum(xx));
            m=theY+Loc(Cond(2),2);
        else %prevents activating target loop on return to start
            l = 2000;
            m = 2000;
            
            
        end
        
        
        % set text size
        Screen(theWindow,'TextSize',24);
        
        
        %mask target with black
        if trackM==0
            %Fill start location with red
            Screen(theWindow,'FillOval', rectColor, centeredRect,maxDiameter);
            Screen(theWindow,'FillOval', [0 0 0], centeredRectTarg,maxDiameter);
            
            
        end
        
        while (1)
            %get mouse coordinates
            [x,y,buttons] = GetMouse(theWindow);
            [KeyIsDown, EndRT, KeyCode] = KbCheck;
            
            % escape program - uses abort function 
            if ((KeyIsDown)==1 )%%%%buttons(1)
                abort
            else
                break
            end
        end
        
        if trackM==0
            Screen(theWindow,'DrawText','START',50,50,255);
        else
            Screen(theWindow,'DrawText','START',50,50,0);
        end
        Screen('Flip', theWindow, 0, 1);
        
        
    
         Screen(theWindow,'TextSize',12*1);
        if trackM==0
            %            RTstart = GetSecs;
            GoSecs=GetSecs;
            while borderBreak(GoX, GoY,x, y)==1%while mouse is in start location
                [x,y,buttons] = GetMouse(theWindow);
                
                
                if (GetSecs-GoSecs)>2 %if timer from time of entering start location is greater than 2
                    %                 [theX,theY] = GetMouse(theWindow);
                    %                 thePoints = [theX theY];
                    
                    Screen('Flip', theWindow);
                   
                    %%%%%insert FUS trigger
                    Behaviour_triggerFUS; % start FUS
                    pause(.25) %delay green; make sure to substract 0.25s from accelerometer peak                     
                    Screen(theWindow,'FillOval', rectColorGo,centeredRect,maxDiameter); %sound(1)
                    Screen(theWindow,'FillOval', rectColorTarg, centeredRectTarg,maxDiameter);
                    RTstart = GetSecs;
                    Screen(theWindow,'DrawText','+',centeredRectTarg(1)+97,centeredRectTarg(2)+94); %centeredRectTarg(1))+95,floor(centeredRectTarg(2))+88,255);

                    %activate mouse tracker
                    trackM = 1;
                    
                    break %get out of this while loop
                    
                    
                end
                
               
            end
        end
        if trackM==1
            
            [datx,daty,buttons] = GetMouse(theWindow);
    
            
            DataSetup;
        end
        tstart = GetSecs;
        
        while borderBreakTarg(l-400, m,x, y)==1 %while mouse in target location
            [x,y,buttons] = GetMouse(theWindow);
            
            if (GetSecs-tstart)>2%
                RTend(i) = GetSecs-RTstart;
                timer1=1;
                counter= (GetSecs-tstart);
                trackM=0;
                break
            else
                trackM=1;
                
                
            end
            
            if ((KeyIsDown)==1 )%~buttons(1)
                abort
            end
            
        end
        
        if trackM==0
            Screen('Flip', theWindow);
            datx =[]; daty=[];
        end
        
        
    
        if timer1==1
            
            DatSet1 = [DatA; DatSet1];
            DatSet2 = [DatB; DatSet2];
            DatSet3 = [DatC; DatSet3];

            DatA =[];
            DatB = [];
            DatC = [];
            i = i+1;
            SetMouse(theX+500,theY,theWindow);
        else
            i=i;
            j=j+1;
        end
    end
    Screen(theWindow,'Close')

    
    s1 = unique(DatSet1(:,3));
    s2 = unique(DatSet2(:,3));
    s3 = unique(DatSet3(:,3));
    for d = 1:size(s1)
        [rows,cols,vals] = find(DatSet1(:,3)==s1(d));
        DatSet1(rows,5)=(RTend(s1(d))-2);
    end
     for d = 1:size(s2)
        [rows,cols,vals] = find(DatSet2(:,3)==s2(d));
        DatSet2(rows,5)=(RTend(s2(d))-2);
    end
     for d = 1:size(s3)
        [rows,cols,vals] = find(DatSet3(:,3)==s3(d));
        DatSet3(rows,5)=(RTend(s3(d))-2);
    end
    
   
    warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
    
    
    xlswrite(excelname,DatSet1,'Close')
    xlswrite(excelname,DatSet2,'Med')
    xlswrite(excelname,DatSet3,'Far')
    
catch
    Screen('CloseAll')
   
    
    psychrethrow(psychlasterror);
end %try..catch..
