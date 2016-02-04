%finding controller K

maxerr=zeros(21,1);
for K = -10:10 %can change to first order etc.
    H_n=; %normal
    H_p=; %Parkinsonian
    H_k=; %controlled system
    [mag_p,~] = bode(H_p,z);
    [mag_k,~] = bode(H_k,z);
    for z =  0:.1:2*pi
        if abs(mag_k-mag_p) > maxerr(k)
            maxerr(K) = abs(mag_k-mag_p);
        end
    end
end
[y,i] = min(maxxerr);
K = -10:10;
K=K(i);
bodeplot(H_p,'b',H_k,'r');
