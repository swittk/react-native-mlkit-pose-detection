#import <React/RCTBridgeModule.h>

#ifndef HAS_VISION_CAMERA
#if __has_include(<VisionCamera/Frame.h>)
#define HAS_VISION_CAMERA 1
@class Frame;
#endif
#endif

#ifdef __cplusplus

#import "react-native-mlkit-pose-detection.h"

#endif

@interface SKRNMlkitPoseDetection : NSObject <RCTBridgeModule>
@property (nonatomic, assign) BOOL setBridgeOnMainQueue;
@end
