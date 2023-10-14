library ieee;
use ieee.std_logic_1164.all;

entity frequency_reg is
	generic (a : positive := 14);
	port(
		load : in std_logic; -- enable register to load data
		clk : in std_logic; -- system clock
		reset_bar : in std_logic; -- active low asynchronous reset
		d : in std_logic_vector(a-1 downto 0); -- data input
		q : out std_logic_vector(a-1 downto 0) -- register output
		);
end frequency_reg;		 


architecture behavioral of frequency_reg is
begin
	process(clk, reset_bar)	
		variable reg : std_logic_vector(a-1 downto 0);
	begin 			
		if reset_bar = '0' then
			q <= (others => '0');
			reg := (others => '0');
		elsif rising_edge(clk) then
			if load = '1' then
				reg := d;
			end if;
			q <= reg;
		end if;
	end process;
end behavioral;	