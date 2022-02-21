/*
  $VER: XFADE v0.1c
  DATE: 22-FEB-2022
  TYPE: AREXX / Octamed SoundStudio v1.03c
  PLAT: AMIGA
  SITE: github.com/renewable-intel   
  DOCS: xfade.txt
*/

address OCTAMED_REXX
options results
                                                            
ver='0.1c'                                                     
                                                            
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
    start=RESULT
                                                            
    SA_GETRANGEEND                                          /* get sample end */
    end_=RESULT
                                                                                      
    ulen=len-start                                          /* user start point */

    pct=3                                                   /* xfade % default (3) */    
                                                            
    if start<=0 then SIGNAL _routine                        /* check mode */
        else SIGNAL _user    
                                                                                                                
_user:                                                      /* user mode */
    
    pct=TRUNC(((ulen/len)*100))                             /* convert range to % */
        if pct>=50 then pct=50 
                                                                          
_routine:

    d_len=TRUNC(((len*pct)/100))                            /* convert % to default range */           
    dstart=(len-d_len)                                      /* calculate start point from end */
                                
    SA_RANGE dstart len                                     /* start of routine */  
    SA_CHANGEVOL 100 0
    SA_CUTRANGE    
    SA_RANGE 0 d_len
    SA_CHANGEVOL 0 100
    SA_MIX 100 100
    SA_SETLOOPSTATE ON
    SA_RANGE 0 0
    
    WI_SHOWSTRING ' | XFADE v'ver' | Crossfade: 'pct'% | Status: DONE! |'
    
exit                                                        /* end of routine */
