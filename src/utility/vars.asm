welcome: db 'Kernel Booted!', 0xA, 0xD, \
 '--------------', 0xA, 0xD, 0xA, 0xD, \
  'F) File Browser', 0xA, 0xD, \
   'R) Reboot',0xA, 0xD, \
   'P) Print Registers', 0xA, 0xD, \
   'G) GFX Mode Test', 0xA, 0xD, \
    0xA, 0xD, 0

nl: db 0xA, 0xD, 0

fileTableHeading: db '-------------------------------------------', 0xA, 0xD, \
 'File/Program    Extension    Sector    Size', 0xA,0xD, \
 '-------------------------------------------', 0xA,0xD, \
 0xA, 0xD, 0

printRegisterHeading: db '--------        ------', 0xA, 0xD, \
'Register        Memory', 0xA, 0xD,\
'--------        ------', 0xA, 0xD, 0

success: db 'Command ran successfully!', 0xA, 0xD, 0

failure: db 'Command not found!', 0xA, 0xD, 0

regString: db 0xA, 0xD, 'dx                ', 0

hexString: db '0x0000', 0

cmdLength: db 0

fileNotFoundMsg: db 'File/Program Not Found!', 0xA, 0xD, 0

invalidSectorMsg: db 'Sector Not Found!', 0xA, 0xD, 0

unableToLoadMsg: db 'File/Program Not Loaded!', 0xA, 0xD, 0



cmdString: db '', 0