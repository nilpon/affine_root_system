require 'set'

def str2w(s)
  w = []
  mydic = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  
  s.each_char{|c|
    w.push(mydic.index(c))
  }
  return w
end

def gen_quiver_matrix(rank, dir)
  if dir.length == rank * (rank - 1) / 2 then
    mat = Array.new(rank).map{Array.new(rank, 0)}
    for i in 0..(rank - 2) do
      for j in (i + 1)..(rank - 1) do
        mat[i][j] = dir[i*(2*rank - i - 1) / 2 + j - i - 1]
        mat[j][i] = -mat[i][j]
      end
    end
  end
  return mat
end

def reverse_bracket(v)
  if v.instance_of?(Array) then
    v.reverse!
    v.each{|w|
      reverse_bracket(w)
    }
  end
  v
end

def confluent_rewriting_typeA(w)
  while true do
    reducible = false
    for i in 0..(w.size - 2) do
      if w[i] == w[i + 1] then
        reducible = true
        w.slice!(i, 2)
        break
      elsif w[i] - w[i + 1] >= 2 then
        reducible = true
        tmp = w[i]
        w[i] = w[i + 1]
        w[i + 1] = tmp
        break
      else
        stair_len = 0
        for k in (i + 1)..(w.size - 1) do
          if w[k] != w[i] - (k - i) then
            stair_len = k - i - 1
            break
          end
        end
        
        if stair_len > 0 && w[i] == w[i + stair_len + 1] then
          reducible = true
          w[i] -= 1
          for j in 1..(stair_len + 1) do
            w[i + j] = w[i] - j + 2
          end
          break
        end
      end
    end
    if !reducible then
      break
    end
  end
  return w
end

def list_all_w_typeA(l)
  s = Set[[]]
  while true do
    lastsize = s.size
    newwords = Set.new
    s.each{|w|
      for i in 1..l do
        newwords.add(confluent_rewriting_typeA(w + [i]))
      end
    }
    s += newwords
    if s.size <= lastsize then
      break
    end
  end
  return s
end

def flatten_monomial(m)
  if m.is_a?(Array) then
    return flatten_monomial(m[0]) + flatten_monomial(m[1])
  else
    return [m]
  end
end

# currently ADE only!
def sorted_monomial_coeff(s, q)
  # if i->j, e_i e_j = q^{-1} e_j e_i
  # moving e_i from right to left, for i = 0, 1, 2, ...
  # then coefficients appear only when exchanging each e_j (j > i)
  # lying in left side of e_i;   e_j e_i = q^ij e_i e_j
  coeff = 0
  for i in 0..(s.size - 1) do
    for j in 0..(i - 1) do
      if s[j] > s[i] then
        coeff += q[s[i]][s[j]]
      end
    end
  end
  return coeff
end

def act_on_monomial(v, rho)
  for i in 0..(v.size - 1) do
    if v[i].instance_of?(Array) then
      act_on_monomial(v[i], rho)
    else
      v[i] = rho[v[i]]
    end
  end
  v
end
