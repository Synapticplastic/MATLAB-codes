%config file for Behaviour script


Cond = [0 1; 0 2; 0 3; 20 1; 20 2; 20 3];   %0 or 20 watts for each distance

% Start location radius
rad = 200;

% Set the color of the rect
rectColor = [100 0 0]; %Red
rectColorGo = [0 100 0]; %Green
rectColorTarg = [0 0 100]; %Blue

%Set abort key
abortkey = KbName('E');
KbName('UnifyKeyNames');

% Target locations (erase once calibrartion script is done!!!!)
Loc = [50 50; 300 150; 600 350];

%Store data based on target location
DatA = [];
DatB = [];
DatC = [];
thePoints=[];
triNum = [];
datx =[];
daty=[];

%Mouse tracker ON/OFF
trackM = 0;

% See config for rad
baseRect = [0 0 rad rad];
baseRectSmall = [0 0 50 50];
TriNum = 15; 

Cond2 = repmat(Cond,TriNum,1);
pp = randperm(90);

% For Ovals we set a miximum diameter up to which it is perfect for
maxDiameter = max(baseRect);

Xnum = repmat(1:3, [1 TriNum ]);
xxSet = Xnum(randperm(numel(Xnum)));

%Number of trials
MaxTrials = size(Cond2);
MaxTrials = MaxTrials(1);
