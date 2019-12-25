library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_machine is
    Port ( clock, reset, sensor, long, short, HLSensor, PLSensor : in std_logic;
              HL1, HL0, FL1, FL0, HLL1, HLL0, PL0, PL1, clear : out std_logic );
end state_machine;

architecture Behavioral of state_machine is
   type state_type is (hwygreen0, hwygreen1, hwyyellow0, hwyyellow1, hwyred0, hwyred1, farmgreen0, farmgreen1, farmyellow0, farmyellow1, farmred0, farmred1, hwyLgreen0, hwyLgreen1, hwyLyellow0, hwyLyellow1, hwyLred0, hwyLred1);
   attribute enum_encoding: string; 
   attribute enum_encoding of state_type: type is "000000000000000001 000000000000000010 000000000000000100 000000000000001000 000000000000010000 000000000000100000 000000000001000000 000000000010000000 000000000100000000 000000001000000000 000000010000000000 000000100000000000 000001000000000000 000010000000000000 000100000001000000 00100000000000000 01000000000000000 10000000000000000";
   signal CS, NS: state_type;

begin
   process (clock, reset) 
   begin
       if (reset='1') then 
	      CS <= hwygreen0; 
       elsif rising_edge(clock) then
	      CS <= NS; 
       end if;
   end process; 

   process (reset, sensor, long, short, HLSensor, PLSensor)
   begin
      case CS is 
	when hwygreen0 =>
	    HL1 <= '0'; HL0 <= '0'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1'; 
	    clear <= '1';
	    if (reset='0' and (sensor='1' or PLSensor='1')) then 
	        NS <= hwygreen1; 
	    else
	        NS <= hwygreen0; 
         end if; 

	when hwygreen1 =>
	    HL1 <= '0'; HL0 <= '0'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '0';
	    if (reset='0' and sensor='1' and long='1' ) then 
	        NS <= hwyyellow0; 
	    else
	        NS <= hwygreen1; 
         end if; 

	when hwyyellow0 =>
	    HL1 <= '0'; HL0 <= '0'; 
	    FL1 <= '0'; FL0 <= '1';
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1'; 
	    if (reset='0' and sensor='1') then 
	        NS <= hwyyellow1;
	    else
	        NS <= hwygreen0;
         end if; 

	when hwyyellow1 =>
	    HL1 <= '1'; HL0 <= '0'; 
	    FL1 <= '0'; FL0 <= '1';
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '0'; 
	    if (reset='0' and short='1') then 
	        NS <= hwyred0;
	    else
	        NS <= hwyyellow1;
         end if; 
			
	when hwyred0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1';
	    if (reset='0') then 
	        NS <= hwyred1; 
	    else
	        NS <= hwygreen0; 
         end if; 			

	when hwyred1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '0';
	    if (reset='0' and short='1') then 
	        NS <= farmgreen0; 
	    else
	        NS <= hwyred1; 
         end if; 
			
	when farmgreen0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '0'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 if (PLSensor='1')then
			PL1 <= '0'; PL0 <= '0';
			else 
				PL1 <= '0'; PL0 <= '1';
				end if;
	    clear <= '1'; 
	    if (reset='0') then 
	        NS <= farmgreen1; 
	    else 
	        NS <= hwygreen0; 
         end if; 

	when farmgreen1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '0'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 		 if (PLSensor='1')then
			PL1 <= '0'; PL0 <= '0';
			else 
				PL1 <= '0'; PL0 <= '1';
				end if;
	    clear <= '0';  
		if (reset='0' and (sensor='0' or long='1')) then
				NS <= farmyellow0;
	    else 
	        NS <= farmgreen1; 
        end if; 

	when farmyellow0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '0'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 		 if (PLSensor='1')then
			PL1 <= '0'; PL0 <= '0';
			else 
				PL1 <= '0'; PL0 <= '1';
				end if;
	    clear <= '1'; 
	    if (reset='0' and HLSensor='1') then 
	        NS <= farmyellow1; 
	    else
	        NS <= hwygreen0; 
         end if; 

	when farmyellow1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '1'; FL0 <= '0'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 		 if (PLSensor='1')then
			PL1 <= '1'; PL0 <= '0';
			else 
				PL1 <= '0'; PL0 <= '1';
				end if;
	    clear <= '0'; 
	    if (reset='0' and (short='1')) then 
	        NS <= farmred0; 
	    else
	        NS <= farmyellow1; 
         end if; 

	when farmred0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1';
	    if (reset='0' and HLSensor='1') then 
	        NS <= farmred1; 
	    else
	        NS <= hwygreen0; 
         end if; 			

	when farmred1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '0';
		 if (reset='0' and short='1') then 
				if (HLSensor='1')then
					NS <= hwyLgreen0;	
				else 
					if(reset='0' and short='1')then
						NS <= hwygreen0;
					end if;
				end if;
		 else  
	        NS <= farmred1; 
			end if;
			
	when hwyLgreen0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '0';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1';
	    if (reset='0') then 
	        NS <= hwyLgreen1; 
	    else
	        NS <= hwygreen0; 
         end if; 

	when hwyLgreen1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1'; 
		 HLL1 <= '0'; HLL0 <= '0';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '0';
	    if (reset='0' and short='1') then 
	        NS <= hwyLyellow0; 
	    else
	        NS <= hwyLgreen1; 
         end if; 

	when hwyLyellow0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1';
		 HLL1 <= '0'; HLL0 <= '0';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1'; 
	    if (reset='0') then 
	        NS <= hwyLyellow1;
	    else
	        NS <= hwygreen0;
         end if; 

	when hwyLyellow1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1';
		 HLL1 <= '1'; HLL0 <= '0';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '0'; 
	    if (reset='0' and short='1') then 
	        NS <= hwygreen0;
	    else
	        NS <= hwyLyellow1;
         end if; 

	when hwyLred0 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1';
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1'; 
	    if (reset='0') then 
	        NS <= hwyLred1;
	    else
	        NS <= hwygreen0;
         end if; 
	
	when hwyLred1 =>
	    HL1 <= '0'; HL0 <= '1'; 
	    FL1 <= '0'; FL0 <= '1';
		 HLL1 <= '0'; HLL0 <= '1';
		 PL1 <= '0'; PL0 <= '1';
	    clear <= '1'; 
	    if (reset='0' and short='1') then 
	        NS <= hwygreen0;
	    else
	        NS <= hwyLred1;
			  end if;
			  
	
		end case; 
    end process; 

end Behavioral; 

