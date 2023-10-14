--------------------------------------------------------------------------
----
--
-- File : quad_address_counter.vhd
-- Entity Name : quad_address_counter
-- Architecture : behavioral
-- Author : Omar Mohamed
--
--------------------------------------------------------------------------
--
----
--
-- Generated : Sun Apr 9 12:35:09 2023
--
--------------------------------------------------------------------------
--
----
--
-- Description: Behavioral style design description of 7 bit address
--	counter for sine table lookup
--
--------------------------------------------------------------------------
--
----

--------------------------------------------------------------------------
--
-- quad_address_counter entity declaration and architecture
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee. numeric_std.all;

entity quad_address_counter is
	port(
		clk : in std_logic; -- system clock, 50% duty cycle assumed
		reset_bar : in std_logic;-- active low asynchronous reset
		pos_neg : out std_logic;-- 1 for first half of cycle, 0 for second half
		address : out std_logic_vector(6 downto 0)-- address to sine table 
		);																   
		
end quad_address_counter;	  

architecture behavioral of quad_address_counter is 
	-- sine wave have four quadrants (0, pi/2, pi, 3pi/2, 2pi)
	signal quadrant : std_logic_vector(1 downto 0); 
begin
--------------------------------------------------------------------------
-- Update address counter on each rising clock edge 
	process(clk, reset_bar)
		variable address_v : unsigned(6 downto 0);
	begin 
		address_v := unsigned(address);						 
		
		if reset_bar = '0' then	
			address <= (others => '0');
			pos_neg <= '1';
			quadrant <= "00";
		else
			if rising_edge(clk) then  		
				-- increment counter if in odd quadrant (1 or 3) 
				if quadrant = "00" or quadrant = "10" then
					address_v := address_v + 1;
				-- decrement counter if in even quadrant (2 or 4) 
				elsif quadrant = "01" or quadrant = "11" then 
					address_v := address_v - 1;
				end if;
				-- update address output
				address <= std_logic_vector(address_v);	  
				
				-- update quadrant signal
				-- address reaches max value at end of 1st and 3rd quadrants 
				if to_integer(address_v) = 127 then
					if quadrant = "00" then 
						quadrant <= "01";	-- 1st quadrant -> 2nd quadrant
					elsif quadrant = "10" then
						quadrant <= "11";	-- 3rd quadrant -> 4th quadrant	
					end if;
				-- address reaches min value at end of 2nd and 4th quadrants
				elsif to_integer(address_v) = 0 then
					if quadrant = "01" then
						quadrant <= "10";	-- 2nd quadrant -> 3rd quadrant
						pos_neg <= '0';	  	-- positive half-cycle -> negative half-cycle
					elsif quadrant = "11" then
						quadrant <= "00";	-- 4th quadrant -> 1st quadrant
						pos_neg <= '1';		-- negative half-cycle -> positive half-cycle
					end if;	
				end if;
			end if;
		end if;
	end process;								
end behavioral;	