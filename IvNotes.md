# Overview and Definitions
There are many reasons why we may be interested in estimating a model for which $\mathbb{E}(Xe)\neq0$. To me, the foremost *economic* reason is that the projection coefficient $\beta^*$ is usually not an object of interest for most economic theories. This is because economic models are equilibrium systems which give rise to well known endogeneity concerns. There are also *statistical* reasons which lie behind our desire to estimate models for which $\mathbb{E}(Xe)\neq0.$ These reasons are statistical in nature because they often inhibit a researcher from estimating $\beta^*$ without bias. That is, the estimation of $\beta^*$ is still of primary interest but is made infeasible by practical considerations such as unobservability or measurement error.

Whatever the reason, we suppose that the researcher is interested in estimating
$$\begin{align*}
Y &= X'\beta + e\quad\text{where}\\
&\mathbb{E}(Xe)\neq0
\end{align*}$$
Since $\beta$ does not correspond to the projection coefficient, the difinition of $\beta$ must necessarily differ from the defnition of the projection coefficient. These definitions are referred to as **structural**.

We partition $X$ into two separate vectors $X = (X_1, X_2)$ with dimsnesions $(k_1,k_2)$ so that $X_1$ contains exogenous regressors and $X_2$ contains endogenous regressors. We also let $\beta = (\beta_1,\beta_2).$ Then the structural equation can and moment conditions can be written
$$\begin{align}
Y &= X_1'\beta_1 + X_2'\beta_2 + e\\
&\mathbb{E}(X_1e) = 0\nonumber\\
&\mathbb{E}(X_2e) \neq 0\nonumber
\end{align}
$$
> **Definition.** (Instruments) The $l\times1$ random vector $Z$ is an instrumental variable for the structural equation (1) if
> $$\mathbb{E}(Ze) = 0$$
> $$\mathbb{E}(ZZ') > 0$$
> $$\text{rank}\mathbb{E}(ZX') = k.$$
Here are a few items of note:
1. A necessary condition for the above rank condition (also called the **relevance condition**) is that $l\geq k$
2. The regressors $X_1$ satisfy exogeneity and, as such, are included in $Z$. We write $Z = (Z_1, Z_2) = (X_1,Z_2)$. The $X_1$ are the **included exogenous variables** and have dimension $k_1$. $Z_2$ are the **excluded exogenous variables** and have dimension $l_2$.
3. The **exclusion restriction** is given by the first condition.
4. The model is **just identified** if $l=k$ and **over-identified** if $l\geq k$.

# The Reduced Form
If we project the endogenous variables onto the instrument $Z$, we will have an $l\times k_2$ matrix of projection coefficients,
$$\Gamma \equiv \mathbb{E}(ZZ')^{-1}\mathbb{E}(ZX'_2)$$
There are two  **reduced form** equations. One describes the relationship between the endogenous variables and the instruments
$$X_2 = \Gamma'Z + u_2 = \Gamma'_{12}Z_1 + \Gamma'_{22}Z_2 + u_2$$
The other plugs this one into the structural equation yielding
$$
Y_1 = Z'_1\beta_1 + (\Gamma'_{12}Z_1 + \Gamma_{22}Z_2 + u_2)'\beta_2 + e
$$
Defining
$$\begin{align*}
\lambda_1 &= \beta_1 + \Gamma_{12}\beta_2\\
\lambda_2 &= \Gamma_{22}\beta_2\\
u_1 &= u'_2\beta_2 + e
\end{align*}$$
The above equation is more compactly written
$$Y_1 = Z'\lambda + u_1$$
where $\lambda = [\lambda_1, \lambda_2]'$ is an $l\times1$ vector. The equations defining $\lambda_1,\lambda_2$ suggest that
$$\begin{equation}
\lambda = \bar\Gamma\beta
\end{equation}$$
where
$$\bar\Gamma = 
\begin{bmatrix}
\textbf{I}_{k_1} && \Gamma_{12}\\
0 && \Gamma_{22}
\end{bmatrix}\quad(l\times k)
$$
All together the **Reduced Form System** is
> $$Y = \lambda'Z+ u_1$$
> $$X_2 = \Gamma'Z + u_2$$
Estimators for these reduced form equations are given in chapters 11 and 12 of Hansen's *Econometrics*.

# Identification
We can now see how the rank condition above plays a role in the identification of the structural parameter $\beta$. First, a definition. A parameter is **identified** if it is a unique function of the probability distribution of the observables. The way we will establish idenfication here is by showing that $\beta$ can be written as an explicit function of population moments. 

Notice first that,
$$\begin{bmatrix}
X_1 & X_2
\end{bmatrix} = Z'\bar\Gamma + v.$$
it is clear that $\bar\Gamma$ is the projection coefficient of $X'$ on $Z$ so that $\bar\Gamma = \mathbb{E}(ZZ')^{-1}\mathbb{E}(ZX')$. Using this fact and the fact that $\lambda$ is the projection coefficient for $Y$ on $Z$ in combination with (2) yields
$$\begin{align*}
\mathbb{E}(ZZ')^{-1}\mathbb{E}(ZY) &= \mathbb{E}(ZZ')^{-1}\mathbb{E}(ZX')\beta\\
\mathbb{E}(ZY) &= \mathbb{E}(ZX')\beta.
\end{align*}
$$
The above system of equations is $l$ equations in $k$ unknowns. We know from linear algebra that this system has unique solution if and only if
$$\text{rank}\mathbb{E}(ZX') = k.$$
This was assumed in the definition of the instrument $Z$.

# Two Stage Least Squares
Plug $\lambda$ into the first reduced form equation so that
$$\begin{align*}
Y &= Z'\bar\Gamma\beta + u_1\\
&\mathbb{E}(Zu_1) = 0.
\end{align*}$$
If we suppose, for the moment, that $\bar\Gamma$ is known and let $W = Z'\bar\Gamma$, then the estimation of $\beta$ is recoverable by least squares,
$$\hat\beta = (W'W)^{-1}(W'Y) = (\bar\Gamma'Z'Z\bar\Gamma)^{-1}(\bar\Gamma Z'Y).$$
Recognizing that $\bar\Gamma$ is the projection coeffecient from the second reduced form equation (with $X_1$ included in the left hand side) yields
$$\hat\Gamma = (Z'Z)^{-1}(Z'X)$$
which yields
$$\begin{align*}
\hat\beta_{2sls} &= (\hat\Gamma'Z'Z'\hat\Gamma)^{-1}(\hat\Gamma'Z'Y)\\
&=(X'Z(Z'Z)^{-1}Z'Z(Z'Z)^{-1}Z'X)^{-1}X'Z(Z'Z)^{-1}Z'Y\\
&=(X'Z(Z'Z')^{-1}Z'X)^{-1}X'Z(Z'Z)^{-1}Z'Y.
\end{align*}$$
Let $P = Z(Z'Z)^{-1}Z'$ denote the projection (onto $Z$) matrix. Then
> $$\hat\beta_{2sls} = (X'PX)^{-1}X'PY$$
Projection matrices are idempotent (see Hansen's *Econometrics*) so that $PP = P$. Thus, a common way of writing the 2sls estimator is
> **Equivalent Formula** $$\hat\beta_{2sls} = (X'PPX)^{-1}X'PY = (\hat X' \hat X)^{-1}\hat X' Y.$$

The hats in this equation denote fitted values. This motivates the estimation procedure and name *two stage* least squares whereby one first regresses the model's $X$ matrix on the instruments to obtain $\hat X$ and then regresses $Y$ on these fitted values. It is worth noting that since $X = [Z_1, Z_2]$ and $Z = [Z_1,Z_2]$ we have that $\hat X_1 = PZ_1 = Z_1$. That is, the fitted values equal the actual observed values for the included exogenous regressors.

# Concluding Remarks
The asymptotic distribution of the estimator under iid sampling is derived by an application of the central limit theorem. A derivation of the distribution can be found in Hansen's *Econometrics* (Chapter 12, p.353).
