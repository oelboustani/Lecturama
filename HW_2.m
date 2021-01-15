clear all
close all
clc

Fs = 256e3;
Fc = 100e3; %carrier freq


M = 8;
% data_t = [1 5 2 4 0 7 7 0 7 1 2 4 7 6 0 4 4 3 7 1];
data_t = randi([0 M-1],1e3,1); %symbol rate 1e3

T = 30; 
data_t = kron(data_t, ones(T,1));

phz = 0;
Rbb_t = pskmod(data_t,M,0, 'bin');

Ibb_t = real(Rbb_t); %in-phase
Qbb_t = imag(Rbb_t);

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

% x1_f=fft(data_t,4*length(data_t));  
% x1_f=fftshift(x1_f);
% N_x1=length(x1_f);
% nx_f=[-0.5:1/N_x1:(0.5)-(1/(2*N_x1))]; % frequency index
% 
% figure(4)
% plot(nx_f,pow2db(abs(x1_f)));
% xlim([0 0.5])

% return
IQ_bb = Ibb_t + 1j.*Qbb_t;
% x1_f=fft(X,8*length(X));  
% x1_f=fftshift(x1_f);
% N_x1=length(x1_f);
% nx_f=[-0.5:1/N_x1:(0.5)-(1/(2*N_x1))]; % frequency index

% figure(6)
% plot(nx_f,(abs(x1_f)));

% pwelch(X,[],[],[],Fs,'centered')

figure(7)
% hold on
txfilter = comm.RaisedCosineTransmitFilter;
filteredData = txfilter(data_t);
pwelch(filteredData,[],[],[],Fs,'centered')

t = linspace(0, 1/Fc, length(Qbb_t));
% x = cos(2*pi*t*Fc);
RF_out = real(IQ_bb.*exp(1j*2*pi*Fc.*t));
% figure(8)
% pwelch(RF_out,[],[],[],Fs,'centered')
% 
% 
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




