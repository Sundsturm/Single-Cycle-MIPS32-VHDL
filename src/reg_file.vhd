-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: reg_file.vhd
-- Deskripsi	: Implementasi Register File Single-Cycle MIPS32(R)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg_file IS
    PORT (
        clock       : IN STD_LOGIC;                       -- Clock signal
        WR_EN       : IN STD_LOGIC;                       -- Write enable signal
        ADDR_1      : IN STD_LOGIC_VECTOR (4 DOWNTO 0);   -- Read address 1
        ADDR_2      : IN STD_LOGIC_VECTOR (4 DOWNTO 0);   -- Read address 2
        ADDR_3      : IN STD_LOGIC_VECTOR (4 DOWNTO 0);   -- Write address
        WR_Data_3   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);  -- Write data
        RD_Data_1   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Read data 1
        RD_Data_2   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)  -- Read data 2
    );
END ENTITY;

ARCHITECTURE behavioral OF reg_file IS
    TYPE ramtype IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL mem: ramtype := (
        0 => X"00000001", 1 => X"00000002", 2 => X"00000003", 3 => X"00000004",
        4 => X"00000005", 5 => X"00000006", 6 => X"00000007", 7 => X"00000008",
        8 => X"00000009", 9 => X"0000000A", 10 => X"0000000B", 11 => X"0000000C",
        12 => X"0000000D", 13 => X"0000000E", 14 => X"0000000F",
        others => X"00000000"
    );
BEGIN
    PROCESS(clock)
    BEGIN
        IF rising_edge(clock) THEN
            -- Write operation
            IF WR_EN = '1' THEN
                mem(to_integer(unsigned(ADDR_3))) <= WR_Data_3;
            END IF;
            
        END IF;
        IF falling_edge(clock) THEN
            -- Read operation
            RD_Data_1 <= mem(to_integer(unsigned(ADDR_1)));
            RD_Data_2 <= mem(to_integer(unsigned(ADDR_2)));
        END IF;
    END PROCESS;
END behavioral;