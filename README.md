# 🚁 3DOF Helicopter Elevation Advanced Control System

An advanced aerospace control engineering project focused on developing and simulating a robust 2-DOF control architecture (PID with dynamic prefilter) for a 3DOF laboratory helicopter plant manufactured by Quanser Consulting. The system leverages MATLAB and Simulink to linearize plant dynamics, model parametric uncertainties, and minimize multi-objective cost functions to optimize absolute tracking performance and flight stability.

---

## 🔗 Project Resources & Live Demo

You can access the full project simulation files and documentation via the link below:

https://drive.google.com/drive/folders/11j7oxraGqaNKVxbQ-9ePE6ddVqXM0jxN

---

## 📊 Plant Mathematical Modeling & Constraints

The dynamic model focuses on the helicopter's **elevation angle (theta)** while mitigating cross-coupling non-linearities. The elevation dynamics were obtained utilizing Lagrange's equations and linearized around the nominal operation point (theta_0 = 0 degrees), yielding a second-order transfer function with an inherent time-delay (T):

$$P(s) = \frac{k \cdot \omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2} \cdot e^{-sT}$$

### Real-World Nonlinearities Addressed:
* **Actuator Constraints:** Strict motor voltage saturation limits enforced at +/-10 V.
* **Sensor Limitations:** High-frequency quantization noise effects modeled at 0.0015 rad.
* **Parametric Uncertainty:** Evaluated across worst-case tolerance intervals (k: 0.1 to 0.15, zeta: 0.03 to 0.05, omega_n: 1.0 to 1.5) under a counter-mass configuration of 19 g.

---

## 💻 Controller Design & Multi-Objective Optimization

The system implements a **2-DOF controller structure** combining a Proportional-Integral-Derivative (PID) loop reinforced with **Anti-windup Clamping** alongside a custom reference prefilter to smooth command inputs and prevent overshoot.

### Control Parameters Configured:
* **PID Gains:** Kp = 150.0, Ki = 0.001, Kd = 80.0
* **Filter Derivative Coefficient (N):** 200
* **Prefilter Transfer Function:** num_F = [1], den_F = [0.1, 1]

### Optimization Results & Cost Function Metrics:
The system was validated via a dynamic script designed to calculate a multi-objective cost function (J) over a 120.00-second mission profile, achieving zero crash penalties:

| Optimization Component Metrics | Calculated Score Value |
| :--- | :--- |
| 🎯 **Tracking Component** | 1.20504 |
| 🛡️ **Disturbance Rejection** | 0.77163 |
| ⛽ **Fuel Consumption** | 0.11796 |
| 🔊 **Noise Rejection** | 0.63936 |
| 💥 **Crash Penalty** | 0.00000 |
| 🏆 **TOTAL MINIMIZED COST (J)** | **2.73399** |

* **Flight Safety Verification:** [PASSED] No crash detected under maximum simulated flight envelope limits.

---

## 🚀 MATLAB & Simulink Verification Screenshots

To verify system transient response stability across all flight operational mission phases (takeoff, ascending, cruise, disturbance rejection, and landing), comprehensive script analysis was completed.

### 1. Optimization Script & Tracking Plots
The control firmware processes the variable tracking inputs, rendering precise transient reactions while rejecting unexpected step disturbances.

<img width="1081" height="531" alt="IMG_5386" src="https://github.com/user-attachments/assets/303cadad-75d6-4f44-a31f-5adcd9ed6ac3" />


### 2. Workspace Command Window Outputs
Successful runtime execution indicating successful cost function numerical breakdown and safety criteria approval.

<img width="1069" height="537" alt="IMG_5385" src="https://github.com/user-attachments/assets/629080f6-73fe-4545-ad28-2ce9cacd02eb" />


### 3. Simulink Architectural Diagram
The complete graphical block layout detailing tracking loops, anti-windup clamping paths, and state-space plant sub-blocks.

<img width="1070" height="525" alt="IMG_5388" src="https://github.com/user-attachments/assets/d19c8b52-bcf6-4e90-bc07-ece2f589cbfe" />


### 4. High-Precision Scope Display
Comparative signal validation between the reference trajectory prefilter channel and the actual physical helicopter feedback.

<img width="1057" height="533" alt="IMG_5387" src="https://github.com/user-attachments/assets/8ed9593f-6a3c-4a7c-93a6-bc1b97982507" />


---

## 👥 Project Owner & Affiliation

- **Lead Engineer:** Eng. Fajr Aldajani
- **Affiliation:** Taif University (Academic Project)
- **Project Status:** Completed Successfully! 🚀
