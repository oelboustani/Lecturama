% upConvTest
clc
clear all
close all
M = 8;              % Modulation order
k = log2(M);        % Bits/symbol
n = 1e3;            % Transmitted bits
nSamp = 4;          % Samples per symbol
span = 6;           % Filter span in symbols
rolloff = 0.25;     % Rolloff factor
Fs =  1e3;          % Sampling rate
Fc = 20e3;          % Center frequency
nHold = 20*nSamp;   % Width of rectangular wave
intpF = 20;         % Interpolation factor
x = randi([0 M-1],n,1); % Random bits
data = kron(x, ones(nHold,1));
t = linspace(0, 1/Fs, length(data))';
LO1 = cos(2*pi*Fc*t); 
LO2 = cos(2*2*pi*Fc*t); 
l1 = plot(t*1e3, LO1);
hold on
l2 = plot(t*1e3, LO2);
xlabel('Time (ms)')
hold off
legend([l1, l2],{'Fc','2*Fc'})
x = LO1.*LO2;
pwelch(x,[],[],[],4*Fc,'centered')
