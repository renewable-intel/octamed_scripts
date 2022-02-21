/*
  $VER: XFADE v0.1a
  DATE: 22-FEB-2022
  TYPE: AREXX / Octamed SoundStudio v1.03c
  PLAT: AMIGA
  SITE: github.com/renewable-intel   
  DOCS: xfade.txt
*/

address OCTAMED_REXX
options results
                                                            
ver=1.0                                                     
                                                            
IN_GETTYPE                                                  /* check instrument status */
if RESULT = SAMPLE then SIGNAL _init
    else if RESULT = EMPTY then WI_SHOWSTRING ' XFADE v'ver' | status: ERR! (sample buffer empty)'
        else WI_SHOWSTRING ' XFADE v'ver' | status: ERR! (sample instruments only)'
    exit
end

                                                            
_init:
                                                                    
    SA_GETSAMPLELENGTH                                      /* get sample length */ 
    len=RESULT
                                                            
    SA_GETRANGESTART                                        /* get sample start */
    rstart=RESULT
                                                            
    SA_GETRANGEEND                                          /* get sample end */
    rend=RESULT
                                                                                      
    ulen=len-rstart                                         /* user start point */
                                                  
                                                            
    if rstart<=0 then SIGNAL _default                       /* check mode */
        else SIGNAL _user
                 
exit    
    
_default:                                                   /* auto mode */
                                                               
    pct=3                                                   /* xfade % default = 3 - change me!
                                                               (beyond 50 and it stops being affective)*/
                                                             
    d_rlen=TRUNC(((len*pct)/100))                           /* convert % to default range */           
    rstart_buf=(len-d_rlen)                                 /* calculate start point from end */
                                
    SA_RANGE rstart_buf len                                 /* start of routine */
    SA_CHANGEVOL 100 0
    SA_CUTRANGE    
    SA_RANGE 0 d_rlen
    SA_CHANGEVOL 0 100
    SA_MIX 100 100
    SA_SETLOOPSTATE ON
    SA_RANGE 0 0
    
    WI_SHOWSTRING ' | XFADE v'ver' | Crossfade: 'upct'% | Status: DONE! |'
                                                                
exit                                                        /* end of routine */  

_user:                                                      /* user mode */
    
    upct=TRUNC(((ulen/len)*100))                            /* convert range to % */
        if upct>=50 then upct=50
                                                                           
    d_rlen=TRUNC(((len*upct)/100))                          /* convert % to default range */
    rstart_buf=(len-d_rlen)                                 /* calculate start point from end */
                                
    SA_RANGE rstart_buf len                                 /* start of routine */  
    SA_CHANGEVOL 100 0
    SA_CUTRANGE    
    SA_RANGE 0 d_rlen
    SA_CHANGEVOL 0 100
    SA_MIX 100 100
    SA_SETLOOPSTATE ON
    SA_RANGE 0 0
    
    WI_SHOWSTRING ' | XFADE v'ver' | Crossfade: 'upct'% | Status: DONE! |'
    
exit                                                        /* end of routine */