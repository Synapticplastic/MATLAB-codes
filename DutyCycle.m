%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Ultrasound Neuromodulation Duty Cycle Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO .  Do not edit!
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
DCSet = [10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50,10,30,31,50];  % in s
%Note: 31 is SHAM (power= 0 )
rndDC= DCSet(randperm(length(DCSet)));


disp('ISI = 5 seconds, SonicDuration = 0.5s , PRF=1000 Hz, Power=20W, 40 sonications randomized, DC 10%,30%,31%(SHAM), 50%') 
disp(' ');

Num = 40;  % Def=40
ISI = 5; %input(prompt);
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
SonicDuration = 0.5 ; %datasample(durationSet,1,'Replace',false);  
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

prompt = 'Would you like to redo the ENTIRE BLOCK of sonications? y/n ? '; % ask if new block?
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

DCSet = [];
rndDC = [];
M = [];

prompt = 'Would you like to Redo a SPECIFIC PORTION of the sonications? y/n ? '; % ask if new block?
str = input(prompt,'s');
if str == 'y'
    sheet=sheet+1;
        
    
prompt = 'How many sonications of the 10% DC condition would you like?';
first = input(prompt); 
DCSet(1:first)=10;
    
prompt = 'How many sonications of the 30% DC condition would you like?';
second = input(prompt);
DCSet((first+1):(first+second))=30;

prompt = 'How many sonications of the 50% DC condition would you like?';
third = input(prompt);
DCSet((first+second+1):(first+second+third))=50;

prompt = 'How many SHAM sonications of the SHAM condition would you like?';
fourth = input(prompt); 
DCSet((first+second+third+1):(first+second+third+fourth))=31;


rndDC= DCSet(randperm(length(DCSet)));

disp('Press a key to START SONICATION... ')        
pause;  %wait for user to press key 

for i= 1:length(rndDC)


%randomized parameters

if rndDC(i) == 31
    burstLength = ( 1000*(30/100) );   %  in microseconds( 10us resolution )
Power = 0; 
M(i,1)=Power;

else
Power = 20;
M(i,1)=Power;
burstLength = ( 1000*(rndDC(i)/100) );   %  in microseconds( 10us resolution )
end

M(i,2)=rndDC(i);
M(i,3)=SonicDuration;

%% Sets burst parameter commands to TPO                     

setBurst(serialTPO,burstLength);            % always set power after frequency or you may limit TPO
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


disp(['Success! ' num2str(length(DCSet)) ' sonications delivered.'])
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

