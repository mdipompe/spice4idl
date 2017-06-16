FUNCTION define_ell_bins,nperdex,max

  step=1./nperdex
  power=step
  bin_edge=0
  WHILE (max(bin_edge) LT max) DO BEGIN
     bin_edge=[bin_edge,10.^power]
     power=power+step
  ENDWHILE
  IF (max(bin_edge) GT max) THEN bin_edge[n_elements(bin_edge)-1]=max
  
  return,bin_edge
END
