# RTL-Scan-Insertion-and-MBIST-Controller

Complete Design-for-Testability (DFT) implementation featuring custom multiplexed scan flip-flops inserted into a 4-bit data pipeline. Includes full ATPG verification in Xilinx Vivado, timing simulations, and quantitative PPA overhead analysis.

---

## Architecture Details

### 1. Scan Chain Insertion (`scan_dut.v` & `scan_flop.v`)

To detect Single Stuck-At (SSA) faults within the logic blocks, the internal registers are stitched into a continuous chain.

* **Scan Flop Logic**: A 2:1 multiplexer controls the input to the D-Flip-Flop. When `Scan Enable (SE) = 0`, normal system data (`D`) is passed. When `SE = 1`, the `Scan In (SI)` test data is shifted through.
* **ATPG Execution Flow**:
  1. **Shift-In**: Assert `SE`. Serially shift the deterministic ATPG test vector into the registers via the `SI` pin.
  2. **Capture**: De-assert `SE` for one clock cycle. The combinational logic evaluates the test vector, and the result is captured back into the flops.
  3. **Shift-Out**: Re-assert `SE`. Serially shift the captured response out via the `Scan Out (SO)` pin to compare with the expected, fault-free golden response.

 ---

### 2. MBIST Controller (`mbist_controller.v` & `target_memory.v`)

Memory arrays are highly dense and prone to specific physical defects (e.g., coupling faults, address decoder faults) that standard logic scans cannot efficiently detect. 

* **Test Algorithm Generation**: The controller utilizes an internal FSM to generate addresses, write known data backgrounds (e.g., `0x00`, `0xFF`, `0x55`, `0xAA`), and generate the required memory control signals (Write Enable, Chip Select).
* **Autonomous Verification**: It reads the data back from the `target_memory.v` and feeds it into an internal comparator.
* **Status Flags**: The controller outputs external `BIST_DONE` and `BIST_PASS`/`BIST_FAIL` signals, completely eliminating the need for an external tester to access internal memory buses.
---

## Signal Definitions

The internal logic and module ports utilize the following key signals:

| Signal Name | Description |
| :--- | :--- |
| `clk` / `rst_n` | Master clock / Active-low system reset |
| `se` / `si` / `so` | Scan enable / Serial scan input / Serial scan output |
| `bist_start` / `bist_done` | MBIST test trigger / Test sequence execution complete flag |
| `bist_pass` / `bist_fail` | Memory test status pass flag / Memory defect detected flag |
| `mem_addr` / `mem_wdata` | Target memory address bus / Target memory write data bus |
| `mem_rdata` / `mem_we` | Target memory read data bus / Memory write enable control signal |

---

## Verification and Simulation

The design includes a comprehensive, self-checking Verilog testbench suite (`tb_scan_chain.v` and `tb_mbist.v`). It features automated stimulus application, clock generation, and self-checking output monitors.

### Waveform Analysis

The simulation proves correct Shift-In $\rightarrow$ Capture $\rightarrow$ Shift-Out timing phases for scan chain testing, as well as autonomous memory address sweeping during MBIST execution.

<img width="1550" height="309" alt="Screenshot 2026-09-03 205311" src="https://github.com/user-attachments/assets/c6bcc29d-a2d0-499e-a2f2-73e12a3aa677" />

<img width="1552" height="309" alt="Screenshot 2026-09-03 205839" src="https://github.com/user-attachments/assets/08ee2be6-cd14-4e29-ad22-68916206dc36" />

---

### Automated Checker Results

A dedicated verification monitor checks the scan out serial vectors and memory read outputs directly against expected golden patterns, ensuring 100% fault detection coverage and zero data corruption.

<img width="414" height="109" alt="Screenshot 2026-09-03 205443" src="https://github.com/user-attachments/assets/0c3e7fa3-bca7-4105-b578-0aefe12c1e0a" />

<img width="738" height="129" alt="Screenshot 2026-09-03 205855" src="https://github.com/user-attachments/assets/f0301fbf-f720-468c-a401-2d864afbcf16" />



