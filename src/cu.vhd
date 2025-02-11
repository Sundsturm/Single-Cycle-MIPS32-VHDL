-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: cu.vhd
-- Deskripsi	: Implementasi Control Unit Single-Cycle MIPS32(R)

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

-- Control Unit: 2 Input Port dan 10 Output Port
-- Masing-masing output port akan menjelaskan 9 jenis instruksi.

ENTITY cu IS
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
END cu;

ARCHITECTURE behavior OF cu IS
BEGIN
  PROCESS (OP_In, FUNCT_In)
  BEGIN

    -- Checking Opcode (OP_In)
    CASE OP_In IS
      -- R-type Instruction (Add, Sub, And, Or, etc.)
      WHEN "000000" =>  -- R-type instructions
        -- Check Funct code for specific R-type operations
        CASE FUNCT_In IS
          WHEN "100000" =>  -- ADD
			Sig_Branch  <= '0';
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
			Sig_MemWrite <= '0';
			Sig_RegDest <= "01";   -- Register destination is rd
			Sig_RegWrite <= '1';   -- Register write enable
			Sig_ALUSrc <= "00";    -- ALU source is from registers
            Sig_ALUCtrl <= "00"; -- ADD
            Sig_Jmp <= "00";  -- Default value for jump signal
			Sig_Bne <= '0';  -- Default value for branch not equal signal
          WHEN "100010" =>  -- SUB
			Sig_Branch  <= '0';
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
			Sig_MemWrite <= '0';
			Sig_RegDest <= "01";   -- Register destination is rd
			Sig_RegWrite <= '1';   -- Register write enable
			Sig_ALUSrc <= "00";    -- ALU source is from registers
            Sig_ALUCtrl <= "01"; -- SUB
            Sig_Jmp <= "00";  -- Default value for jump signal
			Sig_Bne <= '0';  -- Default value for branch not equal signal
          WHEN OTHERS =>
            Sig_Branch  <= '0';
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
			Sig_MemWrite <= '0';
			Sig_RegDest <= "00";   -- Register destination is rd
			Sig_RegWrite <= '0';   -- Register write enable
			Sig_ALUSrc <= "00";    -- ALU source is from registers
            Sig_ALUCtrl <= "00"; -- ADD
            Sig_Jmp <= "00";  -- Default value for jump signal
			Sig_Bne <= '0';  -- Default value for branch not equal signal
        END CASE;

      -- I-type Instructions (Immediate type)
      WHEN "001000" =>  -- ADDI
		Sig_Branch  <= '0';
		Sig_MemtoReg <= '0';
		Sig_MemRead <= '0';
		Sig_MemWrite <= '0';
		Sig_RegDest <= "00";   
        Sig_RegWrite <= '1';   -- Register write enable
        Sig_ALUSrc <= "01";    -- ALU source is the immediate
        Sig_ALUCtrl <= "00";
        Sig_Jmp <= "00";  
		Sig_Bne <= '0';  

      WHEN "100011" =>  -- LOAD WORD (LW)
		Sig_Branch  <= '0';
        Sig_MemtoReg <= '1';   -- Memory to register
		Sig_MemRead <= '1';    -- Memory read
		Sig_MemWrite <= '0';
		Sig_RegDest <= "00";   
        Sig_RegWrite <= '1';   -- Register write enable
        Sig_ALUSrc <= "01";    -- ALU source is the immediate
        Sig_ALUCtrl <= "00";
        Sig_Jmp <= "00";  
		Sig_Bne <= '0';  

      WHEN "101011" =>  -- STORE WORD (SW)
		Sig_Branch  <= '0';
        Sig_MemtoReg <= '0';   
		Sig_MemRead <= '0';    
        Sig_MemWrite <= '1';   -- Memory write
        Sig_RegDest <= "00";   
        Sig_RegWrite <= '0';   
        Sig_ALUSrc <= "01";    -- ALU source is the immediate
        Sig_ALUCtrl <= "00";  
        Sig_Jmp <= "00";  
		Sig_Bne <= '0'; 

      -- Branch instructions
      WHEN "000100" =>  -- BEQ (Branch If Equal)
		Sig_Branch <= '1';    -- Enable branching
        Sig_MemtoReg <= '0';   
		Sig_MemRead <= '0';    
        Sig_MemWrite <= '0'; 
		Sig_RegDest <= "XX";
		Sig_RegWrite <= '0'; 
        Sig_ALUCtrl <= "XX";  
        Sig_ALUSrc <= "XX"; 
        Sig_Jmp <= "00";  
		Sig_Bne <= '0';  
              
      WHEN "000101" =>  -- BNE (Branch If Not Equal)
		Sig_Branch <= '0';
        Sig_MemtoReg <= '0';   
		Sig_MemRead <= '0';    
        Sig_MemWrite <= '0'; 
		Sig_RegDest <= "XX";
		Sig_RegWrite <= '0';
        Sig_ALUCtrl <= "XX";  
        Sig_ALUSrc <= "XX";  
        Sig_Jmp <= "00"; 
        Sig_Bne <= '1';        -- Enable branch if not equal

      -- Jump instructions
      WHEN "000010" =>  -- J
		Sig_Branch  <= '0';
        Sig_MemtoReg <= '0';   
		Sig_MemRead <= '0';    
        Sig_MemWrite <= '0'; 
        Sig_RegDest <= "XX";
        Sig_RegWrite <= '0';
        Sig_ALUCtrl <= "XX";  
        Sig_ALUSrc <= "XX"; 
        Sig_Jmp <= "01";      -- Enable Jump operation 
        Sig_Bne <= '0';

      -- Default case for invalid opcodes
      WHEN OTHERS =>
        Sig_Branch <= '0';   -- No branch
        Sig_MemtoReg <= '0'; -- No memory to register
        Sig_MemRead <= '0';  -- No memory read
        Sig_MemWrite <= '0'; -- No memory write
        Sig_RegDest <= "00"; -- No register destination
        Sig_RegWrite <= '0'; -- No register write
        Sig_ALUSrc <= "00";  -- No ALU source
        Sig_ALUCtrl <= "00"; -- No ALU operation
    END CASE;
  END PROCESS;
END behavior;