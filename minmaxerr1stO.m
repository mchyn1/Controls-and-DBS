%Code to find the best controller K
%PI: Sridevi Sarma
%Pseudocode: Michelle Chyn
%TF/Edits: Melissa Lin, Debra Huang

clear all; close all;clc;
%Load global variables
global lags psth counter

%Set up parameters based on the 'best' values found in earlier trials
A_normal = 4.6560;
gamma_normal = 0.9544;
w_normal = 6.3461;
d_normal = 6;

A_pd = 4.232389;
gamma_pd = 0.9497;
w_pd = 0.0631;
d_pd = 6;

%Set up unmodified transfer functions based on Sabatino's code
den = [1 -2*gamma_normal*cos(w_normal) gamma_normal^2];
num = [A_normal -A_normal*gamma_normal*cos(w_normal) 0];
den1 = [1 -2*gamma_pd*cos(w_pd) gamma_pd^2];
num1 = [A_pd -A_pd*gamma_pd*cos(w_pd) 0];
Ts  = 0.0001;

%finding controller K
maxerr=zeros(21,21);

for j = 1:201
    for B = 1:51
        %K = j -11; just a gain
        H_n = tf(num,den,Ts,'variable','z^-1','InputDelay',d_normal);
        H_p = tf(num1,den1,Ts,'variable','z^-1','InputDelay',d_pd); %Use Sabatine code to find; %Parkinsonian
        %H_control = tf(num(2,:),(den(2,:)+num(2,:)*K),Ts,'variable','z^-1','InputDelay',d(2,:));
        %^ is for K=gain
        %First order K based on %H_p/(1+H_p*K)
        A_K=(j-1)./100;
        B_K=-(B-1)./10-35;
        %num_c = [A_K -A_K*gamma_pd*cos(w_pd) -A_K*B_K*gamma_pd*cos(w_pd) 0];
        %den_c = [1 A_K^2-2*gamma_pd*cos(w_pd)+B_K -(A_K^2*gamma_pd*cos(w_pd)-2*B_K*gamma_pd*cos(w_pd)+gamma_pd^2) B_K*gamma_pd^2];
        num_c= [A_pd A_pd.*B_K-A_pd.*gamma_pd.*cos(w_pd) -A_pd.*gamma_pd.*B_K.*cos(w_pd) 0];
        den_c= [1 A_pd.*A_K+B_K-2.*gamma_pd.*cos(w_pd) gamma_pd.^2-A_pd.*A_K.*gamma_pd.*cos(w_pd)-2.*B_K.*gamma_pd.*cos(w_pd) B_K.*gamma_pd.^2];
        H_control = tf(num_c, den_c, Ts, 'variable','z^-1','InputDelay',d_normal);
        w=360*10:360*30;
        [a,~] = bode(H_control,w);
        [b,~] = bode(H_p,w);
        [c,~] = bode(H_n,w);
        mag=zeros(7201,1);
        mag_p=mag;mag_n=mag;
        for k = 1:7201
            mag(k)=a(:,:,k);
            mag_p(k)=b(:,:,k);
            mag_n(k)=c(:,:,k);
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
            error = zeros(360,1);
            for q=1:360*20+1
                error(q) = abs(mag_n(q)-mag(q));
            end
            [maxerr(j,B), index] = max(error);
        end
    end
end
%%
% y=zeros(21,1);i=zeros(21,1);
% for m = 1:size(maxerr,1)
%     [y(m),i(m)] = min(maxerr(m,:));
% end
% [y2,i2] = min(y);
[y,i] = min(maxerr(:));
[i_row, i_col] = ind2sub(size(maxerr(:)),i);
A_K = 0:.01:2;
B_K = -(35:.1:40);
A_K=A_K(104);
B_K = B_K(1);
% num_c = [A_K -A_K*gamma_pd*cos(w_pd) -A_K*B_K*gamma_pd*cos(w_pd) 0];
%den_c = [1 A_K^2-2*gamma_pd*cos(w_pd)+B_K -(A_K^2*gamma_pd*cos(w_pd)-2*B_K*gamma_pd*cos(w_pd)+gamma_pd^2) B_K*gamma_pd^2];
num_c= [A_pd A_pd.*B_K-A_pd.*gamma_pd.*cos(w_pd) -A_pd.*gamma_pd.*B_K.*cos(w_pd) 0];
den_c= [1 A_pd.*A_K+B_K-2.*gamma_pd.*cos(w_pd) gamma_pd.^2-A_pd.*A_K.*gamma_pd.*cos(w_pd)-2.*B_K.*gamma_pd.*cos(w_pd) B_K.*gamma_pd.^2];
H_control = tf(num_c, den_c, Ts, 'variable','z^-1','InputDelay',d_normal);
bodeplot(H_n,'b',H_control,'r',H_p,'m');
legend('H_n','H_control','H_p');
