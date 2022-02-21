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
                                                            
_init:
                                                                    
    SA_GETSAMPLELENGTH                                      /* get sample length */ 
    len=RESULT
                                                            
    SA_GETRANGESTART                                        /* get sample start */
    start=RESULT
                                                            
    SA_GETRANGEEND                                          /* get sample end */
    end_=RESULT
                                                                                      
    ulen=len-start                                          /* user start / end */

    pct=3                                                   /* xfade % default (3) */    
                                                            
    if start<=0 then SIGNAL _routine                        /* check mode */
        else SIGNAL _user    
                                                                                                                
_user:                                                      /* user mode */
    
    pct=TRUNC(((ulen/len)*100))                             /* convert range to % */
        if pct>=50 then pct=50 
                                                                          
_routine:

    d_len=TRUNC(((len*pct)/100))                            /* convert % to range */           
    dstart=(len-d_len)                                      /* calculate selection length */
                                
    SA_RANGE dstart len                                     /* select buffer range */  
    SA_CHANGEVOL 100 0                                      /* fadeout (100 - 0) */
    SA_CUTRANGE                                             /* cut range */
    SA_RANGE 0 d_len                                        /* select range at the beginning */      
    SA_CHANGEVOL 0 100                                      /* fadein (0 to 100) */
    SA_MIX 100 100                                          /* mix copybuffer with sample */
    SA_SETLOOPSTATE ON                                      /* turn on looping */
    SA_RANGE 0 0                                            /* reset range */
    
    WI_SHOWSTRING ' | XFADE v'ver' | Crossfade: 'pct'% | Status: DONE! |'
    
exit                                                        /* end of routine */
