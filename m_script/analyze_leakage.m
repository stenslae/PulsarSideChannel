% ------------------------------------------------------------
%  Pulsar Obfuscation + Leakage: Signal Analysis
%  Emma Stensland
%  MATLAB/Octave
% ------------------------------------------------------------

function results = analyze_leakage(x, fs, titles)
  results = struct();

    % FFT magnitude (shift dc)
    x = x - mean(x);
    N = length(x);
    hN = floor(N/2);
    Xfull = abs(fft(x));

    % Keep only first half
    X = Xfull(1:hN);
    f = (0:hN-1)/N * fs;

    % Peak detectability
    [fft_peak, idx] = max(X);
    noise_floor = median(X);
    fft_ratio = fft_peak / noise_floor;

    % Autocorrelation
    [r, lags] = xcorr(x, 'normalized');
    r( lags == 0 ) = 0;
    [r_peak, r_idx] = max(r);
    sidelobe = median(abs(r));

    autocorr_ratio = r_peak / sidelobe;

    % PSD
    [Pxx, ff] = pwelch(x, [], [], [], fs);
    psd_ratio = max(Pxx) / median(Pxx);

    % Build contents of structure
    results.fft_ratio = fft_ratio;
    results.autocorr_ratio = autocorr_ratio;
    results.psd_ratio = psd_ratio;
    results.fft_peak_freq = f(idx);
    results.autocorr_peak_time = lags(r_idx)/fs;
end
