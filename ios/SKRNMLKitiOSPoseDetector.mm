//
//  SKRNMLKitiOSPoseDetector.m
//  react-native-mlkit-pose-detection
//
//  Created by Switt Kongdachalert on 18/1/2565 BE.
//

#import "SKRNMLKitiOSPoseDetector.h"

#ifdef HAS_SKRN_NATIVE_VIDEO
#import <react-native-native-video/SKiOSNativeVideoCPP.h>
using namespace SKRNNativeVideo;
#endif
using namespace SKRNMLKitPoseDetection;

NSDictionary *SKRNMLKitPoseDetectionMapStringLandmarkNamesToNativeNames = @{
    @"Nose": MLKPoseLandmarkTypeNose,
    @"LeftEyeInner": MLKPoseLandmarkTypeLeftEyeInner,
    @"LeftEye": MLKPoseLandmarkTypeLeftEye,
    @"LeftEyeOuter": MLKPoseLandmarkTypeLeftEyeOuter,
    @"RightEyeInner": MLKPoseLandmarkTypeRightEyeInner,
    @"RightEye": MLKPoseLandmarkTypeRightEye,
    @"RightEyeOuter": MLKPoseLandmarkTypeRightEyeOuter,
    @"LeftEar": MLKPoseLandmarkTypeLeftEar,
    @"RightEar": MLKPoseLandmarkTypeRightEar,
    @"MouthLeft": MLKPoseLandmarkTypeMouthLeft,
    @"MouthRight": MLKPoseLandmarkTypeMouthRight,
    @"LeftShoulder": MLKPoseLandmarkTypeLeftShoulder,
    @"RightShoulder": MLKPoseLandmarkTypeRightShoulder,
    @"LeftElbow": MLKPoseLandmarkTypeLeftElbow,
    @"RightElbow": MLKPoseLandmarkTypeRightElbow,
    @"LeftWrist": MLKPoseLandmarkTypeLeftWrist,
    @"RightWrist": MLKPoseLandmarkTypeRightWrist,
    @"LeftPinkyFinger": MLKPoseLandmarkTypeLeftPinkyFinger,
    @"RightPinkyFinger": MLKPoseLandmarkTypeRightPinkyFinger,
    @"LeftIndexFinger": MLKPoseLandmarkTypeLeftIndexFinger,
    @"RightIndexFinger": MLKPoseLandmarkTypeRightIndexFinger,
    @"LeftThumb": MLKPoseLandmarkTypeLeftThumb,
    @"RightThumb": MLKPoseLandmarkTypeRightThumb,
    @"LeftHip": MLKPoseLandmarkTypeLeftHip,
    @"RightHip": MLKPoseLandmarkTypeRightHip,
    @"LeftKnee": MLKPoseLandmarkTypeLeftKnee,
    @"RightKnee": MLKPoseLandmarkTypeRightKnee,
    @"LeftAnkle": MLKPoseLandmarkTypeLeftAnkle,
    @"RightAnkle": MLKPoseLandmarkTypeRightAnkle,
    @"LeftHeel": MLKPoseLandmarkTypeLeftHeel,
    @"RightHeel": MLKPoseLandmarkTypeRightHeel,
    @"LeftToe": MLKPoseLandmarkTypeLeftToe,
    @"RightToe": MLKPoseLandmarkTypeRightToe
};
NSDictionary *SKRNMLKitPoseDetectionMapNativeLandmarkNamesToStringNames = @{
  MLKPoseLandmarkTypeNose: @"Nose",
  MLKPoseLandmarkTypeLeftEyeInner: @"LeftEyeInner",
  MLKPoseLandmarkTypeLeftEye: @"LeftEye",
  MLKPoseLandmarkTypeLeftEyeOuter: @"LeftEyeOuter",
  MLKPoseLandmarkTypeRightEyeInner: @"RightEyeInner",
  MLKPoseLandmarkTypeRightEye: @"RightEye",
  MLKPoseLandmarkTypeRightEyeOuter: @"RightEyeOuter",
  MLKPoseLandmarkTypeLeftEar: @"LeftEar",
  MLKPoseLandmarkTypeRightEar: @"RightEar",
  MLKPoseLandmarkTypeMouthLeft: @"MouthLeft",
  MLKPoseLandmarkTypeMouthRight: @"MouthRight",
  MLKPoseLandmarkTypeLeftShoulder: @"LeftShoulder",
  MLKPoseLandmarkTypeRightShoulder: @"RightShoulder",
  MLKPoseLandmarkTypeLeftElbow: @"LeftElbow",
  MLKPoseLandmarkTypeRightElbow: @"RightElbow",
  MLKPoseLandmarkTypeLeftWrist: @"LeftWrist",
  MLKPoseLandmarkTypeRightWrist: @"RightWrist",
  MLKPoseLandmarkTypeLeftPinkyFinger: @"LeftPinkyFinger",
  MLKPoseLandmarkTypeRightPinkyFinger: @"RightPinkyFinger",
  MLKPoseLandmarkTypeLeftIndexFinger: @"LeftIndexFinger",
  MLKPoseLandmarkTypeRightIndexFinger: @"RightIndexFinger",
  MLKPoseLandmarkTypeLeftThumb: @"LeftThumb",
  MLKPoseLandmarkTypeRightThumb: @"RightThumb",
  MLKPoseLandmarkTypeLeftHip: @"LeftHip",
  MLKPoseLandmarkTypeRightHip: @"RightHip",
  MLKPoseLandmarkTypeLeftKnee: @"LeftKnee",
  MLKPoseLandmarkTypeRightKnee: @"RightKnee",
  MLKPoseLandmarkTypeLeftAnkle: @"LeftAnkle",
  MLKPoseLandmarkTypeRightAnkle: @"RightAnkle",
  MLKPoseLandmarkTypeLeftHeel: @"LeftHeel",
  MLKPoseLandmarkTypeRightHeel: @"RightHeel",
  MLKPoseLandmarkTypeLeftToe: @"LeftToe",
  MLKPoseLandmarkTypeRightToe: @"RightToe"
};

SKRNMLKitiOSPoseDetector::SKRNMLKitiOSPoseDetector(bool _accurate, SKRNMLKitPoseDetection::PoseDetectorDetectionMode _detectionMode)
: SKRNMLKitPoseDetection::SKRNMLKitPoseDetector(_accurate, _detectionMode)
{
    MLKCommonPoseDetectorOptions *options;
    if(accurate) {
        options = [[MLKAccuratePoseDetectorOptions alloc] init];
    }
    else {
        options = [[MLKPoseDetectorOptions alloc] init];
    }
    switch(detectionMode) {
        case PoseDetectorDetectionModeStream: {
            options.detectorMode = MLKPoseDetectorModeStream;
        } break;
        case PoseDetectorDetectionModeSingleImage: {
            options = [[MLKPoseDetectorOptions alloc] init];
            options.detectorMode = MLKPoseDetectorModeSingleImage;
        } break;
    }
    poseDetector = [MLKPoseDetector poseDetectorWithOptions:options];
}
SKRNMLKitiOSPoseDetector::~SKRNMLKitiOSPoseDetector() {
    NSLog(@"freeing poseDetector");
    poseDetector = nil;
}

std::vector<std::shared_ptr<SKRNMLKitPoseDetectionMLKPose>> SKRNMLKitiOSPoseDetector::processNative(CMSampleBufferRef buf, UIImageOrientation orientation) {
    MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:buf];
    image.orientation = orientation;
    NSError *error;
    NSArray <MLKPose *>*poses = [poseDetector resultsInImage:image error:&error];
    if(error) {
        NSLog(@"Error processing frame %@", error);
    }
//    NSLog(@"poses are %@", poses);
    if(![poses count]) {
        return std::vector<std::shared_ptr<SKRNMLKitPoseDetectionMLKPose>>();
    }
    std::vector<std::shared_ptr<SKRNMLKitPoseDetectionMLKPose>> ret;
    for(MLKPose *pose in poses) {
        ret.push_back(std::make_shared<SKRNMLKitPoseDetectioniOSMLKPose>(pose));
    }
    return ret;
}


#ifdef HAS_SKRN_NATIVE_VIDEO
std::vector<std::shared_ptr<SKRNMLKitPoseDetection::SKRNMLKitPoseDetectionMLKPose>> SKRNMLKitiOSPoseDetector::process(std::shared_ptr<SKRNNativeVideo::SKNativeFrameWrapper> frameWrapper) {
    SKiOSNativeFrameWrapper *frame = (SKiOSNativeFrameWrapper *)(frameWrapper.get());
    return processNative(frame->buffer, frame->orientation);
}
#endif

SKRNMLKitPoseDetectioniOSMLKPose::SKRNMLKitPoseDetectioniOSMLKPose(MLKPose *_pose) {
    pose = _pose;
}
SKRNMLKitPoseDetectioniOSMLKPose::~SKRNMLKitPoseDetectioniOSMLKPose() {
    pose = nil;
}

static SKRNMLKitPoseDetectionMLKPoseLandmark landmarkForMLKPoseLandmark(MLKPoseLandmark *l) {
    auto toPush = SKRNMLKitPoseDetectionMLKPoseLandmark();
    Point3D p;
    p.x = l.position.x; p.y = l.position.y; p.z = l.position.z;
    toPush.type = [SKRNMLKitPoseDetectionMapNativeLandmarkNamesToStringNames[l.type] cStringUsingEncoding:NSUTF8StringEncoding];
    toPush.position = std::move(p);
    toPush.inFrameLikelihood = l.inFrameLikelihood;
    return toPush;
}

std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> SKRNMLKitPoseDetectioniOSMLKPose::landmarks() {
    std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> ret;
    NSArray <MLKPoseLandmark *>*landmarks = [pose landmarks];
    for(MLKPoseLandmark *l in landmarks) {
        auto toPush = landmarkForMLKPoseLandmark(l);
        ret.push_back(std::move(toPush));
    }
//    NSLog(@"got landmarks len %d, outlen %d", landmarks.count, ret.size());
    return ret;
}

SKRNMLKitPoseDetectionMLKPoseLandmark SKRNMLKitPoseDetectioniOSMLKPose::landmarkOfType(std::string landmarkType) {
    MLKPoseLandmark *l = [pose landmarkOfType:SKRNMLKitPoseDetectionMapStringLandmarkNamesToNativeNames[[NSString stringWithUTF8String:landmarkType.c_str()]]];
    return landmarkForMLKPoseLandmark(l);
}

NSDictionary *SKRNMLKitPoseDetectioniOSMLKPose::createNativeDictionary() {
    NSMutableDictionary *poseLandmarks = [NSMutableDictionary new];
    NSArray<MLKPoseLandmark *>*landmarks = [pose landmarks];
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
    return poseLandmarks;
}

