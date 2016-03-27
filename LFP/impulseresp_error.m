function err = impulseresp_error(x)

%--------------------------------------------------------------------------
% Let us assume that we would like to fit the following class of transfer
% functions on the data
%
%                       A*gamma*sin(w)*z^-1
% H(z) = ---------------------------------------------- x z^-d
%             1 -2*gamma*cos(w)*z^-1 + gamma^2*z^-2
%
% where z^-1 is the Z-transform variable, and A, gamma, w, d are 5 numbers
% that we need to estimate. Hence, let us assume that the input vector "x"
% contains these numbers, i.e., x = [A gamma w d].
%
% Note that - if you want to modify the class of transfer functions - then
% your vector "x" will contain a different set of parameters.
%--------------------------------------------------------------------------

% the PSTH curve is in the workspace in the vector "psth" and the
% correspondent time instants are in the vector "lags"
global lags resp counter

% extract the parameters
A = x(1); gamma = x(2); w = x(3); d = 0;%round(x(4));

if A < 0 || gamma < 0 || w < 0
    err = 0;
    return;
end

% define the numerator and denominator of the transfer function, along with
% the sampling rate Ts. Note that the sampling rate is the interval between
% consecutive samples in the PSTH. In your case, it is always 0.1 ms.
% IMPORTANT: if you want to change the structure of your transfer function,
% you will modify here the definition of numerator and denominator.
% num = [0 A*gamma*sin(w) 0];
% den = [1 -2*gamma*cos(w) gamma^2];
den = [1 -2*gamma*cos(w) gamma^2];
num = [A -A*gamma*cos(w) 0];
Ts  = 1;

% define the transfer function
Hsys = tf(num,den,Ts,'variable','z^-1','InputDelay',d);

% compute the impulse response of the transfer function and be sure that it
% is evaluated exactly at the same time instants where the PSTH curve was
% estimated
y = impulse(Hsys,lags);
%whos y resp

% compute the error between the actual impulse response (i.e., the PSTH
% curve) and the impulse response of the model. This error would be zero if
% the model fits perfectly the actual data. However, it is likely that the
% fit is not perfect, hence we will have an error greater than zero. The
% goal of our search will be finding those parameters A, gamma, w, and d
% that make the error as close to zero as possible
err = norm(resp-y,2);

% If you want to compare the estimated and actual impulse response or
% return the value of the quadratic error, uncomment these lines
% % plot(lags,psth,'k',lags,y,'r');
% % fprintf('%f\n',err);
