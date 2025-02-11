-- Praktikum EL3011 Arsitektur Sistem Komputer
-- Modul		: 3
-- Tugas		: 1
-- Tanggal		: 18 Desember 2024
-- Kelompok		: 09/07
-- Rombongan	: D/C
-- Nama (NIM) 1	: Kean Malik Aji Santoso (13222083)
-- Nama (NIM) 2	: Raifal Abyan Rosaldi (13222053)
-- Nama File 	: data_memory.vhd
-- Deskripsi	: Implementasi Data Memory dengan Altera MegaFunction ALTSYNCRAM

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY altera_mf;
USE altera_mf.all;

ENTITY data_memory IS
    PORT (
        ADDR: IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Address
        WR_EN: IN STD_LOGIC;                    -- Write Enable
        RD_EN: IN STD_LOGIC;                    -- Read Enable
        clock: IN STD_LOGIC;                    -- Clock signal
        RD_Data: OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- Read data (output)
        WR_Data: IN STD_LOGIC_VECTOR (31 DOWNTO 0)   -- Write data (input)
    );
END ENTITY;

ARCHITECTURE structural OF data_memory IS
    COMPONENT altsyncram
        GENERIC (
            init_file: STRING;        -- Initialization file (.mif)
            operation_mode: STRING;   -- Memory operation mode
            widthad_a: NATURAL;       -- Address width
            width_a: NATURAL          -- Data width
        );
        PORT (
            wren_a: IN STD_LOGIC;                    -- Write enable
            rden_a: IN STD_LOGIC;                    -- Read enable
            clock0: IN STD_LOGIC;                    -- Clock signal
            address_a: IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Address input
            q_a: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);   -- Data output
            data_a: IN STD_LOGIC_VECTOR(31 DOWNTO 0)  -- Data input
        );
    END COMPONENT;

    SIGNAL read_buffer: STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
    PROCESS(clock)
    BEGIN
        IF falling_edge(clock) and (RD_EN = '1') THEN
			RD_Data <= read_buffer;
        END IF;
    END PROCESS;

    -- Instantiate altsyncram component
    altsyncram_component : altsyncram
        GENERIC MAP (
            init_file => "dmemory.mif",
            operation_mode => "SINGLE_PORT",
            widthad_a => 8,
            width_a => 32
        )
        PORT MAP (
            wren_a => WR_EN, -- Controlled by write process
            rden_a => RD_EN,  -- Controlled by read process
            clock0 => clock,                 -- Clock signal
            address_a => ADDR,               -- Address input
            q_a => read_buffer,                  -- Data output
            data_a => WR_Data                -- Write data input
        );
END structural;