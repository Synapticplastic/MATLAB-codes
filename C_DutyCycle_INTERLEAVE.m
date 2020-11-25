%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Ultrasound Neuromodulation MAIN Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO 
disp('Connecting to TPO....');
%USB communication code specific to device must be added here

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% EDITABLE SCRIPT START %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Entering Duty Cycle Protocol....')  
disp(' ');


n=2;
sheet=1;


prompt = 'Please enter a unique filename ID:   ';
numba = input(prompt,'s');
filename=['C_DutyCycle_',num2str(numba),'.xlsx'];
disp(' ');

while n>1   % loop that performs a block when requested
    
%% CONDITION DATABASE %%%%
DCSet = [10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50];  % in s

rndDC= DCSet(randperm(length(DCSet))); %randomize/interleave


disp('ISI = 5 seconds, SonicDuration = 0.5s , PRF=1000 Hz, Power=20W, 60 sonications randomized, DC 10%,30%,SHAM, 50%') 
disp(' ');

Num = 60;  % 15 per condition *4 = 60 frames

ISI = 5; 

M = zeros(Num,3); % create blank matrix

disp('Press a key to START SONICATION... ')        
pause;  %wait for user to press key 


for i= 1:Num    %performs sonications
    
    %% SONICATION PARAMETERS
    
%fixed parameters
Depth = 30;  % in mm
xdrCenterFreq = 500;   % in kilohertz

if rndDC(i) == 31
    burstLength = ( 1000*(30/100) );   %  in microseconds( 10us resolution )
Power = 0;  
M(i,1)=Power;
else
Power = 20;
M(i,1)=Power;
burstLength = ( 1000*(rndDC(i)/100) );   %  in microseconds( 10us resolution )
end



PRF = 1000;  
M(i,2)=rndDC(i);

SonicDuration = 0.5 ;   
M(i,3)=SonicDuration;



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

prompt = 'Would you like to redo the ENTIRE BLOCK of sonications? y/n ? '; % ask if new block?
str = input(prompt,'s');
if str == 'y'
    n = 2; %redo while loop , sonicate another block
    sheet=sheet+1;
else
    n = 0; %end program
end
end





%% Changes TPO control to front panel control
setLocal(serialTPO,1);

clear

