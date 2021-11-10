%% Conflict finder and deleter.
function [Rule1 Rule1MVlu RuleDegree] = ConflictChecking(Rule,Rule_MV)
k = 1;
    
    while ~isempty(Rule)
        First = repmat(Rule(1,1:end-1),size(Rule,1),1);
        Rule_B = Rule(:,1:end-1);
        Index = Rule_B == First;
        Index = find(sum(Index,2) == numel(Rule_B(1,:)));
        
        [RuleDegree(k) Rule_Index] = max(prod(Rule_MV(Index,:),2));
        
        Rule1(k,:) = Rule(Index(Rule_Index),:);
        Rule1MVlu(k,:) = Rule_MV(Index(Rule_Index),:);
        k = k+1;
        m = 1;
        RuleBuffer = [];
        
        for n=1:size(Rule,1)
            if isempty(find(Index==n))
                RuleBuffer(m,:) = Rule(n,:);            
                m = m+1;
            end
        end
        
        Rule = RuleBuffer;
    end
end