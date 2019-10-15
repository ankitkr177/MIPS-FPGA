library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ProgramCounter is
    Port ( PCSrc, clk, clr, Jump, Halt: in STD_LOGIC;
           SignImm : in STD_LOGIC_VECTOR (31 downto 0);
           Instr : in STD_LOGIC_VECTOR (31 downto 0);
           PC : inout STD_LOGIC_VECTOR(31 downto 0):= x"00000000"
           );
end ProgramCounter;

architecture Behavioral of ProgramCounter is

signal PC_temp: STD_LOGIC_VECTOR(31 downto 0):= (others=> '0');
signal PC_4,PC_Branch, SI_temp : STD_LOGIC_VECTOR(31 downto 0);

begin

PC_4 <= PC + 4;
PC_Branch <= (PC + 4 + (SignImm(29 downto 0) & SignImm(31 downto 30))) when Jump = '0'
              else ("0000" & Instr(25 downto 0) & "00") when Jump = '1'; -----Changed Jump Compare with green sheet

PC_temp <= PC_4 when PCSrc = '0' and Halt = '0' else
           PC_Branch when PCSrc = '1' and Halt = '0' else
           PC when Halt = '1';

process(clk,clr)
begin
    if clr = '1' then
        PC <= (others=> '0');
    elsif rising_Edge(clk) then
        PC <= PC_temp;
    end if;
end process;

end Behavioral;
