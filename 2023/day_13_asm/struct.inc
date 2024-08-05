struc STAT {
    .st_dev     dd  ?     ; ID of device containing file

    .pad1       dd  ?

    .st_ino     dd  ?     ; inode number
    .st_mode    dd  ?     ; protection
    .st_nlink   dd  ?     ; number of hard links

    .pad2       dq  ?

    .st_uid     dd  ?     ; user ID of owner
    .st_gid     dd  ?     ; group ID of owner

    .pad3       dq  ?
    .pad4       dd  ?

    .st_size    dq  ?     ; total size, in bytes
    .st_blocks  dq  ?
    .st_blksize dd  ?     ; block size

    .pad5       dd  ?

    .st_atime   dq  ?     ; time of last access
    .st_atime_nsec   dq  ?     ; time of last access
    .st_mtime   dq  ?     ; time of last modification
    .st_mtime_nsec   dq  ?     ; time of last modification
    .st_ctime   dq  ?     ; time of last status change
    .st_ctime_nsec   dq  ?     ; time of last status change
}


; struc STAT {
;    .st_dev     dd  ?     ; ID of device containing file
;    .pad1       dd  ?
;    .st_ino     dd  ?     ; inode number
;    .st_mode    dw  ?     ; protection
;    .st_nlink   dw  ?     ; number of hard links
;    .st_uid     dw  ?     ; user ID of owner
;    .st_gid     dw  ?     ; group ID of owner
;    .st_rdev    dw  ?     ; device ID (if special file)
;    .pad2       dd  ?
;    .pad3       dw  ?
;    .st_size    dd  ?     ; total size, in bytes
;    .st_blksize dd  ?     ; block size
;    .st_blocks  dd  ?
; 
;    .st_atime   dd  ?     ; time of last access
;    .unused1    dd  ?
; 
;    .st_mtime   dd  ?     ; time of last modification
;    .unused2    dd  ?
; 
;    .st_ctime   dd  ?     ; time of last status change
;    .unused3    dd  ?
;    .unused4    dd  ?
;    .unused5    dd  ?
; }
