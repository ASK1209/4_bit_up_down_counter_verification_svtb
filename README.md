# Up/Down Counter Verification Project

A **SystemVerilog verification environment** for a **4-bit Up/Down Counter**, implemented and simulated on **EDA Playground** using **Aldec Riviera Pro**.

## 🚀 Quick Run

You can view and run this project directly in your browser here:

https://www.edaplayground.com/x/qbCP


---

## 🛠️ Verification Features

* **Randomized Stimulus**
  Uses a SystemVerilog **transaction class** with `rand` variables to generate random combinations of:

  * `enable`
  * `up_down`

* **Transaction-Based Testbench Architecture**
  The testbench follows a modular structure consisting of:

  * **Generator** – produces randomized transactions
  * **Driver** – applies stimulus to the DUT through an interface
  * **Monitor** – observes DUT signals and forwards them for checking
  * **Scoreboard** – compares DUT outputs against a reference model

* **Reference Model (Golden Model)**
  The scoreboard maintains an internal **expected counter value** and compares it with the DUT output on every clock cycle.

  If a mismatch occurs, the testbench reports an error using `$error`.

* **Assertions (SystemVerilog Assertions - SVA)**
  Several properties verify the correct behavior of the counter:

  * Reset forces the counter to **0**
  * Counter holds value when `enable = 0`
  * Counter increments correctly when counting up
  * Counter decrements correctly when counting down
  * Wrap-around behavior:

    * `15 → 0` when counting up
    * `0 → 15` when counting down

* **Functional Coverage**
  A `covergroup` ensures that important functional scenarios are exercised:

  * Enable signal conditions
  * Up and down counting directions
  * All counter states from **0–15**
  * Cross coverage of **enable × up_down**

* **Waveform Analysis**
  Simulation waveforms are generated and can be viewed using **EPWave** to observe:

  * `clk`
  * `rst`
  * `enable`
  * `up_down`
  * `count`

---

## 📁 Project Structure

* `design.sv`
  RTL implementation of the **4-bit Up/Down Counter** using `always_ff` logic.

* `testbench.sv`
  SystemVerilog verification environment containing:

  * interface
  * transaction class
  * generator
  * driver
  * monitor
  * scoreboard
  * SystemVerilog assertions
  * functional coverage
  * waveform dumping

* `README.md`
  Documentation describing the verification methodology and project details.

---

## 📊 How to View Coverage

The simulation prints coverage results in the console at the end of execution.

Steps:

1. Run the simulation on **EDA Playground**.
2. Scroll to the bottom of the simulation log.
3. Observe the coverage report.

Example output:

```
Simulation completed
Functional Coverage = 100.00 %

Enable coverage    = 100%
Up/Down coverage   = 100%
Count coverage     = 100%
Cross coverage     = 100%
```

---

## 🔍 Design Behavior Verified

The verification environment confirms correct operation of the counter under the following conditions:

* Reset behavior
* Enable/disable operation
* Up counting
* Down counting
* Counter wrap-around conditions
* Correct sequential updates on clock edges

---

## 🎯 Key Verification Concepts Demonstrated

This project demonstrates several important **Design Verification concepts**:

* Class-based verification environment
* Transaction-based stimulus generation
* Mailbox communication between verification components
* Interface-based DUT connectivity
* Self-checking scoreboard methodology
* SystemVerilog Assertions (SVA)
* Functional coverage analysis

---

## 👩‍💻 Author
**Ahalya S Kumar** 
Design Verification Engineer  
SystemVerilog | SVA | Functional Coverage | UVM (Learning)

