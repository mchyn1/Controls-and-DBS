function err_temp = find_params(x0);

global lags resp

% set the initial guess for the model parameters that you're looking for.
% The routine will then refine the search. Let as assume for now that the
% parameters are x = [ A gamma w d]
% x0 = [0.0559 0.84 0.0346 5.4]; -> MSE = 0.043006
% x0 = [0 0 1.10000000000000 9]; -> MSE = 0.040491
% x0 = [0.02 0.02 0.2 6.1];

options = struct('MaxFunEvals',50000);
% search the parameter values that best fit the PSTH curve
x = fminsearch(@impulseresp_error,x0);

% build the LTI system with the identified parameters
A = x(1); gamma = x(2); w = x(3); d = 0;
 den = [1 -2*gamma*cos(w) gamma^2];
 num = [A -A*gamma*cos(w) 0];
% num = [0 A*gamma*sin(w) 0];
% den = [1 -2*gamma*cos(w) gamma^2];
Ts  = 1;
Hsys = tf(num,den,Ts,'variable','z^-1','InputDelay',d);

% compute the impulse response of the transfer function
y = impulse(Hsys,lags);

% compute the error between the actual impulse response
err_temp = norm(resp-y,2);

% plot the results
%plot(lags,resp,'k',lags,y,'r');
%fprintf('MSE: %f\n',err_temp);
%fprintf('params: A= %f\t gamma= %f\t w= %f\t d= %f\n',x);
