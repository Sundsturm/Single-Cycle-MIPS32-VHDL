-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: cla_32.vhd
-- Deskripsi	: Implementasi Carry-Lookahead Adder 32-Bit

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

ENTITY cla_32 IS
  PORT (
    OPRND_1 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Operand 1
    OPRND_2 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); -- Operand 2
    C_IN    : IN  STD_LOGIC;                      -- Carry input
    RESULT  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Sum result
    C_OUT   : OUT STD_LOGIC                       -- Carry output
  );
END cla_32;

ARCHITECTURE behavior OF cla_32 IS
  SIGNAL C : STD_LOGIC_VECTOR (32 DOWNTO 0); -- Carry signals (C0 to C32)
BEGIN
  -- Assign initial carry
  C(0) <= C_IN;

  PROCESS (OPRND_1, OPRND_2, C_IN)
  VARIABLE G, P : STD_LOGIC_VECTOR (31 DOWNTO 0); -- Local generate and propagate
  BEGIN
    -- Generate G (Generate) and P (Propagate) signals
    FOR i IN 0 TO 31 LOOP
      G(i) := OPRND_1(i) AND OPRND_2(i);
      P(i) := OPRND_1(i) XOR OPRND_2(i);
    END LOOP;

    -- Calculate carry signals
    FOR i IN 0 TO 31 LOOP
      C(i+1) <= G(i) OR (P(i) AND C(i));
    END LOOP;

    -- Calculate sum and final carry-out
    FOR i IN 0 TO 31 LOOP
      RESULT(i) <= P(i) XOR C(i);
    END LOOP;
    C_OUT <= C(32);
  END PROCESS;
END behavior;
