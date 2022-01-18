import type { Frame } from 'react-native-vision-camera'
import type { MLKitPoseDetectionLandmarkKeyType, SKRNMLKitPoseDetectionMLKPoseLandmark } from './index';

export type SKRNMLKitVisionCameraPluginResultPoseItem = {
  [key in MLKitPoseDetectionLandmarkKeyType]?: SKRNMLKitPoseDetectionMLKPoseLandmark
}

/**
 * Scans frame for MLKit poses.
 */
export function scanSKRNMLKitPose(frame: Frame): SKRNMLKitVisionCameraPluginResultPoseItem[] {
  'worklet'
  // @ts-expect-error
  return __SKRNMLKitPoseDetectionVisionCameraFrameProcessorPlugin(frame)
}
