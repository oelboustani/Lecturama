% PSKModTest
clc
clear all
close all
pos = [343 343 560 343];

% Set up parameters
Fs = 5.0e9;         % Sampling rate
Fc = 0.5e9;         % Center frequency
BW = Fs/500;        % Bandwidth
M = 64;             % Modulation order
k = log2(M);        % Bits/symbol
n = 1e3;            % Transmitted bits
nSamp = 24*k;       % Samples per symbol
span = 1;           % Filter span in symbols
rolloff = 0.2;      % Rolloff factor

% Set up error vector magnitude 
evm = comm.EVM('MaximumEVMOutputPort',true,...
    'XPercentileEVMOutputPort',true, 'XPercentileValue',90,...
    'SymbolCountOutputPort',true);

% Create random data
txdata = randi([0 M-1],n,1);
txdata = csvread('txdata1.csv');

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
txSigUp = upConvert(txSigShapeI,txSigShapeQ,Fc,Fs);

% Apply downconversion
[rxSigDwnI, rxSigDwnQ] = dwnConvert(txSigUp,Fc,Fs);
rxSigDwn = rxSigDwnI + 1j*rxSigDwnQ;

% Apply lowpass filtering
rxSigLPFI = lowpass(rxSigDwnI,BW,Fs);
rxSigLPFQ = lowpass(rxSigDwnQ,BW,Fs);

% Apply pusle-shaping with SRRC
rxSigShapeI = rxfilter(rxSigLPFI, nSamp, span, rolloff);
rxSigShapeQ = rxfilter(rxSigLPFQ, nSamp, span, rolloff);
rxSig = rxSigShapeI + 1j*rxSigShapeQ;

% Apply ZOH function
rxSigSpec = kron(rxSig, ones(nSamp,1));

% Compute error vector magnitude
[rmsEVM,maxEVM,pctEVM,numSym] = evm(rxSig,txSig);
fprintf('rmsEVM = %2.3f%%\n',rmsEVM)

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

% Two channel transmitter
% Create random data
txdata2 = randi([0 M-1],n,1); 
txdata2 = csvread('txdata2.csv');

% Apply PSK modulation
phi = 0;
txSig2 = pskmod(txdata2,M,phi);
txSigI2 = real(txSig2);
txSigQ2 = imag(txSig2);

% Apply ZOH function
txSigSpec2 = kron(txSig2, ones(nSamp,1));

% Apply pusle-shaping with SRRC
txSigShapeI2 = txfilter(txSigI2, nSamp, span, rolloff);
txSigShapeQ2 = txfilter(txSigQ2, nSamp, span, rolloff);

% Apply upconversion
txSigUp2 = upConvert(txSigShapeI2,txSigShapeQ2,1.5*Fc,Fs);

twochannel = txSigShape + 2*txSigUp2;
figure('Position',pos)
pltspectrum(twochannel, Fs)
plotname = 'Multi-Tone Scenario';
title(plotname)
savefig(plotname)

% Plot and save results
pos = [343 343 560 343];
figure('Position',pos)
pltspectrum(rxSigLPFI, Fs)
xlim([-45 45]*1e-3)
plotname = 'Main-Channel Zoomed-In';
title(plotname)
savefig(plotname)