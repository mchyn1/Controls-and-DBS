%Code to find the best controller K
%PI: Sridevi Sarma
%Pseudocode: Michelle Chyn
%TF/Edits: Melissa Lin, Debra Huang

%Load global variables
global lags psth counter

%Set up parameters based on the 'best' values found in earlier trials
A = [11; 8];
gamma = [0.6; .8];
w = [3.5; .4];
d = [7; 7];

%Set up unmodified transfer functions based on Sabatino's code
den = [ones(2,1) -2.*gamma.*cos(w) gamma.^2];
num = [ones(2,1).*A -A.*gamma.*cos(w) zeros(2,1)];
Ts  = 0.1;

%finding controller K
maxerr=zeros(1,1);

for j = 1:21 %can change to first order etc.
    K = j -11;
    H_n = tf(num(1,:),den(1,:),Ts,'variable','z^-1','InputDelay',d(1,:));
    H_p = tf(num(2,:),den(2,:),Ts,'variable','z^-1','InputDelay',d(2,:)); %Use Sabatine code to find; %Parkinsonian
    H_control = tf(num(2,:),(den(2,:)+num(2,:)*K),Ts,'variable','z^-1','InputDelay',d(2,:));%Create based on %H_p/(1+H_p*K)
    mag = zeros(1,360);
    mag_p = zeros(1,360);
    mag_n = zeros(1,360);
    for q=1:361
        [mag(q),~] = bode(H_control,(q-1)/180*pi);
        [mag_p(q),~] = bode(H_p,(q-1)/180*pi);
        [mag_n(q),~] = bode(H_n,(q-1)/180*pi);
    end
    
    poles=pole(H_control);
    r=length(poles);
    count=0;
    for s=1:r
        if abs(poles(r))>10000 %arbitrary threshold for unstable system
            count=count+1;
        end
    end
    if count==0
        for q=1:361
            [maxerr(j), index] = max(abs(mag_n(q)-mag(q)));
        end
    end
end
[y,i] = min(maxerr);
K = -10:10;
K=K(i);
H_control = tf(num(2,:),(den(2,:)+num(2,:)*K),Ts,'variable','z^-1','InputDelay',d(2,:));
bodeplot(H_n,'b',H_control,'r',H_p,'m');
legend('H_n','H_control','H_p');
