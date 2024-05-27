load 'affine_root_system.rb'

=begin
For the affine quantum group of type A_2^{(1)},
compute a root vector T_0 T_1 T_2 (E_0).
=end

type = 'A'
l = 2

# generate the affine root system of type A_2^{(1)}
rsys =  Affine_root_system.new(type, l)

# w := s_0 s_1 s_2
w = [0, 1, 2]

# compute T_w (E_0)
p rsys.calc_root_vec(w, 0) 

# [X, Y] := [X, Y]_q = XY - q^{\mu, \nu} YX,
# where \mu is the weight of X and \nu is the weight of Y
