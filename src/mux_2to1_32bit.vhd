-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: mux_2to1_32bit.vhd
-- Deskripsi	: Implementasi Multiplexer 32-Bit 2-to-1

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL;

ENTITY mux_2to1_32bit IS
	PORT(
			D1:	IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Operand 1
			D2: IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Operand 2
			Y: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); --Data yang terpilih
			S: IN STD_LOGIC -- Selektor data
		);
END ENTITY;

ARCHITECTURE behavior OF mux_2to1_32bit IS
BEGIN
	PROCESS(S, D1, D2)
	BEGIN
		IF (S = '1') THEN
			Y <= D2;
		ELSE
			Y <= D1;
		END IF;
	END PROCESS;
END behavior;