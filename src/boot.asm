[org 0x7c00]

start:
    call loadDisk

%include "include/utility/disk_load.inc"

times 510-($-$$) db 0
dw 0xAA55