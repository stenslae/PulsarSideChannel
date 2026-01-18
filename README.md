# ⚡ Pulsar Side‑Channels

- **[Full Report](pulsar_report.md)** - Deep dive into the background, methodology, results, and takeaways.

This is a MATLAB/Octave framework for experimenting with signal analysis and side‑channel attacks on simulated pulsar‑like signals. In this case, the side-channel is the simulated pulsar emissions, and the 'target device' is the scrambling algorithm applied to it.

## System Overview

| Feature | Implementation |
|---|---|
| **Platform** | GNU Octave |
| **Languages** | MATLAB / Octave |
| **Signal Analysis Methods** | FFT, Autocorrelation, Power Spectral Density (PSD), Enveloping |
| **Scrambling Algorithm** | Seeded PRNG for Bit flipping, Amplitude shifting, Timing jitter |
| **Attack Method** | Brute‑force seed scoring |

## Basic Usage

- Modify/use the pre-made [driver.m](m_script/driver.m), or use it as below:

```matlab
% noisy_sets: cell array {label, signal}
% fs: sampling frequency
% t: optional time vector for plotting/analysis

results = main_emma(noisy_sets, fs, t);
```

## Acknowledgements

- MATLAB/Octave content and [slideshow](pulsar_slideshow.pdf) was developed for EELE308 at MSU Bozeman. 
