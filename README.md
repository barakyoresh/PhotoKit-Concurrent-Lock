# PhotoKit-Concurrent-Lock
Demo application that displays a single collection view of PhotoKit images.

## Reproducing issue
1. Open the app via Xcode with access to the debugger, make sure you give access to the photo library.
2. Scroll vigorously through the images.

### Expected results
The app should scroll through the photos.

### Actual results
The app stops responding. At this point there are several variations, all including many concurrent worker threads and originating with PhotoKit.
##### "live lock" 
The CPU usage climbs to ~200%, a large amount of worker threads are open, and many of them active.
The main thread is stopped at either
```
[PHCoreImageManager _cancelAsynchronousRequestWithID:] -> ... -> _OSSpinLockLockSlow$VATIANY$wfe
```
or
```
[PHCoreImageManager _processImageRequest:sync:] -> ... -> _OSSpinLockLockSlow$VATIANY$wfe
```
And most of the other threads are stopped at
```
[PLJPEGPreheatItem startPreheatRequestWithCompletionHandler] -> ... -> _OSSpinLockLockSlow$VATIANY$wfe -> syscall_thread_switch
```

##### "dead lock"
The CPU usage drops to 0%, a large amount of worker threads are open.
The majority of threads are stopped at
```
[PHCoreImageManager _processImageRequest:sync:] -> [PHCoreImageManager _preheatItemCreateIfNeededWithAsset...] -> ... -> semaphore_wait_trap
```
