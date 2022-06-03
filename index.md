---
title: Notes
---

- [`alloinit`](alloinit.md): One-step `allotemplate` initializer.

- [`kelon`](https://github.com/allolib-s22/lab02-ethwu/tree/marimba) reusable marimba/xyloophone synthesizer.
  - Resources for mallet percussion synthesis:
    - https://orchestrationonline.com/orchestration-tip-harmonic-spectra-of-xylophone-vs-marimba/
    - https://digital.library.unt.edu/ark:/67531/metadc1248483/m2/1/high_res_d/DAVIS-DISSERTATION-2018.pdf
    - http://www.lafavre.us/tuning-marimba.htm
  - `kelon` is an additive synthesizer for marimba and xylophone. It simulates the effect of hard and soft mallets by including parameters to adjust the volume of the overtones in the mix. It also mimics the tuning of real marimbas which do not tune the second overtone at higher pitches (due to the physical impossibility of tuning such a small bar). It has separate marimba and xylophone modes, which use different harmonics for the overtones and different balances for each overtone. The ring time of each note is scaled according to its pitch, using a formula derived from data about a real marimba. Notes can not be held, since marimbas and xylophones cannot sustain or control the mute time besides by hand damping (which is unusual). It includes an original visualizer that illustrates the fundamental and overtones of each note, coloring notes with the same pitch classes with the same hue and coloring higher notes with decreasing saturation.

    Each component of the synthesizer is modularized, with the base additive synthesizer class separate from the visualizer class and the derivative visualized additive marimba and visualized additive xylophone classes. The project is divided into a library and an executable; the library is all that is needed to run the synthesizer in a different project. The executable simply takes input from a keyboard or MIDI controller and renders the output of the library.


