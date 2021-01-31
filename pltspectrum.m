function pltspectrum(Sig, Fs)
%PLTSPECTRUM plots the spectrum of a signal.
%   Example: 
%   pltspectrum(Sig, Fs)
%
%   - Sig   = signal
%   - Fs    = sampling frequency (Hz)

    [pxx, f] = pwelch(Sig,[],[],[],Fs,'centered');
    plot(f*1e-9, pow2db(pxx),'blue')
    xlabel('Frequency (GHz)')
    ylabel('PSD (dB/Hz)')
    grid on
end