%% Finding The MF Value and The MF Number of each Data.
function [M_Value MF_Num] = MFDetector(x,Num,LowBnd,UpBnd,MemFunTyp)

Y = zeros(1,Num);

switch MemFunTyp
    case 1
        Step = (UpBnd-LowBnd)/(Num-1);
        for i=1:Num
            Center = LowBnd+(i-1)*Step;
            Y(i) = trimf(x,[Center-Step,Center,Center+Step]);
        end
        
    case 2
        Step = (UpBnd-LowBnd)/(Num-1)/3;
        for i=1:Num
            Center = LowBnd+(i-1)*3*Step;
            Y(i) = trapmf(x,[Center-2*Step,Center-Step,Center+Step,Center+2*Step]);
        end
        
    case 3
        Step = (UpBnd-LowBnd)/(Num-1)/2;
        for i=1:Num
            Center = LowBnd+(i-1)*2*Step;
            Y(i) = gaussmf(x,[Step,Center]);
        end
        
    otherwise
        disp(' Selected Membership Function is Wrong!')
        disp(' Please Start Again.')
end

[M_Value MF_Num] = max(Y);
end