clear all; close all; clc;
%% Separation of Two Convolute Blended Signals with noise effect
Fs = 100;
Ts = 1/Fs;% sampling rate
t = 0:Ts:1;% sampling range
f1 = 4;
f2 = 8;
x1 = 5*cos(2*pi*f1*t);% sample signal
x2 = 5*cos(2*pi*f2*t);
x = conv(x1,x2);
nx = 0:length(x)-1;
subplot(3,4,1)
plot(t,x1)
title('x1 signal');
subplot(3,4,5)
plot(t,x2)
title('x2 signal');
subplot(3,4,9)
plot(nx,x)
title('convolution sum of two signals without noise');

%deconvolution without noise
[x1n, r] = deconv(x,x2);
subplot(3,4,2)
plot(t,x1n)
title('x1 without noise after deconvolution');
[x2n, r] = deconv(x,x1);
subplot(3,4,6)
plot(t,x2n)
title('x2 without noise after deconvolution');

% adding noise to mix signal
x1g = x1 + rand(1,length(x1));% random noise % samples with noise
x2g = x2 + rand(1,length(x2));
xg = conv(x1g,x2g);
nxg = 0:length(xg)-1;
subplot(3,4,10)
plot(nxg,xg);
title('convolution sum of two signals with noise');

%deconvolution with noise
[x1ng,~] = deconv(xg,x2g);
subplot(3,4,3)
plot(t,x1ng);
title('x1 with noise after deconvolution');
[x2ng,r] = deconv(xg,x1g);
subplot(3,4,7)
plot(t,x2ng);
title('x2 with noise after deconvolution');

%fft 
%With the Fourier Transform we can visualize what characterizes this signal the most.
%From the Fourier transform we compute the amplitude spectrum:
Y1 = fft(x1);
Y2 = fft(x2);% compute Fourier transform
eY1 = fft(x1ng); % Fourier transform of noisy signal
eY2 = fft(x2ng);
n1 = size(x1ng,2)/2;% use size for scaling
n2 = size(x2ng,2)/2;
amp_spec1 = abs(eY1)/n1; % compute amplitude spectrum
amp_spec2 = abs(eY2)/n2;

subplot(3,4,11); % second of two plots
freq = (0:79)/(2*n1*Ts); % abscissa viewing window
plot(freq,amp_spec1(1:80)); grid on % plot amplitude spectrum
title('Frequency domain for x1');
xlabel('Frequency (Hz)'); % 1 Herz = number of cycles per second
ylabel('Amplitude'); % amplitude as function of frequency

subplot(3,4,12); % second of two plots
freq = (0:79)/(2*n2*Ts); % abscissa viewing window
plot(freq,amp_spec2(1:80)); grid on % plot amplitude spectrum
title('Frequency domain for x2');
xlabel('Frequency (Hz)'); % 1 Herz = number of cycles per second
ylabel('Amplitude'); % amplitude as function of frequency
% On the flrst plot we recognize the shape of the signal. In the plot of the amplitude spectrum,
% the peaks and their heights are the same as on the plot of the amplitude spectrum of the original 
% signal.  The wobbles we see around the peaks show that the amplitude of the noise is less than that
% of the original signal. Via the inverse Fourier transform, we fllter out the noise. The command flx rounds the elements of 
% its argument to the nearest integers towards zero. For this example, we use flx to set all elements in
% eY less than 100 to zero:
fY1 = fix(eY1/100)*100;% set numbers < 100 to zero
fY2 = fix(eY2/100)*100;
ifY1 = ifft(fY1);% inverse Fourier transform of fixed data
ifY2 = ifft(fY2);
cy1 = real(ifY1);% remove imaginary parts
cy2 = real(ifY2);
%The vector cy contains the corrected samples. So, 
%flnally we plot this corrected signal:
subplot(3,4,4)
plot(t,cy1);% plot corrected signal
title('x1 after remove noise');
subplot(3,4,8)
plot(t,cy2);
title('x2 after remove noise');
%Here we flltered out noise of low amplitude. Note we can also remove noise of high frequency.