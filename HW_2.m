clc
clear all
close all

Fs = 80e6;
Fc = 10e6; %carrier freq
Fs = 1e6;   % Fs =  1 MHz
Fc = 10*Fs; % Fc = 10 MHz

M = 8;
% data_t = [1 5 2 4 0 7 7 0 7 1 2 4 7 6 0 4 4 3 7 1];
data_t = randi([0 M-1],1e3,1); %symbol rate 1e3
% data_t = randi([0 M-1],10e3,1); %symbol rate 1e3

T = 30; 
data_t = kron(data_t, ones(T,1));

phz = 0;
Rbb_t = pskmod(data_t,M,0, 'bin');

Ibb_t = real(Rbb_t); %in-phase
Qbb_t = imag(Rbb_t);

scatterplot(Rbb_t)
% return
% figure(1)
% plot(data_t)
% title('data')
% xlabel('t')
% ylabel('Amplitude')
% figure(2)
% plot(Ibb_t)
% title('In- Phase')
% xlabel('t')
% ylabel('Amplitude')
% figure(3)
% plot(Qbb_t)
% title('Quadrature')
% xlabel('t')
% ylabel('Amplitude')
% 
% figure(4)
% scatterplot(Rbb_t,[],[],'b*')
% title('Constellation diagram')
% axis([-2 2 -2 2])
% 


close all
figure(5)
pwelch(data_t,[],[],[],Fs,'centered')




% hold on

txfilter = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', 1);
filteredData_I = txfilter(Ibb_t);
filteredData_Q = txfilter(Qbb_t);
IQ_bb = filteredData_I + 1j.*filteredData_Q;

scatterplot(IQ_bb)

figure(7)
pwelch(IQ_bb,[],[],[],Fs,'centered')

% return
t = linspace(0, 1/Fc, length(IQ_bb))';
n = 0:length(t)-1;
n = n';
RF_out = real(IQ_bb.*exp(1j*2*pi*Fc/Fs.*n));
figure(8)
pwelch(RF_out,[],[],[],Fs, 'centered')
figure(9)
pwelch(filteredData_I,[],[],[],Fs, 'centered')
figure(10)
pwelch(filteredData_I,[],[],[],Fs, 'centered')


% 
%-------------------------------------------------------------------------
%receiver
%-------------------------------------------------------------------------
I_down = 2*RF_out.*cos(2*pi*Fc/Fs.*n);
Q_down = -2*RF_out.*sin(2*pi*Fc/Fs.*n);
% BW = 0.334e6;
BW = 10e6;
% return

figure(11)
disp('Figure 11 - downconversion')
subplot(211)
pwelch(I_down,[],[],[],Fs, 'centered')
title('In-phase power spectrum')
subplot(212)
pwelch(Q_down,[],[],[],Fs, 'centered')
title('Quadrature power spectrum')

I_down_filtered = lowpass(I_down,BW,2*Fs,'ImpulseResponse','iir','Steepness',0.95);
Q_down_filtered = lowpass(Q_down,BW,2*Fs,'ImpulseResponse','iir','Steepness',0.95);

figure(12)
subplot(211)
pwelch(I_down_filtered,[],[],[],Fs, 'centered')
subplot(212)
pwelch(I_down_filtered,[],[],[],Fs, 'centered')


I_down_filtered = txfilter(I_down_filtered);
Q_down_filtered = txfilter(Q_down_filtered);

figure(13)
subplot(211)
pwelch(I_down_filtered,[],[],[],Fs, 'centered')
subplot(212)
pwelch(Q_down_filtered,[],[],[],Fs, 'centered')


Rbb_r = I_down_filtered + 1j*Q_down_filtered;
scatterplot(Rbb_r)
evm = comm.EVM('MaximumEVMOutputPort',true,...
    'XPercentileEVMOutputPort',true, 'XPercentileValue',90,...
    'SymbolCountOutputPort',true);


[rmsEVM,maxEVM,pctEVM,numSym] = evm(Rbb_t,Rbb_r);


% x1_f=fft(y);  
% x1_f=fftshift(x1_f, 1024);
% N_x1=length(x1_f);
% nx_f=[-0.5:1/N_x1:(0.5)-(1/(2*N_x1))]; % frequency index
% 
% figure(9)
% plot(nx_f,(abs(x1_f)));
% % xlim([0 0.5])
% 




% data = (0:M-1);
% symgray = pskmod(data,M,phz,'gray');
% mapgray = pskdemod(symgray,M,phz,'gray');
% symbin = pskmod(data,M,phz,'bin');
% mapbin = pskdemod(symbin,M,phz,'bin');
% 
% scatterplot(symgray,1,0,'b*');
% title('Binary coded constellation diagram')
% for k = 1:M
%     text(real(symbin(k))-0.2,imag(symbin(k))-.15,...
%         dec2base(int32(mapbin(k)),2,3));
%     text(real(symbin(k))-0.2,imag(symbin(k))-.3,...
%         num2str(mapbin(k)));
% end
% axis([-2 2 -2 2])
% 
% scatterplot(symgray,1,0,'b*');
% title('Gray coded constellation diagram')
% for k = 1:M
%     text(real(symgray(k))-0.2,imag(symgray(k))+.15,...
%         dec2base(int32(mapgray(k)),2,3));
%      text(real(symgray(k))-0.2,imag(symgray(k))+.3,...
%          num2str(mapgray(k)));
% end
% axis([-2 2 -2 2])
% 




