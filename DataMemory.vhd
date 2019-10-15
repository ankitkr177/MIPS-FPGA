library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.dmem.all;

entity DataMemory is
    Port ( ALUResult : in STD_LOGIC_VECTOR (31 downto 0);
           clk, MemWrite, Mem2Reg,clr: in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR(31 downto 0);
           ukey : in STD_LOGIC_VECTOR(127 downto 0);
           din : in STD_LOGIC_VECTOR(63 downto 0);
           Result : out STD_LOGIC_VECTOR (31 downto 0);
           mode  : in STD_LOGIC_VECTOR (2 DOWNTO 0);
           enc_out : inout STD_LOGIC_VECTOR (63 downto 0);
           dmem : inout data_out:=(
            x"b7",x"e1",x"51",x"63",
            x"56",x"18",x"cb",x"1c", 
            x"f4",x"50",x"44",x"d5", 
            x"92",x"87",x"be",x"8e", 
            x"30",x"bf",x"38",x"47", 
            x"ce",x"f6",x"b2",x"00", 
            x"6d",x"2e",x"2b",x"b9", 
            x"0b",x"65",x"a5",x"72", 
            x"a9",x"9d",x"1f",x"2b",
            x"47",x"d4",x"98",x"e4",
            x"e6",x"0c",x"12",x"9d", 
            x"84",x"43",x"8c",x"56", 
            x"22",x"7b",x"06",x"0f", 
            x"c0",x"b2",x"7f",x"c8", 
            x"5e",x"e9",x"f9",x"81", 
            x"fd",x"21",x"73",x"3a", 
            x"9b",x"58",x"ec",x"f3", 
            x"39",x"90",x"66",x"ac", 
            x"d7",x"c7",x"e0",x"65",
            x"75",x"ff",x"5a",x"1e", 
            x"14",x"36",x"d3",x"d7", 
            x"b2",x"6e",x"4d",x"90", 
            x"50",x"a5",x"c7",x"49", 
            x"ee",x"dd",x"41",x"02", 
            x"8d",x"14",x"ba",x"bb", 
            x"2b",x"4c",x"34",x"74",
            x"00",x"00",x"00",x"00", --ukey --26
            x"00",x"00",x"00",x"00", --ukey --27
            x"00",x"00",x"00",x"00", --ukey --28
            x"00",x"00",x"00",x"00", --ukey --29
            x"00",x"00",x"00",x"00", --A    --30
            x"00",x"00",x"00",x"00", --B    --31
             x"80",x"00",x"00",x"00", --and operation
             x"00",x"00",x"00",x"00",
             x"00",x"00",x"00",x"00",
             x"00",x"00",x"00",x"00",
             x"00",x"00",x"00",x"00",
             x"00",x"00",x"00",x"00",
              x"00",x"00",x"00",x"00",
              x"00",x"00",x"00",x"00",
              x"00",x"00",x"00",x"00",
              x"00",x"00",x"00",x"00",
              x"00",x"00",x"00",x"00",
              x"00",x"00",x"00",x"00",
               x"00",x"00",x"00",x"00",
               x"00",x"00",x"00",x"00",
               x"00",x"00",x"00",x"00",
               x"00",x"00",x"00",x"00",
               x"00",x"00",x"00",x"00",
               x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",
                 x"00",x"00",x"00",x"00",
                 x"00",x"00",x"00",x"00",
                 x"00",x"00",x"00",x"00",
                 x"00",x"00",x"00",x"00",
                 x"00",x"00",x"00",x"00",
                 x"00",x"00",x"00",x"00",
                     x"00",x"00",x"00",x"00",
                     x"00",x"00",x"00",x"00",
                      x"00",x"00",x"00",x"00",
                      x"00",x"00",x"00",x"00",
                      x"00",x"00",x"00",x"00",
                      x"00",x"00",x"00",x"00",
                      x"00",x"00",x"00",x"00",
                      x"00",x"00",x"00",x"00",
                       x"00",x"00",x"00",x"00",
                       x"00",x"00",x"00",x"00",
                       x"00",x"00",x"00",x"00",
                       x"00",x"00",x"00",x"00",
                       x"00",x"00",x"00",x"00",
                       x"00",x"00",x"00",x"00",
                        x"00",x"00",x"00",x"00",
                        x"00",x"00",x"00",x"00",
                        x"00",x"00",x"00",x"00",
                        x"00",x"00",x"00",x"00",
                        x"00",x"00",x"00",x"00",
                        x"00",x"00",x"00",x"00",
                         x"00",x"00",x"00",x"00",
                         x"00",x"00",x"00",x"00",
                         x"00",x"00",x"00",x"00",
                         x"00",x"00",x"00",x"00",
                         x"00",x"00",x"00",x"00",
                         x"00",x"00",x"00",x"00",
                          x"00",x"00",x"00",x"00",
                          x"00",x"00",x"00",x"00",
                          x"00",x"00",x"00",x"00",
                          x"00",x"00",x"00",x"00",
                          x"00",x"00",x"00",x"00",
                          x"00",x"00",x"00",x"00",
                           x"00",x"00",x"00",x"00",
                           x"00",x"00",x"00",x"00",
                              x"00",x"00",x"00",x"00",
                              x"00",x"00",x"00",x"00",
                                             x"00",x"00",x"00",x"00",
                                             x"00",x"00",x"00",x"00",
                                              x"00",x"00",x"00",x"00",
                                              x"00",x"00",x"00",x"00",
                                                 x"00",x"00",x"00",x"00",
                                      x"00",x"00",x"00",x"00",
                                      x"00",x"00",x"00",x"00",
                                      x"00",x"00",x"00",x"00",
                                       x"00",x"00",x"00",x"00",
                                       x"00",x"00",x"00",x"00",
                                       x"00",x"00",x"00",x"00",
                                       x"00",x"00",x"00",x"00",
                                       x"00",x"00",x"00",x"00",
                                       x"00",x"00",x"00",x"00",
                                        x"00",x"00",x"00",x"00",
                                        x"00",x"00",x"00",x"00",
                                        x"00",x"00",x"00",x"00",
                                        x"00",x"00",x"00",x"00",
                                        x"00",x"00",x"00",x"00",
                                        x"00",x"00",x"00",x"00",                
                     
           x"00",x"00",x"00",x"00",
            x"00",x"00",x"00",x"00"                                           
                 ));
end DataMemory;

architecture Behavioral of DataMemory is

signal ReadData : std_logic_vector (31 downto 0):=(others=>'0');
--signal dmem1 : data_out:= data_out'(
-- x"b7",x"e1",x"51",x"63",
-- x"56",x"18",x"cb",x"1c", 
-- x"f4",x"50",x"44",x"d5", 
-- x"92",x"87",x"be",x"8e", 
-- x"30",x"bf",x"38",x"47", 
-- x"ce",x"f6",x"b2",x"00", 
-- x"6d",x"2e",x"2b",x"b9", 
-- x"0b",x"65",x"a5",x"72", 
-- x"a9",x"9d",x"1f",x"2b",
-- x"47",x"d4",x"98",x"e4",
-- x"e6",x"0c",x"12",x"9d", 
-- x"84",x"43",x"8c",x"56", 
-- x"22",x"7b",x"06",x"0f", 
-- x"c0",x"b2",x"7f",x"c8", 
-- x"5e",x"e9",x"f9",x"81", 
-- x"fd",x"21",x"73",x"3a", 
-- x"9b",x"58",x"ec",x"f3", 
-- x"39",x"90",x"66",x"ac", 
-- x"d7",x"c7",x"e0",x"65",
-- x"75",x"ff",x"5a",x"1e", 
-- x"14",x"36",x"d3",x"d7", 
-- x"b2",x"6e",x"4d",x"90", 
-- x"50",x"a5",x"c7",x"49", 
-- x"ee",x"dd",x"41",x"02", 
-- x"8d",x"14",x"ba",x"bb", 
-- x"2b",x"4c",x"34",x"74",
-- x"00",x"00",x"00",x"00", --ukey --26
-- x"00",x"00",x"00",x"00", --ukey --27
-- x"00",x"00",x"00",x"00", --ukey --28
-- x"00",x"00",x"00",x"00", --ukey --29
-- x"00",x"00",x"00",x"00", --A    --30
-- x"00",x"00",x"00",x"00", --B    --31
--  x"80",x"00",x"00",x"00", --and operation
--  x"00",x"00",x"00",x"00",
--  x"00",x"00",x"00",x"00",
--  x"00",x"00",x"00",x"00",
--  x"00",x"00",x"00",x"00",
--  x"00",x"00",x"00",x"00",
--   x"00",x"00",x"00",x"00",
--   x"00",x"00",x"00",x"00",
--   x"00",x"00",x"00",x"00",
--   x"00",x"00",x"00",x"00",
--   x"00",x"00",x"00",x"00",
--   x"00",x"00",x"00",x"00",
--    x"00",x"00",x"00",x"00",
--    x"00",x"00",x"00",x"00",
--    x"00",x"00",x"00",x"00",
--    x"00",x"00",x"00",x"00",
--    x"00",x"00",x"00",x"00",
--    x"00",x"00",x"00",x"00",
--     x"00",x"00",x"00",x"00",
--     x"00",x"00",x"00",x"00",
--     x"00",x"00",x"00",x"00",
--     x"00",x"00",x"00",x"00",
--     x"00",x"00",x"00",x"00",
--     x"00",x"00",x"00",x"00",
--      x"00",x"00",x"00",x"00",
--      x"00",x"00",x"00",x"00",
--      x"00",x"00",x"00",x"00",
--      x"00",x"00",x"00",x"00",
--      x"00",x"00",x"00",x"00",
--      x"00",x"00",x"00",x"00",
--          x"00",x"00",x"00",x"00",
--          x"00",x"00",x"00",x"00",
--           x"00",x"00",x"00",x"00",
--           x"00",x"00",x"00",x"00",
--           x"00",x"00",x"00",x"00",
--           x"00",x"00",x"00",x"00",
--           x"00",x"00",x"00",x"00",
--           x"00",x"00",x"00",x"00",
--            x"00",x"00",x"00",x"00",
--            x"00",x"00",x"00",x"00",
--            x"00",x"00",x"00",x"00",
--            x"00",x"00",x"00",x"00",
--            x"00",x"00",x"00",x"00",
--            x"00",x"00",x"00",x"00",
--             x"00",x"00",x"00",x"00",
--             x"00",x"00",x"00",x"00",
--             x"00",x"00",x"00",x"00",
--             x"00",x"00",x"00",x"00",
--             x"00",x"00",x"00",x"00",
--             x"00",x"00",x"00",x"00",
--              x"00",x"00",x"00",x"00",
--              x"00",x"00",x"00",x"00",
--              x"00",x"00",x"00",x"00",
--              x"00",x"00",x"00",x"00",
--              x"00",x"00",x"00",x"00",
--              x"00",x"00",x"00",x"00",
--               x"00",x"00",x"00",x"00",
--               x"00",x"00",x"00",x"00",
--               x"00",x"00",x"00",x"00",
--               x"00",x"00",x"00",x"00",
--               x"00",x"00",x"00",x"00",
--               x"00",x"00",x"00",x"00",
--                x"00",x"00",x"00",x"00",
--                x"00",x"00",x"00",x"00",
--                   x"00",x"00",x"00",x"00",
--                   x"00",x"00",x"00",x"00",
--                                  x"00",x"00",x"00",x"00",
--                                  x"00",x"00",x"00",x"00",
--                                   x"00",x"00",x"00",x"00",
--                                   x"00",x"00",x"00",x"00",
--                                      x"00",x"00",x"00",x"00",
--                           x"00",x"00",x"00",x"00",
--                           x"00",x"00",x"00",x"00",
--                           x"00",x"00",x"00",x"00",
--                            x"00",x"00",x"00",x"00",
--                            x"00",x"00",x"00",x"00",
--                            x"00",x"00",x"00",x"00",
--                            x"00",x"00",x"00",x"00",
--                            x"00",x"00",x"00",x"00",
--                            x"00",x"00",x"00",x"00",
--                             x"00",x"00",x"00",x"00",
--                             x"00",x"00",x"00",x"00",
--                             x"00",x"00",x"00",x"00",
--                             x"00",x"00",x"00",x"00",
--                             x"00",x"00",x"00",x"00",
--                             x"00",x"00",x"00",x"00",                
          
--x"00",x"00",x"00",x"00",
-- x"00",x"00",x"00",x"00"                                           
--      );
 
 
signal address,a2: std_logic_vector (31 downto 0);
signal Readmem: Std_logic;
constant t : std_logic_vector(31 downto 0) := x"000001DD" ;
signal c : boolean;
begin
a2 <= ALUResult(29 downto 0) & "00";
--a1 <= unsigned(conv_integer(unsigned(a2)));
process(c,a2)
begin
if (a2<t) then c <= true; address <= a2;
else c<= false; address <= (others =>'0');
end if;
end process;


--process(c)
--begin
--if c then address<= ALUResult(29 downto 0) & "00";
-- else
--    address <= (others=>'0');
--    end if;
--end process;

Readmem <= Mem2Reg;

process(clk,MemWrite,clr)
begin
if (clr = '1')then
--dmem(0) <= x"b7";dmem(1) <= x"e1";dmem(2) <= x"51";dmem(3) <= x"63"; --00
--dmem(4) <= x"56";dmem(5) <= x"18";dmem(6) <= x"cb";dmem(7) <= x"1c"; --01
--dmem(8) <= x"f4";dmem(9) <= x"50";dmem(10) <= x"44";dmem(11) <= x"d5"; 
--dmem(12) <= x"92";dmem(13) <= x"87";dmem(14) <= x"be";dmem(15) <= x"8e";
--dmem(16) <= x"30";dmem(17) <= x"bf";dmem(18) <= x"38";dmem(19) <= x"47"; 
--dmem(20) <= x"ce";dmem(21) <= x"f6";dmem(22) <= x"b2";dmem(23) <= x"00"; 
--dmem(24) <= x"6d";dmem(25) <= x"2e";dmem(26) <= x"2b";dmem(27) <= x"b9"; 
--dmem(28) <= x"0b";dmem(29) <= x"65";dmem(30) <= x"a5";dmem(31) <= x"72"; 
--dmem(32) <= x"a9";dmem(33) <= x"9d";dmem(34) <= x"1f";dmem(35) <= x"2b";
--dmem(36) <= x"47";dmem(37) <= x"d4";dmem(38) <= x"98";dmem(39) <= x"e4";
--dmem(40) <= x"e6";dmem(41) <= x"0c";dmem(42) <= x"12";dmem(43) <= x"9d"; 
--dmem(44) <= x"84";dmem(45) <= x"43";dmem(46) <= x"8c";dmem(47) <= x"56"; 
--dmem(48) <= x"22";dmem(49) <= x"7b";dmem(50) <= x"06";dmem(51) <= x"0f"; 
--dmem(52) <= x"c0";dmem(53) <= x"b2";dmem(54) <= x"7f";dmem(55) <= x"c8"; 
--dmem(56) <= x"5e";dmem(57) <= x"e9";dmem(58) <= x"f9";dmem(59) <= x"81"; 
--dmem(60) <= x"fd";dmem(61) <= x"21";dmem(62) <= x"73";dmem(63) <= x"3a"; 
--dmem(64) <= x"9b";dmem(65) <= x"58";dmem(66) <= x"ec";dmem(67) <= x"f3"; 
--dmem(68) <= x"39";dmem(69) <= x"90";dmem(70) <= x"66";dmem(71) <= x"ac"; 
--dmem(72) <= x"d7";dmem(73) <= x"c7";dmem(74) <= x"e0";dmem(75) <= x"65";
--dmem(76) <= x"75";dmem(77) <= x"ff";dmem(78) <= x"5a";dmem(79) <= x"1e"; 
--dmem(80) <= x"14";dmem(81) <= x"36";dmem(82) <= x"d3";dmem(83) <= x"d7"; 
--dmem(84) <= x"b2";dmem(85) <= x"6e";dmem(86) <= x"4d";dmem(87) <= x"90"; 
--dmem(88) <= x"50";dmem(89) <= x"a5";dmem(90) <= x"c7";dmem(91) <= x"49"; 
--dmem(92) <= x"ee";dmem(93) <= x"dd";dmem(94) <= x"41";dmem(95) <= x"02"; 
--dmem(96) <= x"8d";dmem(97) <= x"14";dmem(98) <= x"ba";dmem(99) <= x"bb"; 
--dmem(100) <= x"2b";dmem(101) <= x"4c";dmem(102) <= x"34";dmem(103) <= x"74"; ---s(25)
dmem(104) <= ukey(31 downto 24);dmem(105) <= ukey(23 downto 16);dmem(106) <= ukey(15 downto 8);dmem(107) <= ukey(7 downto 0);  --26
dmem(108) <= ukey(63 downto 56);dmem(109) <= ukey(55 downto 48);dmem(110) <= ukey(47 downto 40);dmem(111) <= ukey(39 downto 32);  --27
dmem(112) <= ukey(95 downto 88);dmem(113) <= ukey(87 downto 80);dmem(114) <= ukey(79 downto 72);dmem(115) <= ukey(71 downto 64);  --28
dmem(116) <= ukey(127 downto 120);dmem(117) <= ukey(119 downto 112);dmem(118) <= ukey(111 downto 104);dmem(119) <= ukey(103 downto 96);  --29
dmem(120) <= din(63 downto 56);dmem(121) <= din(55 downto 48);dmem(122) <= din(47 downto 40);dmem(123) <= din(39 downto 32);  --30 (A
dmem(124) <= din(31 downto 24);dmem(125) <= din(23 downto 16);dmem(126) <= din(15 downto 8);dmem(127) <= din(7 downto 0);  --31  (B)
dmem(128) <= x"80"; elsif (rising_edge(clk)) then
    if (MemWrite = '1') then
        dmem(conv_integer(unsigned(address))) <= WD(31 downto 24);
        dmem(conv_integer(unsigned(address+1))) <= WD(23 downto 16);
        dmem(conv_integer(unsigned(address+2))) <= WD(15 downto 8);
        dmem(conv_integer(unsigned(address+3))) <= WD(7 downto 0);
    end if;
end if;
end process;

--process(mode)
--begin
--if (mode = "010") or (mode ="000") then
--dmem(120) <= din(63 downto 56);dmem(121) <= din(55 downto 48);dmem(122) <= din(47 downto 40);dmem(123) <= din(39 downto 32);  --30 (A
--dmem(124) <= din(31 downto 24);dmem(125) <= din(23 downto 16);dmem(126) <= din(15 downto 8);dmem(127) <= din(7 downto 0);  --31  (B)
--end if;
--end process;

with ReadMeM select
ReadData <= (dmem(conv_integer((address))) & dmem(conv_integer((address+1)))&
            dmem(conv_integer((address+2))) & dmem(conv_integer((address+3))))
             when '1', x"00000000" when others;

--process(c, ALUResult,Mem2Reg)
--begin
--case Mem2Reg is 
-- when '1' => if c then 
--               address <= ALUResult(29 downto 0) & "00";
--               ReadData <= (dmem1(conv_integer((address))) & dmem1(conv_integer((address+1)))&
--               dmem1(conv_integer((address+2))) & dmem1(conv_integer((address+3))));
--               Result <= ReadData;
--             else
--                address <= (others => '0');
--                ReadData <= (dmem1(conv_integer((address))) & dmem1(conv_integer((address+1)))&
--                            dmem1(conv_integer((address+2))) & dmem1(conv_integer((address+3))));
--                Result <= ReadData;             
--             end if;
-- when '0' => ReadData <= (others => '0');
--             Result <= ALUResult;
-- when others => null;
--end case;                           
--end process;

--process(Mem2Reg,ALUResult,ReadData)
--begin 
--case Mem2Reg is 
--    when '0' => Result <= ALUResult;
--    when '1' => Result <= ReadData;
--    when others => null;
--end case;    
--end process;

Result <= ALUResult when (Mem2Reg = '0')
          else ReadData when (Mem2Reg = '1');
enc_out <= dmem(132)&dmem(133)&dmem(134)&dmem(135)&dmem(136)&dmem(137)&dmem(138)&dmem(139);
--dmem <= dmem2 when clr ='1' else
        --dmem1;
--dmem <= dmem1;        
end Behavioral;
