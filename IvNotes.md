# Overview and Definitions
There are many reasons why we may be interested in estimating a model for which $\mathbb{E}(Xe)\neq0$. To me, the foremost *economic* reason is that the projection coefficient $\beta^*$ is usually not an object of interest for most economic theories. This is because economic models are equilibrium systems which give rise to well known endogeneity concerns. There are also *statistical* reasons which lie behind our desire to estimate models for which $\mathbb{E}(Xe)\neq0.$ These reasons are statistical in nature because they they often inhibit a researcher from estimating $\beta^*$ without bias. That is, the estimation of $\beta^*$ is still of primary interest but is made infeasible by rather practical considerations such as unobservability or measurement error.

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
# Notation
