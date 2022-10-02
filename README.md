# truss

## What is this program about?
This program is about structural analysis using stiffness method. 
During learning, I tried to code the concepts of stiffness in structral analysis using the simplest structure that is 2D truss.
Unlike flexibility methods where internal forces are solved to get delfections, in stiffness method we solve for the deflections first to get internal forces.

This picture is the derivation of stiffness matrix for 2D truss:

<img src="img/1.PNG" alt="2D truss structural elements" width="700"/>

*Notation for stiffness coefficient derivation in 2D truss elements (Kassimali, A.)*

2D truss elements have 2 degree of freedoms in each end. Therefore there is 4 degree of freedoms (u<sub>1</sub>, u<sub>2</sub>, u<sub>3</sub>, u<sub>4</sub>) in each elements (X, Y translations in each end).

This picture is the breakdown of total displacement into each displacement components (u<sub>1</sub>, u<sub>2</sub>, u<sub>3</sub>, u<sub>4</sub>):

<img src="img/2.PNG" alt="2D truss structural elements" width="350"/>

*Stiffness coefficients derivation (Kassimali, A.)*

>k<sub>ij</sub> represents the force at the location and in the direction of Q<sub>i</sub> required,
along with other end forces, to cause a unit value of displacement u<sub>j</sub>,
while all other end displacements are zero. These forces per unit displacement
are called stiffness coefficients. (Kassimali, A.)

From the figure we can get the value of $Q$ by the summation of product between $k$ and $u$ as follows:

$$\begin{eqnarray}
Q_1 = k_{11}u_1 + k_{12}u_2 + k_{13}u_3 + k_{14}u_4\\
Q_2 = k_{21}u_1 + k_{22}u_2 + k_{23}u_3 + k_{24}u_4\\
Q_3 = k_{31}u_1 + k_{32}u_2 + k_{33}u_3 + k_{34}u_4\\
Q_4 = k_{41}u_1 + k_{42}u_2 + k_{43}u_3 + k_{44} u_4\\
\end{eqnarray}$$

or in a matrix form as follows:

$$\begin{bmatrix}
Q_1\\
Q_2\\
Q_3\\
Q_4
\end{bmatrix} = \begin{bmatrix}
k_{11} & k_{12} & k_{13} & k_{14}\\
k_{21} & k_{22} & k_{23} & k_{24}\\
k_{31} & k_{32} & k_{33} & k_{34}\\
k_{41} & k_{42} & k_{43} & k_{44} 
\end{bmatrix}
\begin{bmatrix}
u_1\\
u_2\\
u_3\\
u_4
\end{bmatrix}$$

or

$$ **Q** = **k** \times **u** $$

using equilibrium equations it can be shown that the matrix $k$ equal to:

$$k = \frac{EA}{L} \begin{bmatrix}
1 & 0 & -1 & 0\\
0 & 0 & 0 & 0\\
-1 & 0 & 1 & 0\\
0 & 0 & 0 & 0\\
\end{bmatrix}$$

The formulation of matrix $k$ is in the local coordinates where the end forces are perpendicular or parallel with the axis of the member, for a generalized representation end forces also derived in a more global manner based on this picture below:

<img src="img/3.PNG" alt="2D truss structural elements" width="350"/>

<img src="img/4.PNG" alt="2D truss structural elements" width="350"/>

<img src="img/5.PNG" alt="2D truss structural elements" width="350"/>

<img src="img/6.PNG" alt="2D truss structural elements" width="350"/>

*Stiffness coefficients derivation in global coordinates (Kassimali, A.)*

For the global coordinates the variable used are $F$, $K$ and $v$ that corresponds to $Q$, $k$ and $u$ in local manner consecutively. We can write this equation that correlates stiffness, end forces and displacement in global coordinates:

$$ **F** = **K** \times **v** $$

For more details about formulation of $K$ it can be read through book in the resources below. Matrix $K$ can be derived from $k$ using coordinates transformation to get equation as follows:

$$K = \frac{EA}{L} \begin{bmatrix}
cos^2\theta & cos\theta sin\theta & −cos^2\theta & −cos\theta sin\theta\\
cos\theta sin\theta & sin^2\theta & −cos\theta sin\theta & −sin^2\theta\\
−cos^2\theta & −cos\theta sin\theta & cos^2\theta & cos\theta sin\theta\\
−cos\theta sin\theta & −sin^2\theta & cos\theta sin\theta & sin^2\theta\\
\end{bmatrix}$$

For the next steps are in the resources. It contains the process of assembling element stiffness matrices into structural stiffness matrices and solving the equations using given compatibility of joint forces and reactions.

## Input
- joint data
- support data
- material property data
- cross-sectional property data
- member data
- load data

## Output
- displacements
- member end forces

## What things that I learned during the process?
- How structural analysis is done with computer modeling.
- Creating a simple applications to calculate structural responses from scratch.
- Understanding the program complexity in terms of space and time, $O(NDOF^2)$, where $NDOF$ is number of degree of freedom for a simple linear analysis.
- Understanding this simple problem serves as the foundation to know for more generalized problems (3D frames) which has 6 degree of freedoms (X, Y, Z translations and rotations) in each end of the members. The stiffness coefficients is given below:

$$k = \frac{E}{L^3}
\begin{bmatrix}
AL^2 & 0 & 0 & 0 & 0 & 0 & −AL^2 & 0 & 0 & 0 & 0 & 0\\
0 & 12I_z & 0 & 0 & 0 & 6LI_z & 0 & −12I_z & 0 & 0 & 0 & 6LI_z\\
0 & 0 & 12I_y & 0 & −6LI_y & 0 & 0 & 0 & −12I_y & 0 & −6LI_y & 0\\
0 & 0 & 0 & \frac{GJL^2}{E} & 0 & 0 & 0 & 0 & 0 & \frac{-GJL^2}{E}& 0 & 0\\
0 & 0 & −6LI_y & 0 & 4L^2I_y & 0 & 0 & 0 & 6LI_y & 0 & 2L^2I_y & 0\\
0 & 6LI_z & 0 & 0 & 0 & 4L^2I_z & 0 & −6LI_z & 0 & 0 & 0 & 2L^2I_z\\
−AL^2 & 0 & 0 & 0 & 0 & 0 & AL^2 & 0 & 0 & 0 & 0 & 0\\
0 & −12I_z & 0 & 0 & 0 & −6LI_z & 0 & 12I_z & 0 & 0 & 0 & −6LI_z\\
0 & 0 & −12I_y & 0 & 6LI_y & 0 & 0 & 0 & 12I_y & 0 & 6LI_y & 0\\
0 & 0 & 0 & \frac{-GJL^2}{E} & 0 & 0 & 0 & 0 & 0 & \frac{GJL^2}{E} & 0 & 0\\
0 & 0 & −6LI_y & 0 & 2L^2I_y & 0 & 0 & 0 & 6LI_y & 0 & 4L^2I_y & 0\\
0 & 6LI_z & 0 & 0 & 0 & 2L^2I_z & 0 & −6LI_z & 0 & 0 & 0 & 4L^2I_z
\end{bmatrix}$$

where:

$$\begin{eqnarray}
\large L &=& member \enspace length\\
\large A &=& cross \enspace sectional \enspace area\\
\large E &=& modulus \enspace of \enspace elasticity\\
\large G &=& shear \enspace modulus\\
\large J &=& torsion \enspace constant\\
\large I_y &=& moment \enspace of \enspace inertia \enspace y-y\\
\large I_z &=& moment \enspace of \enspace inertia \enspace z-z\\
\end{eqnarray}$$


## Resources
Kassimali, A., 2012. *Matrix analysis of structures*. 2nd ed. Stamford: Cengage Learning.
