# YouBot Kinematics and Control using MATLAB and CoppeliaSim

This repository contains MATLAB scripts and CoppeliaSim models for kinematics control of the YouBot robot. The project involves using MATLAB to control the robot's arm and perform trajectory tracking, with integration to CoppeliaSim (2024 version).

---

## Prerequisites
1. Install **CoppeliaSim 2024 version**.
2. Install MATLAB
3. Ensure that the `remoteApi` files (in `vrep_lib`) are correctly set up.

---

## File Structure

### Key Directories
- **env/**
  - Contains the CoppeliaSim environment files.
  - `youbot.ttt` - Full YouBot simulation.
  - `youbot_just_arm.ttt` - Simulation with only the arm.
- **video/**
  - `arm_wheel.mp4` - Demonstrates arm and wheel control.
  - `just_arm.avi` - Demonstrates only the arm control.
- **vrep_lib/**
  - Contains the `remoteApi` library files for communication between MATLAB and CoppeliaSim.
- **vrep_sim/**
  - Includes `vrep_model.ttt` - The main CoppeliaSim scene used for this project.

### Key Scripts
- `simple_tracker_arm_KC.m`:
  - Executes the trajectory tracking for the arm.
  - Automatically connects to the CoppeliaSim simulation.
- `simple_tracker_KC.m`:
  - Performs trajectory tracking for the entire YouBot.

---

## Usage

### Steps to Run
1. **Start the CoppeliaSim simulation:**
   - Navigate to the `vrep_sim/` folder.
   - Open `vrep_model.ttt` in CoppeliaSim.
   - Start the simulation.

2. **Run MATLAB script:**
   - Open MATLAB.
   - To control only the arm:
     ```matlab
     simple_tracker_arm_KC
     ```
   - To control the full robot:
     ```matlab
     simple_tracker_KC
     ```

---

## Explanation of Scripts and Functions
- **`ForKin.m`**:
  - Computes the forward kinematics of the YouBot arm.
- **`InvKin.m`**:
  - Computes the inverse kinematics of the YouBot arm for desired end-effector positions.
- **`Jacob.m`, `Jacob2.m`, `JacobM.m`**:
  - Functions for calculating the Jacobian matrix.
  - Used in trajectory tracking and velocity computation.
- **`TransKuka.m`**:
  - Handles transformations specific to manipulator.
- **`VrepConnector.m` / `VrepConnector0.m`**:
  - Establishes communication between MATLAB and CoppeliaSim.
- **`remApi.m`**:
  - Handles remote API functions for communication with CoppeliaSim.

---

## Videos
### Arm and Wheel Control

https://github.com/user-attachments/assets/66c4736d-f980-4094-9eef-ecc408b97bc8

---

https://www.youtube.com/watch?v=2eKb2sDePR8

## Notes
- Ensure that the `remoteApi` library files are in the MATLAB path before running any scripts.
- The scripts are compatible with MATLAB R2020a and later.
- All functions are modular and can be used independently for other kinematic and control tasks.

---

## author
[Masoud Amirkhani]
