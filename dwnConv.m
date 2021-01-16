function [dwnSig, dwnSigI, dwnSigQ] = dwnConv(sigRF,Fc,Fs,n,nSamp,nHold)
    t = [0:1:nSamp*nHold*n-1]'/Fs;
    sigRFI = real(sigRF);
    sigRFQ = real(sigRF);
    dwnSigI = 2*sigRFI.*cos(2*pi*Fc*t);
    dwnSigQ = -2*sigRFQ.*sin(2*pi*Fc*t);
    dwnSig = dwnSigI + dwnSigQ;
end

