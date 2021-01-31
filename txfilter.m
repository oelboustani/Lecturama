function txSig = txfilter(Sig, nSamp, span, rolloff)
%TXFILTER applies square-root raised cosine filter to a transmit signal.
%   Example:
%   txSig = txfilter(Sig, nSamp, span, rolloff)
%   
%   - Sig     = transmit signal
%   - nSamp   = number of samples per bit (oversampling)
%   - span    = filter span in symbols
%   - rolloff = rolloff factor of the square-root raised cosine filter

    rrcFilter = rcosdesign(rolloff, span, nSamp);
    txSig = upfirdn(Sig, rrcFilter, nSamp);
end