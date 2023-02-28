ITER = 10000;
DIV = 1/ITER;
MEAN = 0;

for i = 1:ITER

    BREAK_ALL = 0;
    arrivals = {};
    i = 1;
    kill = 100;
    end_process = 0;
    total_break_time = 0;
    arrival = 0;
    queue = 0;

    break_time = rand_break();
    end_process = end_process + break_time;

    if end_process >= kill
        total_break_time = kill;
        return;
    else
        total_break_time = total_break_time + break_time;
    end

    arrival = arrival + rand_interarrival(arrival);
    arrivals{i} = arrival;
    i = i + 1;
    while arrival <= end_process
        queue = queue + 1;
        arrival = arrival + rand_interarrival(arrival);
        arrivals{i} = arrival;
        i = i + 1;
    end

    while true
        % Process queue
        while queue > 0
            end_process = end_process + rand_service();
            if end_process >= kill
                BREAK_ALL = 1;
                break;
            end
            queue = queue - 1;
        end
        if BREAK_ALL == 1
            break;
        end
        if arrival <= end_process
            % Generate arrivals
            while arrival <= end_process
                queue = queue + 1;
                arrival = arrival + rand_interarrival(arrival);
                arrivals{i} = arrival;
                i = i + 1;
            end
        else
            % Generate breaks
            while end_process < arrival
                break_time = rand_break();
                if end_process + break_time >= kill
                    if kill - end_process > 0
                        total_break_time = total_break_time + (kill - end_process);
                        BREAK_ALL = 1;
                        break;
                    else
                        BREAK_ALL = 1;
                        break;
                    end
                else
                    total_break_time = total_break_time + break_time;
                    end_process = end_process + break_time;
                end
            end
            if BREAK_ALL == 1
                break;
            end
            queue = queue + 1;
            arrival = arrival + rand_interarrival(arrival);
            arrivals{i} = arrival;
            i = i + 1;
        end
    end

    MEAN = MEAN + DIV * total_break_time;

end

disp('Mean break time: ');
disp(MEAN);

% Compare arrival times in server simulation to arrival times in direct
% simulation
% t = 0;
% i = 1;
% isolated_arrival_simulation = {};
% while t <= 100
% t = t + rand_interarrival(t);
% isolated_arrival_simulation{i} = t;
% i = i + 1;
% end
% isolated_arrival_simulation = cell2mat(isolated_arrival_simulation);
% subplot(1,2,1);
% scatter(isolated_arrival_simulation, 0.05 * rand(length(isolated_arrival_simulation),1) + zeros(length(isolated_arrival_simulation)));
% xlim([0 100]);
% ylim([-1 1]);
%
% subplot(1,2,2);
% arrivals = cell2mat(arrivals);
% scatter(arrivals, 0.05 * rand(length(arrivals), 1) + zeros(length(arrivals)));
% xlim([0 100]);
% ylim([-1 1]);

function [x] = rand_service()
x = exprnd(1/25);
end

function [x] = rand_break()
x = 0.3 * rand();
end

function intensity = intensity_function(t)
while t >= 10
    t = t - 10;
end
if t <= 5
    intensity = 3 * t + 4;
else
    intensity = -3 * t + 34;
end
end

function time = rand_interarrival(t)
time = exprnd(1/intensity_function(t));
end

% x = linspace(0,100,1000000);
% y = arrayfun(@(x) intensity_function(x), x);
% subplot(1,2,1);
% plot(x,y);
%
% t = 0;
% z = zeros(1000,1);
% for i = 1:1000
%     t = t + rand_interarrival(t);
%     z(i) = t;
% end
%
% subplot(1,2,2);
% scatter(z,0.005*rand(1000,1)+zeros(1000,1));
% xlim([-10 110]);
% ylim([-0.1 0.1]);

% disp('');
% disp('Expected number of hours on break1:');
% disp(mu_hat);