library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

use work.dmem.all;
use work.imem.all;
use work.registers.all;

entity Processor_FPGA_tb is
end;

architecture bench of Processor_FPGA_tb is

component ControlUnit
port (
  Instr      : in  STD_LOGIC_VECTOR (31 downto 0);
  Zero       : in  STD_LOGIC;
  Mem2Reg    : out STD_LOGIC;
  MemWrite   : out STD_LOGIC;
  ALUSrc     : out STD_LOGIC;
  RegDst     : out STD_LOGIC;
  RegWrite   : out STD_LOGIC;
  Halt       : out STD_LOGIC;
  PCSrc      : out STD_LOGIC;
  Branch     : inout STD_LOGIC;
  Jump       : inout STD_LOGIC;
  ALUControl : out STD_LOGIC_VECTOR (3 downto 0)
);
end component ControlUnit;

signal Instr      : STD_LOGIC_VECTOR (31 downto 0);
signal Zero       : STD_LOGIC;
signal Mem2Reg    : STD_LOGIC;
signal MemWrite   : STD_LOGIC;
signal ALUSrc     : STD_LOGIC;
signal RegDst     : STD_LOGIC;
signal RegWrite   : STD_LOGIC;
signal Halt       : STD_LOGIC;
signal PCSrc      : STD_LOGIC;
signal Branch     : STD_LOGIC;
signal Jump       : STD_LOGIC;
signal ALUControl : STD_LOGIC_VECTOR (3 downto 0);

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

signal clr     : STD_LOGIC;
signal SignImm : STD_LOGIC_VECTOR (31 downto 0);

signal PC      : STD_LOGIC_VECTOR(31 downto 0):= x"00000000";

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


signal WD3      : STD_LOGIC_VECTOR (31 downto 0);
signal WE3      : STD_LOGIC;
signal RD1      : STD_LOGIC_VECTOR (31 downto 0);
signal reg_file : register_out;
signal RD2      : STD_LOGIC_VECTOR (31 downto 0);

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


signal ALUResult  : STD_LOGIC_VECTOR(31 downto 0);

component DataMemory
port (
  ALUResult : in  STD_LOGIC_VECTOR (31 downto 0);
  clk       : in  STD_LOGIC;
  clr       : in  STD_LOGIC;
  MemWrite  : in  STD_LOGIC;
  Mem2Reg   : in  STD_LOGIC;
  mode      : in  STD_LOGIC_VECTOR(2 downto 0);
  ukey      : in  STD_LOGIC_VECTOR (127 downto 0);
  din       : in  STD_LOGIC_VECTOR (63 downto 0);
  WD        : in  STD_LOGIC_VECTOR(31 downto 0);
  Result    : out STD_LOGIC_VECTOR (31 downto 0);
  dmem      : inout data_out;
  enc_out   : inout STD_LOGIC_VECTOR (63 downto 0)
);
end component DataMemory;

signal WD        : STD_LOGIC_VECTOR(31 downto 0);
signal Result    : STD_LOGIC_VECTOR (31 downto 0);
signal dmem      : data_out;

component InstructionMemory
port (
  PC    : in  STD_LOGIC_VECTOR (31 downto 0);
  Instr : inout STD_LOGIC_VECTOR (31 downto 0)
);
end component InstructionMemory;


component SignExtend
port (
  Instr   : in  STD_LOGIC_VECTOR (31 downto 0);
  SignImm : out STD_LOGIC_VECTOR (31 downto 0)
);
end component SignExtend;

  signal mode: std_logic_vector (2 downto 0);  
  
  signal ukey: std_logic_vector(127 downto 0);
  signal din : std_logic_vector(63 downto 0);
  signal clk: STD_LOGIC;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
  signal enc_out : std_logic_vector(63 downto 0);

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
  Halt       => Halt,
  PCSrc      => PCSrc,
  Branch     => Branch,
  Jump       => Jump,
  ALUControl => ALUControl
);
ProgramCounter_i : ProgramCounter
port map (
  PCSrc   => PCSrc,
  clk     => clk,
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
  clr      => clr,
  clk      => clk,
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
  clk       => clk,
  clr       => clr,
  ukey      => ukey,
  din       => din,
  mode      => mode,
  MemWrite  => MemWrite,
  Mem2Reg   => Mem2Reg,
  WD        => RD2,
  Result    => Result,
  dmem      => dmem,
  enc_out   => enc_out
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
  stimulus: process
  begin
  
    -- Put initialisation code here
   mode <= "001"; 
   ukey <=   x"00000000000000000000000000000000";
   din <=  x"EEDBA5216D8F4B15";
    
  clr <= '1'; wait for 10ns; clr <= '0'; wait for 130000ns;
  mode <= "010";
  wait for 50000ns; mode <= "000"; wait for 20ns; mode <= "010";
  din <= x"0982278592302112"; wait for 100000000ns;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  