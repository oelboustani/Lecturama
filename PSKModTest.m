% PSKModTest
clc
clear all
close all

M = 8;              % Modulation order
k = log2(M);        % Bits/symbol
n = 1e3;            % Transmitted bits
nSamp = 4;          % Samples per symbol
span = 6;           % Filter span in symbols
rolloff = 0.2;     % Rolloff factor
Fs = 100e6;          % Sampling rate
    Fc = 20e6;           % Center frequency
    BW = Fc;
nHold = 20*nSamp;   % Width of rectangular wave
intpF = 20;         % Interpolation factor
x = randi([0 M-1],n,1); % Random bits


txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);


data = kron(x, ones(nHold,1));
txSig = pskmod(data,M,0, 'bin');

txSigI = real(txSig);
txSigQ = imag(txSig);

txSigFiltI = txfilter(txSigI);
txSigFiltQ = txfilter(txSigQ);
txSigFilt = txSigFiltI + 1j*txSigFiltQ;

[upSig, upSigI, upSigQ] = upConv(txSigFilt,Fc,Fs,n,nSamp,nHold);
[dwnSig, dwnSigI, dwnSigQ] = dwnConv(upSig,Fc,Fs,n,nSamp,nHold);

rxSigLPFI = lowpass(dwnSigI,BW,2*Fs,'ImpulseResponse','iir','Steepness',0.95);
rxSigLPFQ = lowpass(dwnSigQ,BW,2*Fs,'ImpulseResponse','iir','Steepness',0.95);

rxSigFiltI = rxfilter(rxSigLPFI);
rxSigFiltQ = rxfilter(rxSigLPFQ);
rxSig = rxSigFiltI + 1j*rxSigFiltQ;

figure
subplot(221)
pwelch(txSig,[],[],[],Fs,'centered')
title('Transmit signal')
subplot(222)
pwelch(upSig,[],[],[],Fs,'centered')
title('Transmit signal upconverted')
subplot(223)
pwelch(dwnSig,[],[],[],Fs,'centered')
title('Received signal downconverted')
subplot(224)
pwelch(rxSig,[],[],[],Fs,'centered')
title('Received signal')

figure
subplot(121)
pwelch(txSigFilt,[],[],[],Fs,'centered')
title('Transmit signal SRRC')

subplot(121)
pwelch(txSigFilt,[],[],[],Fs,'centered')
title('Transmit signal SRRC')

subplot(122)
pwelch(rxSig,[],[],[],Fs,'centered')
title('Receive signal SRRC')

evm = comm.EVM('MaximumEVMOutputPort',true,...
    'XPercentileEVMOutputPort',true, 'XPercentileValue',90,...
    'SymbolCountOutputPort',true);



rxdata = pskdemod(rxSig, M, 0);
comp = data == pskdemod(rxSig, M, 0);
A = [data, rxdata, comp];
[rmsEVM,maxEVM,pctEVM,numSym] = evm(rxSig,txSig);

fprintf('Comparing input data and   mod data: rmsEVM = %2.3f%%\n',rmsEVM)
[rmsEVM,maxEVM,pctEVM,numSym] = evm(rxdata,data);
fprintf('Comparing input data and demod data: rmsEVM = %2.3f%%\n',rmsEVM)

scatterplot(txSig)
title('Transmitted Signal')

scatterplot(rxSig)
title('Received Signal')



