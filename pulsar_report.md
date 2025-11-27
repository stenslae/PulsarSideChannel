# Side-Channel Pulsar Analysis

## Introduction

### What is a Side-Channel Attack?

- 
  
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
  - The attacker has full access to the obfuscated signal.
  - The attacker knows the scrambling/bfuscation methods being used.

#### Method

1.**Leakage Pre-Analysis:** 
    - Evaluated leakage metrics on the scrambled signal.
    - The envelope contained the most preserved structure, so envelope correlation became a key scoring component.
    - FFT and PSD ratios were selected as the main spectral fingerprints.
    - Final scoring strategy was defined as: `score = (PSD ratio + log‑scaled FFT ratio) × envelope correlation coefficient`
2. **Loop Design:**
    - Nested exhaustively searches `scrambling levels` × `candidate seeds.`
3. **Seed Trials:**
    - The scrambled signal was descrambled with the guessed seed. 
    - Output was normalized.
4. **Envelope Matching:**
    - The envelope of the descrambled signal had its correlation coefficient compared to the envelope of the scrambled signal.
    - A value close to `1.0` indicated similar peak structure and helped reject high spectral ratios that were not preserving the original signal's leakage.
5. **Spectral Ratio Scoring:** 
    - Computed the `FFT Ratio` and `PSD Ratio`.
    - FFT Ratio was scaled loarithmically to normalize it.
    - Descrambled signals with the highest FFT and PSD ratios hinted towards the best reconstruction of the original signal.
6. **Noise Thresholding:** 
    - Applied fast Pre-Filters:
	    - The FFT, PSD, Envelope median were multiplied by a constant for scaling across noises
		- If the envelope, FFT, or PSD values were outside observed sane ranges, seed was skipped or rejected.
	- This reduced false positives by ensuring sure a seed scored well across all tests, and slightly improved runtime.

#### Results

Multiple batches of small sets of seeds (2^12 to 2^16 possible seeds) were tested. The scoring function showed a **consistent bias toward the correct seed** across noise and scrambling changes. Even when collisions occurred (different seed, similar decoded output), **the true seed always appeared in the Top‑5 candidates.**

An interesting note is that before implementing noise thresholding, Top‑1 & Top‑5 accuracy hovered around 50–75%, especially failing under high noise. After thresholding, Top‑5 accuracy reached 100%, showing that **thresholding corrected mis‑weighted spectral scores inflated by noise.**

Additionally, the speed of the brute force mechanism is slow. Some potential improvements would be improving speed by using MATLAB instead of Octave, as a lot of the brute force tasks could be parallelized, and MATLAB's parallelization performance is better. Using `parfor` for the brute force loops would greatly reduce runtime. 

##### Test 1 Results: 4096 Possible Seeds on the Same Signal of Varying Noise

```bash
------------------------------------------------------------
                   4096 POSSIBLE SEEDS
------------------------------------------------------------
Attack Summary:
Total Sets Brute Forced        : 15
Range of Seeds Guessed         : 1-4096
Successful Recoveries          : 15 (100.00%)
Average Brute-Force Time       : 143.1173 sec

Accuracy Metrics:
Top 1 Accuracy                      : 100.00%
Top 5 Accuracy                      : 100.00%

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

##### Test 2 Results: 65,536 Possible Seeds on the Same Signal of Varying Noise



##### Test 3 Results: 4096 Possible Seeds on the Varying Pulsar Signals with Low Noise



##### Test 4 Results: 4096 Possible Seeds on the Varying Pulsar Signals with Medium Noise



---

## Takeaways

### What techniques can detect data leakage in signals?



### How does scrambling level and the SNR affect pulsar data leakage?



### Can an attacker determine the seed used to obfuscate the signal?

When the seed space is small, an attacker could often recover the correct seed as the most likely (Top-1) candidate, regardless of the noise and scrambling levels. In some cases, a different seed generated a very similar descrambled output, which lowered Top-1 Accuracy. However, the system still achieved 100% Top‑5 accuracy, meaning the true seed consistently appeared among the five closest matches. With only 5 possible seeds, an attacker could do further analysis using other datasets to conclusively identify the seed.

For a single threaded process, brute forcing 2^16 seeds required approximately 40 minutes. **A more cryptographically significant number, such as 2^128 seeds, would take about 0.4 nonillion years to brute force!** Even if this system was parallelized, that would still be an **computationally infeasible** scale. At this magnitude, the amount of false-positive seed collisions also increases, raising the possiblity that the Top-5 candidates may not include the correct seed. 

In modern cryptography, this same principle is mirrored: **Sufficiently large key sizes make it computationally infeasible to determine the encryption key through brute‑force, even when the attacker has access to the encrypted data.** Once the number of possible keys becomes extremely large, key recovery by exhaustive search is no longer a practical attack vector.
