# Parametric-dispersion-model-for-MMF-transmission
Demo code and data for modeling dispersion in light transport through MMF.

This work is published on [Light:Science and Applications 12, 31, 2023](https://www.nature.com/articles/s41377-022-01061-7#Abs1), entitled: Efficient dispersion modeling in optical multimode fiber. Please cite the paper if you use the code for your own publications.

1. demo_main.m fits and validates the dispersion model of the MMF up to K=2 order (Figure 2 in results). The optimization ran in ~8 min.
2. demo_PM.m computes the spectral-variant principal modes (PMs) using a previously fitted dispersion model (Figure 3 in results).
3. demo_fast_construction.m shows the procedures and results for speed-driven multispectral calibration (Figure 4 in results).
4. demo_UQ_data.m applies the dispersion model on a publicly available [dataset](https://espace.library.uq.edu.au/view/UQ:405939) from [this reference](https://doi.org/10.1364/OL.41.005580) (Figure S9 in Supplementary Materials). The optimization ran in ~15 min.
5. The tool functions folder contains essential functions for demo codes. 
6. The data folder contains essential experimental data for demo. Data were collected with a 1m-long 50um-core 0.22NA step-index MMF operated within 1510 - 1630 nm. See additional description of the experiments in Methods.
7. Demo codes were tested on a Windows computer with Intel Core i7-8550U and 32 GB RAM running MATLAB R2020a.
