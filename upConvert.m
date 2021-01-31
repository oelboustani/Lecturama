function upSig = upConvert(sigI,sigQ,Fc,Fs)
%UPCONVERT applies upconversion to a transmit signal.
%   Example:
%   upSig = upConvert(sigBB,Fc,Fs)
%
%   - sigI  = in-phase component of signal to be upconverted
%   - sigQ  = quadrature component of signal to be upconverted
%   - Fc    = frequency of the local oscillator (Hz)
%   - Fs    = sampling frequency (Hz)

    t = [0:1:length(sigQ)-1]'/Fs;
    upSigI =  1*sigI.*cos(2*pi*Fc*t);
    upSigQ = -1*sigQ.*sin(2*pi*Fc*t);
    upSig = upSigI + upSigQ;
end
