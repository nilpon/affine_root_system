load 'affine_root_system.rb'
load 'utility.rb'

=begin

When a Dynkin quiver Q is given, list up all the w in the finite Weyl group
s.t. there is an imaginary monomial T_w(\varphi_{i, m})
which does not vanish by the projection pi_Q^+.

=end

type = 'A'
l = 4

# generate the affine root system of type A_4^{(1)}
rsys =  Affine_root_system.new(type, l)

# set the orientation of the Dynkin quiver Q as 0 <- 1 -> 2 <- 3 -> 4 <- 0
q = gen_quiver_matrix(l + 1, [-1, 0, 0, 1, 1, 0, 0, -1, 0, 1])

# for all w in the finite Weyl group
wlist = list_all_w_typeA(l)
wlist.each{|w|
  nonvanish = false
  for i in 1..l do
    for m in 1..3 do # check only for m = 1, 2, 3 due to compromise of computation time
      # compute v = T_w(\varphi_{i, m})
      v = rsys.imaginary_monomial(i, m, w)
      coeff_list = [] # store the scalar multiplier
      # check whether \pi_Q^+(v) is nonzero
      if rsys.is_not_vanish(v, q, coeff_list) then
        nonvanish = true
        break
      end
    end
    
    # if \pi_Q^+(v) != 0 for some m, list up w
    if nonvanish then
      break
    end
  end
  if nonvanish then
    puts w.join
  end
}
