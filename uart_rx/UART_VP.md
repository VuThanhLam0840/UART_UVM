# UART VP

## 1. Overview

This verification plan covers the UART receive DUT implemented in [receiver.v](d:\HOCTAP\CE434_TKVM1\uart_rx\dut\receiver.v). The DUT receives a serial UART stream and reconstructs one 8-bit data byte.

From the RTL and repo documentation, the intended protocol is:

- Clock frequency: 10 MHz
- Baud rate: 115200
- `CLKS_PER_BIT = 87`
- Frame format: 1 start bit, 8 data bits, 1 stop bit
- Data order: LSB first
- No parity
- Output behavior: `o_Rx_Byte[7:0]` holds the received byte and `o_Rx_DV` pulses high for one clock after a frame completes

The testbench architecture in this repo uses:

- A master UART agent to drive serial RX stimulus
- A slave monitor to observe DUT outputs
- A scoreboard to compare expected vs actual data
- A configuration object `uart_cfg` for error-injection control
- A transaction object `uart_tlm` that also supports functional coverage

## 2. DUT Features To Verify

The following behavior is directly visible in the RTL and must be verified:

1. Idle detection
   - While line is high, receiver remains in IDLE.

2. Start-bit qualification
   - A low level on `i_Rx_Serial` moves the DUT out of IDLE.
   - The DUT checks the middle of the start bit.
   - If the start bit is not still low at the middle sample point, the DUT returns to IDLE.

3. Data-bit capture
   - Exactly 8 bits are sampled.
   - Sampling occurs once per bit time.
   - Data is captured LSB first into `o_Rx_Byte`.

4. Stop-bit phase
   - The DUT waits one stop-bit interval after the 8th data bit.
   - At the end of the stop-bit interval, `o_Rx_DV` is asserted.

5. Valid pulse generation
   - `o_Rx_DV` is asserted for one clock only.
   - `o_Rx_DV` returns low in cleanup/idle.

6. Byte retention
   - `o_Rx_Byte` reflects the last successfully received byte.

7. Synchronization robustness
   - The double-register input path does not corrupt correctly timed serial data.

## 3. Verification Scope

### In Scope

- Correct reception of legal UART frames
- Data ordering and byte reconstruction
- `o_Rx_DV` pulse timing and width
- Back-to-back legal frames
- Rejection of a false start bit
- Error-injection behavior already implied by `uart_err_test` and `uart_cfg`
- Functional coverage of key byte patterns defined in `uart_tlm.sv`

### Out of Scope

- Parity checking
- Configurable baud rate
- Break detection
- Framing error reporting signal in DUT
- Overrun buffering/FIFO behavior
- Reset behavior inside DUT, because `receiver.v` has no reset port

## 4. Testbench Strategy

### Stimulus

The driver forms a 10-bit frame:

- Start bit = `0`
- Data byte = `rx_data[7:0]`, transmitted LSB first
- Stop bit = `1`

The driver sends:

- Directed pattern traffic
- Random byte traffic
- Error-injected traffic when `inject_err == 1`

### Checking

The scoreboard compares:

- Reference transaction from the master agent: `rx_data`
- Actual transaction from the monitor: `o_data`

Expected results:

- Normal mode: `o_data == rx_data`
- Error injection mode: comparison should fail as expected

The monitor also checks:

- A legal stop bit is observed on the serial stream
- `o_valid` asserts after frame completion
- `o_valid` timeout is detected if the DUT fails to respond

## 5. Planned Tests

### Test 1: `uart_demo_test`

Purpose:
- Baseline sanity test for nominal UART reception

Stimulus:
- Send 10 legal UART frames using randomized `rx_data`

Checks:
- Every transmitted byte is received correctly
- `o_valid` is observed once per legal frame

Expected result:
- All packets match in scoreboard

### Test 2: Directed data-pattern test

Purpose:
- Validate corner patterns and bit ordering

Stimulus:
- Send these directed values:
  - `8'h00`
  - `8'hFF`
  - `8'h55`
  - `8'hAA`
  - Additional mixed values such as `8'h01`, `8'h80`, `8'h3C`, `8'hC3`

Checks:
- Data matches exactly
- LSB-first reconstruction is correct

Expected result:
- All packets match in scoreboard

### Test 3: Back-to-back frame test

Purpose:
- Verify consecutive legal frames with minimal idle spacing

Stimulus:
- Send multiple legal frames continuously

Checks:
- No packet loss
- No duplicated packet
- `o_valid` pulses once per frame

Expected result:
- Scoreboard match for every frame

### Test 4: False-start rejection test

Purpose:
- Verify the DUT returns to IDLE when a start bit is not valid at the mid-bit sample point

Stimulus:
- Pull RX low briefly, then return high before the mid-start-bit sample

Checks:
- No `o_valid`
- No packet appears at monitor/scoreboard output

Expected result:
- Receiver ignores the false frame

### Test 5: Error injection test `uart_err_test`

Purpose:
- Demonstrate the negative-checking path using `inject_err`

Stimulus:
- Driver corrupts the transmitted data when `inject_err == 1`

Checks:
- Scoreboard detects mismatch relative to the original reference byte
- Failure is treated as expected behavior for this mode

Expected result:
- Negative test passes by observing intended mismatch behavior

### Test 6: Long random regression

Purpose:
- Improve confidence over a larger sample size

Stimulus:
- Random legal frames over an extended run

Checks:
- No unexpected mismatches
- Coverage goals are met

Expected result:
- Clean scoreboard and closure of functional coverage bins

## 6. Functional Coverage Plan

Functional coverage should be implemented in `uart_tlm.sv` using the transaction event `sample_e`.

### Coverpoints

1. RX byte pattern coverage
   - `8'h00`
   - `8'hFF`
   - `8'h55`
   - `8'hAA`
   - All other values

2. Test mode coverage
   - Normal mode (`inject_err = 0`)
   - Error injection mode (`inject_err = 1`)

3. Frame spacing coverage
   - Isolated frame
   - Back-to-back frame

4. Start validation coverage
   - Legal start bit accepted
   - False start rejected

### Coverage Goals

- 100% hit on directed pattern bins
- At least one run of error-injection mode
- At least one false-start scenario
- At least one back-to-back frame scenario

## 7. Assertions / Protocol Checks

If assertions are added later, recommended checks are:

1. `o_Rx_DV` pulse width is exactly 1 clock.
2. `o_Rx_DV` only asserts after 8 data bits plus 1 stop bit.
3. No `o_Rx_DV` on false-start rejection.
4. A legal frame eventually produces one valid pulse.

## 8. Pass / Fail Criteria

The verification effort is considered complete when:

- All planned tests run to completion
- No unexpected UVM errors or fatals occur
- All legal-frame comparisons pass
- Negative test behavior is observed as intended
- No leftover reference packets remain in the scoreboard FIFO at end of test
- Functional coverage goals are met

## 9. Risks / Assumptions

- The DUT has no reset input, so internal state reset verification is not part of this plan.
- The current repo is a lab skeleton with multiple `Todo` sections, so this VP describes the intended completed environment behavior.
- The monitor is expected to use the generated `uart_clk` to align serial sampling with the driver.

## 10. Traceability Matrix

| DUT Requirement | Source in Code | Verification Method | Planned Test |
|---|---|---|---|
| Idle when RX high | `s_IDLE` in `receiver.v` | Directed check | False-start test |
| Mid-start-bit validation | `s_RX_START_BIT` in `receiver.v` | Directed negative test | False-start test |
| Capture 8 bits LSB first | `s_RX_DATA_BITS` in `receiver.v` | Scoreboard compare | Demo test, directed patterns |
| Stop-bit wait before valid | `s_RX_STOP_BIT` in `receiver.v` | Monitor timing check | Demo test, back-to-back test |
| One-cycle valid pulse | `s_CLEANUP` in `receiver.v` | Monitor/assertion | Demo test, regression |
| Correct byte output | `r_Rx_Byte` assignment | Scoreboard compare | All positive tests |

