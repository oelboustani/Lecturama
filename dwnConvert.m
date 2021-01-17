function [dwnSigI, dwnSigQ] = dwnConvert(sigRF,Fc,Fs)
    t = [0:1:length(sigRF)-1]'/Fs;
    dwnSigI =  2*sigRF.*cos(2*pi*Fc*t);
    dwnSigQ = -2*sigRF.*sin(2*pi*Fc*t);
end

