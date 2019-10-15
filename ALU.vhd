library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_logic_unsigned.all;

entity ALU is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           SignImm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           Zero : out STD_LOGIC;
           ALUControl : in STD_LOGIC_VECTOR (3 downto 0);
           ALUResult : out STD_LOGIC_VECTOR(31 downto 0));
end ALU;

architecture Behavioral of ALU is

signal SrcA,SrcB,LR,RR : std_logic_vector(31 downto 0);

begin

SrcA <= RD1;
SrcB <= RD2 when (ALUSrc = '0') else SignImm when (ALUSrc = '1');

WITH SrcB(4 DOWNTO 0) SELECT
        LR <= SrcA(30 DOWNTO 0) & "0" WHEN "00001",
                SrcA(29 DOWNTO 0) & "00" WHEN "00010",
                SrcA(28 DOWNTO 0) & "000" WHEN "00011",
                SrcA(27 DOWNTO 0) & "0000" WHEN "00100",
                SrcA(26 DOWNTO 0) & "00000" WHEN "00101",
                SrcA(25 DOWNTO 0) & "000000" WHEN "00110",
                SrcA(24 DOWNTO 0) & "0000000" WHEN "00111",
                SrcA(23 DOWNTO 0) & "00000000" WHEN "01000",
                SrcA(22 DOWNTO 0) & "000000000" WHEN "01001",
                SrcA(21 DOWNTO 0) & "0000000000" WHEN "01010",
                SrcA(20 DOWNTO 0) & "00000000000" WHEN "01011",
                SrcA(19 DOWNTO 0) & "000000000000" WHEN "01100",
                SrcA(18 DOWNTO 0) & "0000000000000" WHEN "01101",
                SrcA(17 DOWNTO 0) & "00000000000000" WHEN "01110",
                SrcA(16 DOWNTO 0) & "000000000000000" WHEN "01111",
                SrcA(15 DOWNTO 0) & "0000000000000000" WHEN "10000",
                SrcA(14 DOWNTO 0) & "00000000000000000" WHEN "10001",
                SrcA(13 DOWNTO 0) & "000000000000000000" WHEN "10010",
                SrcA(12 DOWNTO 0) & "0000000000000000000" WHEN "10011",
                SrcA(11 DOWNTO 0) & "00000000000000000000" WHEN "10100",
                SrcA(10 DOWNTO 0) & "000000000000000000000" WHEN "10101",
                SrcA(9 DOWNTO 0) &  "0000000000000000000000" WHEN "10110",
                SrcA(8 DOWNTO 0) &  "00000000000000000000000" WHEN "10111",
                SrcA(7 DOWNTO 0) &  "000000000000000000000000" WHEN "11000",
                SrcA(6 DOWNTO 0) &  "0000000000000000000000000" WHEN "11001",
                SrcA(5 DOWNTO 0) &  "00000000000000000000000000" WHEN "11010",
                SrcA(4 DOWNTO 0) &  "000000000000000000000000000" WHEN "11011",
                SrcA(3 DOWNTO 0) &  "0000000000000000000000000000" WHEN "11100",
                SrcA(2 DOWNTO 0) &  "00000000000000000000000000000" WHEN "11101",
                SrcA(1 DOWNTO 0) &  "000000000000000000000000000000" WHEN "11110",
                SrcA(0) &           "0000000000000000000000000000000" WHEN "11111",
                SrcA WHEN OTHERS;
--WITH SrcB(4 DOWNTO 0) SELECT
--           RR<= SrcA(0) & SrcA(31 DOWNTO 1)  WHEN "00001",
--                SrcA(1 DOWNTO 0) & SrcA(31 DOWNTO 2) WHEN "00010",
--                SrcA(2 DOWNTO 0) & SrcA(31 DOWNTO 3) WHEN "00011",
--                SrcA(3 DOWNTO 0) & SrcA(31 DOWNTO 4) WHEN "00100",
--                SrcA(4 DOWNTO 0) & SrcA(31 DOWNTO 5) WHEN "00101",
--                SrcA(5 DOWNTO 0) & SrcA(31 DOWNTO 6) WHEN "00110",
--                SrcA(6 DOWNTO 0) & SrcA(31 DOWNTO 7) WHEN "00111",
--                SrcA(7 DOWNTO 0) & SrcA(31 DOWNTO 8) WHEN "01000",
--                SrcA(8 DOWNTO 0) & SrcA(31 DOWNTO 9) WHEN "01001",
--                SrcA(9 DOWNTO 0) & SrcA(31 DOWNTO 10) WHEN "01010",
--                SrcA(10 DOWNTO 0) & SrcA(31 DOWNTO 11) WHEN "01011",
--                SrcA(11 DOWNTO 0) & SrcA(31 DOWNTO 12) WHEN "01100",
--                SrcA(12 DOWNTO 0) & SrcA(31 DOWNTO 13) WHEN "01101",
--                SrcA(13 DOWNTO 0) & SrcA(31 DOWNTO 14) WHEN "01110",
--                SrcA(14 DOWNTO 0) & SrcA(31 DOWNTO 15) WHEN "01111",
--                SrcA(15 DOWNTO 0) & SrcA(31 DOWNTO 16) WHEN "10000",
--                SrcA(16 DOWNTO 0) & SrcA(31 DOWNTO 17) WHEN "10001",
--                SrcA(17 DOWNTO 0) & SrcA(31 DOWNTO 18) WHEN "10010",
--                SrcA(18 DOWNTO 0) & SrcA(31 DOWNTO 19) WHEN "10011",
--                SrcA(19 DOWNTO 0) & SrcA(31 DOWNTO 20) WHEN "10100",
--                SrcA(20 DOWNTO 0) & SrcA(31 DOWNTO 21) WHEN "10101",
--                SrcA(21 DOWNTO 0) & SrcA(31 DOWNTO 22) WHEN "10110",
--                SrcA(22 DOWNTO 0) & SrcA(31 DOWNTO 23) WHEN "10111",
--                SrcA(23 DOWNTO 0) & SrcA(31 DOWNTO 24) WHEN "11000",
--                SrcA(24 DOWNTO 0) & SrcA(31 DOWNTO 25) WHEN "11001",
--                SrcA(25 DOWNTO 0) & SrcA(31 DOWNTO 26) WHEN "11010",
--                SrcA(26 DOWNTO 0) & SrcA(31 DOWNTO 27) WHEN "11011",
--                SrcA(27 DOWNTO 0) & SrcA(31 DOWNTO 28) WHEN "11100",
--                SrcA(28 DOWNTO 0) & SrcA(31 DOWNTO 29) WHEN "11101",
--                SrcA(29 DOWNTO 0) & SrcA(31 DOWNTO 30) WHEN "11110",
--                SrcA(30 DOWNTO 0) & SrcA(31) WHEN "11111",
--                SrcA WHEN OTHERS;

--process(ALUControl,LR,RR,SrcA,SrcB)
--begin
--case ALUControl is
--        when "0000"  => out_temp <= SrcA  +  SrcB; Zero <= '0';     --  ADD
--        when "0001"  => out_temp <= SrcA  -  SrcB; Zero <= '0';    --  SUB
--        when "0010"  => out_temp <= SrcA AND SrcB; Zero <= '0';    --  AND
--        when "0011"  => out_temp <= SrcA  OR SrcB; Zero <= '0';    --  OR
--        when "0100"  => out_temp <= NOT(SrcA OR SrcB); Zero <= '0';--  NOR
--        when "0101"  => out_temp <= LR; Zero <= '0';             --  Left Shift
----        when "110"  => out_temp <= RR; Zero <= '0';
----        when "0110"  => out_temp <= (others=> '0');
----                                     if (SrcA /= SrcB) then
----                                        Zero <= '0'            -- Branch if Equal
----        when "0111"  => out_temp <= (others=> '0'); Zero <= '0';                --  Branch if not equal
----        when "0111"  => out_temp <= (others=> '0') ; Zero <= '0';            --  Branch if not equal
--        when others => out_temp <= X"00000000";
--end case;
--end process;



ALUResult <= (SrcA + SrcB) when (ALUControl = "0000") else
             (SrcA - SrcB) when (ALUControl = "0001") else
             (SrcA AND SrcB) when ALUControl = "0010" else
             (SrcA OR SrcB) when ALUControl = "0011" else
             (NOT(SrcA OR SrcB)) when (ALUControl = "0100") else
             LR when (ALUControl = "0101") else
             X"00000000";

Zero <= '1' when (ALUControl = "0110" and SrcA = SrcB) else
        '1' when (ALUControl = "0111" and SrcA /= SrcB) else
        '1' when (ALUControl = "1000" and SrcA < SrcB) else
        '0';


end Behavioral;
