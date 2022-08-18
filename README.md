# Toggle Challenge
This repository contains a solution for the problem proposed.

## Technologies
This project was written using no external dependencies, but there are UI extensions based on the PureLayout framework API to facilitate writing view-related code. 

## Requirements
To be able to run this project you'll need [XcodeGen](https://github.com/yonaskolb/XcodeGen), Xcode (12.5 or higher) and a iOS device running iOS 13.0 or higher. Alternatively you can use a simulator provided with Xcode.

## How to run
If all requirements were met, running the project should be fairly easy. Make sure to follow the steps below:

1. Inside the project directory, run `make xcodegen` to generate the project file.
2. Open the `ToggleChallenge.xcodeproj` with Xcode
3. Once the project opens, select the target `ToggleChallenge`
4. Now select a device (it needs to be plugged in your machine) or a simulator

## Troubleshooting
1. Can't see the FaceID/TouchID login option on the simulator?
	If you're using the simulator, you need to enroll to FaceID/TouchID inside the `Features` menu.

2. Can get past the FaceID/TouchID check?
	Once you have FaceID/TouchID, the app will validate you biometry credentials. To simulate a successful check, use the following shortcut: Option + Command + M

## Module Tree
To see a `diagraph` representation of the modules in the project, run `make export_tree` and copy the graph output and paste it on [GraphvizOnline](https://dreampuf.github.io/GraphvizOnline) or another preferred diagraph interpreter.
