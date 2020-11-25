%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Ultrasound Neuromodulation Sonication Duration Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO 
disp('Connecting to TPO....');
%USB communication code specific to device must be added here

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% EDITABLE SCRIPT START %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Entering sonication duration protocol....')  
disp(' ');

n=2;
sheet=1;

prompt = 'Please enter a unique filename ID:   ';
numba = input(prompt,'s');
filename=['E_SonicationDuration_',num2str(numba),'.xlsx'];
disp(' ');

while n>1   % loop that performs a block when requested
    
%% CONDITION DATABASE %%%%
durationSet = [0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4,0.5,0.1,0.3,0.09,0.2,0.4];  % in s
rand_durationSet= durationSet(randperm(length(durationSet)));
%Note: 0.09 is variable placeholder for sham (zero power), but all time periods trigger 0.5s tonal masking

disp('Power=20W , ISI = 5 seconds, 60 sonications, duration of 0.09 (SHAM), 0.1, 0.2, 0.3, 0.4, or 0.5 seconds') 
Num = 60;  %default=60
ISI = 5; %input(prompt);
M = zeros(Num,3); % create blank matrix

disp('Press a key to START SONICATION... ')        
pause;  %wait for user to press key 

for i= 1:Num    %performs sonications
    
    %% SONICATION PARAMETERS
    
%fixed parameters
Depth = 30;  % in mm
xdrCenterFreq = 500;   % in kilohertz
burstLength = 500 ;   %  in microseconds( 10us resolution )
PRF = 1000;  


if rand_durationSet(i) == 0.09    
Power = 0; 
SonicDuration = 0.5;  %0.5s trigger masking tone 
M(i,1)=Power;


else
Power = 20;
SonicDuration = rand_durationSet(i);   
M(i,1)=Power;

end

M(i,2)=PRF;
M(i,3)=durationSet(i);


%% Sets burst parameter commands to TPO

setFreq(serialTPO,0,xdrCenterFreq); % with '0' as the second argument, freq is assigned to all channels
setPower(serialTPO,Power);             % always set power after frequency or you may limit TPO
setBurst(serialTPO,burstLength);
setPRF(serialTPO,PRF);             % in Hz
setTimer(serialTPO,SonicDuration);            
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
%% START Treatment
startTPO(serialTPO);
pause(ISI);   %ISI pauses between sonications in seconds
stopTPO(serialTPO);
end
disp(['Success! ' num2str(i) ' sonications delivered.'])
disp(' ');
disp('Writing DATA to file....please wait.....')
%Write to File
   
warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
xlswrite(filename,M,sheet)
disp(['Data Saved Successfully in sheet# ' num2str(sheet)])

prompt = 'Would you like to repeat the ENTIRE block of sonications? y/n ? '; % ask if new block?
str = input(prompt,'s');
if str == 'y'
    n = 2; %redo while loop , sonicate another block
    sheet=sheet+1;
else
    n = 0; %end program
end
end

n=2;

while n>1   % loop that performs a block when requested

durationSet = [];
%rand_durationSet = [];
M = [];

prompt = 'Would you like to Redo a SPECIFIC PORTION of the sonications? y/n ? '; % ask if new block?
str = input(prompt,'s');
if str == 'y'
    sheet=sheet+1;
    
prompt = 'How many sonications of the 0.1s condition would you like?';
first = input(prompt); 
durationSet(1:first)=0.1;
    
prompt = 'How many sonications of the 0.2s condition would you like?';
second = input(prompt);
durationSet((first+1):(first+second))=0.2;

prompt = 'How many sonications of the 0.3s condition would you like?';
third = input(prompt);
durationSet((first+second+1):(first+second+third))=0.3;

prompt = 'How many sonications of the 0.4s condition would you like?';
fourth = input(prompt);
durationSet((first+second+third+1):(first+second+third+fourth))=0.4;

prompt = 'How many sonications of the 0.5s condition would you like?';
fifth = input(prompt);
durationSet((first+second+third+fourth+1):(first+second+third+fourth+fifth))=0.5;

prompt = 'How many sonications of the SHAM condition (power=0) would you like?';
sixth = input(prompt);
durationSet((first+second+third+fourth+fifth+1):(first+second+third+fourth+fifth+sixth))=0.09;

disp('Press a key to START SONICATION... ')        
pause;  %wait for user to press key 

for i= 1:length(durationSet)


%randomized parameters
if durationSet(i) == 0.09    
Power = 0; 
SonicDuration = 0.5;   %masking sound for 0.5s 
M(i,1)=Power;


else
Power = 20;
SonicDuration = durationSet(i);   
M(i,1)=Power;

end

M(i,2)=PRF;
M(i,3)=durationSet(i);

%% Sets burst parameter commands to TPO                     

setTimer(serialTPO,SonicDuration);            
setPower(serialTPO,Power);    
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

disp(['Success! ' num2str(length(durationSet)) ' sonications delivered.'])
disp(' ');
disp('Writing DATA to file....please wait.....')
%Write to File


warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
xlswrite(filename,M,sheet)
disp(['Data Saved Successfully in sheet# ' num2str(sheet)])

else
    n=0;
end
end

%% Changes TPO control to front panel control
setLocal(serialTPO,1);
clc
clear