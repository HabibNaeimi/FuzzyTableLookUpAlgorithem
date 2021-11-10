clc
clear all
close all
%% TABLE LOOK UP TRAINING ALGORITHEM.
%   This programm developed as a course project for Fuzzu systems course by
%    Habibollah Naeimi.
disp(' TABLE LOOK UP TRAINING ALGORITHEM.');
disp('  This programm developed as a course project for Fuzzu systems course')
disp('   by Habibollah Naeimi.')
disp('*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*------------------------------------------------------')

%% 1st Part: Parameter Setting.
%%  Parameters Initiating.

disp(' Parameters Initiating...');
InpuNumb = 6;%input(' How many input do you want? Inputs =');% Input Numbers.
disp(' ');

disp(' How many membership functions do you want?');
MemFuNu  = [18];%input(' Please Enter a vector. MFN =');        % Membership Function Numbers.  
e1 = numel(MemFuNu);                   % Number of Matrix Elements.
disp(' ');

disp(' Which membership functions type do you want?');
disp(' Triangular = 1 , Trapezoidal = 2 , Gaussian = 3');
MemFTy = [3];%input(' Please Enter a vector. MF =');           % Membership Function Types.
e4 = numel(MemFTy);                    % Number of Matrix Elements.
disp(' ');

disp(' Enter the Lower Bound.');
LowBnd = [0.25];%input(' Please Enter a vector. Low Bnd =');       % Lower Bound.
e2 = numel(LowBnd);                    % Number of Matrix Elements.
disp(' ');

disp(' Enter the Upper Bound.');                           % Upper Bound.
UpBnd = [1.6];%input(' Please Enter a vector. Upper Bnd =');                     
e3 = numel(UpBnd);                    % Number of Matrix Elements.

q1 = e1~=InpuNumb;            
q2 = e2~=InpuNumb;
q3 = e3~=InpuNumb;
q4 = e4~=InpuNumb;
Training_Ratio = 0.5;


%%  Fixing Parameters dimentions.

switch q1
    case 1                            % Fixing Membership Function dimentions.
        if e1==1
            MemFuNu = repmat(MemFuNu,1,InpuNumb+1); 
        else
            disp(' Invalid Membership Function Number!');
            disp(' Please Start again.');
        end
end
        
switch q2
    case 1                            % Fixing Lower Bound dimentions.
        if e2==1
            LowBnd = repmat(LowBnd,1,InpuNumb+1);
        else
            disp(' Invalid Lower Boundary!');
            disp(' Please Start again.');
        end
end
        
switch q3
    case 1                            % Fixing Upper Bound dimentions.
        if e3==1
            UpBnd = repmat(UpBnd,1,InpuNumb+1); 
        else
            disp(' Invalid Upper Boundary!');
            disp(' Please Start again.');
        end
end

switch q4
    case 1                            % Fixing Membership Type dimentions.
        if e4==1
            MemFTy = repmat(MemFTy,1,InpuNumb+1);
        else
            disp(' Invalid Membership Function Handle!');
            disp(' Please Start again.');
        end
end
disp(' ');
disp('*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*------------------------------------------------------')
disp(' ');
%% 2nd Part: Data.
%%  Sampling.


SAMPLES = rand(1,32);                 % Primary sampling.
%SAMPLES = 0.2:0.01:0.51;
for v=33:1033                         % Secoundary Sampling.
    SAMPLES(v) = 0.2*SAMPLES(v-31)/(1+(SAMPLES(v-31)^10))+0.9*SAMPLES(v-1);
end

SAMPLES = SAMPLES(34:end);            % Samples.
plot(SAMPLES)
%%  Data Paires.

e5 = numel(SAMPLES);
w1 = round(Training_Ratio*e5);
Training_Datas = zeros(w1,InpuNumb+1);

for v=1:w1
    Training_Datas(v,:) = SAMPLES(v:v+InpuNumb);  % Creating data paires.
end

disp(' Data sampling check!');
disp('*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-----------------------------------------------------')
disp(' ');
%% 3rd Part: Rule Base.
%%  Finding Rules.
                                            % Implementing a function to
                                            % find rules.
[Rules , RulesMVlu] = RuleFinder(Training_Datas,MemFuNu,LowBnd,UpBnd,MemFTy);
PRB = Rules(:,:);                           % Primary Rule Base.
disp(' The Rule Base is READY!'); 
disp(' Here is the detailes:  ');
Rules_Number_all = numel(PRB(:,1));         % Calculating Number of Rules.
disp(' Number of All Rules:');
disp(Rules_Number_all); 

                                            % Implimenting a function to
Rules = ConflictChecking(Rules,RulesMVlu);  % eliminate conflictions.
RuleBase = [Rules ones(size(Rules,1),2)];   % Creating final Rule Base.
nonconflict_rules = numel(Rules(:,1));       
disp(' And Number of No Conflicting Rules:'); % Nonconflicting Rules.
disp(nonconflict_rules); 

conflict_Rules = Rules_Number_all-nonconflict_rules; % Calculating Number
disp(' And Number of Conflicted Rules:');            % of Conflicted 
disp(conflict_Rules);                                % Rules.

disp(' ');
disp('*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*------------------------------------------------------')
disp(' ');
%% 4th Part: Fuzzy System.
%%  Defining Fuzzy System.

TSP = newfis('Time Series Prediction'); % Creating the fuzzy system.
e1  = numel(MemFuNu);

for i=1:e1-1                            % Defining the Inputs.
    Name = ['X' num2str(i)];            % Rule Name's Creation.
    TSP = addvar(TSP,'input',Name,[LowBnd(i),UpBnd(i)]);
    
    switch MemFTy(i)
        case 1                          % For Triangular Membership Function.
            Step = (UpBnd(i)-LowBnd(i))/(MemFuNu(i)-1);
            for j = 1:MemFuNu(i)
                Center = LowBnd(i)+(j-1)*Step;
                MemFName = [Name '_MF' num2str(j)];   % Rule Name's Creation.
                TSP = addmf(TSP,'input',i,MemFName,'trimf',[Center-Step,Center,Center+Step]);
            end
            
        case 2                         % For Trapezoidal Membership Function.
            Step = (UpBnd(i)-LowBnd(i))/(MemFuNu(i)-1)/3;
            for j = 1:MemFuNu(i)
                Center = LowBnd(i)+(j-1)*3*Step;
                MemFName = [Name '_MF' num2str(j)];   % Rule Name's Creation.
                TSP = addmf(TSP,'input',i,MemFName,'trapmf',[Center-2*Step,Center-Step,Center+Step,Center+2*Step]);
            end
            
        case 3                         % For Gaussian Membership Function.
            Step = (UpBnd(i)-LowBnd(i))/(MemFuNu(i)-1)/2;
            for j = 1:MemFuNu(i)
                Center = LowBnd(i)+(j-1)*2*Step;
                MemFName = [Name '_MF' num2str(j)];   % Rule Name's Creation.
                TSP = addmf(TSP,'input',i,MemFName,'gaussmf',[Step,Center]);
            end
    end
end
                                       % Deffining the Output.
TSP = addvar(TSP,'output','Y',[LowBnd(end),UpBnd(end)]);
Name = ['Y'];

switch MemFTy(end)
        case 1                         % For Triangular Membership Function.
            Step = (UpBnd(end)-LowBnd(end))/(MemFuNu(end)-1);
            for j=1:MemFuNu(end)
                Center = LowBnd(end)+(j-1)*Step;
                MemFName = [Name '_MF' num2str(j)];   % Rule Name's Creation.
                TSP = addmf(TSP,'output',1,MemFName,'trimf',[Center-Step,Center,Center+Step]);
            end
            
        case 2                         % For Trapezoidal Membership Function.
            Step = (UpBnd(end)-LowBnd(end))/(MemFuNu(end)-1)/3;
            for j=1:MemFuNu(end)
                Center = LowBnd(end)+(j-1)*3*Step;
                MemFName = [Name '_MF' num2str(j)];   % Rule Name's Creation.
                TSP = addmf(TSP,'output',1,MemFName,'trapmf',[Center-2*Step,Center-Step,Center+Step,Center+2*Step]);
            end
            
        case 3                         % For Gaussian Membership Function.
            Step = (UpBnd(end)-LowBnd(end))/(MemFuNu(end)-1)/2;
            for j=1:MemFuNu(end)
                Center = LowBnd(end)+(j-1)*2*Step;
                MemFName = [Name '_MF' num2str(j)];   % Rule Name's Creation.
                TSP = addmf(TSP,'output',1,MemFName,'gaussmf',[Step,Center]);
            end
end

TSP = addrule(TSP,RuleBase);          % Deploying Rule Base to our Fuzzy System.
disp(' Fuzzy System is Ready!');
disp(' Fuzzy System detailes:');
showfis(TSP)                           % Showing Fuzzy System detailes.

disp(' ');
disp('*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*-.-*------------------------------------------------------')
disp(' ');
%% 5th Part: Conclusion.
%%  Predicting.

Y = SAMPLES(1:InpuNumb);

for i=InpuNumb+1:numel(SAMPLES)           % Calculating Pridictions.
    
    Y(i)=evalfis(SAMPLES(i-InpuNumb:i-1),TSP);
    
end

Error = sum(abs(SAMPLES-Y))/100;           % Calculating Error.
ED = [' Error of Prediction = ' num2str(Error) '%' ];

%%  Plotting.

AH = axes;
sam_plt = plot(AH,SAMPLES);
hold on
output_plt = plot(AH,Y,'r');

xlim([0 e5]);
ylim([LowBnd(end)-0.2 UpBnd(end)+0.2]);
legend(AH,'Real Value','Prediction');
disp(ED);



