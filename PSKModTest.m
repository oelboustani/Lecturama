% PSKModTest
clc
clear all
close all

Fs = 2.0e9;         % Sampling rate
Fc = 0.3e9;         % Center frequency
BW = Fc/3;          % Bandwidth
M = 64;             % Modulation order
k = log2(M);        % Bits/symbol
n = 2e3;            % Transmitted bits
nSamp = 10*k;       % Samples per symbol
span = 1;           % Filter span in symbols
rolloff = 0.2;      % Rolloff factor

evm = comm.EVM('MaximumEVMOutputPort',true,...
    'XPercentileEVMOutputPort',true, 'XPercentileValue',90,...
    'SymbolCountOutputPort',true);

txdata = randi([0 M-1],n,1); % Random bits

phi = 0;
txSig = pskmod(txdata,M,phi);
txSigI = real(txSig);
txSigQ = imag(txSig);
txSigSpec = kron(txSig, ones(nSamp,1));

txSigShapeI = txfilter(txSigI, nSamp, span, rolloff);
txSigShapeQ = txfilter(txSigQ, nSamp, span, rolloff);
txSigShape = txSigShapeI + 1j*txSigShapeQ;

txSigUp = upConvert(txSigShape,Fc,Fs);
[rxSigDwnI, rxSigDwnQ] = dwnConvert(txSigUp,Fc,Fs);
rxSigDwn = rxSigDwnI + 1j*rxSigDwnQ;

rxSigLPFI = lowpass(rxSigDwnI,BW,Fs,'ImpulseResponse','iir','Steepness',0.95);
rxSigLPFQ = lowpass(rxSigDwnQ,BW,Fs,'ImpulseResponse','iir','Steepness',0.95);

rxSigShapeI = rxfilter(rxSigLPFI, nSamp, span, rolloff);
rxSigShapeQ = rxfilter(rxSigLPFQ, nSamp, span, rolloff);
rxSig = rxSigShapeI + 1j*rxSigShapeQ;

rxSigSpec = kron(rxSig, ones(nSamp,1));

[rmsEVM,maxEVM,pctEVM,numSym] = evm(rxSig,txSig);
fprintf('Comparing input data and   mod data: rmsEVM = %2.3f%%\n',rmsEVM)

rxdata = pskdemod(rxSig,M,phi,'bin');
A = [rxdata, txdata, rxdata==txdata];
pos = [343 343 560 343];

figure('Position',pos)
pltspectrum(txSigSpec, Fs)
plotname = 'Transmit Baseband Signal';
title(plotname)
savefig(plotname)


figure('Position',pos)
pltspectrum(txSigShape, Fs)
plotname = 'Transmit Pulse-Shaped Signal';
title(plotname)
savefig(plotname)

figure('Position',pos)
pltspectrum(txSigUp, Fs)
plotname = 'Transmit Upconverted Signal';
title(plotname)
savefig(plotname)

figure('Position',pos)
pltspectrum(rxSigDwnI, Fs)
plotname = 'Receive Downconverted Signal';
title(plotname)
savefig(plotname)


figure('Position',pos)
pltspectrum(rxSigLPFI, Fs)
plotname = 'Receive Filtered Downconverted Signal';
title(plotname)
savefig(plotname)

figure('Position',pos)
pltspectrum(rxSigSpec, Fs)
plotname = 'Receive Pulse-Shaped Signal';
title(plotname)
savefig(plotname)

scatterplot(txSig)
plotname = 'Transmit Constellation';
title(plotname)
savefig(plotname)


scatterplot(rxSig)
plotname = 'Receive Constellation';
title(plotname)
savefig(plotname)


return
figure
subplot(231)
pwelch(txSigSpec,[],[],[],Fs,'centered')
title('TX Baseband Signal')

subplot(232)
pwelch(txSigShape,[],[],[],Fs,'centered')
title('TX Pulse-Shaped Signal')

subplot(233)
pwelch(txSigUp,[],[],[],Fs,'centered')
title('TX Upconverted Signal')


subplot(234)
pwelch(rxSigDwnI,[],[],[],Fs,'centered')
title('RX Downconverted Signal')

subplot(235)
pwelch(rxSigLPFI,[],[],[],Fs,'centered')
title('RX Downconverted LPF Signal')

subplot(236)
pwelch(rxSigSpec,[],[],[],Fs,'centered')
title('RX Pulse-Shaped Signal')
