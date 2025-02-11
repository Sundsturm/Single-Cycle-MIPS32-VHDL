-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: sign_extender.vhd
-- Deskripsi	: Implementasi Sign Extender 16-Bit -> 32-Bit

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

ENTITY sign_extender IS
  PORT (
    D_In  : IN  std_logic_vector (15 DOWNTO 0); -- Data Input (16-bit)
    D_Out : OUT std_logic_vector (31 DOWNTO 0)  -- Data Output (32-bit)
  );
END sign_extender;

ARCHITECTURE behavior OF sign_extender IS
BEGIN
  PROCESS (D_In)
  BEGIN
    D_Out(31 DOWNTO 16) <= (OTHERS => D_In(15)); -- Extend sign bit to upper 16 bits, logical or arithmatical extend
    D_Out(15 DOWNTO 0)  <= D_In; -- Copy the lower 16-bits of input
  END PROCESS;
END behavior;