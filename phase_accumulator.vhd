-------------------------------------------------------------------------------
---------------------------------------------------------------------------
----
--
-- File : phase_accumulator.vhd
-- Entity Name : phase_accumulator
-- Architecture : behavioral
-- Author : Omar Mohamed
--
---------------------------------------------------------------------------
----
--
-- Generated : Mon May 1 05:42:34 2023
--
---------------------------------------------------------------------------
----
--
-- Description : Behavioral style description for phase accumulator in DDS
--	with frequency select
---------------------------------------------------------------------------
----															 

--------------------------------------------------------------------------
--
-- phase_accumulator entity declaration and architecture
--------------------------------------------------------------------------

library ieee;				
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accumulator is
	generic(
		a : positive := 14;-- width of phase accumulator
		m : positive := 7 -- width of phase accum output
		);
	port(
		clk : in std_logic; -- system clock
		reset_bar : in std_logic; -- asynchronous reset
		up : in std_logic; -- count direction control, 1 => up, 0 => dn
		d : in std_logic_vector(a -1 downto 0); -- count delta
		max : out std_logic; -- count has reached max value
		min : out std_logic; -- count has reached min value
		q : out std_logic_vector(m - 1 downto 0) -- phase acc. output	 
		);
end phase_accumulator;		   

architecture behavioral of phase_accumulator is	
	signal temp : std_logic_vector(a downto 0);	-- stores roll around value for 1 clock
	signal counter_reg : std_logic_vector(a-1 downto 0); 
begin
	process(clk, reset_bar)
		-- unsigned variables
		variable count_var : unsigned(a-1 downto 0);
		-- integer variables
		variable max_count, min_count : integer;
		variable delta : integer;
	begin
		if reset_bar = '0' then 
			q <= (others => '0');				  
			counter_reg <= (others => '0');
			(min, max) <= std_logic_vector'("10");	 
			temp <= (others => '0');
		elsif rising_edge(clk) then	
			-- convert d input to integer
			delta := to_integer(unsigned(d));
			
			-- define limits
			max_count := (2**a)-1-delta;	-- count + delta cannot exceed all 1's
			min_count := delta;		-- count minus delta cannot go below all 0's 
			
			-- counter register	new value
			count_var := unsigned(counter_reg);	-- store register value
			(min, max) <= std_logic_vector'("00");	
			
			if up = '1' then		 	
				if to_integer(count_var) >= max_count then -- check for roll around							
					count_var := (others => '1');	
					
					
					
					if temp(a) = '1' then	
						count_var := count_var - unsigned(d) - unsigned(temp(a-1 downto 0));	
						temp <= (others => '0');
					else	
						count_var := count_var - unsigned(d) - unsigned(counter_reg); 
					end if;
					
					count_var := count_var + to_unsigned((2**a)-1,a-1);
					if temp(a) = '0' then
						temp <= '1' & std_logic_vector(count_var);
						count_var := (others => '1');
					end if;	
					(min, max) <= std_logic_vector'("01");
				else
					count_var := count_var + unsigned(d); 
					temp <= (others => '0');	-- clear roll around register
				end if;	
			else  	
				if to_integer(count_var) <= min_count then	-- check for roll around				 
					count_var := (others => '0');	
					count_var := count_var + unsigned(d); 				
					
					if temp(a) = '1' then
						count_var := count_var - unsigned(temp(a-1 downto 0)); 
						temp <= (others => '0');	-- clear roll around register
					else
						count_var := count_var - unsigned(counter_reg);
					end if;
					
					(min, max) <= std_logic_vector'("10");	
				else 		
					count_var := count_var - unsigned(d);
					temp <= (others => '0');	-- clear roll-around register
				end if;						
			end if;				
			
			-- update counter register and output
			counter_reg <= std_logic_vector(count_var);
			q <= counter_reg(a-1 downto m);
		end if;
	end process;
end behavioral;