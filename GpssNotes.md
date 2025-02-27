# Goldsmith-Pinkham, Sorkin, Swift (2020)
*Title:* "Bartik Instruments: What, When, Why and How"
The structural relationship is assumed to be of the form
$$y_l = \rho + \beta_0 x_l + e_l$$
where $l$ is a location and $x_l$ is employment growth.
## Two Accoutning Identities
1. You can, (as in the Borusyak et. al. NBER (2024) article) decompose the growth rate across industries
$$\begin{align*}
x_l &= \frac{m'_l - m_l}{m_l}\quad\text{(Let $m$ denote employment)}\\
&= \frac{\sum_{k}(1+g_{lk})m_{lk} - \sum_k m_{lk}}{m_l}\quad\text{(Break employment across indsutry, apply local growth rate)}\\
&=\sum_k z_{lk}g_{lk}
\end{align*}$$
$$$$
where $z_{lk}$ is the industry $k$ share of employment in location $l$ and $g_{lk}$ is that industry's employment growth in location $l$.

2. The other is
$$\begin{align*}
g_{lk} &= g_k + g_{lk} - g_k \\
       &= g_k + \tilde g_{lk}
\end{align*}$$

## Definition of the Bartik Instrument
$$B_l \equiv \sum_k z_{lk}g_k$$

## Contributions of the Paper
There are many. This paper is brilliant!
1. How to assess the SS when identification "comes from the shares" (exposure design).
    - They show that TSLS estimates with a Bartik instrument is numerically equivalent to a GMM estimator where the shares are the instruments and the shifts are
    the weights.
2. They give tests for validity of the design
    - Check correlates of the shares
    - If we assume a null of constant (homogenous effects) then running a set of standard tests can reject this null. This rejection, however, can be due to treatment
    effect heterogeneity or a violation of the exclusion restriction.
    - Come up with another instrument. Are the estimated effects similar?
3. A visual diagnostic to help researchers understand the patterns of underlying hetoergeneity in their data.
4. A decomposition of the Bartik estimator into just-identified IV estimateors whichseparately use each $z_{lk}$ as an instrument. This decomposition tells us how sensitive the overidentified estimate of $\beta_0$ is to misspecification arising due to endogeneity.
    - This is related to Andrews, Gentzkow and Shapiro's "sensitivity to misspecification" parameter.
    - The weights in the decomposition can guide researchers, heuristically, as to which exposure designs to implement specification tests on. "If the high-weight designs...pass basic specification tests, then researchers should feel reassured about the basic empirical strategy." (Pg. 2589)

## Bartik IV $\iff$ GMM with Shares as Instruments
Assume we are in a panel setting with $K$ industries and $T$ time periods. Assume that the structural equation of interest is
$$y_{lt} = D_{lt}\rho + x_{lt}\beta_0 + \varepsilon_{lt}$$
where $D_{lt}$ contains time and location fixed effects in addition to covariates. Bartik exploits the inner product structure of the growth rates
$$x_{lt} = Z'_{lt}G_{lt} = \sum_kz_{lkt}g_{lkt}$$
where $Z_{lt}, G_{lt}$ are $K\times1$ vectors of industry employment shares and growth rates, respecitively (in location $l$). The Bartik instrument itself fixes industry shares to an initial time period and uses the aggregate industry-time growth rate. The authors do this because doing so makes the "analogy to DiD clearer,
$$B_l = Z'_{l0}G_t =\sum_k z_{lk0}g_{kt}$$
The first stage is then
$$x_{lt} = D_{lt}\tau + B_{lt}\gamma + \eta_{lt}.$$

### Two Industries, One Time Period.
The instrument is simply
$$B_l = z_{l1}g_1 + z_{l2}g_2.$$
Since the shares sum to one
$$B_l = g_2 + (g_1 - g_2)z_{l1}.$$
The first stage can then be written
$$\begin{align*}
x_l &= \gamma_0 + \gamma B_l + \eta_{l} \\
    &= \gamma_0 + \gamma g_2 + \gamma(g_1 - g_2)z_{l1} + \eta_l
\end{align*}$$
The first two terms comprise the intercept of a TSLS estimation procedure based on the shares as instruments and the $\gamma(g_2-g_1)$ is the slope.

### Two Industries, Two Time Periods
Now the growth rates vary over time. Yet, the industry shares in the pre period are of course fixed. Becuase they are fixed, using the shares as an instrument requires the use of time indicators in order to clarify the mapping to the TSLS bartik procedure.
$$\begin{align*}
x_{lt} &= \tau_t + B_{lt}\gamma + \eta_{lt}\quad&\text{(Add a time fe)}\\
       &= \underbrace{(\tau_t + g_{2t}\gamma)}_{\text{Intercept}} + z_{l10}\textbf{1}(t = 1)\underbrace{(g_{11} - g_{21})\gamma}_{\tilde\gamma_1} + z_{l10}\textbf{1}(t = 2)\underbrace{(g_{21} - g_{22})\gamma}_{\tilde\gamma_2} + \tilde\eta_{lt}\quad&\text{(Shares sum to 1)}
\end{align*}$$
Thus, one could regress the endogenous variable on the industry shares in the first stage. This would recover two parameters which are scaled versions of the underlying Bartik parameter.

# The K-Industry 1-Period Equivalence
> A TSLS preocedure based on the Bartik instrument is equivalent to a GMM procedure with the weight matrix $W = GG'$.

We will explore this result numerically. The structural relationship of interest is
$$y_{lt} = D'_{lt}\rho + x_{lt}\beta_0 + \varepsilon_{lt}$$
where $l$ is a location, $t$ is time and $D_{lt}$ is a $(Q\times1)$ vector of strictly exogenous controls which include time and state fixed effects. We can drop the time subscripts in this example since we are supposing that there is only one time period. $x_{l}$ is employment growth in location $l$ and $y_l$ is the *change* in some outocome of interest.

Turning to the data let
$$
D = 
\begin{bmatrix}
D'_1\\
\vdots\\
D'_L
\end{bmatrix}
$$
denote an $(L\times Q)$ matrix. Let $P_D = D(D'D)^{-1}D'$ denote the $(L\times L)$ projection matrix for the included exogenous regressors in $D_l$. Then $M_D = \mathbb{I}_L - P_D$ is the corresponding annihilator matrix.

We let $Z_l$ be a $(K\times1)$ vector of indsutry shares in employment for location $l$. We collect these vectors into a $(L\times K)$ matrix,
$$
Z =
\begin{bmatrix}
Z'_1\\
\vdots\\
Z'_L
\end{bmatrix}.
$$
We can collect the common component of the industry growth rates into a $(K\times1)$ vector $G$. The vector of Bartik instruments across locations is given by $B = ZG$.

### The Bartik and GMM Estimators of $\beta$
Let $X$ denote a $(L\times1)$ vector of employment growth rates. Let $\tilde Y = M_DY$, $\tilde X = M_DX$ and $P_B = B(B'B)^{-1}B'$. Note that $B'B$ is $(1\times1)$. By Frisch-Waugh-Lovell we have that the 2sls estimate of $\beta$ is,
$$
\begin{align*}
\hat\beta_\text{Bartik} &= (\tilde X' P_B\tilde X)^{-1}\tilde X'P_B\tilde Y\\
                        &= \left(\tilde X'\frac{BB'}{B'B}\tilde X\right)^{-1}\tilde X'\frac{BB'}{B'B}\tilde Y\\
                        &= (\tilde X'BB'\tilde X)^{-1}\tilde X' BB' \tilde Y \\
                        &= (\tilde X'B)^{-1}(B'\tilde X)^{-1}(\tilde X'B)B'\tilde Y\\
                        &= \frac{B'\tilde Y}{B'\tilde X}
\end{align*}
$$

The GMM estimator is
$$\hat\beta_{\text{GMM}} = \frac{\tilde X'ZWZ'\tilde Y}{\tilde X'ZWZ'\tilde X}$$
