function upSig = upConvert(sigBB,Fc,Fs)
    t = [0:1:length(sigBB)-1]'/Fs;
    upSigI =  real(sigBB).*cos(2*pi*Fc*t);
    upSigQ = -imag(sigBB).*sin(2*pi*Fc*t);
    upSig = upSigI + upSigQ;
end
