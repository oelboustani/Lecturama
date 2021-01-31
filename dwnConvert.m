function [dwnSigI, dwnSigQ] = dwnConvert(sigRF,Fc,Fs)
%DWNCONVERT applies downconversion to a receive signal and generates IQ.
%   Example:
%   [dwnSigI, dwnSigQ] = dwnConvert(sigRF,Fc,Fs)
%
%   - sigRF = signal to be downconverted
%   - Fc    = frequency of the local oscillator (Hz)
%   - Fs    = sampling frequency (Hz)

    t = [0:1:length(sigRF)-1]'/Fs;
    dwnSigI =  2*sigRF.*cos(2*pi*Fc*t);
    dwnSigQ = -2*sigRF.*sin(2*pi*Fc*t);
end

