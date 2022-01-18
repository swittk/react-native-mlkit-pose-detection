import { NativeModules, Platform } from 'react-native';
import type { NativeFrameWrapper } from 'react-native-native-video';
const LINKING_ERROR =
  `The package 'react-native-mlkit-pose-detection' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const MLKitPoseDetectionLandmarkKeys = ["Nose", "LeftEyeInner", "LeftEye", "LeftEyeOuter", "RightEyeInner", "RightEye", "RightEyeOuter", "LeftEar", "RightEar", "MouthLeft", "MouthRight", "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow", "LeftWrist", "RightWrist", "LeftPinkyFinger", "RightPinkyFinger", "LeftIndexFinger", "RightIndexFinger", "LeftThumb", "RightThumb", "LeftHip", "RightHip", "LeftKnee", "RightKnee", "LeftAnkle", "RightAnkle", "LeftHeel", "RightHeel", "LeftToe", "RightToe"] as const;
type MLKitPoseDetectionLandmarkKeyType = (typeof MLKitPoseDetectionLandmarkKeys)[number];

// const MlkitPoseDetection = 
NativeModules.MlkitPoseDetection
  ? NativeModules.MlkitPoseDetection
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );
export interface Position3D {
  x: number; y: number; z: number;
}

export interface SKRNMLKitPoseDetectionMLKPoseLandmark {
  inFrameLikelihood: number;
  position: Position3D;
  type: MLKitPoseDetectionLandmarkKeyType
}

export interface SKRNMLKitPoseDetectionMLKPose {
  landmarks(): SKRNMLKitPoseDetectionMLKPoseLandmark[];
  landmarkOfType(type: MLKitPoseDetectionLandmarkKeyType): SKRNMLKitPoseDetectionMLKPoseLandmark;
}

export interface SKRNMLKitPoseDetector {
  process(frame: NativeFrameWrapper): SKRNMLKitPoseDetectionMLKPose[];
}

// function multiply(a: number, b: number): Promise<number> {
//   return MlkitPoseDetection.multiply(a, b);
// }

export function MLKitPoseDetector(accurate?: boolean, detectionMode?: 'stream' | 'single'): SKRNMLKitPoseDetector {
  return (global as any).SKRNMLKitPoseDetectionNewPoseDetector(accurate, detectionMode);
}
