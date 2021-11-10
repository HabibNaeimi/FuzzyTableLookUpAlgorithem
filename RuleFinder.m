%% Rules Finder.
%%  For implementing in Table look Up Algorithm.

function [Rule RuleMemValue] = RuleFinder(Pair,MFNum,LowBnd,UpBnd,MemFunTyp)

e1 = numel(MFNum);
e2 = size(Pair,1);
MVal = zeros(1,e1);
MFun = zeros(1,e1);
Rule = zeros((size(Pair)));
RuleMemValue = zeros((size(Pair)));

    for i=1:e2  
        for j=1:e1
            [MVal(j) MFun(j)] = MFDetector(Pair(i,j),MFNum(j),LowBnd(j),UpBnd(j),MemFunTyp(j));    
        end
        
        Rule(i,:)=MFun;
        RuleMemValue(i,:)=MVal;
    end
end