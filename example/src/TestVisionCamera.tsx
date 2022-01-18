import * as React from 'react';
import { useRef, useState, useMemo, useCallback } from 'react';
import { AppState, AppStateStatus, StyleSheet, Text, View } from 'react-native';
import {
  CameraDeviceFormat,
  CameraRuntimeError,
  FrameProcessorPerformanceSuggestion,
  PhotoFile,
  sortFormats,
  useCameraDevices,
  useFrameProcessor,
  VideoFile,
} from 'react-native-vision-camera';
import { Camera, frameRateIncluded } from 'react-native-vision-camera';
import Reanimated, { Extrapolate, interpolate, useAnimatedGestureHandler, useAnimatedProps, useSharedValue } from 'react-native-reanimated';
import { useEffect } from 'react';
import { initializeVisionCameraFrameProcessor, scanSKRNMLKitPose } from 'react-native-mlkit-pose-detection';
const MAX_ZOOM_FACTOR = 2;


const useIsForeground = (): boolean => {
  const [isForeground, setIsForeground] = useState(true);

  useEffect(() => {
    const onChange = (state: AppStateStatus): void => {
      setIsForeground(state === 'active');
    };
    AppState.addEventListener('change', onChange);
    return () => AppState.removeEventListener('change', onChange);
  }, [setIsForeground]);

  return isForeground;
};

const ReanimatedCamera = Reanimated.createAnimatedComponent(Camera);
Reanimated.addWhitelistedNativeProps({
  zoom: true,
});

const SCALE_FULL_ZOOM = 3;
const BUTTON_SIZE = 40;

export function TestVisionCamera(props: {

}): React.ReactElement {
  const camera = useRef<Camera>(null);
  const [isCameraInitialized, setIsCameraInitialized] = useState(false);
  const [hasMicrophonePermission, setHasMicrophonePermission] = useState(false);
  const zoom = useSharedValue(0);
  const isPressingButton = useSharedValue(false);

  // check if camera page is active
  const isForeground = useIsForeground();
  const isActive = isForeground;

  const [cameraPosition, setCameraPosition] = useState<'front' | 'back'>('back');
  const [enableHdr, setEnableHdr] = useState(false);
  const [flash, setFlash] = useState<'off' | 'on'>('off');
  const [enableNightMode, setEnableNightMode] = useState(false);

  // camera format settings
  const devices = useCameraDevices();
  const device = devices[cameraPosition];
  const formats = useMemo<CameraDeviceFormat[]>(() => {
    if (device?.formats == null) return [];
    return device.formats.sort(sortFormats);
  }, [device?.formats]);

  //#region Memos
  const [is60Fps, setIs60Fps] = useState(true);
  const fps = useMemo(() => {
    if (!is60Fps) return 30;

    if (enableNightMode && !device?.supportsLowLightBoost) {
      // User has enabled Night Mode, but Night Mode is not natively supported, so we simulate it by lowering the frame rate.
      return 30;
    }

    const supportsHdrAt60Fps = formats.some((f) => f.supportsVideoHDR && f.frameRateRanges.some((r) => frameRateIncluded(r, 60)));
    if (enableHdr && !supportsHdrAt60Fps) {
      // User has enabled HDR, but HDR is not supported at 60 FPS.
      return 30;
    }

    const supports60Fps = formats.some((f) => f.frameRateRanges.some((r) => frameRateIncluded(r, 60)));
    if (!supports60Fps) {
      // 60 FPS is not supported by any format.
      return 30;
    }
    // If nothing blocks us from using it, we default to 60 FPS.
    return 60;
  }, [device?.supportsLowLightBoost, enableHdr, enableNightMode, formats, is60Fps]);

  const supportsCameraFlipping = useMemo(() => devices.back != null && devices.front != null, [devices.back, devices.front]);
  const supportsFlash = device?.hasFlash ?? false;
  const supportsHdr = useMemo(() => formats.some((f) => f.supportsVideoHDR || f.supportsPhotoHDR), [formats]);
  const supports60Fps = useMemo(() => formats.some((f) => f.frameRateRanges.some((rate) => frameRateIncluded(rate, 60))), [formats]);
  const canToggleNightMode = enableNightMode
    ? true // it's enabled so you have to be able to turn it off again
    : (device?.supportsLowLightBoost ?? false) || fps > 30; // either we have native support, or we can lower the FPS
  //#endregion

  const format = useMemo(() => {
    let result = formats;
    if (enableHdr) {
      // We only filter by HDR capable formats if HDR is set to true.
      // Otherwise we ignore the `supportsVideoHDR` property and accept formats which support HDR `true` or `false`
      result = result.filter((f) => f.supportsVideoHDR || f.supportsPhotoHDR);
    }

    // find the first format that includes the given FPS
    return result.find((f) => f.frameRateRanges.some((r) => frameRateIncluded(r, fps)));
  }, [formats, fps, enableHdr]);

  //#region Animated Zoom
  // This just maps the zoom factor to a percentage value.
  // so e.g. for [min, neutr., max] values [1, 2, 128] this would result in [0, 0.0081, 1]
  const minZoom = device?.minZoom ?? 1;
  const maxZoom = Math.min(device?.maxZoom ?? 1, MAX_ZOOM_FACTOR);

  const cameraAnimatedProps = useAnimatedProps(() => {
    const z = Math.max(Math.min(zoom.value, maxZoom), minZoom);
    return {
      zoom: z,
    };
  }, [maxZoom, minZoom, zoom]);
  //#endregion

  //#region Callbacks
  const setIsPressingButton = useCallback(
    (_isPressingButton: boolean) => {
      isPressingButton.value = _isPressingButton;
    },
    [isPressingButton],
  );
  // Camera callbacks
  const onError = useCallback((error: CameraRuntimeError) => {
    console.error(error);
  }, []);
  const onInitialized = useCallback(() => {
    console.log('Camera initialized!');
    setIsCameraInitialized(true);
  }, []);
  const onFlipCameraPressed = useCallback(() => {
    setCameraPosition((p) => (p === 'back' ? 'front' : 'back'));
  }, []);
  const onFlashPressed = useCallback(() => {
    setFlash((f) => (f === 'off' ? 'on' : 'off'));
  }, []);
  //#endregion

  //#region Tap Gesture
  const onDoubleTap = useCallback(() => {
    onFlipCameraPressed();
  }, [onFlipCameraPressed]);
  //#endregion

  //#region Effects
  const neutralZoom = device?.neutralZoom ?? 1;
  useEffect(() => {
    // Run everytime the neutralZoomScaled value changes. (reset zoom when device changes)
    zoom.value = neutralZoom;
  }, [neutralZoom, zoom]);

  useEffect(() => {
    Camera.getMicrophonePermissionStatus().then((status) => setHasMicrophonePermission(status === 'authorized'));
  }, []);
  //#endregion

  if (device != null && format != null) {
    console.log(
      `Re-rendering camera page with ${isActive ? 'active' : 'inactive'} camera. ` +
      `Device: "${device.name}" (${format.photoWidth}x${format.photoHeight} @ ${fps}fps)`,
    );
  } else {
    console.log('re-rendering camera page without active camera');
  }

  const frameProcessor = useFrameProcessor((frame) => {
    'worklet';
    const pose = scanSKRNMLKitPose(frame);
    console.log(`Return Pose: ${JSON.stringify(pose)}`);
  }, []);

  const onFrameProcessorSuggestionAvailable = useCallback((suggestion: FrameProcessorPerformanceSuggestion) => {
    console.log(`Suggestion available! ${suggestion.type}: Can do ${suggestion.suggestedFrameProcessorFps} FPS`);
  }, []);

  return (
    <View style={styles.container}>
      {device != null && (
        <Reanimated.View style={StyleSheet.absoluteFill}>
          <ReanimatedCamera
            ref={camera}
            style={StyleSheet.absoluteFill}
            device={device}
            format={format}
            fps={fps}
            hdr={enableHdr}
            lowLightBoost={device.supportsLowLightBoost && enableNightMode}
            isActive={isActive}
            onInitialized={onInitialized}
            onError={onError}
            enableZoomGesture={false}
            animatedProps={cameraAnimatedProps}
            photo={true}
            video={true}
            audio={hasMicrophonePermission}
            frameProcessor={device.supportsParallelVideoProcessing ? frameProcessor : undefined}
            orientation="portrait"
            frameProcessorFps={1}
            onFrameProcessorPerformanceSuggestionAvailable={onFrameProcessorSuggestionAvailable}
          />
        </Reanimated.View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'black',
  },
  text: {
    color: 'white',
    fontSize: 11,
    fontWeight: 'bold',
    textAlign: 'center',
  },
});
