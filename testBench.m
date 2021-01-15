close all
clear all

% ArraySize = 64;
% X = randi([0 1], [ArraySize 1]);
% PSK = pskmod(X, ArraySize);
% scatterplot(PSK)
fs = 10e3;
dataIn = randn(1000,1);
[y, lpFilt] = lowpass(dataIn,150,fs);
dataOut = filter(lpFilt,dataIn);
return

[rmsEVM,maxEVM,pctEVM,numSym] = evm(tx_data,rx_data)
M = 8;
data = (0:M-1);
data = [3 1 5 2 4 0 7 7 0 7 1 2 4 7 6 0 4 4 3 7 1 0 ];
phz = 0;

symgray = pskmod(data,M,phz,'gray');
mapgray = pskdemod(symgray,M,phz,'gray');

symbin = pskmod(data,M,phz,'bin');
mapbin = pskdemod(symbin,M,phz,'bin');

scatterplot(symgray,1,0,'b*');

for k = 1:M
    text(real(symgray(k))-0.2,imag(symgray(k))+.15,...
        dec2base(mapgray(k),2,3));
     text(real(symgray(k))-0.2,imag(symgray(k))+0.3,...
         num2str(mapgray(k)));

    text(real(symbin(k))-0.2,imag(symbin(k))-.15,...
        dec2base(mapbin(k),2,3),'Color',[1 0 0]);
    text(real(symbin(k))-0.2,imag(symbin(k))-.3,...
        num2str(mapbin(k)),'Color',[1 0 0]);
end


c = symbin;
rxSig = awgn(c,10,'measured');
h = scatterplot(rxSig);
hold on
scatterplot(c,[],[],'r*',h)
grid
hold off

