LIBRARY ieee;
library std;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use work.dmem.all;
use work.imem.all;
use work.registers.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
ENTITY processor_test IS
END processor_test;
 
ARCHITECTURE behavior OF processor_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
      enc_out   : inout std_logic_vector(63 downto 0)
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
      signal enc : std_logic_vector(63 downto 0):=(others =>'0');
      signal dout : std_logic_vector(63 downto 0);
   --Inputs

 --signal skey: work.rc5_pkg.ROM1;
   -- Clock period definitions
 
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
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
   enc_out   => enc
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
 
 
   clock_process :process
   begin
  clk <= '0';
  wait for clock_period/2;
  clk <= '1';
  wait for clock_period/2;
   end process;
   

   
stim_proc: process
         file cmdfile: TEXT;       -- Define the file 'handle'
        variable L: Line;         -- Define the line buffer
        variable good: boolean; --status of the read operation
variable count : integer := 1;
       variable din_read : std_logic_vector(63 downto 0);
       variable dout_read: std_logic_vector(63 downto 0);
       variable space   : character;
   
 begin 
   clr <= '0';
  ukey <=   x"00000000000000000000000000000000";
  mode <= "001"; 
  wait for 125000 ns; mode <= "000"; wait for 10 ns;
    FILE_OPEN(cmdfile,"C:\Xilinx\Vivado\RC5_vectors.txt",READ_MODE);
        loop
            if endfile(cmdfile) then  -- Check EOF
                assert false
                    report "End of file encountered; exiting."
                    severity NOTE;
                exit;
            end if;
           readline(cmdfile,L);           -- Read the line
            next when L'length = 0;  -- Skip empty lines
          hread(L,din_read,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;
--           read(L, space, good);
--                 assert good report "bad vector value";      
          hread(L,dout_read,good);     -- Read the B argument
            assert good
              report "Text I/O read error"
            severity ERROR;
--  clr <= '1'; wait for 30 ns;
  mode <= "000"; clr <= '1';
  din <= din_read;
  wait for 50 ns;clr <= '0';
  mode <= "010";
  wait for 1000ns;
  wait for 150000ns; 
  
  --enc<=x"EEDBA5216D8F4B15";
  dout <= dout_read;
   wait for 15*clock_period;
            assert (enc = dout_read)
                report "Encryption Check failed!" &  integer'image(count)
                    severity ERROR;
            assert (enc /= dout_read)
                report "Encryption Check Passed!" &  integer'image(count)
                    severity NOTE;
        count := count +1;
    end loop;
      wait;
   end process;
END;