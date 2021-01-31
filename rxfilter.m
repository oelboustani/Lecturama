function rxSig = rxfilter(Sig, nSamp, span, rolloff)
%RXFILTER applies square-root raised cosine filter to a receive signal.
%   Example:
%   rxSig = rxfilter(Sig, nSamp, span, rolloff)
%
%   - Sig     = receive signal
%   - nSamp   = number of samples per bit (oversampling)
%   - span    = filter span in symbols
%   - rolloff = rolloff factor of the square-root raised cosine filter

    rrcFilter = rcosdesign(rolloff, span, nSamp);
    rxSig = upfirdn(Sig, rrcFilter, 1, nSamp);
    rxSig = rxSig(span+1:end-span);
end