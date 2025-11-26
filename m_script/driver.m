% ==== TEST PULSAR ====
fs = 1000;                 % sampling rate
t = 0:1/fs:5;              % 5 seconds
x = zeros(size(t));        % init

pulse_width = 10; % samples
for idx = round(0.7*fs:0.7*fs:length(t))
    x(idx:idx+pulse_width-1) = 1;
end

% light noise
x_noise = x + 0.1*randn(size(x));

% noise
x_noisy = x + 0.5*randn(size(x));
x_noisyy = x + 1*randn(size(x));

% ==== TEST PULSAR ====


noisy_sets = {
    'Clean', x;
    'Small Noise', x_noise;
    'Medium Noise',x_noisy;
    'Large Noise',x_noisyy
};

results = struct();

% THEN, CALL THIS FUNCTION
results = main_emma(noisy_sets, fs, t);
