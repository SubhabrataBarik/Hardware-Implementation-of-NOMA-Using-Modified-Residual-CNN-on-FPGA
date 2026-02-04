BTP Thesis Final write up
Abstract
Non-orthogonal multiple access (NOMA) is a promising solution to the problem of spectrum deficiency. NOMA receivers require information about the modulation type of the co-scheduled user’s signal to perform successive interference cancellation (SIC). Automatic modulation classification (AMC) is used to reduce the signal overhead created due to sharing of this information. 
In this paper, we have taken a convolutional neural network (CNN) with a modified residual block (MR-CNN) is proposed for AMC in NOMA systems from [1]. This model we have implemented in Verilog from scratch without using HLS. The classification performance of MR-CNN is evaluated on the input signal with four different modulation formats at varying signal to noise ratios (SNRs). Experimental results demonstrate the proposed model can achieve more than 90% classification accuracy for SNRs higher than 10𝑑𝐵. Further, comparative analysis depicts that the proposed model outperforms existing methods in terms of classification accuracy at low SNRs and has similar performance at high SNRs. 
Index Terms—Non-orthogonal multiple access (NOMA), automatic modulation classification (AMC), convolution neural network(CNN),Convolutional residual block, Verilog, Hardware, FPGA

Introduction

Introduction to 6G and Its Advancements
The transition to 6G is driven by its potential to deliver significant improvements over 5G, including higher capacity, faster speeds, and reduced latency. These enhancements are critical for supporting emerging technologies such as artificial intelligence, autonomous vehicles, and immersive experiences, enabling transformative applications across industries. Unlike 5G, where mobile edge computing is an add-on feature, 6G will inherently integrate edge and core computing into a unified communications and computation infrastructure framework. This integration is expected to provide substantial benefits, including better access to AI-driven capabilities and enhanced support for advanced mobile devices and systems.
Non-Orthogonal Multiple Access (NOMA) in Future Networks
Non-Orthogonal Multiple Access (NOMA) is being adopted in modern communication systems due to its ability to improve spectral efficiency, facilitate massive connectivity, and reduce latency, particularly in 5G and beyond. Unlike traditional Orthogonal Multiple Access (OMA) techniques, NOMA allows multiple users to share the same time and frequency resources by leveraging power-domain multiplexing. In 6G, NOMA is anticipated to play a central role by further enhancing spectral efficiency, ultra-reliable low-latency communications (URLLC), and support for large-scale connectivity. Its integration with emerging technologies such as artificial intelligence, reconfigurable intelligent surfaces (RIS), and terahertz (THz) communications will be essential in meeting the stringent demands of future wireless networks.
NOMA introduces power as a new dimension in resource allocation, complementing existing dimensions such as frequency, time, space, and code. This approach offers several advantages over conventional OMA, including superior spectral efficiency through simultaneous multi-user transmission and interference mitigation via Successive Interference Cancellation (SIC). Additionally, NOMA supports a higher number of connected devices, reduces latency by eliminating the need for scheduled time slots, and improves fairness by dynamically allocating power between strong and weak users. These characteristics make NOMA particularly effective in enhancing cell-edge throughput and overall user experience.
Successive Interference Cancellation (SIC) and Its Role in NOMA
Successive Interference Cancellation (SIC) is a fundamental signal processing technique in modern communication systems, particularly in NOMA and multi-user detection schemes. It enables the decoding of multiple overlapping signals by sequentially demodulating the strongest signal, reconstructing it, and subtracting its contribution from the composite signal before processing the next strongest signal. This iterative process significantly reduces interference and improves overall system performance. The effectiveness of SIC depends on accurate channel state information (CSI), robust signal detection algorithms, and precise synchronization, making it a critical component in advanced wireless systems such as 5G and 6G.
Automatic Modulation Classification (AMC) for Enhanced SIC Performance
Automatic Modulation Classification (AMC) plays a vital role in optimizing SIC by identifying the modulation schemes of interfering signals, thereby improving signal reconstruction and cancellation accuracy. The integration of deep learning techniques, such as convolutional neural networks, has further enhanced AMC by enabling direct processing of raw signal data without manual feature extraction. This adaptability is particularly valuable in dynamic environments with co-channel interference or densely packed spectra. By leveraging AMC, SIC-based systems can achieve higher spectral efficiency, better interference management, and improved reliability, making it indispensable for next-generation wireless technologies, including cognitive radio and spectrum-sharing applications.
Hardware Implementation of NOMA-SIC
In this work, we implement the NOMA-SIC model proposed in [1] in hardware. After successfully replicating the software model and validating its alignment with the original paper, we proceed to the hardware implementation phase. Unlike conventional approaches that rely on High-Level Synthesis (HLS), which often introduces inefficiencies due to abstraction and lack of direct hardware control, we adopt a custom design methodology. By developing all components from scratch, we gain finer control over the hardware architecture, enabling optimizations such as pipelining, folding, and resource-aware scheduling. This approach not only improves performance but also provides deeper insight into the model’s operational dynamics, ensuring a more efficient and scalable implementation.

Proposed digital VLSI Architecture/system design

System overview: - 

i)	Block level view
 [4][5][6][7]

This is a flow diagram showing a system architecture for Automatic Modulation Classification (AMC) in a NOMA (Non-Orthogonal Multiple Access) system, eventually targeting FPGA hardware implementation.

Basic NOMA System Model (Fig 3(a))
The BS (Base Station) sends signals to multiple users (UE₁ and UE₂) using NOMA. This signal is received by user. Which will then process the signal
Middle block: Internal Processing (Fig 3(b))
Received Signal goes into a Pre-processing Block. Inside the NOMA block we have SIC (Successive Interference Cancellation) helped separate users' signal, a Machine Learning Unit (SVM - Support Vector Machine) does part of the signal analysis and AMC (Automatic Modulation Classification) identifies the modulation type. SINR Estimation estimates Signal-to-Interference-plus-Noise Ratio.

Separation: First and second users' received symbols are separated. Finally, a Link Control Unit adjusts link parameters (like power and adaptation).
This block handles signal analysis, classification, and separation of users.

Bottom block: MR-CNN Architecture for AMC (Fig 3(c))
They use a Modified Residual Convolutional Neural Network (MR-CNN) for AMC. We have the Network architecture as follows
o	Input → Convolution layers → Modified Residual Blocks → Average Pooling → Dense Layers → Output.
Modified Residual Block structure is shown (with 2 convolution branches merged) and Architecture for one neuron is also shown
This CNN is optimized for detecting modulation formats.



ii)	Proposed AMC in [1] 
 
 

Let’s take a quick look at internal parameters 

 
This is the original model, but after incites from the author we discovered some mistakes, mainly related to dimension of layers, exposed due to mismatch between formula and reality.

Our updated model is as follows

 

The Modified Residual Convolutional Neural Network (MR-CNN) proposed for Automatic Modulation Classification (AMC) in Non-Orthogonal Multiple Access (NOMA) systems is designed to extract discriminative features from received signals with high efficiency. The network accepts an input tensor of dimension (2, 200, 1), corresponding to two channels and 200-time samples. The initial feature extraction is performed through a convolutional layer with 64 filters, followed by a secondary convolutional layer with 32 filters. Thereafter, two parallel convolutional paths, each with 16 filters, are employed, and their outputs are concatenated to enhance feature diversity and representation. An average pooling operation follows, reducing the spatial dimensions while preserving critical features. This block structure is repeated with additional convolutional layers and a second concatenation. A final convolutional layer with 8 filters processes the pooled feature maps before the feature space is flattened. The flattened vector is passed through three dense layers with 128, 24, and 4 neurons, respectively, where the final dense layer performs modulation classification among four classes. The use of modified residual blocks through concatenation facilitates improved feature propagation and network convergence. The overall architecture is optimized for reduced computational complexity, making it highly suitable for VLSI implementation and real-time deployment on FPGA platforms targeting AMC tasks in NOMA systems.


iii)	Data Path

Now we will look at each block one by one

Convolution Block

Underlying equation for CNN Blocks

The pth filter in the qth layer has parameters denoted by the 3-dimensional tensor. 
W(p,q) = [w (p,q) ijk ]  -> W is filter matrix , 
The indices i, j, k indicate the positions along the height, width, and depth of the filter.
H(q) = [h (q) ijk ]  -> Layers on which computation takes place
Lq*Bq -> dimension on input
Fq-> Length of filter in the respective dimension

 
[8]

Convolution block 2x8,64

Convolution Block (2×8, 64) Explanation
The convolution block highlighted in the diagram performs a 2-dimensional convolution with the following characteristics:
•	Kernel size: 2×8
•	Number of output channels (filters): 64
This means that for each convolutional operation:
•	A filter of size 2×8 is applied across the input feature maps.
•	Each filter slides over the input spatial dimensions
•	A total of 64 such filters are used, producing 64 output feature maps.
Input and Output Dimensions
•	The input to this block appears to be of shape 3×207, representing three channels or stacked inputs of size 207. Which are processed by making two parts (1,2) x 207 and (2,3)x 207. The third row (index 3) is zero-padded to preserve dimensions during convolution.
•	The output of the convolution block is shaped 1×200×64 where:
o	1 represents a compressed or reduced dimension after convolution 
o	200 represents the length of the sequence dimension after convolution.
o	64 corresponds to the number of output channels produced by the filters.

 

Now let’s look at inside one convolution block
 
Architecture of One Convolution Rectangle in Block 1
This figure provides an internal view of a single processing unit used in a convolution block. It consists of the following components:
1. BRAM (Block RAM)
•	Function: Stores input filters and kernel weights.
•	Interface: Outputs two 16-bit data values to the multiplication unit.
•	These represent the input feature value and the corresponding weight.
2. Multiplier Unit
•	Inputs: Two 16-bit values.
•	Output: A 32-bit product from the multiplication of input data and weight.
•	Purpose: Performs the core operation of the convolution by computing the element-wise product.
3. Adder Unit
•	Inputs: 32-bit multiplier output and previous accumulated value from the register.
•	Output: A 32-bit sum.
•	Purpose: Accumulates the sum of products to implement the MAC (Multiply-Accumulate) operation required in convolution.
4. Register (Reg)
•	Function: Temporarily stores the accumulated sum from the adder.
•	Feedback Loop: Feeds the stored sum back into the adder for accumulation in the next cycle.
5. Block 2 Interface
•	Function: Passes the final accumulated result to the next processing block.
•	Output Width: 16-bit, downscaling from 32-bit precision. How it is done is shown below
 
Block 2: Output Control and Quantization Logic
Key Functionalities:
1.	Input Register Bank (b entries{31:12}):
o	A row of outputs from multiple convolution units is passed into this block.
o	Each rectangle represents one bit.
2.	Fixed-Point Format:
o	Values are in 8.24 fixed-point representation (8 bits for the integer part and 24 bits for the fraction).
o	The target format is 4.12 (4 bits for integer, 12 for fraction), for truncation and precision control.
3.	MUX Operation 1: Precision Control
o	Compares the incoming value b with a maximum threshold.
o	If {b} > max(4.12), output is capped at max(4.12).
o	Otherwise, value is truncated from 8.24 to 4.12.
o	The multiplexer selects between max(4.12) and the truncated value.
4.	MUX Operation 2: ReLU activation behaviour (setting negative outputs to 0)
o	Secondary MUX decides whether the value is negative based on sign bit
Now let’s move to next block Convolution 2x4,32 

Convolution Block (2×4, 32) Explanation
Input and Dimensions:
•	Input Shape:
2 × 203 × 64
This implies:
o	2 rows (representing stacked features),
o	203 columns (sequence length),
o	64 input channels (from the previous layer).
•	Padding:
Padding is applied to the input to preserve alignment and output dimensions after convolution.

Convolution Operation:
•	Kernel Size:
2 × 4
Each kernel slides over a 2-row × 4-column region from the input.
•	Number of Filters:
32
32 different 2×4 filters are applied to the input. Each produces one output channel.
•	Per-Channel Operation:
For each of the 64 input channels:
o	Sliding 2×4 kernels compute local weighted sums.
o	Results are summed across channels (as per standard convolution).
o	This is done 32 times with different filters → yields 32 output feature maps.

Output Shape:
•	Shape:
1 × 200 × 32
o	1: Result of reducing across 2-row input 
o	200: Sequence dimension is slightly reduced from 203 due to kernel width (4) and padding.
o	32: Number of output filters.

Processing Architecture:
•	Parallel Units:
The diagram shows 32 parallel blocks, each processing the 64-channel input independently. This maps well to parallel filter banks in hardware (e.g., 32 MAC pipelines).

 


Average Pooling block 

The average pooling operation in the qth layer is applied over a 3-dimensional input tensor to reduce its spatial dimensions.
The input feature map is denoted as:

H⁽q⁾ = [h⁽q⁾ᵢⱼₖ]
 

where i, j, and k denote the positions along the height, width, and depth dimensions, respectively.
The pooling window is defined with a size of Pq × Qq, where Pq and Qq represent the height and width of the pooling region.
The output after pooling is given by:

h⁽q+1⁾ᵢⱼₖ = (1 / (Pq × Qq)) × Σʳ₌₀ᴾq₋₁ Σˢ₌₀Qq₋₁ h⁽q⁾ᵢ₊ʳ,ⱼ₊ˢ,ₖ

 

for all valid i, j, and k in the output dimensions.
This operation computes the mean value over non-overlapping or overlapping rectangular regions of the input, thereby reducing the spatial dimensions while retaining essential information. Average pooling thus plays a critical role in downsampling and improving the computational efficiency of the network.

In pooling we reuse the same hardware putting multiplying factor as 1/ no of elements

 

Taking a closer look at one unit
 
We can see we have added 3 numbers then divided by 3


Modified Residual Block

The modified residual block processes the input through two parallel convolutional layers and merges their outputs through concatenation.
The input feature map is simultaneously fed into:
•	A convolutional layer with a kernel size of 1×8 and 16 output channels.
•	A convolutional layer with a kernel size of 1×1 and 16 output channels.
The outputs from both convolutional operations are concatenated along the depth dimension. This concatenated feature map is then passed to the next layer.
Unlike traditional residual connections that use element-wise addition, the modified block employs concatenation, enabling the network to preserve more spatial information from each parallel path.
The structure enhances the representational capacity of the network while maintaining computational efficiency.

 
 

Dense Layer

The dense (fully connected) layer serves as a crucial component for feature aggregation and decision-making within the neural network. In a dense layer, each input neuron is connected to every output neuron through a trainable weight parameter. Given an input vector 𝑥∈𝑅𝑛, the output 𝑦∈𝑅𝑚 of the dense layer is computed as:
y=Wx+b
where, 
W∈R m×n   is the weight matrix,
b∈R m   is the bias vector,
m is the number of neurons in the dense layer, and
n is the number of inputs.

The dense layer performs a linear transformation followed by an optional non-linear activation function. It is typically placed after convolutional and pooling layers, enabling the model to map high-level extracted features to the desired output space, such as class probabilities in classification tasks.
 

Inside each neuron we have

 


iv)	Control path

Base on internal count signal

 


3.	Performance Analysis

 


4.	FPGA Prototyping
The remaining blocks are taking even more time to run. For future work we will have to optimize hardware. Due to large number of LUTs we cant run on hardware. 
5.	ASIC Chip design
6.	Review and discussion 
We have more work to complete in the future, 
Optimize hardware – on two low levels
				1: block level
				2: module level
Dense Layer verification, which we were doing using software dense layer. But we plan to convert even dense into hardware. FPGA implementation after optimisation

7.	References
[1] A. Parmar, K. Captain, U. Satija, and A. Chouhan, "Modulation Classification for Non-orthogonal Multiple Access System using a Modified Residual-CNN," in Proc. IEEE Wireless Communications and Networking Conference (WCNC), 2023, pp. XX-XX, ISBN: 978-1-6654-9122-8, Doi: 10.1109/WCNC55385.2023.10118621. 

[2] S. M. R. Islam, M. Zeng, and O. A. Dobre, "NOMA in 5G Systems: Exciting Possibilities for Enhancing Spectral Efficiency," IEEE 5G Tech Focus, vol. 1, no. 2, June 2017.

[3] P. Triantaris, E. Tsimbalo, W. H. Chin, and D. Gündüz, "Automatic Modulation Classification in the Presence of Interference," in Proc. European Conference on Networks and Communications (EUCNC), 2023.

[4] Basic NOMA Model.- Kim, Ji-Hwan & Lee, won-Seok & Song, Hyoung-Kyu. (2019). Performance Enhancement Using Receive Diversity with Power Adaptation in the NOMA System. IEEE Access. PP. 1-1. 10.1109/ACCESS.2019.2930990.

[5] NOMA Internal structure - Norolahi, Jafar & Azmi, Paeiz. (2022). A Machine Learning Based Algorithm for Joint Improvement of Power Control, link adaptation, and Capacity in Beyond 5G Communication systems. 10.21203/rs.3.rs-1958090/v1.
 
[6] MR CNN Model - Parmar, K. Captain, U. Satija and A. Chouhan, "Modulation Classification for Non-orthogonal Multiple Access System using a Modified Residual-CNN," 2023 IEEE Wireless Communications and Networking Conference (WCNC), Glasgow, United Kingdom, 2023, pp. 1-6.

[7] Neuron - Mohanty, Prayag. (2023). Analysis on Implementation of different Single Precision CNN Architectures on FPGAs. 10.13140/RG.2.2.31819.77604. 

[8] C. C. Aggarwal, Neural Networks and Deep Learning: A Textbook. Cham, Switzerland: Springer, 2018.

