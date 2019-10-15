library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Unsigned.all;
USE IEEE.STD_LOGIC_ARITH.ALL;

use work.dmem.all;
use work.imem.all;
use work.registers.all;


entity Processor_FPGA is
    Port ( BTN : in STD_LOGIC_VECTOR(4 downto 0);
           clk : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR(15 downto 0);
           --dmem_d :out data_out;
           --reg_d : out register_out;
          -- PC_d : out STD_LOGIC_VECTOR(31 downto 0);
          CA  : out  STD_LOGIC_VECTOR (7 downto 0);
           AN  : out  STD_LOGIC_VECTOR (7 downto 0);
          LED : out STD_LOGIC_VECTOR (15 downto 0));
end Processor_FPGA;

architecture Behavioral of Processor_FPGA is

component ControlUnit
port (
  Instr      : in  STD_LOGIC_VECTOR (31 downto 0);
  Zero       : in  STD_LOGIC;
  Mem2Reg    : out STD_LOGIC;
  MemWrite   : out STD_LOGIC;
  ALUSrc     : out STD_LOGIC;
  RegDst     : out STD_LOGIC;
  RegWrite   : out STD_LOGIC;
  Jump       : inout STD_LOGIC;
  Halt       : out STD_LOGIC;
  PCSrc      : out STD_LOGIC;
  Branch     : inout STD_LOGIC;
  ALUControl : out STD_LOGIC_VECTOR (3 downto 0)
);
end component ControlUnit;

component ALU
port (
  RD1        : in  STD_LOGIC_VECTOR (31 downto 0);
  RD2        : in  STD_LOGIC_VECTOR (31 downto 0);
  SignImm    : in  STD_LOGIC_VECTOR (31 downto 0);
  ALUSrc     : in  STD_LOGIC;
  Zero       : out STD_LOGIC;
  ALUControl : in  STD_LOGIC_VECTOR (3 downto 0);
  ALUResult  : out STD_LOGIC_VECTOR(31 downto 0)
);
end component ALU;

component DataMemory
port (
  ALUResult : in  STD_LOGIC_VECTOR (31 downto 0);
  clk       : in  STD_LOGIC;
  clr       : in  STD_LOGIC;
  MemWrite  : in  STD_LOGIC;
  Mem2Reg   : in  STD_LOGIC;
  mode      : in std_logic_vector(2 downto 0);
  ukey      : in  STD_LOGIC_VECTOR(127 downto 0);
  din       : in  STD_LOGIC_VECTOR(63 downto 0);     
  WD        : in  STD_LOGIC_VECTOR(31 downto 0);
  Result    : out STD_LOGIC_VECTOR (31 downto 0);
  dmem      : inout data_out
);
end component DataMemory;

component InstructionMemory
port (
  PC    : in  STD_LOGIC_VECTOR (31 downto 0);
  Instr : inout STD_LOGIC_VECTOR (31 downto 0)
);
end component InstructionMemory;


component ProgramCounter
port (
  PCSrc   : in  STD_LOGIC;
  clk     : in  STD_LOGIC;
  clr     : in  STD_LOGIC;
  Jump    : in  STD_LOGIC;
  Halt    : in  STD_LOGIC;
  SignImm : in  STD_LOGIC_VECTOR (31 downto 0);
  Instr   : in  STD_LOGIC_VECTOR (31 downto 0);
  PC      : inout STD_LOGIC_VECTOR(31 downto 0):= x"00000000"
);
end component ProgramCounter;

component RegisterFile
port (
  Instr    : in  STD_LOGIC_VECTOR (31 downto 0);
  WD3      : in  STD_LOGIC_VECTOR (31 downto 0);
  WE3      : in  STD_LOGIC;
  clr      : in  STD_LOGIC;
  clk      : in  STD_LOGIC;
  RegDst   : in  STD_LOGIC;
  RD1      : out STD_LOGIC_VECTOR (31 downto 0);
  reg_file : inout register_out;
  RD2      : out STD_LOGIC_VECTOR (31 downto 0);
  mode     : in STD_LOGIC_VECTOR (2 downto 0)
);
end component RegisterFile;

component SignExtend
port (
  Instr   : in  STD_LOGIC_VECTOR (31 downto 0);
  SignImm : out STD_LOGIC_VECTOR (31 downto 0)
);
end component SignExtend;

component Hex2LED --Converts a 4 bit hex value into the pattern to be displayed on the 7seg
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component;


signal Instr,Result,RD1,RD2,ALUResult: STD_LOGIC_VECTOR (31 downto 0);
signal Zero       : STD_LOGIC;
signal Mem2Reg    : STD_LOGIC;
signal MemWrite   : STD_LOGIC;
signal ALUSrc     : STD_LOGIC;
signal RegDst     : STD_LOGIC;
signal RegWrite   : STD_LOGIC;
signal Jump       : STD_LOGIC;
signal Halt       : STD_LOGIC;
signal PCSrc      : STD_LOGIC;
signal Branch     : STD_LOGIC;
signal ALUControl : STD_LOGIC_VECTOR (3 downto 0);
signal clr        : STD_LOGIC;
signal SignImm,PC : STD_LOGIC_VECTOR (31 downto 0);  
signal dmem   : data_out;
signal reg_file : register_out;

type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;
signal Val : std_logic_vector(3 downto 0) := (others => '0');
signal HexVal: std_logic_vector(31 downto 0);
signal slowCLK,slow1CLK: std_logic:='0';
signal i_cnt: std_logic_vector(19 downto 0):=x"00000";
signal i_cnt1: std_logic_vector(27 downto 0):=x"0000000";
signal slowerCLK: std_logic:='0';

signal address: std_logic_vector(7 downto 0);
signal ukey : std_logic_vector(127 downto 0);
signal din  : std_logic_vector (63 downto 0);
signal mode : std_logic_vector (2 downto 0);
signal clk_temp : std_logic;
begin

ControlUnit_i : ControlUnit
port map (
  Instr      => Instr,
  Zero       => Zero,
  Mem2Reg    => Mem2Reg,
  MemWrite   => MemWrite,
  ALUSrc     => ALUSrc,
  RegDst     => RegDst,
  RegWrite   => RegWrite,
  Jump       => Jump,
  Halt       => Halt,
  PCSrc      => PCSrc,
  Branch     => Branch,
  ALUControl => ALUControl
);

ProgramCounter_i : ProgramCounter
port map (
  PCSrc   => PCSrc,
  clk     => clk_temp,
  clr     => clr,
  Jump    => Jump,
  Halt    => Halt,
  SignImm => SignImm,
  Instr   => Instr,
  PC      => PC
);

RegisterFile_i : RegisterFile
port map (
  Instr    => Instr,
  WD3      => Result,
  WE3      => RegWrite,
  clk      => clk_temp,
  clr      => clr,
  RegDst   => RegDst,
  RD1      => RD1,
  reg_file => reg_file,
  RD2      => RD2,
  mode     => mode
);

ALU_i : ALU
port map (
  RD1        => RD1,
  RD2        => RD2,
  SignImm    => SignImm,
  ALUSrc     => ALUSrc,
  Zero       => Zero,
  ALUControl => ALUControl,
  ALUResult  => ALUResult
);

DataMemory_i : DataMemory
port map (
  ALUResult => ALUResult,
  clk       => clk_temp,
  clr       => clr,
  MemWrite  => MemWrite,
  ukey      => ukey,
  mode      => mode,
  din       => din,
  Mem2Reg   => Mem2Reg,
  WD        => RD2,
  Result    => Result,
  dmem      => dmem
);

InstructionMemory_i : InstructionMemory
port map (
  PC    => PC,
  Instr => Instr
);

SignExtend_i : SignExtend
port map (
  Instr   => Instr,
  SignImm => SignImm
);
--slow1CLK <= BTN(4);
clr<=BTN(4); ---BTNC for CLR
LED<=SW;
clk_temp <= slow1clk when (BTN(3 downto 2)="11") else
            BTN(1) when (BTN(3 downto 2)="00");      

mode <= SW(2 downto 0);
            
address <= SW(7 downto 3) & BTN(0) & "00"; ---BTND
with BTN(3 downto 2) select 
    HexVal <= Dmem(conv_integer(unsigned(address))) 
             & Dmem(conv_integer(unsigned(address+1))) & Dmem(conv_integer(unsigned(address+2))) &
             Dmem(conv_integer(unsigned(address+3))) when "10", ---BTNU for DMemory
             
             reg_file(conv_integer(unsigned(SW(7 downto 3)))) when "01", ---BTNL for RegFile
             PC when others;
     

-----Creating a slowCLK of 500Hz using the board's 100MHz clock----
process(clk)
begin
if (rising_edge(clk)) then
if (i_cnt=x"186A0")then --Hex(186A0)=Dec(100,000) (2FAF080)hex for 1 hz = 50,000,000
slowCLK<=not slowCLK; --slowCLK toggles once after we see 100000 rising edges of CLK. 2 toggles is one period.
i_cnt<=x"00000";
else
i_cnt<=i_cnt+'1';
end if;
end if;
end process;

process(clk)
begin
if (rising_edge(clk)) then
if (i_cnt1=x"0000010")then --Hex(186A0)=Dec(100,000) (2FAF080)hex for 1 hz = 50,000,000
slow1CLK<=not slow1CLK; --slowCLK toggles once after we see 100000 rising edges of CLK. 2 toggles is one period.
i_cnt1<=(others=>'0');
else
i_cnt1<=i_cnt1+'1';
end if;
end if;
end process;

--process(CLK) ------ SlowerCLK = 1 Hz.
--begin
--    if (rising_edge(CLK)) then 
--        if (i_cnt1 = x"2FAF080") then slowerCLK <= not slowerCLK; i_cnt1 <= x"0000000";
--        else i_cnt1 <= i_cnt1 + '1';
--        end if;
--    end if;    
--end process;

-----We use the 500Hz slowCLK to run our 7seg display at roughly 60Hz-----
timer_inc_process : process (slowCLK)
begin
	if (rising_edge(slowCLK)) then
				if(Val="1000") then
				Val<="0001";
				else
				Val <= Val + '1'; --Val runs from 1,2,3,...8 on every rising edge of slowCLK
			end if;
		end if;
	--end if;
end process;

--This select statement selects one of the 7-segment diplay anode(active low) at a time. 
with Val select
	        AN <= "01111111" when "0001",
				  "10111111" when "0010",
				  "11011111" when "0011",
				  "11101111" when "0100",
				  "11110111" when "0101",
				  "11111011" when "0110",
				  "11111101" when "0111",
				  "11111110" when "1000",
				  "11111111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
with Val select
	        CA <= NAME(0) when "0001", --NAME contains the pattern for each hex value to be displayed.
				  NAME(1) when "0010", --See below for the conversion
				  NAME(2) when "0011",
				  NAME(3) when "0100",
				  NAME(4) when "0101",
				  NAME(5) when "0110",
				  NAME(6) when "0111",
				  NAME(7) when "1000",
				  NAME(0) when others;


--process(CLK,slowerCLK)
--begin
--    if (slowerCLK = '0') then HexVal <= temp(63 downto 32);
--    elsif (slowerCLK = '1') then Hexval <= temp(31 downto 0);
--    end if;
--end process;

--reg_d <= reg_file;
-- PC_D <= PC;

CONV1: Hex2LED port map (CLK => clk, X => HexVal(31 downto 28), Y => NAME(0));
CONV2: Hex2LED port map (CLK => clk, X => HexVal(27 downto 24), Y => NAME(1));
CONV3: Hex2LED port map (CLK => clk, X => HexVal(23 downto 20), Y => NAME(2));
CONV4: Hex2LED port map (CLK => clk, X => HexVal(19 downto 16), Y => NAME(3));		
CONV5: Hex2LED port map (CLK => clk, X => HexVal(15 downto 12), Y => NAME(4));
CONV6: Hex2LED port map (CLK => clk, X => HexVal(11 downto 8), Y => NAME(5));
CONV7: Hex2LED port map (CLK => clk, X => HexVal(7 downto 4), Y => NAME(6));
CONV8: Hex2LED port map (CLK => clk, X => HexVal(3 downto 0), Y => NAME(7));


end Behavioral;
