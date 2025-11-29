% ------------------------------------------------------------
%  Pulsar Obfuscation + Leakage: Main
%  Emma Stensland
%  MATLAB/Octave
% ------------------------------------------------------------

function results = main_emma(noisy_sets, fs, t)
    results = struct();

    %  Three scramble strengths for all SNR: weak, medium, strong
    scr_level = {'Weak','Medium','Strong'};

    % Generate random seed from 1 to 2^16
    max_seed = 4096;
    seed = randi(max_seed);

    iteration = 0;

    for si = 1:length(scr_level)
        level = scr_level{si};

        for ni = 1:length(noisy_sets(:,1))
           iteration = iteration + 1;
            label = noisy_sets{ni,1};
            x = noisy_sets{ni,2};

            % ==== SCRAMBLE SIGNAL ====
            x_scr = scramble_signal(x, fs, seed, level);

            % ==== DETERMINING SCRAMBLED SIGNAL PATTERNS ====
            % Analyze raw to quantify sucess
            titles_raw = sprintf('Raw Signal, %s SNR',label);
            raw_metrics = analyze_leakage(x, fs, titles_raw);

            % Autocorrelation Leakage and Spectral Fingerprinting
            titles_scr = sprintf('Leakage and Fingerprinting, %s SNR & %s Scrambling',label,level);
            scr_metrics = analyze_leakage(x_scr, fs, titles_scr);

            % Pulse Repetition Detection
            env = abs(hilbert(x_scr));
            % Autocorrelation Leakage and Spectral Fingerprinting on Enveloped Pulse
            titles_env = sprintf('Enveloped, %s SNR & %s Scrambling',label,level);
            env_metrics = analyze_leakage(env, fs, titles_env);

            % Store Results
            results(iteration).label = label;
            results(iteration).level = level;
            results(iteration).raw   = raw_metrics;
            results(iteration).scr   = scr_metrics;
            results(iteration).env   = env_metrics;
            results(iteration).raw_sig   = x;
            results(iteration).scr_sig  = x_scr;
            results(iteration).env_sig  = env;

            % ==== EXPOSING SEED USED TO OBFUSCATE SIGNAL ====
            tic
            all_score = -Inf(1, max_seed);
            for test_seed = 1:max_seed
                   for si = 1:length(scr_level)
                        test_level = scr_level{si};
                        % Try descrambling with seed and guessed level
                        y = descramble_signal(x_scr, fs, test_seed, 'Weak');

                        % Normalize signal
                        y = y / std(y);

                        % Envelope y to prevent false positives
                        y_env = abs(hilbert(y));
                        env_score = corr(y_env(:), env(:));
                        env_threshold = 0.5 * median(env) / max(1e-6, mean(env));

                        % Skip if bad env
                        if env_score < env_threshold
                            continue
                        end

                        % FFT Score
                        Y = abs(fft(y));
                        N = length(Y);
                        Y = Y(1:floor(N/2));
                        fft_noise = median(Y);
                        fft_score = 10*log10(max(Y)/fft_noise);

                        % PSD Score
                        [Pxx, ff] = pwelch(y, [], [], [], fs);
                        psd_noise = median(Pxx);
                        psd_score = 10*log10(max(Pxx) / psd_noise);

                        % Skip if bad fft/psd score
                        if fft_score < 10*log10(1.2) || psd_score < 10*log10(1.2)
                            continue
                        end

                        % Combined score
                        combined_score = (fft_score + psd_score) * env_score;

                        all_score(test_seed) = combined_score;
                  end
             end

             % Scort Scores to get top 5
              [sorted, idx] = sort(all_score, "descend");
              % Throw bad seeds
              best_seed = idx(1);
              second = idx(2);
              top5 = idx(1:5);
              m = sorted(1) - sorted(2);

            % Store Results
            results(iteration).seed_max = max_seed;
            results(iteration).seed_time = toc;
            results(iteration).seed_true  = seed;
            results(iteration).seed_guess = best_seed;
            results(iteration).seed_top5  = top5;
            results(iteration).seed_margin = m;
            results(iteration).seed_error = best_seed - seed;

             printf("Brute forcing done for SNR: %s and Scrambling: %s... Guess: %d Actual: %d, Time: %d\n", label,level,best_seed,seed, results(iteration).seed_time);

            % ==== DESCRAMBLE SIGNAL ====
            fieldname = sprintf('snr_%s_scramble_%s', label, level);
            results(iteration).descrambled = descramble_signal(x_scr, fs, seed,level);

        end
    end

    % Compare results across scrambling metrics
    attack_results(results, noisy_sets, t);
end

