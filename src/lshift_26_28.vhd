-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: lshift_26_28.vhd
-- Deskripsi	: Implementasi Left-Shifter 26-Bit ke 28-Bit

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

ENTITY lshift_26_28 IS
  PORT (
    D_IN  : IN  STD_LOGIC_VECTOR (25 DOWNTO 0); -- Input 26-bit
    D_OUT : OUT STD_LOGIC_VECTOR (27 DOWNTO 0)  -- Output 28-bit after left shift
  );
END lshift_26_28;

ARCHITECTURE behavior OF lshift_26_28 IS
BEGIN
  PROCESS (D_IN)
  BEGIN
    -- Perform a logical left shift by 2 bits
    D_OUT <= D_IN(25 DOWNTO 0) & "00"; -- Shift left by 2 and append '00'
  END PROCESS;
END behavior;