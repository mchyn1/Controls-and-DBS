clear

global lags resp counter

% load the PSTH curves
load('impulse_responses.mat');

% choose the curves that you'd like to fit
lags = lags;
lags = lags(1,4:61)';
resp = resp_normal(1,3:60)';

A_values = 0:0.01:5;
%A_values = 0;
gamma_values = 0:0.01:3;
%gamma_values = 0;
w_values = 0:0.1:2*pi();
%w_values = 2.9;
d_values = 0;

act_param = [];
err1 = [];
xs = [];
counter = 0;
for a = A_values
    for b = gamma_values
        for c = w_values
            for e = d_values
                counter = counter + 1;
                x0 = [a b c e];
                xs = [xs; x0];
                err_temp = find_params(x0);
                err1 = [err1; err_temp];
                final = [xs err1];
            end
        end
    end
end

[Y,I] = sort(final(:,5));
B = final(I,:);