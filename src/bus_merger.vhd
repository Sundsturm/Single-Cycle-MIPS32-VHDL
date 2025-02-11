-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: bus_merger.vhd
-- Deskripsi	: Implementasi Bus Merger (28-Bit dan 4-Bit -> 32-Bit)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL;

ENTITY bus_merger IS
	PORT(
			DATA_IN1: IN STD_LOGIC_VECTOR(3 DOWNTO 0); --Operand 1 yang berukuran 4-bit
			DATA_IN2: IN STD_LOGIC_VECTOR (27 DOWNTO 0); --Operand 2 yang berukuran 28-bit
			DATA_OUT: OUT STD_LOGIC_VECTOR (31 DOWNTO 0) --Hasil perbandingan operand 1 dan operand 2
		);
END ENTITY;

ARCHITECTURE behavior OF bus_merger IS
BEGIN
	PROCESS(DATA_IN1, DATA_IN2)
	BEGIN
		DATA_OUT <= DATA_IN1 & DATA_IN2;
	END PROCESS;
END behavior;