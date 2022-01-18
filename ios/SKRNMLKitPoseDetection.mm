#import "MlkitPoseDetection.h"
#import "react-native-mlkit-pose-detection.h"
#import <React/RCTUtils.h>
#import <React/RCTBridge+Private.h>
#import <jsi/jsi.h>
#import <ReactCommon/CallInvoker.h>
#import "SKRNMLKitiOSPoseDetector.h"
#if HAS_VISION_CAMERA
#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/Frame.h>
#endif
using namespace SKRNMLKitPoseDetection;

extern NSDictionary *SKRNMLKitPoseDetectionMapStringLandmarkNamesToNativeNames;
extern NSDictionary *SKRNMLKitPoseDetectionMapNativeLandmarkNamesToStringNames;

@implementation SKRNMlkitPoseDetection {
#if HAS_VISION_CAMERA
    MLKPoseDetector *poseDetector;
#endif
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
        std::shared_ptr<SKRNMLKitPoseDetector>ret =  std::make_shared<SKRNMLKitiOSPoseDetector>(runtime, accurate, detectionMode);
        return ret;
    });
}

- (void)invalidate {
    RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;
    facebook::jsi::Runtime *runtime = (facebook::jsi::Runtime *)cxxBridge.runtime;
    cleanup(*runtime);
}


#if HAS_VISION_CAMERA

RCT_EXPORT_METHOD(initializeVisionCameraFrameProcessorWithOptions:(NSDictionary *)optionsDict
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)
{
    BOOL accurate = [optionsDict[@"accurate"] boolValue];
    BOOL detectionModeStream = [optionsDict[@"detectionMode"] isEqualToString:@"stream"];
    
    MLKCommonPoseDetectorOptions *options;
    if(accurate) {
        options = [[MLKAccuratePoseDetectorOptions alloc] init];
    }
    else {
        options = [[MLKPoseDetectorOptions alloc] init];
    }
    
    if(detectionModeStream) {
        options.detectorMode = MLKPoseDetectorModeStream;
    }
    else {
        options.detectorMode = MLKPoseDetectorModeSingleImage;
    }
    poseDetector = [MLKPoseDetector poseDetectorWithOptions:options];
    resolve(@(YES));
}
-(NSArray <NSDictionary *>*)posesToBridge:(NSArray <MLKPose *>*)poses {
    NSMutableArray *ret = [NSMutableArray new];
    for(MLKPose *p in poses) {
        NSMutableDictionary *poseLandmarks = [NSMutableDictionary new];
        NSArray<MLKPoseLandmark *>*landmarks = [p landmarks];
        for(MLKPoseLandmark *l in landmarks) {
            NSString *outType = SKRNMLKitPoseDetectionMapNativeLandmarkNamesToStringNames[l.type];
            NSDictionary *convDict = @{
                @"type": outType,
                @"inFrameLikelihood": @(l.inFrameLikelihood),
                @"position":@{
                    @"x": @(l.position.x),
                    @"y": @(l.position.y),
                    @"z": @(l.position.z)
                }
            };
            [poseLandmarks setObject:convDict forKey:outType];
        }
        [ret addObject:poseLandmarks];
    }
    return ret;
}
-(NSArray <NSDictionary *>*)poseResultsForVisionCameraFrame:(Frame *)frame {
    if(!poseDetector) {
        throw [NSError errorWithDomain:@"SKRNMLKitPoseDetection" code:404 userInfo:@{NSLocalizedDescriptionKey:@"Pose detector is not initialized yet. Call initializeVisionCameraFrameProcessorWithOptions: first"}];
    }
    MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:frame.buffer];
    image.orientation = frame.orientation;
    NSError *error;
    NSArray <MLKPose *>*poses = [poseDetector resultsInImage:image error:&error];
    if(error) {
        NSLog(@"Error processing frame %@", error);
    }
    return [self posesToBridge:poses];
}

static inline id SKRNMLKitPoseDetectionVisionCameraFrameProcessorPlugin(Frame* frame, NSArray* arguments) {
  CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(frame.buffer);
  NSLog(@"ExamplePlugin: %zu x %zu Image. Logging %lu parameters:", CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer), (unsigned long)arguments.count);
  
  for (id param in arguments) {
    NSLog(@"ExamplePlugin:   -> %@ (%@)", param == nil ? @"(nil)" : [param description], NSStringFromClass([param classForCoder]));
  }
  
  return [SKRNMlkitPoseDetection shared]
}

VISION_EXPORT_FRAME_PROCESSOR(SKRNMLKitPoseDetectionVisionCameraFrameProcessorPlugin);

#endif



@end
