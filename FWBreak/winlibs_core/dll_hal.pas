(*
          1    0 00002940 ExAcquireFastMutex
          2    1 00002974 ExReleaseFastMutex
          3    2 0000299C ExTryToAcquireFastMutex
         20    3 00007910 HalAcquireDisplayOwnership
         21    4 00006EB4 HalAdjustResourceList
         22    5 0001DEE4 HalAllProcessorsStarted
         23    6 000055C2 HalAllocateAdapterChannel
         24    7 0000443A HalAllocateCommonBuffer
         25    8 00004FBE HalAllocateCrashDumpRegisters
         26    9 00018EE2 HalAssignSlotResources
         27    A 00002F68 HalBeginSystemInterrupt
         28    B 00007B76 HalCalibratePerformanceCounter
          4    C 00002BB0 HalClearSoftwareInterrupt
         29    D 0000854E HalDisableSystemInterrupt
         30    E 00007918 HalDisplayString
         31    F 00008446 HalEnableSystemInterrupt
         32   10 00002F0C HalEndSystemInterrupt
         33   11 0000449E HalFlushCommonBuffer
         34   12 000044A8 HalFreeCommonBuffer
         35   13 00017754 HalGetAdapter
         36   14 00007032 HalGetBusData
         37   15 00006EBE HalGetBusDataByOffset
         38   16 00003ED2 HalGetEnvironmentVariable
         39   17 00006FAE HalGetInterruptVector
         40   18 00005D0E HalHandleNMI
         41   19 0001D9E8 HalInitSystem
         42   1A 00001760 HalInitializeProcessor
         43   1B 00008B60 HalMakeBeep
         44   1C 00008B54 HalProcessorIdle
         45   1D 00007928 HalQueryDisplayParameters
         46   1E 00007B10 HalQueryRealTimeClock
         47   1F 000054C2 HalReadDmaCounter
         48   20 0001DF5A HalReportResourceUsage
         49   21 00001EAC HalRequestIpi
          5   22 00002B68 HalRequestSoftwareInterrupt
         50   23 00003FF0 HalReturnToFirmware
         51   24 00007056 HalSetBusData
         52   25 00006F4E HalSetBusDataByOffset
         53   26 00007930 HalSetDisplayParameters
         54   27 00003F3A HalSetEnvironmentVariable
         55   28 00002494 HalSetProfileInterval
         56   29 00007B28 HalSetRealTimeClock
         57   2A 00007B64 HalSetTimeIncrement
         58   2B 000143B0 HalStartNextProcessor
         59   2C 00002458 HalStartProfileInterrupt
         60   2D 0000247C HalStopProfileInterrupt
          6   2E 00006EB4 HalSystemVectorDispatchEntry
         61   2F 0000707A HalTranslateBusAddress
         62   30 00016F12 IoAssignDriveLetters
         63   31 00005778 IoFlushAdapterBuffers
         64   32 00004694 IoFreeAdapterChannel
         65   33 00004792 IoFreeMapRegisters
         66   34 0000570A IoMapTransfer
         67   35 00016F32 IoReadPartitionTable
         68   36 00016F52 IoSetPartitionInformation
         69   37 00016F72 IoWritePartitionTable
         70   38 0000D920 KdComPortInUse
          7   39 000029F0 KeAcquireInStackQueuedSpinLock
          8   3A 000029E0 KeAcquireInStackQueuedSpinLockRaiseToSynch
          9   3B 00002A4C KeAcquireQueuedSpinLock
         10   3C 00002A3C KeAcquireQueuedSpinLockRaiseToSynch
         71   3D 00006AC4 KeAcquireSpinLock
         11   3E 00002870 KeAcquireSpinLockRaiseToSynch
         72   3F 00007B0A KeFlushWriteBuffer
         73   40 00002428 KeGetCurrentIrql
         74   41 00006AAE KeLowerIrql
         75   42 00007B94 KeQueryPerformanceCounter
         76   43 00006A92 KeRaiseIrql
         77   44 000023D8 KeRaiseIrqlToDpcLevel
         78   45 000023F4 KeRaiseIrqlToSynchLevel
         12   46 00002AA0 KeReleaseInStackQueuedSpinLock
         13   47 00002AA8 KeReleaseQueuedSpinLock
         79   48 00006AE0 KeReleaseSpinLock
         80   49 00007BA6 KeStallExecutionProcessor
         14   4A 00002B08 KeTryToAcquireQueuedSpinLock
         15   4B 00002B00 KeTryToAcquireQueuedSpinLockRaiseToSynch
         16   4C 00002830 KfAcquireSpinLock
         17   4D 00002410 KfLowerIrql
         18   4E 000023B8 KfRaiseIrql
         19   4F 00002900 KfReleaseSpinLock
         81   50 00008A74 READ_PORT_BUFFER_UCHAR
         82   51 00008AA4 READ_PORT_BUFFER_ULONG
         83   52 00008A8C READ_PORT_BUFFER_USHORT
         84   53 00008A54 READ_PORT_UCHAR
         85   54 00008A6C READ_PORT_ULONG
         86   55 00008A60 READ_PORT_USHORT
         87   56 00008AEC WRITE_PORT_BUFFER_UCHAR
         88   57 00008B1C WRITE_PORT_BUFFER_ULONG
         89   58 00008B04 WRITE_PORT_BUFFER_USHORT
         90   59 00008ABC WRITE_PORT_UCHAR
         91   5A 00008AD8 WRITE_PORT_ULONG
         92   5B 00008AC8 WRITE_PORT_USHORT
*)
unit dll_hal;

interface

implementation

end.