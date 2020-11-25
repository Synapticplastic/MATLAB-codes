%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Ultrasound Neuromodulation MAIN Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO.
disp('Connecting to TPO....');
%USB communication code specific to device must be added here

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% EDITABLE SCRIPT START %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Entering PRF (D1) protocol....')  
disp(' ');
n=2;
sheet=1;
prompt = 'Please enter a unique filename ID:   ';
numba = input(prompt,'s');
filename=['D1_PRF_',num2str(numba),'.xlsx'];
disp(' ');

while n>1   % loop that performs a block when requested
    
%% CONDITION DATABASE %%%%
PRFSet = [200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001,200,500,1000,1001];  %in hz

rndprf= PRFSet(randperm(length(PRFSet))); %randomize/interleave

disp('ISI = 5 seconds, 60 sonications randomized (15 per condition), PRF 200 Hz, 500 Hz ,SHAM, 1000 Hz') 
Num = 60;  %default = 60
ISI = 5; 


M = zeros(Num,3); % create blank matrix

disp('Press a key to START SONICATION... ')        
pause;  


for i= 1:Num    %performs sonications
    
    %% SONICATION PARAMETERS
    

Depth = 30;  % in mm
xdrCenterFreq = 500;   % in kilohertz
SonicDuration = 0.5 ;  %in 


if rndprf(i) == 1001
burstLength = (1000000*0.3*(1/1000));   %  in microseconds( 10us resolution )    
Power = 0; 
PRF = 1000;
M(i,1)=Power;


else
burstLength = (1000000*0.3*(1/rndprf(i)));   %  in microseconds( 10us resolution )
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
setTimer(serialTPO,SonicDuration);              % Timer, also adjusts for the 10 ms error of TPO
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Changes TPO control to front panel control
setLocal(serialTPO,1);
clc
clear