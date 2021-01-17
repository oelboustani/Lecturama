function txSig = txfilter(Sig, nSamp, span, rolloff)
    rrcFilter = rcosdesign(rolloff, span, nSamp);
    txSig = upfirdn(Sig, rrcFilter, nSamp);
end