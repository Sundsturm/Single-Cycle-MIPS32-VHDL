-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: program_counter.vhd
-- Deskripsi	: Implementasi Program Counter

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY program_counter IS
	PORT (
			clk: IN STD_LOGIC;
			PC_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PC_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
END program_counter;

ARCHITECTURE behavior OF program_counter IS
	SIGNAL PC_reg: STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
	PROCESS(clk, PC_in)
	BEGIN
    IF rising_edge(clk) THEN
      PC_reg <= PC_in; -- Update the Program Counter on the rising edge of the clock
    END IF;
  END PROCESS;
  
  PC_out <= PC_reg;
END behavior;