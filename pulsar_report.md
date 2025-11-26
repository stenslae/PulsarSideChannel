# Side-Channel Pulsar Analysis

## Introduction

### What is a Side-Channel Attack?
  
### Project Goals

- **Pulsar signals** are periodic electromagnetic pulses from rotating neutron stars. This behavior reveals patterns in high noise environments, and can be an effective model in understanding side-channel techniques.
- The primary [objectives](#takeaways) of this project are as follows:
	1. What techniques can detect data leakage in signals?
	2. How does scrambling level and the SNR affect pulsar data leakage?
	3. Can an attacker determine the seed used to obfuscate the signal?

---

## Project Overview

### Signal Scrambling and Descrambling Methods

#### Method

#### Results

---

### Autocorrelation Leakage

#### Method

#### Results

---

### Spectral Fingerprinting

#### Method

#### Results

---

### Envelope Detection

#### Results

### Noise and SNR Effects

---

### Seed Recovery / Brute-Force Attack

#### Goal

- An attack was simulated where an attacker attempts to recover the scrambling seed using **brute force.**
- **The following assumptions were made:**
  - The attacker has access to the obfuscated signal.
  - The attacker knows the potential obfuscation methods being used.

#### Method

1. Before attempting brute forcing, the leakage metrics of the scrambled signal were analyzed. As the envelope of the scrambled signal revealed the most data, it was included into scoring metrics. Additionally, autocorrelation seemed to be heavily weighed, while PSD and FFT had more reasonable metrics and were the most exposed in the enveloped signal. Therefore, the brute forcing was decided to be scored based on the sum of the PSD ratio and FFT ratio, multiplied by the correlation between the envelope of the scrambled signal and the envelope of the descrambled with the test seed.
2. A loop was built to iterate through each possible scrambling level, and each possible seeds.
3. For each iteration, the scrambled signal was descrambled with the provided key. The descrambled signal was normalized to emphasize peaks.
4. The descrambled signal was enveloped. The envelope of this signal had its correlation coefficient compared to the envelope of the scrambled signal. A correlation coefficient closer to 1 meant the envelopes produced similar peaks. This assisted in throwing out descrambling that produced high spectral ratios that was not preserving the original signal's leakage.
5. The descrambled signal's FFT and PSD ratios were calculated to identify the best spectral fingerprints. Descrambled signals with the highest FFT and PSD ratios hinted towards the best reconstruction of the original signal. The FFT ratio was displayed as a logarithm to normalize it.
6. Noise thresholding was implemented. The FFT, PSD, and Envelope median was multiplied by a value, and added to a minimal value, based on typical observed values while iterating through the brute forcing mechanism. If the envelope is a bad value, the FFT and PSD calculations are skipped and the key guess's score is thrown out. If the FFT or PSD was a small value, the key guess's score is thrown out. This resulted in slightly quicker brute forcing, and fewer false positives.

#### Results

```bash
------------------------------------------------------------
                   4096 POSSIBLE SEEDS
------------------------------------------------------------
Attack Summary:
Total Sets Brute Forced        : 15
Range of Seeds Guessed         : 1-4096
Successful Recoveries          : 15 (100.00%)
Average Brute-Force Time       : 143.1173 sec

Accuracy/Error Metrics:
Top 1 Accuracy                      : 100.00%
Top 5 Accuracy                      : 100.00%
Mean Absolute Error (MAE)           : 0.000
Root Mean Square Error (RMSE)       : 0.000

Seed Recovery Success Rate per Scramble Level:
 Weak   : 100.00%
 Medium : 100.00%
 Strong : 100.00%
Seed Recovery Success Rate per Noise Level:
 Clean  : 100.00%
 Low Noise : 100.00%
 Small Noise : 100.00%
 Medium Noise : 100.00%
 High Noise : 100.00%
 ```

---

## Takeaways

### What techniques can detect data leakage in signals?


### How does scrambling level and the SNR affect pulsar data leakage?


### Can an attacker determine the seed used to obfuscate the signal?

### Further Insights
