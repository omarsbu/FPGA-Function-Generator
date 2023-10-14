--------------------------------------------------------------------------
----
--
-- File : phase_accumulator_fsm_tb.vhd
-- Entity Name : phase_accumulator_fsm_tb
-- Architecture : tb
-- Author : Omar Mohamed
--
--------------------------------------------------------------------------
--
----
--
-- Generated : Mon Apr 24 12:48:07 2023
--
--------------------------------------------------------------------------
--
----
--
-- Description: Non-selfchecking testbench for phase accumulator fsm 
--
--------------------------------------------------------------------------
--
----	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity phase_accumulator_fsm_tb is
end phase_accumulator_fsm_tb;

architecture tb of phase_accumulator_fsm_tb is 
	-- stimulus signals
	signal clk : std_logic := '0'; -- system clock
	signal reset_bar : std_logic; -- asynchronous reset
	signal max : std_logic; -- max count
	signal min : std_logic; -- min count  
	-- observed signals
	signal up : std_logic; -- count direction
	signal pos : std_logic; -- positive half of sine cycle
		
	constant period : time := 1 us; 
begin 	  								
	UUT: entity phase_accumulator_fsm 
		port map (
			clk => clk, 
			reset_bar => reset_bar,
			max => max, 
			min => min,
			up => up,
			pos => pos
			);		
			
		reset_bar <= '0', '1' after 4 * period;
		
		-- apply input stimuli every 2 clks so state transitions occur
		stimulus: process
		begin 
			for i in 0 to 3 loop
				wait for 2*period; 
				(min,max) <= not std_logic_vector(to_unsigned(i, 2));
			end loop;
		end process;
			
		clock: process
		begin for i in 0 to 1032 loop
			wait for period; 
			clk <= not clk;
		end loop;
		std.env.finish;
	end process;
end tb;