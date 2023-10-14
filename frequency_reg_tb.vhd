--------------------------------------------------------------------------
----
--
-- File : frequency_reg_tb.vhd
-- Entity Name : frequency_reg_tb
-- Architecture : tb_architecture
-- Author : Omar Mohamed
--
--------------------------------------------------------------------------
--
----
--
-- Generated : Sun Apr 23 11:35:39 2023
--
--------------------------------------------------------------------------
--
----
--
-- Description: Non-exhaustive and non-selfchecking testbench of 
--		frequency register
--
--------------------------------------------------------------------------
--
----  


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity frequency_reg_tb is
	-- Generic declarations of the tested unit
		generic(
		a : positive := 14;
		m : positive := 7 );
end frequency_reg_tb;

architecture tb_architecture of frequency_reg_tb is

		-- Stimulus signals 	
		signal load : std_logic; -- enable register to load data
		signal clk : std_logic := '0'; -- system clock
		signal reset_bar : std_logic; -- active low asynchronous reset
		signal d : std_logic_vector(a-1 downto 0); -- data input  
		-- Observed signals	
		signal q : std_logic_vector(a-1 downto 0); -- register output	 
		
		constant period : time := 1 us;
begin
	-- Unit Under Test port map
	UUT : entity frequency_reg
		generic map (a => a)
		port map (
			clk => clk,
			reset_bar => reset_bar,
			load => load,
			d => d,
			q => q
		);
		
	stimulus: process	-- system clock
	begin
		for i in 0 to a loop
			wait for period; 
			d <= (others => '0');
			d(i) <= '1';
			wait for period;
			load <= '0';
			wait for period;
			load <= '1';
		end loop;
		std.env.finish;
	end process;	
		
	reset_bar <= '0', '1' after 4 * period;	-- reset signal
	
	clock: process				-- system clock
	begin
		for i in 0 to 1032 loop
			wait for period;
			clk <= not clk;
		end loop;
		std.env.finish;
	end process;
end tb_architecture;