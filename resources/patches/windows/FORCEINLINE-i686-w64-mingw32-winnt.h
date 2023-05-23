From 8da1aae7a7ff5bf996878dc8fe30a0e01e210e5a Mon Sep 17 00:00:00 2001
From: Corinna Vinschen <vinschen@redhat.com>
Date: Tue, 25 Aug 2015 13:51:02 +0200
Subject: [PATCH] winnt.h: FORCELINLINE inline-only definitions

The following test application fails to build on i686 when building
without optimization:

  $ cat foo.c
  #include <windows.h>

  int
  main ()
  {
    MEMORY_BASIC_INFORMATION m;
    NT_TIB *tib = (NT_TIB *) NtCurrentTeb ();
    VirtualQuery (tib, &m, sizeof m);
  }
  $ gcc -g -O foo.c -o foo
  $ gcc -g foo.c -o foo
  /tmp/ccnnAEl3.o: In function `main':
  /home/corinna/foo.c:7: undefined reference to `NtCurrentTeb'
  collect2: error: ld returned 1 exit status

There's no way around that, except for building with optimization, which
is often not prudent when debugging.

In winnt.h, NtCurrentTeb is using __CRT_INLINE which, depending on C
standard, expandes into

  extern inline __attribute__((__gnu_inline__))

or

  extern __inline__

However, that's not sufficient for NtCurrentTeb, nor for GetCurrentFiber,
nor for GetFiberData, since these are inline-only functions not backed by
non-inlined library versions.

This patch fixes that by using FORCEINLINE in place of __CRT_INLINE.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 mingw-w64-headers/include/winnt.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mingw-w64-headers/include/winnt.h b/mingw-w64-headers/include/winnt.h
index 8d8bd0d18..56d663df5 100644
--- a/mingw-w64-headers/include/winnt.h
+++ b/mingw-w64-headers/include/winnt.h
@@ -1995,15 +1995,15 @@ __buildmemorybarrier()
 
 #define DbgRaiseAssertionFailure __int2c
 
-  __CRT_INLINE struct _TEB *NtCurrentTeb(void)
+  FORCEINLINE struct _TEB *NtCurrentTeb(void)
   {
     return (struct _TEB *)__readfsdword(PcTeb);
   }
-  __CRT_INLINE PVOID GetCurrentFiber(void)
+  FORCEINLINE PVOID GetCurrentFiber(void)
   {
     return(PVOID)__readfsdword(0x10);
   }
-  __CRT_INLINE PVOID GetFiberData(void)
+  FORCEINLINE PVOID GetFiberData(void)
   {
       return *(PVOID *)GetCurrentFiber();
   }
