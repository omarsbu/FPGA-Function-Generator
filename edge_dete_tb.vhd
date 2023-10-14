--------------------------------------------------------------------------
----
--
-- File : edge_det_tb.vhd
-- Entity Name : testbench
-- Architecture : tb
-- Author : Omar Mohamed
--
--------------------------------------------------------------------------
--
----
--
-- Generated : Sun Apr 23 07:35:39 2023
--
--------------------------------------------------------------------------
--
----
--
-- Description: tetbench for edge detector
--
--------------------------------------------------------------------------
--
----


library ieee;
use ieee. std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity testbench is 
end testbench;

architecture tb of testbench is
	-- stimulus signals 
	signal clk : std_logic := '0';
	signal rst_bar : std_logic;
	signal sig : std_logic; 
	signal pos : std_logic;   
	-- observed signals
	signal sig_edge : std_logic;    
	
	constant period : time := 1 us;
begin 								
	UUT: entity edge_det
		port map (
		clk => clk,
		rst_bar => rst_bar,
		sig => sig,
		pos => pos,
		sig_edge => sig_edge
		);
		
	rst_bar <= '0', '1' after 4 * period;
	pos <= '1', '0' after 30 * period;
	
	stimulus: process
	begin
		sig <= '0';
		wait for 10 * period;
		-- positive edge 1
		sig <= '1';
		wait for 10 * period;
		-- negative edge 1
		sig <= '0';
		wait for 10 * period; 
		-- positive edge 2
		sig <= '1';
		wait for 10 * period;
		-- negative edge 2
		sig <= '0';	 
	end process;
	
	clock: process	-- system clock
		begin
			for i in 0 to 1032 loop
				wait for period;
				clk <= not clk;
			end loop; 
			std.env.finish;
		end process;
end tb;