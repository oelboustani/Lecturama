% PSKModTest
clc
clear all
close all

% Set up parameters
Fs = 2.0e9;         % Sampling rate
Fc = 0.3e9;         % Center frequency
BW = Fc/3;          % Bandwidth
M = 64;             % Modulation order
k = log2(M);        % Bits/symbol
n = 2e3;            % Transmitted bits
nSamp = 10*k;       % Samples per symbol
span = 1;           % Filter span in symbols
rolloff = 0.2;      % Rolloff factor

% Set up error vector magnitude 
evm = comm.EVM('MaximumEVMOutputPort',true,...
    'XPercentileEVMOutputPort',true, 'XPercentileValue',90,...
    'SymbolCountOutputPort',true);

% Create random data
txdata = randi([0 M-1],n,1); 

% Apply PSK modulation
phi = 0;
txSig = pskmod(txdata,M,phi);
txSigI = real(txSig);
txSigQ = imag(txSig);

% Apply ZOH function
txSigSpec = kron(txSig, ones(nSamp,1));

% Apply pusle-shaping with SRRC
txSigShapeI = txfilter(txSigI, nSamp, span, rolloff);
txSigShapeQ = txfilter(txSigQ, nSamp, span, rolloff);
txSigShape = txSigShapeI + 1j*txSigShapeQ;

% Apply upconversion
txSigUp = upConvert(txSigShape,Fc,Fs);

% Apply downconversion
[rxSigDwnI, rxSigDwnQ] = dwnConvert(txSigUp,Fc,Fs);
rxSigDwn = rxSigDwnI + 1j*rxSigDwnQ;

% Apply lowpass filtering
rxSigLPFI = lowpass(rxSigDwnI,BW,Fs,'ImpulseResponse','iir','Steepness',0.95);
rxSigLPFQ = lowpass(rxSigDwnQ,BW,Fs,'ImpulseResponse','iir','Steepness',0.95);

% Apply pusle-shaping with SRRC
rxSigShapeI = rxfilter(rxSigLPFI, nSamp, span, rolloff);
rxSigShapeQ = rxfilter(rxSigLPFQ, nSamp, span, rolloff);
rxSig = rxSigShapeI + 1j*rxSigShapeQ;


% Apply ZOH function
rxSigSpec = kron(rxSig, ones(nSamp,1));

% Compute error vector magnitude
[rmsEVM,maxEVM,pctEVM,numSym] = evm(rxSig,txSig);
fprintf('Comparing input data and   mod data: rmsEVM = %2.3f%%\n',rmsEVM)

% Plot and save results
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
