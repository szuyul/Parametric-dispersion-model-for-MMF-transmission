# Parametric-dispersion-model-for-MMF-transmission
Demo code and data for modeling dispersion in light transport through MMF

This is a 1m-long 50um-core 0.22NA step-index MMF operated within 1510 - 1630 nm.


1. demo_main.m fits and validates the dispersion model of the MMF up to K=2 order. The optimization ran in ~8 min.
2. demo_PM.m computes the spectral-variant principal modes (PMs) using a fitted dispersion model.
3. demo_fast_construction.m shows the procedures and results for speed-driven multispectral calibration.
4. demo_UQ_data.m applies the dispersion model on another public dataset from [the University of Queensland](https://espace.library.uq.edu.au/view/UQ:405939). The optimization ran in ~15 min.
5. The tool functions folder contains essential functions for demo codes. 
6. The data folder contains essential experimental data for demo.
7. Codes were tested on a Windows computer with Intel Core i7-9750H and 32 GB RAM running MATLAB R2020a.
