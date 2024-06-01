# Affine root system calculator

This is a simple calculator on untwisted affine root systems.

## class `Affine_root_system`
To use this library, `load 'affine_root_system.rb'`

### Initialize: `Affine_root_system.new(type, l)`
Generate the untwisted affine root system of type $X_{\ell}^{(1)}$.
* `type`: a character X = `'A'`, `'B'`, ..., `'G'`
* `l`: a positive integer $\ell$ (RECOMMENDED <= 10)

**WARNING**: The computation time is EXPONENTIAL GROWTH w.r.t. the rank `l`.

### Data structure
#### Roots
The roots are represented as a $\ell+1$-dimensional integral vector.

Example: When type $A_2^{(1)}$, $2\alpha_0 + \alpha_1 + \alpha_2$ is represented as `[2, 1, 1]`.

#### Weyl group
The elements of the Weyl group is represented as a product of simple reflections,
and stored as an array of indices.

Example: When type $A_2^{(1)}$, $s_0 s_1 s_2 s_0$ is represented as `[0, 1, 2, 0]`.



### Methods
#### `simple_root(i)`
Generate the simple root $\alpha_i$ for $i = 0, 1, \dots, \ell$.

#### `root2str(root)`
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
Listup the elements in $\Phi(w) := w\Delta_- \cap \Delta_+$.


## utility.rb
Some auxiliary tools.
### `str2w(s)`

## Reference
V. G. Kac, Infinite-dimensional Lie algebras, third edition, Cambridge University Press, 1990.

M. Sugawara, Quantum dilogarithm identities arising from the product formula for universal R-matrix of quantum affine algebras, Publications of RIMS 59 (2023), 769-819, arXiv:2210.17109.

## Lisence
[MIT License](https://opensource.org/licenses/MIT).
