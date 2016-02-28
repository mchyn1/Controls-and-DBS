for j = 1:6
    for i = 1:6
        n=1;
        A_K=j-3;
        B_K=i-41;
        num_c= [A_pd A_pd.*B_K-A_pd.*gamma_pd.*cos(w_pd) -A_pd.*gamma_pd.*B_K.*cos(w_pd) 0];
        den_c= [1 A_pd.*A_K+B_K-2.*gamma_pd.*cos(w_pd) gamma_pd.^2-A_pd.*A_K.*gamma_pd.*cos(w_pd)-2.*B_K.*gamma_pd.*cos(w_pd) B_K.*gamma_pd.^2];
        H_control = tf(num_c, den_c, Ts, 'variable','z^-1','InputDelay',d_normal);
        figure;
        bodeplot(H_n,'b',H_control,'r',H_p,'m');
        legend('H_n','H_control','H_p');
        title(['A_K = ' num2str(A_K) ' B_K = ' num2str(B_K)]);
        n=n+1;
    end
end