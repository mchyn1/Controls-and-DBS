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

maxerr=zeros(21,21);

%plotting bode's with different K's
for j = 1
    for i = 1:3
        n=1;
        A_K=j./10;
        B_K=-i-30;
        num_c= [A_pd A_pd.*B_K-A_pd.*gamma_pd.*cos(w_pd) -A_pd.*gamma_pd.*B_K.*cos(w_pd) 0];
        den_c= [1 A_pd.*A_K+B_K-2.*gamma_pd.*cos(w_pd) gamma_pd.^2-A_pd.*A_K.*gamma_pd.*cos(w_pd)-2.*B_K.*gamma_pd.*cos(w_pd) B_K.*gamma_pd.^2];
        H_control = tf(num_c, den_c, Ts, 'variable','z^-1','InputDelay',d_normal);
        figure;
        bodeplot(H_n,'b',H_control,'r',H_p,'m');
        legend('H_n','H_control','H_p');
        
        
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
        error = zeros(360,1);
        for q=1:360*20+1
            error(q) = abs(mag_n(q)-mag(q));
        end
        [maxerr(j,i), index] = max(error);
        title(['A_K=' num2str(A_K) ' B_K=' num2str(B_K) ' err=' num2str(maxerr(j,i))]);
    end
end