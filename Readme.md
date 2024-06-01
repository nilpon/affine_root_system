# Affine root system calculator

This is a simple calculator on untwisted affine root systems.

## class `Affine_root_system`
To use this library, `load 'affine_root_system.rb'`

### Initialize: `Affine_root_system.new(type, l)`
Generate the untwisted affine root system of type $X_{\ell}^{(1)}$.
* `type`: a character X = `'A'`, `'B'`, ..., `'G'`
* `l`: a positive integer $\ell$ (RECOMMENDED $\ell \leq 10$)

**WARNING**: The computation time is EXPONENTIAL GROWTH w.r.t. the rank `l`.

### Data structure
#### Roots
The roots are represented as $m_0 \alpha_0 + m_1 \alpha_1 + \dots + m_{\ell} \alpha_{\ell}$, a linear combination of simple roots $\alpha_i$,

and we represent a root by the array of coefficients $[m_0, m_1, \dots, m_{\ell}]$.

Example: When type $A_2^{(1)}$, a root $2\alpha_0 + \alpha_1 + \alpha_2$ is represented as `[2, 1, 1]`.

#### Weyl group
The elements of the Weyl group is represented as a product of simple reflections,
and stored as an array of indices.

Example: When type $A_2^{(1)}$, an element $s_0 s_1 s_2 s_0$ is represented as `[0, 1, 2, 0]`.



### Methods
Parameters:

`i`: an index $0 \leq i \leq \ell$.

`w`: an element of the Weyl group.

`alpha`: a root.

#### `simple_root(i)`
Generate the simple root $\alpha_i$ for $i = 0, 1, \dots, \ell$.

#### `root2str(alpha)`
Represent given root as a readable string.

#### `print_roots(roots)`
Print an array of roots to standard output.

#### `sign(alpha)`
Returns 1, -1, 0 when a root `alpha` is positive, negative, indefinite respectively.

#### `reduce(w)`
Represent an element `w` of the Weyl group as a reduced expression.

#### `action(w, alpha)`
Compute the action of an element `w` of the Weyl group at a root `alpha`.

#### `associated_roots(w)`
Returns the array of all the roots in $\Phi(w) := w\Delta_- \cap \Delta_+$,

where $\Delta_{\pm}$ is the set of positive/negative roots respectively.

#### `action_underlying_simple(w)`
Print the action of `w` on all the simple roots to standard output.

#### `action_underlying(w)`
Print the action of `w` on all the positive roots to standard output.

#### `length(w)`
Returns the length of `w`, which is the length of reduced expression of `w`

and is coincide with the number of the elements in $\Phi(w)$.

#### `is_increase_len(w, i)`
Returns true if the length of $w s_i$ is longer than $w$,

that is, the length of $w$ increases by multiplying the simple reflection $s_i$.

#### `calc_root_vec(w, i)`
Represent $T_w(E_i)$ as a $q$-commutator monomial.


## utility.rb
Some auxiliary tools.

### `str2w(s)`
Convert string of indices to an element of the Weyl group.

Useful when specifying an element of the Weyl group.

Example: str2w("0120") => [0, 1, 2, 0]

## Reference
V. G. Kac, Infinite-dimensional Lie algebras, third edition, Cambridge University Press, 1990.

M. Sugawara, Quantum dilogarithm identities arising from the product formula for universal R-matrix of quantum affine algebras, Publications of RIMS 59 (2023), 769-819, arXiv:2210.17109.

## Lisence
[MIT License](https://opensource.org/licenses/MIT).
