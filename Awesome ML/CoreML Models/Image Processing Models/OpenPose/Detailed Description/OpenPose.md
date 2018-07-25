# Authors and Contributors

OpenPose is authored by Gines Hidalgo, Zhe Cao, Tomas Simon, Shih-En Wei, Hanbyul Joo, and Yaser Sheikh. Currently, it is being maintained by Gines Hidalgo, Bikramjot Hanzra, and Yaadhav Raaj. The original CVPR 2017 repo includes Matlab and Python versions, as well as the training code. The body pose estimation work is based on the original ECCV 2016 demo.
In addition, OpenPose would not be possible without the CMU Panoptic Studio dataset.

# Functionality

**Real-time multi-person keypoint detection**.
**15 or 18-keypoint body estimation**. **Running time invariant to number of detected people**.
**2x21-keypoint hand** estimation. Currently, **running time depends** on **number of detected people**.
**70-keypoint face** estimation. Currently, **running time depends** on **number of detected people**.
**Input**: Image, video, webcam, and IP camera. Included C++ demos to add your custom input.
**Output**: Basic image + keypoint display/saving (PNG, JPG, AVI, ...), keypoint saving (JSON, XML, YML, ...), and/or keypoints as array class.
**Available**: command-line demo, C++ wrapper, and C++ API.
**OS**: Ubuntu (14, 16), Windows (8, 10), Nvidia TX2, iOS.

## License

OpenPose is freely available for free non-commercial use, and may be redistributed under these conditions.

