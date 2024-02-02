;;; 
;;; 0-9: name
;;; 10-12: extension
;;; 13-14: sector
;;; 15: no. of sectors

db 'bootSect',0,0,'bin','01','1',\
'kernel',0,0,0,0,'bin','02','4',\
'fileTable',0,'txt','06','1',\
'program1',0,0,'bin','07','1','}'

times 512-($-$$) db 0