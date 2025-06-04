# WirelessSensorNodes

This repository is part of a Bachelor Graduation Project for the BSc in Electrical Engineering at TU Delft. It focuses on the design, simulation, and analysis of wireless sensor nodes, emphasizing communication protocols and hardware architecture, with the final goal of designing a wireless sensor network for lunar sensing.

## Table of Contents

* [Overview](#overview)
* [System Architecture](#system-architecture)
* [Project Structure](#project-structure)
* [Getting Started](#getting-started)
* [Simulation](#simulation)
* [Contributing](#contributing)
* [License](#license)

## Overview

The WirelessSensorNodes project aims to develop a modular and scalable wireless sensor network (WSN) prototype. The focus is on simulating node behavior, communication protocols, and evaluating performance metrics.

## System Architecture

The system comprises multiple sensor nodes communicating wirelessly to a central base station. Each node is designed to be energy-efficient and capable of transmitting data reliably.

![System Architecture Diagram](path/to/system_architecture_diagram.png)

*Figure: Block diagram illustrating the wireless sensor network architecture.*

## Project Structure

The repository is organized as follows:

* **`src/`**: Contains the source code for the sensor node simulations.
* **`tb/`**: Includes test benches for verifying the functionality of the modules.
* **`waveforms/`**: Stores waveform outputs from simulations for analysis.
* **`run_sim.bat` / `run_sim.sh`**: Scripts to automate the simulation process on Windows and Unix-based systems, respectively.
* **`.gitattributes` / `.gitignore`**: Configuration files for Git.
* **`README.md`**: This documentation file.

## Getting Started

To set up and run simulations:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/rbithray/WirelessSensorNodes.git
   cd WirelessSensorNodes
   ```



2. **Install Dependencies:**

   Ensure you have the necessary simulation tools installed (iverilog, GTKWave).

3. **Run Simulations:**

   * **Windows:**

     ```bash
     run_sim.bat
     ```

   * **Unix/Linux:**

     ```bash
     ./run_sim.sh
     ```

4. **View Results:**

   Simulation outputs and waveforms will be available in the `waveforms/` directory.

## Simulation

The simulations model the behavior of individual sensor nodes and their communication patterns. Test benches in the `tb/` directory are used to validate the modules.

![Simulation Waveform](path/to/simulation_waveform.png)

*Figure: Example waveform output from a sensor node simulation.*

## Contributing

Contributions are welcome! If you'd like to improve the project, please fork the repository and submit a pull request. For major changes, open an issue first to discuss what you would like to change.


---

---

For more information and updates, visit the [WirelessSensorNodes GitHub repository](https://github.com/rbithray/WirelessSensorNodes).

---

