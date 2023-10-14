--------------------------------------------------------------------------
----
--
-- File : phase_accumulator_tb.vhd
-- Entity Name : testbench
-- Architecture : tb
-- Author : Omar Mohamed
--
--------------------------------------------------------------------------
--
----
--
-- Generated : Mon Apr 24 10:13:42 2023
--
--------------------------------------------------------------------------
--
----
--
-- Description: Non-exhaustive, non-selfchecking testbench for 
	-- phase accumulator
--
--------------------------------------------------------------------------
--
----

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity testbench is 
  	generic(
		a : positive := 14;-- width of phase accumulator
		m : positive := 7 -- width of phase accum output
		);
end testbench;


architecture tb of testbench is 
	-- stimulus signals
	signal clk : std_logic; 
	signal reset_bar : std_logic; 
	signal up : std_logic; 
	signal d : std_logic_vector(a -1 downto 0);  
	-- observed signals
	signal max : std_logic; 
	signal min : std_logic; 
	signal q : std_logic_vector(m - 1 downto 0); 
	
	constant period : time := 1 us;
begin	
	UUT: entity phase_accumulator  
		generic map (a => a, m => m)
		port map(
		clk => clk,
		reset_bar => reset_bar,
		up => up, 
		d => d,
		max => max,
		min => min,
		q => q
		); 
	
	-- adjust d value to change counter frequency
	d <=(0 => '1', others => '0') after 2*period; 
	
	reset_bar <= '0', '1' after 2 * period;	 
	
	up <= '1' when max = '0' else '0';
	
	
	clock: process
	begin
		clk <= '0';
		for i in 0 to 100000 loop
			wait for period;
			clk <= not clk;
		end loop;
		wait;
	end process;
	
end tb;
