library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity simple_dds_tb is
end simple_dds_tb;


architecture tb_architecture of simple_dds_tb is
	signal clk : std_logic := '0';
	signal reset_bar : std_logic;
	signal dac_sine_value : std_logic_vector(7 downto 0);
	constant period : time := 1000 ns;
begin 
	uut: entity simple_dds
	port map (
		clk => clk,
		reset_bar => reset_bar,
		dac_sine_value => dac_sine_value
		);	   
		
	reset_bar <= '0', '1' after 4 * period;
	
	clock: process
	begin
		for i in 0 to 1000000000 loop
			wait for period;
			clk <= not clk;
		end loop;
		wait;
	end process;
	end tb_architecture;
	