-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: comparator.vhd
-- Deskripsi	: Implementasi Comparator

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL;

ENTITY comparator IS
	PORT(
			D_1:	IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Operand 1
			D_2:	IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Operand 2
			EQ: OUT STD_LOGIC --Hasil perbandingan operand 1 dan operand 2
		);
END ENTITY;

ARCHITECTURE behavior OF comparator IS
BEGIN
	PROCESS(D_1, D_2)
	BEGIN
		IF (D_1 = D_2) THEN
			EQ <= '1';
		ELSE
			EQ <= '0';
		END IF;
	END PROCESS;
END behavior;