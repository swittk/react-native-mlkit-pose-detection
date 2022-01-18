//
//  SKRNMLKitPoseDetectionVisionCameraFrameProcessor.h
//  react-native-mlkit-pose-detection
//
//  Created by Switt Kongdachalert on 18/1/2565 BE.
//

#import "SKRNMLKitPoseDetection.h"
#if HAS_VISION_CAMERA
#import <Foundation/Foundation.h>
#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/Frame.h>


@interface SKRNMLKitPoseDetectionVisionCameraFrameProcessor : NSObject
+(SKRNMLKitPoseDetectionVisionCameraFrameProcessor *)sharedInstance;
-(BOOL)initializePoseDetectorWithOptions:(NSDictionary *)options;
-(void)invalidate;
-(void)initialize;
@end
#endif
