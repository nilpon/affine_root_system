class Affine_root_system
  attr_reader :cmat, :delta, :type, :l, :w0, :trans, :transt, :dominantv
  
  def initialize(type, l)
    @cmat = get_affine_cartan_mat(type, l)
    @delta = get_null_root(type, l)
    @type = type
    @l = l
    @w0 = gen_longest_element()
    @trans = Array.new(l + 1)
    @transt = Array.new(l + 1)
    t_dominant = []
    for i in 1..l do
      @trans[i] = reduce(fundamental_translation(i))
      t_dominant += @trans[i]
      @transt[i] = reduce(@trans[i] + [i])
    end
    @dominantv = reduce(t_dominant + @w0)
  end
  
  def get_cartan_A(l)
    mat = Array.new(l + 1){Array.new(l + 1, 0)}
    for i in 0..l do
      for j in 0..l do
        if (i - j).abs == 1 then
          mat[i][j] = -1
        elsif i == j then
          mat[i][j] = 2
        end
      end
    end
    
    return mat
  end
  
  # untwisted type only
  # WARNING: mat[i][j] = <\alpha_i, \Check{\alpha_j}>
  def get_affine_cartan_mat(type, l)
    case type
    when 'A' then
      if l == 1 then
        mat = [[2, -2], [-2, 2]]
      else
        mat = get_cartan_A(l)
        mat[0][l] = -1
        mat[l][0] = -1
      end
    when 'B' then
      if l > 2 then
        mat = get_cartan_A(l)
        mat[l - 1][l] = -2
        mat[0][1] = 0
        mat[1][0] = 0
        mat[0][2] = -1
        mat[2][0] = -1
      end
    when 'C' then
      if l > 1 then
        mat = get_cartan_A(l)
        mat[l][l - 1] = -2
        mat[0][1] = -2
      end
    when 'D' then
      if l > 3 then
        mat = get_cartan_A(l)
        mat[l - 2][l] = -1
        mat[l - 1][l] = 0
        mat[l][l - 2] = -1
        mat[l][l - 1] = 0
        mat[0][1] = 0
        mat[1][0] = 0
        mat[0][2] = -1
        mat[2][0] = -1
      end
    when 'E' then
      if l >= 6 && l <= 8 then
        mat = get_cartan_A(l)
        mat[1][2] = 0
        mat[1][3] = -1
        mat[2][1] = 0
        mat[2][3] = 0
        mat[2][4] = -1
        mat[3][1] = -1
        mat[3][2] = 0
        mat[4][2] = -1
        if l != 7 then
          mat[0][1] = 0
          mat[1][0] = 0
          if l == 6 then
            mat[0][2] = -1
            mat[2][0] = -1
          elsif l == 8 then
            mat[0][8] = -1
            mat[8][0] = -1
          end
        end
      end
    when 'F' then
      if l == 4 then
        mat = get_cartan_A(l)
        mat[2][3] = -2
      end
    when 'G' then
      if l == 2 then
        mat = get_cartan_A(l)
        mat[1][2] = -3
      end
    end
    
    return mat
  end
  
  def get_null_root(type, l)
    case type
    when 'A' then
      delta = Array.new(l + 1, 1)
    when 'B' then
      if l > 2 then
        delta = Array.new(l + 1, 2)
        delta[0] = 1
        delta[1] = 1
      end
    when 'C' then
      if l > 1 then
        delta = Array.new(l + 1, 2)
        delta[0] = 1
        delta[l] = 1
      end
    when 'D' then
      if l > 3 then
        delta = Array.new(l + 1, 2)
        delta[0] = 1
        delta[1] = 1
        delta[l - 1] = 1
        delta[l] = 1
      end
    when 'E' then
      case l
      when 6 then
        delta = [1, 1, 2, 2, 3, 2, 1]
      when 7 then
        delta = [1, 2, 2, 3, 4, 3, 2, 1]
      when 8 then
        delta = [1, 2, 3, 4, 6, 5, 4, 3, 2]
      end
    when 'F' then
      if l == 4 then
        delta = [1, 2, 3, 4, 2]
      end
    when 'G' then
      if l == 2 then
        delta = [1, 2, 3]
      end
    end
    
    return delta
  end
  
  def permute_indices(rho, alpha)
    res = alpha.dup
    for i in 0..@l do
      res[rho[i]] = alpha[i]
    end
    
    return res
  end
  
  def symbol2perm(symbol)
    rho = []
    case symbol
    when 'r' then
      case @type
      when 'A' then
        for i in 1..@l do
          rho += [i]
        end
        rho += [0]
      when 'B' then
        rho = [1, 0]
        for i in 2..@l do
          rho += [i]
        end
      when 'C' then
        for i in 0..@l do
          rho += [@l - i]
        end
      when 'D' then
        for i in 0..@l do
          rho += [@l - i]
        end
        
        if @l % 2 == 1 then
          rho[@l - 1] = 0
          rho[@l] = 1
        end
      when 'E' then
        case @l
        when 6 then
          rho = [1, 6, 3, 5, 4, 2, 0]
        when 7 then
          rho = [7, 6, 2, 5, 4, 3, 1, 0]
        end
      end
      
      # the extension is *not* cyclic when D_l (l: even)
    when 't' then
      if @type == 'D' && @l % 2 == 0 then
        tau = [1, 0]
        for i in 2..(@l - 2) do
          tau += [i]
        end
        tau += [@l, @l - 1]
      end
    end
    
    if rho.empty? then
      # trivial
      for i in 0..@l do
        rho += [i]
      end
    end
    
    return rho
  end
  
  def reflection(i, alpha)
    res = alpha.dup
    if @cmat.length != alpha.length || i >= @cmat.length then
      return nil
    else
      diff = 0
      for j in 0..@l do
        diff += alpha[j] * @cmat[j][i]
      end
      
      res[i] -= diff
      
      return res
    end
  end
  
  def action(w, alpha)
    res = alpha.dup
    w.reverse_each{|r|
      if r.is_a?(Integer) then
        res = reflection(r, res)
      elsif r.is_a?(Array) then
        res = permute_indices(r, res)
      elsif r.is_a?(String) then
        res = permute_indices(symbol2perm(r), res)
      else
      end
    }
    return res
  end
  
  def simple_root(i)
    if @l > 0 && i <= @l then
      res = Array.new(@l + 1, 0)
      res[i] = 1
    end
    
    return res
  end
  
  def associated_roots(w)
    roots = []
    w_sub = []
    w.each{|r|
      if r.is_a?(Integer) then
        roots.push(action(w_sub, simple_root(r)))
        w_sub.push(r)
      end
    }
    return roots
  end
  
  def root2str(root)
    str = ""
    
    is_first = false
    if root[0] == 0 then
      is_first = true
    else
      if root[0] == 1 then
        str += 'D'
      elsif root[0] == -1 then
        str += '-D'
      else
        str += root[0].to_s + 'D'
      end
    end
    
    for i in 1..@l do
      coeff = root[i] - root[0] * @delta[i]
      if coeff == 1 then
        if !is_first then
          str += ' + '
        else
          is_first = false
        end
        str += 'a_' + i.to_s
      elsif coeff == -1 then
        if !is_first then
          str += ' - '
        else
          str += '- '
          is_first = false
        end
        str += 'a_' + i.to_s
      elsif coeff > 1 then
        if !is_first then
          str += ' + '
        else
          is_first = false
        end
        str += coeff.to_s + 'a_' + i.to_s
      elsif coeff < -1 then
        if !is_first then
          str += ' - '
        else
          str += '- '
          is_first = false
        end
        str += coeff.abs.to_s + 'a_' + i.to_s
      else
      end
    end
    
    return str
  end
  
  def print_roots(roots)
    roots.each {|root|
      puts root2str(root)
    }
  end
  
  def sign(alpha)
    s = 0
    alpha.each{|k|
      if k > 0 then
        if s >= 0 then
          s = 1
        else
          s = 0
          break
        end
      elsif k < 0 then
        if s <= 0 then
          s = -1
        else
          s = 0
          break
        end
      end
    }
    
    return s
  end
  
  def is_increase_len(w, r)
    if sign(action(w, simple_root(r))) > 0 then
      return true
    else
      return false
    end
  end
  
  def gen_longest_element()
    w = []
    while true do
      is_found = false
      for i in 1..@l do
        if is_increase_len(w, i) then
          w.push(i)
          is_found = true
          break
        end
      end
      
      if !is_found then
        break
      end
    end
    
    return w
  end
  
  def inverse_permutation(rho)
    inv = Array.new(rho.length, 0)
    for i in 0..(rho.length - 1) do
      inv[rho[i]] = i
    end
    
    return inv
  end
  
  def reduce(w)
    res = []
    auts = []
    
    w.each{|r|
      if r.is_a?(Integer) then
        alpha = simple_root(r)
        is_irreducible = true
        counter = 0
        res.reverse_each{|s|
          alpha = action([s], alpha)
          counter += 1
          if sign(alpha) < 0 then
            is_irreducible = false
            res.delete_at(-counter)
            break
          end
        }
        
        if is_irreducible then
          res.push(r)
        end
      else
        if r.is_a?(String) then
          rho = symbol2perm(r)
        else
          rho = r
        end
        inv = inverse_permutation(rho)
        for k in 0..(res.size - 1) do
          res[k] = inv[res[k]]
        end
        auts.push(rho)
      end
    }
    
    aut = Array.new(@l + 1)
    is_trivial = true
    for i in 0..@l do
      j = i
      auts.reverse_each{|rho|
        j = rho[j]
      }
      aut[i] = j
      if j != i then
        is_trivial = false
      end
    end
    
    if is_trivial then
      return res
    else
      return [aut] + res
    end
  end
  
  # alpha = m \delta + e => return e in \circ{\Delta}
  def finite_part(alpha)
    e = alpha.dup
    for i in 0..@l do
      e[i] -= alpha[0] * @delta[i]
    end
    
    return e
  end
  
  def translation(weight, alpha)
    res = finite_part(alpha)
    
    # alpha = stride * delta + res
    stride = alpha[0] # first coefficient delta of alpha
    for i in 1..@l do 
      stride -= res[i] * weight[i - 1]
    end
    
    for i in 0..@l do
      res[i] += stride * @delta[i]
    end
    
    return res
  end
  
  def action_underlying(w)
    associated_roots(@w0).each {|alpha|
      puts root2str(alpha) + " => " + root2str(action(w, alpha))
    }
  end
  
  def action_underlying_simple(w)
    for i in 1..@l do
      puts root2str(simple_root(i)) + " => " + root2str(action(w, simple_root(i)))
    end
  end
  
  def length(w)
    len = 0
    associated_roots(@w0).each{|alpha|
      beta = action(w, alpha)
      if sign(finite_part(beta)) > 0 then
        len += beta[0].abs
      else
        len += (beta[0] - 1).abs
      end
    }
    
    return len
  end
  
  # calc c where \pi_q([X_a, X_b]_q) = (1 - q^c) X_a X_b
  # c := (b, a) + {b, a}_q
  # {\alpha_i, \alpha_j}_q =  1 if i -> j in q
  #                        = -1 if j -> i in q
  #                        =  0 otherwise
  def flatten_q_braket_pairing(a, b, q)
    res = 0
    for i in 0..@l do
      for j in 0..@l do
        res += a[i] * b[j] * (1 - q[i][j]) * @cmat[i][j]
      end
    end
    
    return res
  end
  
  def calc_root_vec(w, i)
    # ADE type only!
    if ['A', 'D', 'E'].include?(@type) then
      if w.length <= 0 then
        return i
      else
        j = w[w.length - 1]
        wp = w[0, w.length - 1]
        
        if j.is_a?(Integer) then
          if @cmat[i][j] == 0 then
            return calc_root_vec(wp, i)
          else
            if sign(action(wp, simple_root(i))) > 0 then
              return [calc_root_vec(wp, j), calc_root_vec(wp, i)]
            else
              return calc_root_vec(reduce(wp + [i]), j)
            end
          end
        else
          if j.is_a?(String) then
            aut = symbol2perm(j)
          else
            aut = j
          end
          return calc_root_vec(wp, aut[i])
        end
      end
    end
  end
  
  def root_vector_seq(w)
    for i in 0..w.length-1 do
      if w[i].is_a?(Integer) then
        p calc_root_vec(w[0, i], w[i])
      end
    end
  end
  
  # for general q-monomials
  # return weight of m if it does not vanish
  #        nil if m vanishes
  def is_not_vanish_m(m, q, coeff_list = nil)
    if m.instance_of?(Integer) then
      return simple_root(m)
    elsif m.instance_of?(Array) then
      if m.size == 2 then
        m0 = is_not_vanish_m(m[0], q, coeff_list)
        m1 = is_not_vanish_m(m[1], q, coeff_list)
        if m0.nil? || m1.nil? then
          return nil
        else
          coeff = flatten_q_braket_pairing(m0, m1, q)
          if !coeff_list.nil? then
            coeff_list.push(coeff)
          end
          
          if coeff == 0 then
            return nil
          else
            wt = Array.new(@l + 1)
            for k in 0..@l do
              wt[k] = m0[k] + m1[k]
            end
            return wt
          end
        end
      else
        return nil
      end
    else
      return nil
    end
  end
  
  def is_not_vanish(m, q, coeff_list = nil)
    if is_not_vanish_m(m, q, coeff_list).nil? then
      return false
    else
      return true
    end
  end
  
  def is_not_vanish_w(w, i, q, is_psi = false)
    v = calc_root_vec(w, i)
    if is_psi then
      reverse_bracket(v)
    end
    
    if is_not_vanish_m(v, q).nil? then
      return false
    else
      return true
    end
  end
  
  # t_{\varepsilon_i}
  def fundamental_translation(i)
    case @type
    when 'A' then
      if i > 0 && i <= @l then
        aut = Array.new(@l, 'r')
        for k in 1..i do
          aut += [k]
        end
        t = []
        for k in 1..(@l + 1 - i) do
          t += aut
        end
        
        return t
      end
    else
      return []
    end
  end
  
  # calc T_w(\varphi_{i, m})
  def imaginary_monomial(i, m, w = [])
    tm = []
    if sign(action(w, simple_root(i))) > 0 then
      for k in 1..(m - 1) do
        tm += @trans[i]
      end
      tm += @transt[i]
      return [calc_root_vec(w + tm, i), calc_root_vec(w, i)]
    else
      wtilde = reduce(@w0 + w.reverse)
      vwtilde = @dominantv + wtilde
      if vwtilde[0].is_a?(Array) then
        vwtilde[0] = inverse_permutation(vwtilde[0])
      end
      vwtilde.reverse!
      
      if m > 1 then
        for k in 1..(m - 2) do
          tm += @trans[i]
        end
        tm += @transt[i]
        
        v_pre = calc_root_vec(w + tm, i)
      else
        v_pre = calc_root_vec(reduce(w + [i]), i)
      end
      return [v_pre, reverse_bracket(calc_root_vec(vwtilde, i))]
    end
  end
  
end


