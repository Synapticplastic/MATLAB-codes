%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Ultrasound Neuromodulation MAIN Script.  v1.3  Nov 19, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code to connect to TPO 
disp('Connecting to TPO....');
%USB communication code specific to device must be added here

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% EDITABLE SCRIPT START %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Entering BLOCK PRF1 protocol....')  
disp(' ');
  

%% SONICATION PARAMETERS
    
%fixed parameters
Num = 15;  % 15 per condition 
ISI = 5;     %pause between frames
Depth = 30;  % in mm
SonicDuration = 0.5 ; %in s
xdrCenterFreq = 500;   % in kilohertz




    
%% CONDITION DATABASE %%%%
%Note: Randomize order of block delivery between participants 
% ie: This participant order: = [200,Sham,500,1000]


disp('BLOCKS of conditions, ISI = 5 seconds, 60 sonications (15 per condition), 20s rest between blocks, PRF 200 Hz, SHAM, 500 Hz , 1000 Hz') 
disp('Press a key to START SONICATION... ')        
pause;  


for i= 1:Num    %performs sonications
     

burstLength = (1000000*0.3*(1/200));   %  in microseconds( 10us resolution )
Power = 20;
PRF = 200;


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

pause(20); %20s rest between blocks




%PRF = sham
for i= 1:Num    %performs sonications
    
burstLength = (1000000*0.3*(1/1000));   %  in microseconds( 10us resolution )    
Power = 0; 
PRF = 1000;

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

pause(20);


%PRF= 500
for i= 1:Num    %performs sonications
     

burstLength = (1000000*0.3*(1/500));   %  in microseconds( 10us resolution )
Power = 20;
PRF = 500;


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

pause(20);


%PRF= 1000
for i= 1:Num    %performs sonications
     

burstLength = (1000000*0.3*(1/1000));   %  in microseconds( 10us resolution )
Power = 20;
PRF = 1000;


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


disp(['Success! all blocks of sonications delivered.'])
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Changes TPO control to front panel control
setLocal(serialTPO,1);

clear