function [total_break_time] = server_break2(rand_interarrival, rand_service, rand_break, kill)
%SERVER_BREAK2 Simulate single server queue in HW 2 Problem 4.
%   SERVER_BREAK2 begins with the server waiting for an arrival (not on
%   break).

% Initialization
end_process = 0;
total_break_time = 0;
arrival = 0;
queue = 0;

arrival = arrival + rand_interarrival(arrival);
queue = queue + 1;
end_process = arrival;
arrival = arrival + rand_interarrival(arrival);

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
