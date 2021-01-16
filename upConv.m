function [upSig, upSigI, upSigQ] = upConv(sigBB,Fc,Fs,n,nSamp,nHold)
    t = [0:1:nSamp*nHold*n-1]'/Fs;
    sigBBI = real(sigBB);
    sigBBQ = imag(sigBB);
    upSigI = sigBBI.*cos(2*pi*Fc*t);
    upSigQ = sigBBQ.*sin(2*pi*Fc*t);
    upSig = upSigI + upSigQ;
end

