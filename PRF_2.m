%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Ultrasound Neuromodulation PRF2 Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO .  Do not edit!
disp('Connecting to TPO....');
%USB communication code specific to device must be added here


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% EDITABLE SCRIPT START %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Entering PRF2 protocol....')  
disp(' ');

n=2;
sheet=1;

prompt = 'Please enter a unique filename ID:   ';
numba = input(prompt,'s');
filename=['D2_PRF_',num2str(numba),'.xlsx'];
disp(' ');

while n>1   % loop that performs a block when requested
    
%% CONDITION DATABASE %%%%
PRFSet = [200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001];  % in s
%note: 1001 is sham (zero power)
rndprf= PRFSet(randperm(length(PRFSet)));

disp('ISI = 5 seconds, 40 sonications randomized, PRF 200 Hz, 500 Hz ,1001 Hz (SHAM), 1 KHz') 
Num = 40;  %default = 40
ISI = 5; 


M = zeros(Num,3); % create blank matrix

disp('Press a key to START SONICATION... ')        
pause;  

for i= 1:Num    %performs sonications
    
    %% SONICATION PARAMETERS
    

Depth = 30;  % in mm
xdrCenterFreq = 500;   % in kilohertz
SonicDuration = 0.5 ;  %in 
burstLength = 500;

if rndprf(i) == 1001
Power = 0; 
PRF = 1000;
M(i,1)=Power;


else
Power = 20;
PRF = rndprf(i);
M(i,1)=Power;

end

M(i,2)=rndprf(i);
M(i,3)=SonicDuration;


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
disp(' ');
disp('Writing DATA to file....please wait.....')
%Write to File
   
warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
xlswrite(filename,M,sheet)
disp(['Data Saved Successfully in sheet# ' num2str(sheet)])




prompt = 'Would you like to perform another block of sonications? y/n ? '; % ask if new block?
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

PRFSet = [];
rndprf = [];
M = [];

prompt = 'Would you like to Redo a SPECIFIC PORTION of the sonications? y/n ? '; % ask if new block?
str = input(prompt,'s');
if str == 'y'
    sheet=sheet+1;
    
prompt = 'How many sonications of the 200 Hz condition would you like?';
first = input(prompt); 
PRFSet(1:first)=200;
    
prompt = 'How many sonications of the 500 Hz condition would you like?';
second = input(prompt);
PRFSet((first+1):(first+second))=500;

prompt = 'How many sonications of the 1 KHz condition would you like?';
third = input(prompt);
PRFSet((first+second+1):(first+second+third))=1000;

prompt = 'How many SHAM sonications of the SHAM 1001Hz condition would you like?';
fourth = input(prompt);
PRFSet((first+second+third+1):(first+second+third+fourth))=1001;

rndprf= PRFSet(randperm(length(PRFSet)));

disp('Press a key to START SONICATION... ')        
pause;  %wait for user to press key 

for i= 1:length(rndprf)


%randomized parameters

if rndprf(i) == 1001
Power = 0; 
PRF = 1000;
M(i,1)=Power;


else
Power = 20;
PRF = rndprf(i);
M(i,1)=Power;


end


M(i,2)=rndprf(i);
M(i,3)=SonicDuration;


%% Sets burst parameter commands to TPO
                       
setPRF(serialTPO,PRF);             % always set power after frequency or you may limit TPO
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
%% START sonication
startTPO(serialTPO);
pause(ISI);   %ISI pauses between sonications in seconds
stopTPO(serialTPO);


end


disp(['Success! ' num2str(length(PRFSet)) ' sonications delivered.'])
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Changes TPO control to front panel control
setLocal(serialTPO,1);
clc
clear