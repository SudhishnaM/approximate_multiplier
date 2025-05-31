# approximate_multiplier

This project implements an *approximate 4x4-bit binary multiplier* in Verilog. The design uses custom approximation techniques to reduce area, power, and logic complexity while maintaining acceptable accuracy for error-tolerant applications.

Overview
This 4x4-bit approximate multiplier is implemented using a combination of basic logic gates, half adders, full adders, and custom compressors. The design strategically replaces some exact arithmetic operations with approximate ones to reduce logic complexity, area, and power consumption. Key techniques include the use of OR-AND logic in place of full adders and compressors, along with simplified carry handling to minimize critical path delays.

approximation techniques:

1. half_adder
Implements the standard half-adder logic:
sum = x ^ y
carry = x & y
This is used for partial sum generation where only two inputs are involved.

2. full_adder
This module approximates the carry logic:
sum = x ^ y ^ z
carry = y (Instead of full logic: carry = (x & y) | (y & z) | (z & x))
This simplifies hardware but may introduce some error, which is tolerable in approximate designs.

3. compressor
The compressor reduces four inputs to two outputs (out1, out2) using OR and XOR approximations:
out1 = (i1 | i2) ^ (i3 | i4)
out2 = (i1 | i2) & (i3 | i4)
This significantly reduces logic depth and improves speed.

➤ Partial Product Generation
Standard AND logic is used to compute 16 partial products from inputs A[3:0] and B[3:0].

➤ Approximation Stage
Partial products are combined in pairs using OR (for sum) and AND (for carry). This allows early-stage reduction without full adders.

➤ Intermediate Reduction
These simplified terms are processed through a sequence of:
Half adders for 2-input sums.
Compressors for 4-input approximate reductions.
Full adders for selected 3-input stages.
This hybrid method enables balance between speed, power, and accuracy.

➤Final Output Assembly
The final 8-bit product P[7:0] is constructed using a combination of outputs from half adders, full adders, and compressors used in intermediate stages:
P[0] is directly assigned from the least significant partial product pp0, ensuring accuracy at the LSB.
P[1] to P[6] are computed through a staged reduction tree using:
Approximated pairwise OR-AND operations.
Compressors to reduce four inputs to two outputs.
Half adders for efficient 2-input addition.
Full adders with simplified carry logic for balanced accuracy and performance.
P[7], the most significant bit, is derived using a final half adder to include remaining carry outputs.
This structure ensures that the multiplier outputs an approximate but computationally efficient result for A × B, making it well-suited for low-power and error-tolerant applications.

# Results and Analysis
Mean relative error: 8.875% (less than 15%)
![1](https://github.com/user-attachments/assets/55d52fab-18fa-4c8d-a328-defc38fe4a15)


LUT Utilization: Number of LUTs = 8 (less than 12)
![2](https://github.com/user-attachments/assets/39f8bca4-4b49-4271-b648-9af893867f87)


Power Utilization: 
![3](https://github.com/user-attachments/assets/3334c972-86c5-44a4-a061-578a2ef0eaf6)



