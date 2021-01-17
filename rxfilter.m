function rxSig = rxfilter(Sig, nSamp, span, rolloff)
    rrcFilter = rcosdesign(rolloff, span, nSamp);
    rxSig = upfirdn(Sig, rrcFilter, 1, nSamp);
    rxSig = rxSig(span+1:end-span);
end