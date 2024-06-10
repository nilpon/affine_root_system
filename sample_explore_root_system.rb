load 'affine_root_system.rb'
load 'utility.rb'
require 'set'

=begin
Let's explore the world of affine root systems! (・∀・)
=end

type = 'B'
l = 4

# Generate the affine root system R of type B_4^{(1)}
rsys =  Affine_root_system.new(type, l)

# Print all the positive roots in the finite root subsystem of type B_4 spanned by a_1, ..., a_l,
# where a_i is the i-th simple root. We follow the assignment of indices as in Kac's textbook.
puts 'List of positive roots in the finite root system of type B_4'
rsys.print_roots(rsys.associated_roots(rsys.w0))
puts

# The roots which are congruent to simple roots modulo the action of the Weyl group
# is called 'real'. The roots which are not real is called 'imaginary'.

# Print the null root, D := a_0 + a_1 + 2*a_2 + 2*a_3 + 2*a_4.
# It is known that every imaginary root in R is of the form m*D (m: nonzero integer)
puts 'The null root:'
print 'D = '
for i in 0..l do
  if rsys.delta[i] > 0 then
    if rsys.delta[i] > 1 then
      print rsys.delta[i].to_s + '*'
    end
    print 'a_' + i.to_s
  end
  if i < l then
    print ' + '
  else
    puts
  end
end
puts

# Then, every real root in the root system R is of the form m*D + a, 
# where m is an integer and a is a root in the finite root system of type B_4

# The null root is fixed by all the simple reflections
puts 'The action of simple reflection on the null root D'
for i in 0..l do
  b = rsys.action([i], rsys.delta)
  puts 's_' + i.to_s + '(D) = ' + rsys.root2str(b)
end
puts

wstr = "02431231402123"
puts 'w := ' + wstr + ' (size: ' + wstr.size.to_s + ')'
w = str2w(wstr)

puts 'The action of w:'
rsys.action_underlying(w)
puts

# The length of an element w of the Weyl group is
# the shortest length k of expression of the form w = s_{i_1} s_{i_2} ... s_{i_k}.
# It coincide with the number of positive roots which are sent to negative roots by w.
# If w(alpha) =  m*D + beta (beta: positive),
# then w reverse the sign of positive roots n*D + alpha to negative for n = 0, 1, ..., -m-1 (thus -m roots)
#                                       and n*D - alpha             for n = 1, 2, ..., m (thus m roots)
# and thus w reverse in total |m| roots.
# In the same way, 
# if w(alpha) =  m*D - beta (beta: positive),
# then w reverse the sign of positive roots n*D + alpha to negative for n = 0, 1, ..., -m (thus -m+1 roots)
#                                       and n*D - alpha             for n = 1, 2, ..., m-1 (thus m-1 roots)
# and thus w reverse in total |m-1| roots.

# Please rest easy, you can compute the length of w as following:
puts 'The length of w = ' + rsys.length(w).to_s

# You can get reduced expression:
wred = rsys.reduce(w)
puts 'w = ' + wred.join + ' (reduced)'
puts

# When w = s_{i_1} s_{i_2} ... s_{i_k} is reduced, the set of positive roots
# \Phi(w) := w\Delta_- \cap \Delta_+ = {s_{i_1} s_{i_2} ... s_{i_{m-1}} (\alpha_m) | m = 1, 2, ..., k}
# is important set in the theory of convex orders.
# By the way, by definition, \Phi(w^{-1}) = w^{-1}\Delta_- \cap \Delta_+
# coincide with the set of positive roots which is reversed by w.
puts 'The positive roots reversed by w:'
rsys.print_roots(rsys.associated_roots(wred.reverse))
# Note: w^{-1} = w.reverse since the order of simple reflection s_i is 2.
