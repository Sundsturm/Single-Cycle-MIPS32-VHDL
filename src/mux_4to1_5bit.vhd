-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: mux_4to1_5bit.vhd
-- Deskripsi	: Implementasi Multiplexer 5-Bit 4-to-1

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mux_4to1_5bit IS
	PORT(
		D1: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 1
		D2: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 2
		D3: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 3
		D4: IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- Operand 4
		Y:  OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- Data yang terpilih
		S:  IN STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Selektor data
	);
END ENTITY;

ARCHITECTURE behavior OF mux_4to1_5bit IS
BEGIN
	PROCESS(S, D1, D2, D3, D4)
	BEGIN
		CASE S IS
			WHEN "11" =>
				Y <= D4;
			WHEN "10" =>
				Y <= D3;
			WHEN "01" =>
				Y <= D2;
			WHEN OTHERS =>
				Y <= D1;
		END CASE;
	END PROCESS;
END behavior;
