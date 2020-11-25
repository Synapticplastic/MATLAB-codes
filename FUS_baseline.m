
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Ultrasound Neuromodulation MAIN Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO .  Do not edit!
disp('Connecting to TPO....');
%USB communication code specific to device must be added here


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% EDITABLE SCRIPT START %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Press a key to view Basic parameters....')  
disp(' ');
disp(' ');        
pause;  %wait for user to press key 


n=2;

while n>1   % loop that performs a block when requested
    
%% CONDITION DATABASE %%%%


disp('Basic parameters = 20W (flip transducer over for SHAM) , PRF=1000 Hz, DC =30% ,  Duration = 0.5s, Depth = 30mm, FF=500kHz') 
disp('ISI = 5 seconds, 20 sonications') 

Num = 20;  %sonications per block
ISI = 5; 

disp('Press ANY KEY to SONICATE....') 
pause;  %wait for user to press key 

for i= 1:Num    %performs sonications
    
    %% SONICATION PARAMETERS
    
%fixed parameters
Depth = 30;  % in mms
xdrCenterFreq = 500;   % in kilohertz
burstLength = 300 ;   %  in microseconds( 10us resolution )
Power = 20;  % in Watts
SonicDuration = 0.5;   % Sonication Duration in seconds
PRF = 1000;  % in Hertz

%% Sets burst parameter commands to TPO
setFreq(serialTPO,0,xdrCenterFreq); % with '0' as the second argument, freq is assigned to all channels
setPower(serialTPO,Power);             % always set power after frequency or you may limit TPO
setBurst(serialTPO,burstLength);
setPRF(serialTPO,PRF);             % in Hz
setTimer(serialTPO,SonicDuration);              % Timer
setDepth(serialTPO,Depth);


pause(1);                           % slight delay for TPO to update parameters

%% Display calculated parameters of burst
disp(['Sonication #' num2str(i) ' :'])
disp(' ');
disp(['Fund. Frequency: ' num2str(xdrCenterFreq) ' kHz']);
disp(['Depth: ' num2str(Depth) ' mm']);
disp(['Power: ' num2str(Power) ' Watts']);
disp(['Sonication Duration: ' num2str(SonicDuration) ' seconds']);
disp(['Burst Length: ' num2str(burstLength) 'us']);
disp(['PRF: ' num2str(PRF) ' Hz']);
disp(' ');
disp(' ');
%% START Sonication
startTPO(serialTPO);
pause(ISI);   %ISI pauses between sonications in seconds
stopTPO(serialTPO);
end
disp(['Success! ' num2str(i) ' sonications delivered.'])

prompt = 'Would you like to perform another block of sonications? y/n ? '; % ask if new block?
str = input(prompt,'s');
if str == 'y'
    n = 2; %redo while loop , sonicate another block
    
else
    n = 0; %end program
end
end

%% Changes TPO control to front panel control
setLocal(serialTPO,1);
clc
clear

