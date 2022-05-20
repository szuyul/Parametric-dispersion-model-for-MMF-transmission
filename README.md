# Parametric-dispersion-model-for-MMF-transmission
Demo code and data for modeling dispersion in light transport through MMF

This is a 1m-long 50um-core 0.22NA step-index MMF operated within 1510 - 1630 nm.

dataset (~200 MB):
https://www.dropbox.com/sh/ac3hjfhg4g614vc/AAC8Wf43KcMpDBnUpoLb1Afga?dl=0

1. demo_main.m fits and validates the dispersion model of the MMF up to K=2 order. Ran in ~2 min in the test computer.
2. demo_PM.m computes the spectral-variant principal modes (PMs) using a fitted dispersion model. Ran in ~1 min in the test computer.
3. demo_fast_construction.m shows the procedures and results for speed-driven multispectral calibration. Ran in 5 seconds in the test computer.
4. demo_UQ_data.m applies the dispersion model on another public dataset from the University of Queensland. Ran in ~1 min in the test computer.
5. The tool functions folder contains essential functions for demo codes. 
6. Codes were tested on a Windows computer with Intel Core i7-9750H and 32 GB RAM running MATLAB R2020a.
