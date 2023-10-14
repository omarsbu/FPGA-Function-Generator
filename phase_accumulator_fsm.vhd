-------------------------------------------------------------------------------
---------------------------------------------------------------------------
----
--
-- File : phase_accumulator_fsm.vhd
-- Entity Name : phase_accumulator_fsm
-- Architecture : moore_fsm
-- Author : Omar Mohamed
--
---------------------------------------------------------------------------
----
--
-- Generated : Mon May 1 03:17:06 2023
--
---------------------------------------------------------------------------
----
--
-- Description : Moore finite state machine for phase accumulator in DDS
--	with frequency select 
---------------------------------------------------------------------------
----															 

--------------------------------------------------------------------------
--
-- phase_accumulator_fsm entity declaration and architecture
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accumulator_fsm is
	port(
		clk : in std_logic; -- system clock
		reset_bar : in std_logic; -- asynchronous reset
		max : in std_logic; -- max count
		min : in std_logic; -- min count	
		up : out std_logic; -- count direction
		pos : out std_logic -- positive half of sine cycle
		);
end phase_accumulator_fsm;

architecture moore_fsm of phase_accumulator_fsm is 
	type state is (state_a, state_b, state_c, state_d);
	signal present_state , next_state : state;
begin 
	state_reg: process(clk, reset_bar)
	begin
		if reset_bar = '0' then 
			present_state <= state_a;
		elsif rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process;	
	
	outputs: process(present_state)
	begin
		case present_state is 
			when state_a => (up, pos) <= std_logic_vector'("11");
			when state_b => (up, pos) <= std_logic_vector'("01");
			when state_c => (up, pos) <= std_logic_vector'("10"); 
			when state_d => (up, pos) <= std_logic_vector'("00");
		end case;
	end process;
	
	nxt_state: process(present_state, min, max)
	begin
		case present_state is
			when state_a =>
			if std_logic_vector'(min, max) = "01" then
				next_state <= state_b;
			else
				next_state <= state_a;
			end if;			  

			when state_b =>              
			if std_logic_vector'(min, max) = "10" then    	
				next_state <= state_c;   
			else                         
				next_state <= state_b;                        
			end if;                      	
	
			when state_c =>              	
			if std_logic_vector'(min, max) = "01" then    	
				next_state <= state_d;   	
			else                         	
				next_state <= state_c;   	
			end if;    
			
			when state_d =>            			
			if std_logic_vector'(min, max) = "10" then  			
				next_state <= state_a;
			else                       
				next_state <= state_d; 
			end if;            
		end case;
	end process;
end moore_fsm;	