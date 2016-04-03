%Set up parameters based on the 'best' values found in earlier trials
A_normal = 4.6560;
gamma_normal = 0.9544;
w_normal = 6.3461;
d_normal = 6;

A_pd = 4.232389;
gamma_pd = 0.9497;
w_pd = 0.0631;
d_pd = 6;

d2=7;
lags=0:.1:59.9;

%Set up unmodified transfer functions based on Sabatino's code
den = [1 -2*gamma_normal*cos(w_normal) gamma_normal^2];
num = [A_normal -A_normal*gamma_normal*cos(w_normal) 0];
den1 = [1 -2*gamma_pd*cos(w_pd) gamma_pd^2];
num1 = [A_pd -A_pd*gamma_pd*cos(w_pd) 0];
Ts  = .1;

H_n = tf(num,den,Ts,'variable','z^-1','InputDelay',d_normal);
H_p = tf(num1,den1,Ts,'variable','z^-1','InputDelay',d_pd);

%maxerr=zeros(2001,2001);
%w=360*10:360*30;
%[b,~] = bode(H_p,w);
%[c,~] = bode(H_n,w);
[yp,tp]=impulse(H_p,lags);
[yn,tn]=impulse(H_n,lags);
%mag=zeros(7201,1);
%mag_p=mag;mag_n=mag;
%for k = 1:7201
%    mag_p(k)=b(:,:,k);
%    mag_n(k)=c(:,:,k);
%end

%plotting bode's with different K's
for j = 1%:3%1:2001
    for i = 1%:10%1:2001
        n=1;
        A_K=j/100;%(j-2)./100000;%(j-1001)./1000; %-1:.001:1
        B_K=i/100;%i-40;%(-i+1)./200-40; %-40:.005:-30
        %num_c= [A_pd A_pd.*B_K-A_pd.*gamma_pd.*cos(w_pd) -A_pd.*gamma_pd.*B_K.*cos(w_pd) 0];
        %den_c= [1 A_pd.*A_K+B_K-2.*gamma_pd.*cos(w_pd) gamma_pd.^2-A_pd.*A_K.*gamma_pd.*cos(w_pd)-2.*B_K.*gamma_pd.*cos(w_pd) B_K.*gamma_pd.^2];
        num_c = [0 0 A_K];
        den_c = [0 1 B_K];
        K = tf(num_c, den_c, Ts, 'variable','z^-1','InputDelay',d2);
        H_cl=feedback(H_p,K,+1);
        %H_cl=tf(num_c, den_c, Ts, 'variable','z^-1','InputDelay',d2);
        figure;
        %bodeplot(H_n,'b',H_control,'r',H_p,'m');
        %legend('H_n','H_control','H_p');
        
        %[a,~] = bode(H_cl,w);
        %for k = 1:7201
        %    mag(k)=a(:,:,k);
        %end
        [ycl,tcl]=impulse(H_cl,lags);
        error = zeros(length(tcl),1);
        for q=1:length(tn)
            error(q) = abs(ycl(q)-yn(q));
        end
%         for q=1:360*20+1
%             error(q) = abs(mag_n(q)-mag(q));
%         end
        [maxerr(j,i), index] = max(error);
        plot(tcl,ycl);
        title(['A_K=' num2str(A_K) ' B_K=' num2str(B_K) ' err=' num2str(maxerr(j,i))]);
    end
end