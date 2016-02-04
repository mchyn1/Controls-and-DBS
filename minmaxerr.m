%Code to find the best controller K
%PI: Sridevi Sarma
%Pseudocode: Michelle Chyn
%TF/Edits: Melissa Lin

%Load global variables
global lags psth counter

%Set up parameters based on the 'best' values found in earlier trials
A = 11;
gamma = 0.6;
w = 3.5;
d = 7;

%Set up unmodified transfer functions based on Sabatino's code
den = [1 -2*gamma*cos(w) gamma^2];
num = [A -A*gamma*cos(w) 0];
Ts  = 0.1;

%finding controller K
maxerr=zeros(21,1);

for K = -10:10 %can change to first order etc.
    H_n = %Use Sabatino code to find; %normal
    H_p=; %Use Sabatine code to find; %Parkinsonian
    H_control = %Create based on %H_p/(1+H_p*K)
    
    [mag,~] = bode(H_control,z);
    [mag_p,~] = bode(H_p,z);
    [mag_n,~] = bode(H_n,z);
    %zplane(num,den);
    for z =  0:.1:2*pi
        if abs(mag_n-mag) > maxerr(k)
            maxerr(K) = abs(mag_n-mag);
        end
    end
end
[y,i] = min(maxxerr);
K = -10:10;
K=K(i);
bodeplot(H_n,'b',H_control,'r');
