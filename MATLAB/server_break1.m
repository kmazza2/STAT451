function [total_break_time] = server_break1(rand_interarrival, rand_service, rand_break, kill)
%SERVER_BREAK1 Simulate single server queue in HW 2 Problem 4.
%   SERVER_BREAK1 begins with the server on break.

% Initialization
end_process = 0;
total_break_time = 0;
arrival = 0;
queue = 0;

break_time = rand_break();
end_process = end_process + break_time;
% If break ends after end of simulation, add only the part of the break
% occurring before the end of the simulation to total_break_time.
% Otherwise, can add all of the break time to total_break_time.
if end_process >= kill
    total_break_time = kill;
    return;
else
    total_break_time = total_break_time + break_time;
end

arrival = arrival + rand_interarrival(arrival);
while arrival <= end_process
    queue = queue + 1;
    arrival = arrival + rand_interarrival(arrival);
end

while true
    % Process queue
    while queue > 0
        end_process = end_process + rand_service();
        queue = queue - 1;
    end
    if arrival <= end_process
        % Generate arrivals
        while arrival <= end_process
            queue = queue + 1;
            arrival = arrival + rand_interarrival(arrival);
        end
    else
        % Generate breaks
        while end_process < arrival
            break_time = rand_break();
            if end_process + break_time >= kill
                if kill - end_process > 0
                    total_break_time = total_break_time + (kill - end_process);
                    return;
                else
                    return;
                end
            else
                total_break_time = total_break_time + break_time;
                end_process = end_process + break_time;
            end
        end
        queue = queue + 1;
        arrival = arrival + rand_interarrival(arrival);
    end
end
end
