# 4-Bit Up-Down Counter Verification using SystemVerilog Testbench (SVTB)

A complete functional verification project for a 4-bit up-down counter using a SystemVerilog Testbench (SVTB) with constrained-random stimulus, a scoreboard, functional coverage, and SVA assertions. Simulated on **Aldec Riviera-PRO 2025.04** via [EDA Playground](https://www.edaplayground.com/).

---

## Project Structure

```
├── design.sv          # RTL: 4-bit up-down counter
└── testbench.sv       # SVTB: Generator, Driver, Monitor, Scoreboard, Coverage, Assertions
```

---

## Design Overview

The DUT is a synchronous 4-bit up-down counter with the following interface:

| Port       | Direction | Description                        |
|------------|-----------|------------------------------------|
| `clk`      | Input     | Clock signal                       |
| `rst`      | Input     | Active-high synchronous reset      |
| `enable`   | Input     | Enables counting when high         |
| `up_down`  | Input     | `1` = count up, `0` = count down   |
| `count`    | Output    | 4-bit counter output               |

**Behavior:**
- On reset: `count` resets to `0`
- When `enable = 1` and `up_down = 1`: count increments (`count + 1`)
- When `enable = 1` and `up_down = 0`: count decrements (`count - 1`)
- Wraps around: `15 → 0` (up) and `0 → 15` (down)

---

## Testbench Architecture

```
┌───────────┐    mailbox     ┌───────────┐
│ Generator │ ─────────────► │  Driver   │
└───────────┘   gen2drv      └───────────┘
                                   │ drives
                              ┌────▼─────┐
                              │   DUT    │
                              └────┬─────┘
                                   │ observes
┌───────────┐    mailbox     ┌─────▼─────┐
│Scoreboard │ ◄────────────── │  Monitor  │
└───────────┘   mon2sb       └───────────┘
```

### Components

| Component     | Description |
|---------------|-------------|
| **Transaction** | Data object holding `rst`, `enable`, `up_down`, `count` |
| **Generator**   | Generates 1000 constrained-random transactions |
| **Driver**      | Drives stimulus onto the DUT via virtual interface |
| **Monitor**     | Observes DUT outputs and sends to scoreboard |
| **Scoreboard**  | Reference model — compares expected vs actual count |
| **Coverage**    | Covergroup sampling `enable`, `up_down`, `count`, wrap transitions, and cross coverage |
| **Assertions**  | SVA properties checking reset, enable, count up/down, and wrap-around behavior |

---

## Functional Coverage

Coverage is collected using a covergroup instantiated in the module, sampled automatically on `@(posedge clk)`:

| Coverpoint         | Description                              |
|--------------------|------------------------------------------|
| `cp_enable`        | Covers `enable = 0` and `enable = 1`     |
| `cp_updown`        | Covers `up_down = 0` and `up_down = 1`   |
| `cp_count`         | Covers all 16 states `[0:15]`            |
| `bins wrap_up`     | Transition bin: `15 → 0`                 |
| `bins wrap_down`   | Transition bin: `0 → 15`                 |
| `cross`            | Cross of `cp_enable` and `cp_updown`     |

**Result: 100% Functional Coverage achieved**

---

## SVA Assertions

| Assertion           | Property Verified                                      |
|---------------------|--------------------------------------------------------|
| `reset_check`       | When `rst=1`, `count` must be `0`                      |
| `enable_check`      | When `enable=0`, `count` must remain stable            |
| `count_up_check`    | Count increments by 1 when counting up (non-wrap)      |
| `count_down_check`  | Count decrements by 1 when counting down (non-wrap)    |
| `wrap_up_check`     | Count wraps from `15` to `0` when counting up          |
| `wrap_down_check`   | Count wraps from `0` to `15` when counting down        |

**Result: All assertions passed — zero failures**

---

## Simulation Results

```
Functional Coverage = 100.00 %
Enable coverage     = 100.00%
Up/Down coverage    = 100.00%
Count coverage      = 100.00%
Cross coverage      = 100.00%

Scoreboard: All transactions PASS
Assertions: No failures
```

---

## How to Run

### On EDA Playground
1. Go to [https://www.edaplayground.com](https://www.edaplayground.com)
2. Paste `design.sv` in the **Design** pane
3. Paste `testbench.sv` in the **Testbench** pane
4. Select **Aldec Riviera-PRO** as the simulator
5. Add `-sv` in the **Compile Options** box
6. Add `+access+r` in the **Run Options** box
7. Click **Run**

---

## Tools Used

| Tool            | Version         |
|-----------------|-----------------|
| Simulator       | Aldec Riviera-PRO 2025.04 |
| Language        | SystemVerilog (IEEE 1800-2012) |
| Platform        | EDA Playground  |

---

## Key Concepts Demonstrated

- Interface-based testbench using `virtual interface`
- Constrained-random stimulus generation using `rand` and `randomize()`
- Mailbox-based communication between TB components
- Self-checking scoreboard with reference model
- Functional coverage with covergroups, bins, and cross coverage
- SystemVerilog Assertions (SVA) — both `assert property` and `cover property`
- Directed test sequences for corner case coverage (wrap-around)

---

## Author

> Replace this section with your name, university/organization, and LinkedIn/contact if desired.

```
Name   : Ahalya S Kumar
Email  : 12091998ask@gmail.com
LinkedIn: www.linkedin.com/in/ahalya-sivakumar
```
