library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package registers is
    type register_out is array(0 to 31) of std_logic_vector(31 downto 0);
end package;
