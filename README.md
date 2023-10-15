# FPGA-Function-Generator

FPGA based Function Generator

SPI controlled Direct-Digital-Synthesis (DDS) function generator with 22 bits of frequency resolution. Program for a Lattice FPGA in VHDL to be interfaced with a DAC and low-pass filter.
8 bit fixed frequency sine wave lookup table. The symmetry of a sine wave is exploited by storing 90 degrees of a cycle. Variable frequency is generated through a phase accumulator register 
that indexes the lookup table with a flexible sample frequency. Circular addressing of the lookup table is used to eliminate distortion at higher frequencies. The digital output from the FPGA 
is fed into a DAC to generate a zero-order hold of the desired waveform. An active lowpass filter at the output with a cutoff frequency of half the system clock removes the discontinuities. 
