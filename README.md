# FPGA-Function-Generator

- Developed an SPI controlled Direct-Digital-Synthesis (DDS) signal generator with 22 bits of frequency
resolution by programming a Lattice FPGA in VHDL and interfacing it with a DAC and low-pass filter.

- Created an 8 bit fixed frequency sine wave lookup table. The symmetry of a sine wave is exploited by
storing 90 degrees of a cycle. Variable frequency is generated through a phase accumulator register that
indexes the lookup table with a flexible sample frequency. Implemented circular addressing of the lookup
table to eliminate distortion at higher frequencies. Enabled precise control of the output frequencies via an
SPI interface with a microcontroller.

- The digital output from the FPGA is fed into a DAC to generate a zero-order hold of the desired waveform.
Integrated an active lowpass filter at the output with a cutoff frequency of half the system clock removes the
discontinuities.

![image](https://github.com/user-attachments/assets/d579680d-fca0-469b-816b-a1b912394704)
