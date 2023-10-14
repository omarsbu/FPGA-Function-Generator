-------------------------------------------------------------------------------
---------------------------------------------------------------------------
----
--
-- File : adder_subtracter.vhd
-- Entity Name : adder_subtracter
-- Architecture : behavioral
-- Author : Omar Mohamed
--
---------------------------------------------------------------------------
----
--
-- Generated : Mon Apr 10 02:52:46 2023
--
---------------------------------------------------------------------------
----
--
-- Description : Behavioral style adder/subtractor for DDS design
---------------------------------------------------------------------------
----															 

--------------------------------------------------------------------------
--
-- adder_subtracter entity declaration and architecture
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_subtracter is	
	port (
		pos : in std_logic;-- indicates pos. or neg. half of cycle
		sine_value : in std_logic_vector(6 downto 0);-- from sine table
		dac_sine_val : out std_logic_vector(7 downto 0)-- output to DAC
		);
end adder_subtracter;

architecture behavioral of adder_subtracter is
begin 
	-- 255 = 1; 128 = 0; 0 = -1
	process(pos, sine_value)
		variable x : unsigned (7 downto 0);
	begin	
		x := unsigned ('1' & sine_value);
		if pos = '1' or sine_value = "0000000" then	
			-- add 128 if >= 0
			dac_sine_val <= std_logic_vector(x); 		
		else
			-- invert if < 0
			dac_sine_val <= not std_logic_vector(x); 
		end if;
	end process;
end behavioral;