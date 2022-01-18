#import <React/RCTBridgeModule.h>
#if __has_include(<VisionCamera/Frame.h>)
#define HAS_VISION_CAMERA 1
@class Frame;
#endif
#ifdef __cplusplus

#import "react-native-mlkit-pose-detection.h"

#endif

@interface SKRNMlkitPoseDetection : NSObject <RCTBridgeModule>
@property (nonatomic, assign) BOOL setBridgeOnMainQueue;
#if HAS_VISION_CAMERA
-(NSDictionary *)poseResultsForVisionCameraFrame:(Frame *)frame;
#endif
@end
