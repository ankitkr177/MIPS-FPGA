library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity SignExtend is
    Port ( Instr : in STD_LOGIC_VECTOR (31 downto 0);
           SignImm : out STD_LOGIC_VECTOR (31 downto 0));
end SignExtend;

architecture Behavioral of SignExtend is

begin

SignImm <= x"0000" & Instr(15 downto 0) when Instr(15) = '0'
           else x"ffff" & Instr(15 downto 0);

end Behavioral;
