# react-native-mlkit-pose-detection

MLKit Pose Detection (currently iOS only)

Supports
- Regular videos (from file system) via `react-native-native-video` (by me!)
- Live videos via Frame processor plugins of `react-native-vision-camera` (by @mrousavy)


## Installation

```sh
npm install react-native-mlkit-pose-detection
```

For Vision Camera to work, you must add the babel plugin
````ts
module.exports = {
  plugins: [
    [
      'react-native-reanimated/plugin',
      {
        globals: ['__SKRNMLKitPoseDetectionVisionCameraFrameProcessorPlugin'],
      },
    ],
````

## Usage

TODO: DO THIS
(See example for now)

```js
import { multiply } from "react-native-mlkit-pose-detection";

// ...

const result = await multiply(3, 7);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
