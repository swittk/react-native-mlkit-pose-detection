#import "SKRNMLKitPoseDetection.h"
#import "react-native-mlkit-pose-detection.h"
#import <React/RCTUtils.h>
#import <React/RCTBridge+Private.h>
#import <jsi/jsi.h>
#import <ReactCommon/CallInvoker.h>
#import "SKRNMLKitiOSPoseDetector.h"
#if HAS_VISION_CAMERA
#import "SKRNMLKitPoseDetectionVisionCameraFrameProcessor.h"
#endif
using namespace SKRNMLKitPoseDetection;

@implementation SKRNMlkitPoseDetection {
}
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()



+ (BOOL)requiresMainQueueSetup {
    return YES;
}



- (void)setBridge:(RCTBridge *)bridge {
    _bridge = bridge;
    _setBridgeOnMainQueue = RCTIsMainQueue();
    [self installLibrary];
}

-(void)installLibrary {
//    self.bridge.reactInstance;
    RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
    if (!cxxBridge.runtime) {
        
        /**
         * This is a workaround to install library
         * as soon as runtime becomes available and is
         * not recommended. If you see random crashes in iOS
         * global.xxx not found etc. use this.
         */
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            /**
             When refreshing the app while debugging, the setBridge
             method is called too soon. The runtime is not ready yet
             quite often. We need to install library as soon as runtime
             becomes available.
             */
            [self installLibrary];
            
        });
        return;
    }
    facebook::jsi::Runtime *runtime = (facebook::jsi::Runtime *)cxxBridge.runtime;
    install(*runtime, [](facebook::jsi::Runtime& runtime, bool accurate, PoseDetectorDetectionMode detectionMode) -> std::shared_ptr<SKRNMLKitPoseDetector> {
        std::shared_ptr<SKRNMLKitPoseDetector>ret =  std::make_shared<SKRNMLKitiOSPoseDetector>(accurate, detectionMode);
        return ret;
    });
#if HAS_VISION_CAMERA
    [[SKRNMLKitPoseDetectionVisionCameraFrameProcessor sharedInstance] initialize];
#endif
}

- (void)invalidate {
    RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
    facebook::jsi::Runtime *runtime = (facebook::jsi::Runtime *)cxxBridge.runtime;
    cleanup(*runtime);
#if HAS_VISION_CAMERA
    [[SKRNMLKitPoseDetectionVisionCameraFrameProcessor sharedInstance] invalidate];
#endif
}


#if HAS_VISION_CAMERA

RCT_REMAP_METHOD(initializeVisionCameraFrameProcessorWithOptions,
                 initializeVisionCameraFrameProcessorWithOptions:(NSDictionary *)optionsDict
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)
{
    BOOL result = [[SKRNMLKitPoseDetectionVisionCameraFrameProcessor sharedInstance] initializePoseDetectorWithOptions:optionsDict];
    resolve(@(result));
}

#endif



@end
