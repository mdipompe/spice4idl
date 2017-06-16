;+
;  NAME:
;    spice4idl
;  PURPOSE:
;    Cross-correlate healpix maps using PolSpice. Options
;    to bin in ell as well.
;
;  USE:
;    spice4idl,[ell=ell,cls=cls,bins=bins,
;              binnedout=binnedout,polspice options]
;
;  INPUT:
;
;  OPTIONAL INPUT:
;    See PolSpice help for options (or run
;        using spice4idl,/help
;    ell - set to variable containing ell values (will be binned if
;          bin keyword is set)
;    cls - set to variable containing cl values (will be binned if bin
;          keyword is set)
;    bins - Set to bin PolSpice output. If set to a single value N,
;           creates bins of N per dex. Can also be an array of bin
;           edges.
;    binnedout - set to file name to contained binned output
;
;  OUTPUT:
;    See Polspice outputs
;
;  HISTORY:
;    6-16-17 - Written - MAD (Dartmouth)
;-
PRO spice4idl,ell=ell,cls=cls,$
              bins=bins,binnedout=binnedout,$
              about=about,$
              apodizesigma=apodizesigma,$
              apodizetype=apodizetype,$
              beam1=beam1,$
              beam_file1=beam_file1,$
              beam2=beam2,$
              beam_file2=beam_file2,$
              clfile=clfile,$
              cl_inmap_file=cl_inmap_file,$
              cl_inmask_file=cl_inmask_file,$
              cl_outmap_file=cl_outmap_file,$
              cl_outmask_file=cl_outmask_file,$
              corfile=corfile,$
              covfile_out=covfile_out,$
              decouple=decouple,$
              dry=dry,$
              extramapfile1=extramapfile1,$
              extramapfile2=extramapfile2,$
              fits_out=fits_out,$
              help=help,$
              history=history,$
              kernelsfileout=kernelsfileout,$
              listmapfiles1_1=listmapfiles1_1,$
              listmapfiles2_1=listmapfiles2_1,$
              listmapweights1_1=listmapweights1_1,$
              listmapweights2_1=listmapweights2_1,$
              mapfile1=mapfile1,$
              mapfile2=mapfile2,$
              maskfile1=maskfile1,$
              maskfile2=maskfile2,$
              maskfilep1=maskfilep1,$
              maskfilep2=maskfilep2,$
              nlmax=nlmax,$
              noiseclfile=noiseclfile,$
              noisecorfile=noisecorfile,$
              normfac=normfac,$
              optinfile=optinfile,$
              optoutfile=optoutfile,$
              overwrite=overwrite,$
              pixelfile1=pixelfile1,$
              pixelfile2=pixelfile2,$
              polarization=polarization,$
              subav=subav,$
              subdipole=subdipole,$
              symmetric_cl=symmetric_cl,$
              tf_file=tf_file,$
              thetamax=thetamax,$
              tolerance=tolerance,$
              usage=usage,$
              verbosity=verbosity,$
              version=version,$
              weightfile1=weightfile1,$
              weightfile2=weightfile2,$
              weightfilep1=weightfilep1,$
              weightfilep2=weightfilep2,$
              weightpower1=weightpower1,$
              weightpower2=weightpower2,$
              weightpowerp1=weightpowerp1,$
              weightpowerp2=weightpowerp2,$
              windowfilein=windowfilein,$
              windowfileout=windowfileout


  poldir=getenv('POLSPICE')
  
  IF keyword_set(about) THEN BEGIN
     cmd=[poldir+'/spice','-about']
     spawn,cmd,/noshell
     return
  ENDIF
  IF keyword_set(help) THEN BEGIN
     cmd=[poldir+'/spice','-help']
     spawn,cmd,/noshell
     return
  ENDIF
  IF keyword_set(history) THEN BEGIN
     cmd=[poldir+'/spice','-history']
     spawn,cmd,/noshell
     return
  ENDIF
  IF keyword_set(usage) THEN BEGIN
     cmd=[poldir+'/spice','-usage']
     spawn,cmd,/noshell
     return
  ENDIF
  IF keyword_set(version) THEN BEGIN
     cmd=[poldir+'/spice','-version']
     spawn,cmd,/noshell
     return
  ENDIF

  IF ~keyword_set(apodizesigma) THEN apodizesigma='NO'
  IF ~keyword_set(apodizetype) THEN apodizetype='0'
  IF ~keyword_set(beam1) THEN beam1='NO'
  IF ~keyword_set(beam_file1) THEN beam_file1='NO'
  IF ~keyword_set(beam2) THEN beam2='NO'
  IF ~keyword_set(beam_file2) THEN beam_file2='NO'
  IF ~keyword_set(clfile) THEN clfile='NO'
  IF ~keyword_set(cl_inmap_file) THEN cl_inmap_file='NO'
  IF ~keyword_set(cl_inmask_file) THEN cl_inmask_file='NO'
  IF ~keyword_set(cl_outmap_file) THEN cl_outmap_file='NO'
  IF ~keyword_set(cl_outmask_file) THEN cl_outmask_file='NO'
  IF ~keyword_set(corfile) THEN corfile='NO'
  IF ~keyword_set(covfileout) THEN covfileout='NO'
  IF ~keyword_set(decouple) THEN decouple='NO'
  IF ~keyword_set(dry) THEN dry='NO'
  IF ~keyword_set(extramapfile1) THEN extramapfile1='NO'
  IF ~keyword_set(extramapfile2) THEN extramapfile2='NO'
  IF ~keyword_set(fits_out) THEN fits_out='NO'
  IF ~keyword_set(kernelsfileout) THEN kernelsfileout='NO'
  IF ~keyword_set(listmapfiles1_1) THEN listmapfiles1_1='NO'
  IF ~keyword_set(listmapfiles2_1) THEN listmapfiles2_1='NO'
  IF ~keyword_set(listmapweights1_1) THEN listmapweights1_1='1.0'
  IF ~keyword_set(listmapweights2_1) THEN listmapweights2_1='1.0'
  IF ~keyword_set(mapfile1) THEN mapfile1='YES'  
  IF ~keyword_set(mapfile2) THEN mapfile2='NO'
  IF ~keyword_set(maskfile1) THEN maskfile1='NO'
  IF ~keyword_set(maskfile2) THEN maskfile2='NO'
  IF ~keyword_set(maskfilep1) THEN maskfilep1=maskfile1
  IF ~keyword_set(maskfilep2) THEN maskfilep2=maskfile2
  IF mapfile1 EQ 'YES' THEN BEGIN
     read_fits_map,'map.fits',map
  ENDIF ELSE BEGIN
     read_fits_map,mapfile1,map
  ENDELSE
  nside=sqrt(n_elements(map)/12.)
  IF ~keyword_set(nlmax) THEN nlmax=strtrim(fix(3.*nside-1.),2)
  IF ~keyword_set(noiseclfile) THEN noiseclfile='NO'
  IF ~keyword_set(noisecorfile) THEN noisecorfile='NO'
  IF ~keyword_set(normfac) THEN normfac='NO'
  IF ~keyword_set(optinfile) THEN optinfile='NO'
  IF ~keyword_set(optoutfile) THEN optoutfile='NO'
  IF ~keyword_set(overwrite) THEN overwrite='YES'
  IF ~keyword_set(pixelfile1) THEN pixelfile1='NO'
  IF ~keyword_set(pixelfile2) THEN pixelfile2=pixelfile1
  IF ~keyword_set(polarization) THEN polarization='NO'
  IF ~keyword_set(subav) THEN subav='NO'
  IF ~keyword_set(subdipole) THEN subdipole='NO'
  IF ~keyword_set(symmetric_cl) THEN symmetric_cl='NO'
  IF ~keyword_set(tf_file) THEN tf_file='NO'
  IF ~keyword_set(thetamax) THEN thetamax='NO'
  IF ~keyword_set(tolerance) THEN tolerance='NO'
  IF ~keyword_set(verbosity) THEN verbosity='1'
  IF ~keyword_set(weightfile1) THEN weightfile1='NO'
  IF ~keyword_set(weightfile2) THEN weightfile2='NO'
  IF ~keyword_set(weightfilep1) THEN weightfilep1=weightfile1
  IF ~keyword_set(weightfilep2) THEN weightfilep2=weightfile2
  IF ~keyword_set(weightpower1) THEN weightpower1='1.0'
  IF ~keyword_set(weightpower2) THEN weightpower2='1.0'
  IF ~keyword_set(weightpowerp1) THEN weightpowerp1='YES'
  IF ~keyword_set(weightpowerp2) THEN weightpowerp2='YES'
  IF ~keyword_set(windowfilein) THEN windowfilein='NO'
  IF ~keyword_set(windowfileout) THEN windowfileout='NO'
  
  cmd=[poldir+'/spice',$
       '-apodizesigma',apodizesigma,$
       '-apodizetype',apodizetype,$
       '-beam',beam1,$
       '-beam_file',beam_file1,$
       '-beam2',beam2,$
       '-beam_file2',beam_file2,$
       '-clfile',clfile,$
       '-cl_inmask_file',cl_inmask_file,$
       '-cl_outmap_file',cl_outmap_file,$
       '-cl_outmask_file',cl_outmask_file,$
       '-corfile',corfile,$
       '-covfileout',covfileout,$
       '-decouple',decouple,$
       '-dry',dry,$
       '-extramapfile',extramapfile1,$
       '-extramapfile2',extramapfile2,$
       '-fits_out',fits_out,$
       '-kernelsfileout',kernelsfileout,$
       '-listmapfiles1_1',listmapfiles1_1,$
       '-listmapfiles2_1',listmapfiles2_1,$
       '-listmapweights1_1',listmapweights1_1,$
       '-listmapweights2_1',listmapweights2_1,$
       '-mapfile',mapfile1,$
       '-mapfile2',mapfile2,$
       '-maskfile',maskfile1,$
       '-maskfile2',maskfile2,$
       '-maskfilep',maskfilep1,$
       '-maskfilep2',maskfilep2,$
       '-nlmax',nlmax,$
       '-noiseclfile',noiseclfile,$
       '-noisecorfile',noisecorfile,$
       '-normfac',normfac,$
       '-optinfile',optinfile,$
       '-optoutfile',optoutfile,$
       '-overwrite',overwrite,$
       '-pixelfile',pixelfile1,$
       '-pixelfile2',pixelfile2,$
       '-polarization',polarization,$
       '-subav',subav,$
       '-subdipole',subdipole,$
       '-symmetric_cl',symmetric_cl,$
       '-tf_file',tf_file,$
       '-thetamax',thetamax,$
       '-tolerance',tolerance,$
       '-weightfile',weightfile1,$
       '-weightfile2',weightfile2,$
       '-weightfilep',weightfilep1,$
       '-weightfilep2',weightfilep2,$
       '-weightpower',weightpower1,$
       '-weightpower2',weightpower2,$
       '-weightpowerp',weightpowerp1,$
       '-weightpowerp2',weightpowerp2,$
       '-windowfilein',windowfilein,$
       '-windowfileout',windowfileout]
       
  spawn,cmd,/noshell

  IF keyword_set(bins) THEN BEGIN
     readcol,clfile,ell_raw,cl_raw,format='D'
     IF (n_elements(bins) EQ 1) THEN bin_edges=define_ell_bins(bins,nlmax)
     IF (n_elements(bins) GT 1) THEN bin_edges=bins
     bin_llcl,cl_raw,bin_edges,ell,cls,/uniform
     IF keyword_set(binnedout) THEN BEGIN
        openw,lun,binnedout,/get_lun
        FOR i=0L,n_elements(cl)-1 DO printf,lun,ell[i],cl[i]
        close,lun
     ENDIF
  ENDIF
  
  IF (~keyword_set(bins) AND (keyword_set(ell) OR keyword_set(cl))) THEN $
     readcol,clfile,ell,cls,format='D'
  
  return
END

