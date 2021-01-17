function pltspectrum(Sig, Fs)
    [pxx, f] = pwelch(Sig,[],[],[],Fs,'centered');
    plot(f*1e-9, pow2db(pxx),'blue')
    xlabel('Frequency (GHz)')
    ylabel('PSD (dB/Hz)')
    grid on
end