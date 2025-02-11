-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: scmips32.vhd
-- Deskripsi	: Implementasi Top-Level Single-Cycle MIPS32(R)

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

ENTITY scmips32 IS
  PORT (
    clk_in 		: IN std_logic;
    rst 		: IN std_logic;
    ALU_RESULT	: OUT std_logic_vector (31 downto 0);
    EQUALITY	: OUT std_logic;
    RD_DATA_MEM	: OUT std_logic_vector (31 downto 0);
    PC_IN		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    PC_OUT		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    INSTR	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    OPCODE	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
    REG_S	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    REG_T	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    REG_D	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    FUNCT	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
    IMMEDIATE	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    SHAMT_I	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    ADDRESS_J: OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
    RD_DATA_ONE: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    RD_DATA_TWO: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    WRITE_DATA_3: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    CLA_OFFSET	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIG_JMP     : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);                     
	SIG_BNE     : OUT STD_LOGIC;                     
	SIG_BRANCH 		: OUT STD_LOGIC;                 
	SIG_MEMTOREG	: OUT STD_LOGIC;                 
	SIG_MEMREAD		: OUT STD_LOGIC;                 
	SIG_MEMWRITE	: OUT STD_LOGIC;                 
	SIG_REGDEST		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIG_REGWRITE	: OUT STD_LOGIC;                 
	SIG_ALUSRC	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
	SIG_ALUCTRL : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
  );
END scmips32;

ARCHITECTURE behavioral OF scmips32 IS
	COMPONENT ALU
		PORT (
			OPRND_1 : IN std_logic_vector (31 DOWNTO 0); -- Data Input 1
			OPRND_2 : IN std_logic_vector (31 DOWNTO 0); -- Data Input 2
			OP_SEL  : IN std_logic_vector (1 DOWNTO 0);  -- Operation Select
			RESULT  : OUT std_logic_vector (31 DOWNTO 0) -- Data Output
		);
	END COMPONENT;
	
	COMPONENT bus_merger
		PORT (
			DATA_IN1: IN STD_LOGIC_VECTOR(3 DOWNTO 0); --Operand 1 yang berukuran 4-bit
			DATA_IN2: IN STD_LOGIC_VECTOR (27 DOWNTO 0); --Operand 2 yang berukuran 28-bit
			DATA_OUT: OUT STD_LOGIC_VECTOR (31 DOWNTO 0) --Hasil perbandingan operand 1 dan operand 2
		);
	END COMPONENT;
	
	COMPONENT cla_32
		PORT (
			OPRND_1 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Operand 1
			OPRND_2 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Operand 2
			C_IN    : IN  STD_LOGIC;                      -- Carry input
			RESULT  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Sum result
			C_OUT   : OUT STD_LOGIC                       -- Carry output
		);
	END COMPONENT;
	
	COMPONENT comparator
		PORT (
			D_1:	IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Operand 1
			D_2:	IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Operand 2
			EQ: OUT STD_LOGIC --Hasil perbandingan operand 1 dan operand 2
		);
	END COMPONENT;
	
	COMPONENT cu
		PORT (
			OP_In       : IN STD_LOGIC_VECTOR (5 DOWNTO 0);  -- Operasi Opcode Input
			FUNCT_In    : IN STD_LOGIC_VECTOR (5 DOWNTO 0);  -- Funct Code Input
			Sig_Jmp     : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);                      -- Sinyal untuk Jump
			Sig_Bne     : OUT STD_LOGIC;                      -- Sinyal untuk Branch if Not Equal
			Sig_Branch  : OUT STD_LOGIC;                     -- Branch signal
			Sig_MemtoReg : OUT STD_LOGIC;                    -- Mem to Reg signal
			Sig_MemRead : OUT STD_LOGIC;                     -- Mem Read signal
			Sig_MemWrite : OUT STD_LOGIC;                    -- Mem Write signal
			Sig_RegDest : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); -- Reg Destination signal
			Sig_RegWrite : OUT STD_LOGIC;                    -- Reg Write signal
			Sig_ALUSrc : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);  -- ALU Src signal
			Sig_ALUCtrl : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)  -- ALU Control signal
		);
	END COMPONENT;
	
	COMPONENT data_memory
		PORT (
			ADDR: IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Address
			WR_EN: IN STD_LOGIC;                    -- Write Enable
			RD_EN: IN STD_LOGIC;                    -- Read Enable
			clock: IN STD_LOGIC;                    -- Clock signal
			RD_Data: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Read data (output)
			WR_Data: IN STD_LOGIC_VECTOR (31 DOWNTO 0)   -- Write data (input)
		);
	END COMPONENT;
	
	COMPONENT instruction_memory
		PORT (
			ADDR: IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- alamat
			clock: IN STD_LOGIC := '1'; -- clock
			INSTR: OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- output
		);
	END COMPONENT;
	
	COMPONENT lshift_26_28
		PORT (
			D_IN  : IN  STD_LOGIC_VECTOR (25 DOWNTO 0); -- Input 26-bit
			D_OUT : OUT STD_LOGIC_VECTOR (27 DOWNTO 0)  -- Output 28-bit after left shift
		);
	END COMPONENT;
	
	COMPONENT lshift_32_32
		PORT (
			D_IN  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Input 32-bit
			D_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)  -- Output 32-bit after left shift
		);
	END COMPONENT;
	
	COMPONENT mux_2to1_32bit
		PORT (
			D1:	IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Operand 1
			D2: IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Operand 2
			Y: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); --Data yang terpilih
			S: IN STD_LOGIC -- Selektor data
		);
	END COMPONENT;
	
	COMPONENT mux_4to1_5bit
		PORT (
			D1: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 1
			D2: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 2
			D3: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 3
			D4: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 4
			Y:  OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- Data yang terpilih
			S:  IN STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Selektor data
		);
	END COMPONENT;
	
	COMPONENT mux_4to1_32bit
		PORT (
			D1: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operand 1
			D2: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operand 2
			D3: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operand 3
			D4: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Operand 4
			Y:  OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data yang terpilih
			S:  IN STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Selektor data
		);
	END COMPONENT;
	
	COMPONENT program_counter
		PORT (
			clk		: IN STD_LOGIC;
			PC_in 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PC_out 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT reg_file
		PORT (
			clock       : IN STD_LOGIC;                       -- Clock signal
			WR_EN       : IN STD_LOGIC;                       -- Write enable signal
			ADDR_1      : IN STD_LOGIC_VECTOR (4 DOWNTO 0);   -- Read address 1
			ADDR_2      : IN STD_LOGIC_VECTOR (4 DOWNTO 0);   -- Read address 2
			ADDR_3      : IN STD_LOGIC_VECTOR (4 DOWNTO 0);   -- Write address
			WR_Data_3   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);  -- Write data
			RD_Data_1   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Read data 1
			RD_Data_2   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)  -- Read data 2
		);
	END COMPONENT;
	
	COMPONENT sign_extender
		PORT (
			D_In  : IN  std_logic_vector (15 DOWNTO 0); -- Data Input (16-bit)
			D_Out : OUT std_logic_vector (31 DOWNTO 0)  -- Data Output (32-bit)
		);
	END COMPONENT;
	
	-- Definisi sinyal-sinyal Instruction Memory
	SIGNAL instr_out: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Data Memory
	SIGNAL rd_datamem: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Register
	SIGNAL rd_data1, rd_data2, wr_data3: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Multiplexer 2-to-1 32-Bit Pre-Program Counter #1
	SIGNAL outmux32_2to1_prepc1: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Multiplexer 4-to-1 32-Bit Pre-Program Counter
	SIGNAL outmux32_4to1_prepc: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Multiplexer 4-to-1 5-Bit Register di Register
	SIGNAL outmux32_4to1_reg: std_logic_vector (4 downto 0);
	
	-- Definisi sinyal-sinyal Multiplexer 2-to-1 32-Bit Pre-Program Counter #2
	-- No need karena ada di Program Counter
	
	-- Definisi sinyal-sinyal Comparator
	SIGNAL eq_o: std_logic;
	
	-- Definisi sinyal-sinyal Bus Merger
	SIGNAL bus_merge_out: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Multiplexer 4-to-1 32-Bit Post-Program Counter (Setelah Register)
	-- No need karena ada di Control Unit, Sign Extender, ALU, dan Register
	
	-- Definisi sinyal-sinyal Multiplexer 2-to-1 32-Bit Post-Program Counter (Setelah Data Memory)
	-- No need karena udah ada di Register
	
	-- Definisi sinyal-sinyal Program Counter
	SIGNAL pc_i, pc_o: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Left-Shift 32-Bit
	SIGNAL d_32_out: std_logic_vector (31 downto 0);
	
	-- Definisi sinyal-sinyal Left-Shift 26-Bit ke 28-Bit
	SIGNAL d_2628_out: std_logic_vector (27 downto 0);
	
	-- Definisi CLA di dekat Program Counter
	SIGNAL cla_pc: std_logic_vector (31 downto 0);
	
	-- Definisi CLA di Left-Shifter 32-Bit
	SIGNAL cla_lshift: std_logic_vector (31 downto 0);
	
	-- Definisi Sign Extender
	SIGNAL d_extend_out: std_logic_vector (31 downto 0);
	
	-- Membagi instr sesuai Format-Format Instruksi
	alias op_i : std_logic_vector(5 downto 0) is instr_out(31 downto 26);
	alias funct_i : std_logic_vector(5 downto 0) is instr_out(5 downto 0);
	
	alias rs : std_logic_vector(4 downto 0) is instr_out(25 downto 21); -- ADDR_1
	alias rt : std_logic_vector(4 downto 0) is instr_out(20 downto 16); -- ADDR_2
	alias rd : std_logic_vector(4 downto 0) is instr_out(15 downto 11); 
	alias shamt : std_logic_vector(4 downto 0) is instr_out(10 downto 6);
	alias imdt : std_logic_vector(15 downto 0) is instr_out(15 downto 0); -- Immediate
	alias addr : std_logic_vector(25 downto 0) is instr_out(25 downto 0); -- Untuk J-Format (address)
	
	-- Definisi sinyal-sinyal Control Unit
	SIGNAL bne, branch, memtoreg, memread, memwrite, regwrite: std_logic;
	SIGNAL regdest, alusrc, aluctrl, jmp: std_logic_vector (1 downto 0);
	
	-- Definisi sinyal-sinyal ALU
	SIGNAL oprnd_2_alu, alu_rslt: std_logic_vector (31 downto 0);
	
	-- Operator sinyal logika (Rangkaian NOT, AND, dan OR)
	SIGNAL sel_mux_prepc: std_logic;
	SIGNAL out_and1: std_logic;
	SIGNAL out_and2: std_logic;
	
	BEGIN
	out_and1 <= NOT(eq_o) AND bne;
	out_and2 <= branch AND eq_o;
	sel_mux_prepc <= out_and1 OR out_and2;
	
	-- Multiplexer 2-to-1 Pre-Program Counter #1
    MUX_PREPC_2TO1_1: mux_2to1_32bit
        PORT MAP (
            D1 => cla_pc,
            D2 => cla_lshift,
            S  => sel_mux_prepc, 
            Y  => outmux32_2to1_prepc1
        );
        
    -- Multiplexer 4-to-1 Pre-Program Counter
    MUX_PREPC_4TO1: mux_4to1_32bit
        PORT MAP (
            D1 => outmux32_2to1_prepc1,
            D2 => bus_merge_out,
            D3 => X"00000000",              -- Default zero (unused case)
            D4 => X"00000000",
            S  => jmp,
            Y  => outmux32_4to1_prepc
        );
        
    -- Multiplexer 2-to-1 Pre-Program Counter #2
    MUX_PREPC_2TO1_2: mux_2to1_32bit
        PORT MAP (
            D1 => outmux32_4to1_prepc,
            D2 => X"00000000",
            S  => rst, 
            Y  => pc_i
        );
	
    -- Program Counter
    PC: program_counter
        PORT MAP (
            clk     => clk_in,
            PC_in   => pc_i,
            PC_out  => pc_o
        );
        
    -- CLA Adder for PC Increment
    CLA_PROGRAM_COUNTER: cla_32
        PORT MAP (
            OPRND_1 => pc_o,
            OPRND_2 => X"00000004", -- Increment PC by 4
            C_IN    => '0',
            RESULT  => cla_pc,
            C_OUT   => OPEN
        );

    -- Instruction Memory
    IMEM: instruction_memory
        PORT MAP (
            ADDR  => pc_o(7 DOWNTO 0),
            clock => clk_in,
            INSTR => instr_out
        );

    -- Control Unit
    CONTROLUNIT: cu
        PORT MAP (
            OP_In      => op_i,
            FUNCT_In   => funct_i,
            Sig_Jmp    => jmp,
            Sig_Bne    => bne,
            Sig_Branch => branch,
            Sig_MemtoReg => memtoreg,
            Sig_MemRead  => memread,
            Sig_MemWrite => memwrite,
            Sig_RegDest  => regdest,
            Sig_RegWrite => regwrite,
            Sig_ALUSrc   => alusrc,
            Sig_ALUCtrl  => aluctrl
        );

    -- Register File
    REGISTER_FILE: reg_file
        PORT MAP (
            clock     => clk_in,
            WR_EN     => regwrite,
            ADDR_1    => rs,  -- rs
            ADDR_2    => rt,  -- rt
            ADDR_3    => outmux32_4to1_reg,  -- rd
            WR_Data_3 => wr_data3,
            RD_Data_1 => rd_data1,
            RD_Data_2 => rd_data2
        );
        
    -- Multiplexer 4-to-1 Register
    MUX_REGISTER_4TO1: mux_4to1_5bit
        PORT MAP (
            D1 => rt,
            D2 => rd,
            D3 => "00000",            
            D4 => "00000",
            S  => regdest,
            Y  => outmux32_4to1_reg
        );

    -- Sign Extender
    SE: sign_extender
        PORT MAP (
            D_In  => imdt,
            D_Out => d_extend_out
        );
        
   -- Left Shift 26-to-28-bit
    LSHIFT_26_28_UNIT: lshift_26_28
        PORT MAP (
            D_IN  => addr,
            D_OUT => d_2628_out
        );
        
    -- Bus Merger
    BUS_MERGE_32: bus_merger
        PORT MAP (
            DATA_IN1 => cla_pc(31 downto 28),
			DATA_IN2 => d_2628_out,
			DATA_OUT => bus_merge_out
        );
        
    -- Comparator
    COMP: comparator
        PORT MAP (
            D_1 => rd_data1,
            D_2 => rd_data2,
            EQ  => eq_o
        );
        
    -- Multiplexer 4-to-1 Pre-Program Counter
    MUX_ALU_4TO1: mux_4to1_32bit
        PORT MAP (
            D1 => rd_data2,
            D2 => d_extend_out,
            D3 => X"00000000",              -- Default zero (unused case)
            D4 => X"00000000",
            S  => alusrc,
            Y  => oprnd_2_alu
        );  
   
   -- ALU (Arithmetic Logic Unit)
    ALU_UNIT: ALU
        PORT MAP (
            OPRND_1 => rd_data1,
            OPRND_2 => oprnd_2_alu,
            OP_SEL  => aluctrl,
            RESULT  => alu_rslt
        );
        
   -- Left Shift 32-bit
    LSHIFT_32: lshift_32_32
        PORT MAP (
            D_IN  => d_extend_out,
            D_OUT => d_32_out
        );
        
        
   -- CLA Adder for Immediate
    CLA_LSHIFT_UNIT: cla_32
        PORT MAP (
            OPRND_1 => d_32_out,
            OPRND_2 => cla_pc,
            C_IN    => '0',
            RESULT  => cla_lshift,
            C_OUT   => OPEN
        );

    -- Data Memory
    DMEM: data_memory
        PORT MAP (
            ADDR    => alu_rslt(7 DOWNTO 0),
            WR_EN   => memwrite,
            RD_EN   => memread,
            clock   => clk_in,
            RD_Data => rd_datamem,
            WR_Data => rd_data2
        );
        
    -- Multiplexer 2-to-1 Data Memory
    MUX_DATMEM_2TO1: mux_2to1_32bit
        PORT MAP (
            D1 => alu_rslt,
            D2 => rd_datamem,
            S  => memtoreg, 
            Y  => wr_data3
        );

    -- Output assignments
    ALU_RESULT		<= alu_rslt;
    EQUALITY		<= eq_o;
    RD_DATA_MEM		<= rd_datamem;
    PC_IN			<= pc_i;
    PC_OUT			<= pc_o;
    INSTR			<= instr_out;
    OPCODE			<= op_i;
    REG_S			<= rs; -- ADDR_1
    REG_T			<= rt; -- ADDR_2
    REG_D			<= rd;
    FUNCT			<= funct_i;
    IMMEDIATE		<= imdt;
    SHAMT_I			<= shamt;
    ADDRESS_J		<= addr;
    WRITE_DATA_3	<= wr_data3;
    RD_DATA_ONE		<= rd_data1;
    RD_DATA_TWO		<= rd_data2;
    CLA_OFFSET		<= cla_lshift;
    SIG_JMP        <= jmp;
    SIG_BRANCH     <= branch;
    SIG_MEMTOREG   <= memtoreg;
    SIG_MEMREAD    <= memread;
    SIG_MEMWRITE   <= memwrite;
    SIG_REGDEST    <= regdest;
    SIG_REGWRITE   <= regwrite;
    SIG_ALUSRC     <= alusrc;
    SIG_ALUCTRL    <= aluctrl;

END behavioral;