-------------------------------------------------------------------------------
---------------------------------------------------------------------------
----
--
-- File : simple_dds.vhd
-- Entity Name : simple_dds
-- Architecture : structural
-- Author : Omar Mohamed
--
---------------------------------------------------------------------------
----
--
-- Generated : Wed Apr 12 05:12:56 2023
--
---------------------------------------------------------------------------
----
--
-- Description : structural style implementation of analog sine wave from
--	direct-digital synthesis
---------------------------------------------------------------------------
----															 

--------------------------------------------------------------------------
--
-- simple_dds entity declaration and architecture
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity simple_dds is 
	port (
	clk : in std_logic;
	reset_bar : in std_logic;
	dac_sine_value : out std_logic_vector(7 downto 0)
	);
	
	attribute loc : string;
	attribute loc of reset_bar : signal is "A13";
	attribute loc of clk     : signal is "F8";
	attribute loc of dac_sine_value       : signal is "H1,H3,J2,J1,L5,L1,M1,N3";
	
end simple_dds;


architecture structural of simple_dds is 
	signal address : std_logic_vector(6 downto 0);	-- output from quad_address_counter
	signal pos : std_logic; -- input to adder/subtractor
	signal sine_value : std_logic_vector(6 downto 0); -- output from sine table  
begin 
	u0: entity quad_address_counter 
		port map (clk => clk, reset_bar => reset_bar, 
					pos_neg => pos, address => address);
				
	u1: entity sine_table 
		port map(addr => address, sine_val => sine_value);
		
	u2: entity adder_subtracter
		port map (pos => pos, sine_value => sine_value,
					dac_sine_val => dac_sine_value);
		
end structural;	