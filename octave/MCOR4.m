function SwitchingActivity = MCOR4(N)

MonteCarloSize = N;

Workload = [];
for i = 1:MonteCarloSize
    Workload = [Workload; round(rand(1,4))];
end


vectorsNumber = size(Workload, 1);
gateInputsNumber = size(Workload, 2);

gateOutput = 0 | 0 | 0 | 0;
switchesNumber = 0;

for i = 1:vectorsNumber
    NewGateOutput = Workload(i,1) | Workload(i,2) | Workload(i,3) | Workload(i,4);

    if (gateOutput == NewGateOutput)
        continue;
    else
        gateOutput = NewGateOutput;
    end

    switchesNumber = switchesNumber + 1;
end

switchesNumber
vectorsNumber
SwitchingActivity = switchesNumber / vectorsNumber

endfunction

