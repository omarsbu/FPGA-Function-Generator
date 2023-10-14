--------------------------------------------------------------------------
----
--
-- File : dds_w_frequency_select.vhd
-- Entity Name : dds_w_frequency_select
-- Architecture : structural 
-- Author : Omar Mohamed
--
--------------------------------------------------------------------------
--
----
--
-- Generated : Tues Apr 25 05:42:14 2023
--
--------------------------------------------------------------------------
--
----
--
-- Description: Sructural style design description of dds with frequency
--	select
--
--------------------------------------------------------------------------
--
----

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity dds_w_freq_select is
	generic (a : positive := 14; m : positive := 7);
	 port(
		 clk : in std_logic;-- system clock
		 reset_bar : in std_logic;-- asynchronous reset
		 freq_val : in std_logic_vector(a - 1 downto 0);-- selects frequency
		 load_freq : in std_logic;-- pulse to load a new frequency selection
		 dac_sine_value : out std_logic_vector(7 downto 0);-- output to DAC
		 pos_sine : out std_logic-- positive half of sine wave cycle
		 );
		
		attribute loc : string;
		attribute loc of clk       : signal is "C13";
		attribute loc of reset_bar : signal is "A13";
		attribute loc of freq_val  : signal is "F8,C12,E10,F9,E8,E7,D7,C5,E6,A10,D9,B6,B5,B4";
		attribute loc of load_freq : signal is "A3";
		attribute loc of dac_sine_value  : signal is " N3,M1,L1,L5,J1,J2,H3,H1";
		attribute loc of pos_sine  : signal is "F5";
end dds_w_freq_select;


architecture structural of dds_w_freq_select is
	signal s1 : std_logic_vector(a-1 downto 0);	-- switches input
	signal s2 : std_logic;	-- edge detector output
	signal s3 : std_logic_vector(a-1 downto 0);	-- frequency register output
	signal s4 : std_logic;	-- phase accumulator fsm 'up' output
	signal s5 : std_logic_vector(1 downto 0);	-- phase accumulator fsm input
	signal s6 : std_logic_vector(m-1 downto 0);	-- sine table input
	signal s7 : std_logic_vector(m-1 downto 0);	-- sine table output
	signal s8: std_logic;	-- phase accumulator fsm 'pos' output 
	signal s9: std_logic_vector(m downto 0);	-- dac sine value output	
begin		 
	s1 <= freq_val;
	
	u1: entity edge_det
		port map(
			rst_bar => reset_bar,
			clk => clk,
			sig => load_freq,
			pos => '1',
			sig_edge => s2);
		
		u2: entity frequency_reg 
		generic map(a => a)
		port map(
			load => s2,
			clk => clk,
			reset_bar => reset_bar, 
			d => s1,
			q => s3);
		
	u3: entity phase_accumulator
		generic map(a => a, m=> m)
		port map(	 
			clk => clk, 
			reset_bar => reset_bar,
			up => s4,
			d => s3,
			max => s5(0),
			min => s5(1),
			q => s6);
		
	u4: entity phase_accumulator_fsm
		port map( 
			clk => clk,
			reset_bar => reset_bar,
			max => s5(0),
			min => s5(1),
			up => s4,
			pos => s8);
		
	u5: entity sine_table
		port map(
			addr => s6,
			sine_val => s7);
	
	u6: entity adder_subtracter
		port map(
			pos => s8, 
			sine_value => s7,
			dac_sine_val => s9);
		
		pos_sine <= s8;
		dac_sine_value <= s9;
end structural;