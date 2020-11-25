%triggering FUS device

%fixed parameters
Depth = 30;  % in mms
xdrCenterFreq = 500;   % in kilohertz
burstLength = 300 ;   %  in microseconds( 10us resolution )
SonicDuration = 0.5;   % Sonication Duration in seconds
PRF = 1000;  % in Hertz

%% SHAM OR FUS

 Power = Cond(1); %fetch sham or FUS from Behaviour_config script
 powercount=powercount+1;  

%% Sets burst parameter commands to TPO

setFreq(serialTPO,0,xdrCenterFreq); % with '0' as the second argument, freq is assigned to all channels
setPower(serialTPO,Power);             % always set power after frequency or you may limit TPO
setBurst(serialTPO,burstLength);
setPRF(serialTPO,PRF);             % in Hz
setTimer(serialTPO,SonicDuration);      
setDepth(serialTPO,Depth);


                          % slight delay for TPO to update parameters


%% START Treatment
startTPO(serialTPO);

