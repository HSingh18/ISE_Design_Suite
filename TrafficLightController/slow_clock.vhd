----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:52 11/13/2019 
-- Design Name: 
-- Module Name:    slow_clock - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all; 

entity slow_clock is
  Port( clock, clear : in STD_LOGIC;
        speed : out STD_LOGIC_VECTOR (5 downto 0) );
end slow_clock;

architecture Behavioral of slow_clock is
   signal cnt: STD_LOGIC_VECTOR (30 downto 0);
begin
	process(clock, clear)
	begin
		if clear='1' then cnt(30 downto 25) <= "000000";
	elsif (clock'event and clock='0') then cnt <= cnt + 1;
	end if; 
	end process; 
speed <= cnt(30 downto 25); 

end Behavioral;  

