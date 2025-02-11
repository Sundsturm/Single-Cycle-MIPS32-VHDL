-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: ALU.vhd
-- Deskripsi	: Implementasi ALU Single-Cycle MIPS32(R)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

  -- ALU has two kind of operations: addition and substraction.
  -- When OP_SEL is 0, the operation is addition.
  -- When OP_SEL is 1, the operation is substraction.

  ENTITY ALU IS
    PORT (
      OPRND_1 : IN std_logic_vector (31 DOWNTO 0); -- Data Input 1
      OPRND_2 : IN std_logic_vector (31 DOWNTO 0); -- Data Input 2
      OP_SEL  : IN std_logic_vector (1 DOWNTO 0);  -- Operation Select
      RESULT  : OUT std_logic_vector (31 DOWNTO 0) -- Data Output
    );
  END ALU;

  ARCHITECTURE behavior OF ALU IS
    COMPONENT cla_32
    PORT (
      OPRND_1 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Operand 1
      OPRND_2 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Operand 2
      C_IN    : IN  STD_LOGIC;                      -- Carry input
      RESULT  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Sum result
      C_OUT   : OUT STD_LOGIC                       -- Carry output
    );
  END COMPONENT;

  SIGNAL SUM_RESULT : STD_LOGIC_VECTOR (31 DOWNTO 0); -- Output from cla_32
  SIGNAL SUB_RESULT : STD_LOGIC_VECTOR (31 DOWNTO 0); -- Output from cla_32
  SIGNAL C_OUT      : STD_LOGIC;                      -- Carry out (unused here)
BEGIN
  -- Instantiate the cla_32 component for addition
  ADD_ADDER: cla_32
    PORT MAP (
      OPRND_1 => OPRND_1,
      OPRND_2 => OPRND_2,
      C_IN    => '0',        -- Assume no initial carry-in
      RESULT  => SUM_RESULT, -- Sum result from the CLA
      C_OUT   => C_OUT       -- Carry out from the CLA (not used in this design)
    );
  SUB_ADDER: cla_32
    PORT MAP (
      OPRND_1 => OPRND_1,
      OPRND_2 => NOT OPRND_2,
      C_IN    => '1',        -- Assume no initial carry-in
      RESULT  => SUB_RESULT, -- Sum result from the CLA
      C_OUT   => C_OUT       -- Carry out from the CLA (not used in this design)
    );

  -- Select operation based on OP_SEL
  PROCESS (OPRND_1, OPRND_2, OP_SEL)
  BEGIN
    CASE OP_SEL IS
      WHEN "00" =>  
        RESULT <= SUM_RESULT;         -- Perform addition
      WHEN "01" =>
        RESULT <= SUB_RESULT;         -- Perform substraction
      WHEN OTHERS =>
        RESULT <= (OTHERS => '0');    -- Default to zero for invalid OP_SEL
    END CASE;
  END PROCESS;
END behavior;