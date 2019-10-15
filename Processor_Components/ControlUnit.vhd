library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_logic_unsigned.all;

entity ControlUnit is
    Port ( Instr : in STD_LOGIC_VECTOR (31 downto 0);
           Zero : in STD_LOGIC;
           Mem2Reg,MemWrite,ALUSrc,RegDst,RegWrite,Halt,PCSrc : out STD_LOGIC;
           Branch,Jump : inout STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (3 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is

signal Op : STD_LOGIC_VECTOR(5 downto 0);
signal Funct : STD_LOGIC_VECTOR(5 downto 0);

begin

Op <= Instr(31 downto 26); Funct <= Instr(5 downto 0);

Mem2Reg <= '1' when Op = "000111" else
           '0';

MemWrite <= '1' when Op = "001000" else
            '0';

Branch <= '1' when Op = "001001" else
          '1' when Op = "001010" else
          '1' when Op = "001011" else
          '1' when Op = "001100" else
          '0';

PCSrc <= (Branch and Zero) or Jump;

ALUControl <= "0000" when (Op = "000000" and Funct = "000001") else
              "0000" when (Op = "000001") else
              "0001" when (Op = "000000" and Funct = "000011") else
              "0001" when (Op = "000010") else
              "0010" when (Op = "000000" and Funct = "000101") else
              "0010" when (Op = "000011") else
              "0011" when (Op = "000000" and Funct = "000111") else
              "0011" when (Op = "000100") else
              "0100" when (Op = "000000" and Funct = "001001") else
              "0101" when (Op = "000101") else
              "0000" when (Op = "000111") else
              "0000" when (Op = "001000") else
              "1000" when (Op = "001001") else
              "0110" when (Op = "001010") else
              "0111" when (Op = "001011") else
              "1111";

ALUSrc <= '1' when ((Op="000001") or (Op="000010") or (Op="000011") or (Op="000100") or
              (Op="000101") or (Op="000111") or (Op="001000")) else
          '0';

--RegDst <= '0' when ((Op="000001") or (Op="000010") or (Op="000011") or (Op="000100") or
--              (Op="000101") or (Op="000111")) else
--          '1';

RegDst <= '1' when (Op="000000") else
          '0';
         
RegWrite <= '1' when ((Op = "000000") or (Op = "000001") or (Op = "000010") or (Op = "000011")
                or (Op = "000100") or (Op = "000101") or (Op = "000111")) else
            '0';

Jump <= '1' when (Op = "001100") else
        '0';

Halt <= '1' when (Op = "111111") else
        '0';

end Behavioral;
