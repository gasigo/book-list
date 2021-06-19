# Toggle Challenge
This repository contains a solution for the problem proposed.

## Technologies
This project was written using only one external dependency: [PureLayout](https://github.com/PureLayout/PureLayout). It helps providing a easy to read interface to write UI related code.

## Requirements
To be able to run this project you'll need Xcode (12.5 or higher) and a iOS device running iOS 13.0 or higher. Alternatively you can use a simulator provided with Xcode.

## How to run
If all requirements were met, running the project should be fairly easy. Make sure to follow the steps below:

1. Inside the project directory, go to `solution/ToggleChallenge`
2. Open the `ToggleChallenge.xcworkspace` with Xcode
3. Once the project opens, select the target `ToggleChallenge`
4. Now select a device (it needs to be plugged in your machine) or a simulator

## Troubleshooting
1. Can't see the FaceID/TouchID login option on the simulator?
	If you're using the simulator, you need to enroll to FaceID/TouchID inside the `Features` menu.

2. Can get past the FaceID/TouchID check?
	Once you have FaceID/TouchID, the app will validate you biometry credentials. To simulate a successful check, use the following shortcut: Option + Command + M