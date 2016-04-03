function err = find_params(x01, x02)

global lags psth err runs y

    % set the initial guess for the model parameters that you're looking for.
    % The routine will then refine the search. Let as assume for now that the
    % parameters are x = [ A gamma w d]
    % x01 = [10*rand(1,1) rand(1,1) rand(1,1) 10*abs(rand(1,1))];
    % x02 = x01.*abs(rand(1,1))*10;
    % x03 = x01.*abs(rand(1,1))*5;

    % search the parameter values that best fit the PSTH curve
    x1 = fminsearch(@impulseresp_error_cos,x01);
    x2 = fminsearch(@impulseresp_error_sin,x02);
    % x3 = fminsearch(@impulseresp_error_cos,x03);

    % build the LTI system with the identified parameters
    A1 = x1(1); gamma1 = x1(2); w1 = x1(3); d1 = round(x1(4));
    A2 = x2(1); gamma2 = x2(2); w2 = x2(3); d2 = round(x2(4));
    % A3 = x3(1); gamma3 = x3(2); w3 = x3(3); d3 = round(x3(4));
    den1 = [1 -2*gamma1*cos(w1) gamma1^2];
    num1 = [A1 -A1*gamma1*cos(w1) 0];
    num2 = [0 A2*gamma2*sin(w2) 0];
    den2 = [1 -2*gamma2*cos(w2) gamma2^2];
    % den3 = [1 -2*gamma3*cos(w3) gamma3^2];
    % num3 = [A3 -A3*gamma3*cos(w3) 0];
    Ts  = 1; %ms
    % to make sure delay is nonnegative, but 
    all = [d1,d2];
    d1 = d1 - min(all);
    d2 = d2 - min(all); 
    % d3 = d3 - min(all);
    Hsys1 = tf(num1,den1,Ts,'variable','z^-1','InputDelay',d1);
    Hsys2 = tf(num2,den2,Ts,'variable','z^-1','InputDelay',d2);
    % Hsys3 = tf(num3,den3,Ts,'variable','z^-1','InputDelay',d3);
    Hsys = Hsys1+Hsys2;
    % compute the impulse response of the transfer function
    y = impulse(Hsys,lags);
    [num{i,1}, den{i,1}]= tfdata(Hsys);

    % compute the error between the actual impulse response
    err = norm(psth-y,2);
