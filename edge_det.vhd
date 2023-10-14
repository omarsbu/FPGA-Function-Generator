library ieee;
use ieee.std_logic_1164.all;

entity edge_det is
	port(
		rst_bar : in std_logic; -- asynchronous system reset
		clk : in std_logic; -- system clock
		sig : in std_logic; -- input signal
		pos : in std_logic; -- '1' for positive edge, '0' for negative
		sig_edge : out std_logic -- high for one sys. clk after edge
		);
end edge_det;

architecture moore_fsm of edge_det is 
	type state is (state_a, state_b, state_c);
	signal present_state, next_state : state;
begin 
	state_reg: process(clk, rst_bar)
	begin
		if rst_bar = '0' then
			present_state <= state_a;
		elsif rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process;
		
	outputs: process (present_state)
	begin
		case present_state is
			when state_c => sig_edge <= '1';
			when others => sig_edge <= '0';
		end case; 	
	end process;

	nxt_state: process (present_state, sig, pos)
	begin
		case present_state is
			when state_a =>
			if sig = not pos then
				next_state <= state_b;
			else
				next_state <= state_a;
			end if;
			
			when state_b =>
			if sig = pos then
				next_state <= state_c;
			else
				next_state <= state_b;
			end if;
			
			when others =>
			if sig = not pos then
				next_state <= state_b;
			else
				next_state <= state_a;
			end if;
		end case;
	end process;
end moore_fsm;