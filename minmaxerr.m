%Code to find the best controller K
%PI: Sridevi Sarma
%Pseudocode: Michelle Chyn
%TF/Edits: Melissa Lin, Debra Huang

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
maxerr=zeros(1,1);

for j = 1:21 %can change to first order etc.
    K = j -11;
    H_n = tf(num,den,Ts,'variable','z^-1','InputDelay',d);
    H_p = tf(num,den,Ts,'variable','z^-1','InputDelay',d); %Use Sabatine code to find; %Parkinsonian
    H_control = tf(num,(den+num*K),Ts,'variable','z^-1','InputDelay',d);%Create based on %H_p/(1+H_p*K)
    mag = zeros(1,360);
    mag_p = zeros(1,360);
    mag_n = zeros(1,360);
    for q=1:361
    [mag(q),~] = bode(H_control,(q-1)/180*pi);
    [mag_p(q),~] = bode(H_p,(q-1)/180*pi);
    [mag_n(q),~] = bode(H_n,(q-1)/180*pi);
    %zplane(num,den);
    
        
    end
    for q=1:361
        [maxerr(j) index] = max(abs(mag_n(q)-mag(q)));
    end
end
[y,i] = min(maxerr);
K = -10:10;
K=K(i);
H_control = tf(num,(den+num*K),Ts,'variable','z^-1','InputDelay',d);
bodeplot(H_n,'b',H_control,'r');


