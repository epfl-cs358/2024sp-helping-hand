# Helping Hand

**Beyond Accessibility: Unleashing the Potential of Home Automation to Foster Independence and Inclusivity for Individuals with Unique Needs**

2024 - EPFL (CS-358) MIT - Group project

<img src="documentation/images/main.png" width="600">

## Project's Overview

Helping Hand is an innovative project designed to enhance the independence of individuals with **mobility impairments** through adaptable **home automation**.
The core of the project is a **modular box** equipped with a **Wi-Fi** enabled microcontroller and a plotter like mechanism that allows **remote control** of various **household appliances**.
This system can be operated via a **smartphone or WEB application**, making it accessible for users with limited physical capabilities.

Inspired by the needs of Sean, a person with ALS who has limited mobility, Helping Hand aims to facilitate tasks such as opening doors and operating blinds without assistance.
The modular box can accommodate different remote controls, allowing users to control multiple devices through a single, user-friendly interface.
The project prioritizes accessibility, ease of use, and adaptability, making it a versatile solution for various remote-controlled appliances.

**Note**: you can check out the original project's proposal: [Helping Hand project proposal](proposal/out/proposal.pdf).

## Project's Structure

Below is a brief explanation of this repository's structure to provide context and aid readers' comprehension in the following sections of this document.

- `code` directory: contains all the code for the different parts of the project.
    - `CVserver`: the python server side program responsible for image processing and remote buttons automatic detection and configuration.
    - `esp32-cam`: the ESP-32 Cam [Arduino](https://www.arduino.cc/) code to be able to capture an image using an HTTP request.
    - `esp32-controller`: the ESP-32 C6 code that is responsible to control the motors and press the remote's buttons on the main plate.
    - `helping_hand`: the [Flutter](https://flutter.dev/) code used to create the application from which we control the device and interact with the different microcontrollers in the system.
- `design` directory: contains all the 3D modeling files and exports along with the laser cut sheets.
- `diagrams` directory: contains all the protocol diagrams specifying how the different parts of the system interact with one another.
- `documentation` directory: contains all the pictures and schematics to be able to reproduce this project.
- `proposal` directory: the [LaTeX](https://www.latex-project.org/) document used to write the original project proposal.
- `reports` directory: our first meetings reports to agree on what to do together.

## Build It Yourself !

This section is all about providing instructions and material to be able for anyone to reproduce this project by themselves.

### Hardware

This project is mainly composed of electronic components, laser cut _4mm_ MDF plates and 3D printed parts.

#### Main body

Here are the steps to follow to build the main body (and the camera module) of the system:

1. Laser cut the following MDF (4mm) parts
    - [Plotter](design/plotter/plotter.dxf)
    - [Cam holder](design/camholder.dxf)
2. 3D print the required parts (PETG)
    - [Gear holders for the column: top](design/plotter/plotter_column_2_belt_holder_top.stl)
    - [Gear holders for the column: bottom](design/plotter/plotter_column_2_belt_holder_bottom.stl) 
    - [All clamp parts](design/clamp/)
    - [All y axis parts](design/y_axis/)
3. For the assembly you will also need the following parts
    - One _8mm_ diameter stainless steel bar, _290mm_ of length
    - One _8mm_ diameter stainless steel bar, _305mm_ of length
    - Two _8mm_ diameter stainless steel bar, _160mm_ of length
    - Four _8mm_ rod bearings to slide on the bars
    - Two _5mm_ diameter stainless steel bars, _150mm_ of length
    - Eight _M4_ screws with nuts, _35mm_ of length
    - Eight _M2_ screws with nuts, _20mm_ of length
    - One _M5_ screw with nut, _30mm_ of length
    - Two _M5_ screws with nuts, _20mm_ of length
    - Eight neodymium magnets, cubes of _5mm_ sides
    - Two rubber sheets, _30mm_ by _12mm_
    - Two plastic belts, _610mm_ and _320mm_
    - End gears and axes for the connection between belt and motors
4. Assemble everything and glue the MDF parts as indicated in the 3D step file: [Full assembly .step file](design/assembly.step).

For reference, here are some pictures of the full result assembly:

<img src="documentation/images/assembly/controller_top.png" height="400"> <img src="documentation/images/assembly/controller_front.png" height="400"> <img src="documentation/images/assembly/controller_east_side.png" height="400"> <img src="documentation/images/assembly/controller_west_side.png" height="400"> <img src="documentation/images/assembly/clamp_bottom.png" height="400"> <img src="documentation/images/assembly/camera_module.png" height="400"> <img src="documentation/images/assembly/camera_top.png" height="400">

#### Electronics

Here are all the required electronic components:

- ESP-32 CAM
- ESP-32 C6
- Stepper mottors Nema14-01 (2 times)
- Motors drivers A4988 (2 times)
- Servo motor MG90S
- DC to DC converters (2 times)
- Two limit switches
- Condensator _100uF_ (2 times)
- Power Supply 9V

Wire everything together as indicated in the following schematic:

<img src="documentation/electric-schema/electric_schema.png" width="500">

**Note**: make sure to leave some length on the cables used on the travelling parts.

For reference, here are some pictures of the resulting cable management (done under the board):

<img src="documentation/images/wiring/board.png" width="500"><br>
<img src="documentation/images/wiring/side.png" width="500">

### Software

We have four system components that need to interact with eachother in order to function properly.
The following diagram summarizes the different intractions between the components:

<img src="diagrams/exports/devices.png" width="400">

#### Application

All the system is driven by a [Flutter](https://flutter.dev/) cross-platform application.

You can install the Flutter dev environment by following the installation instructions (on any OS): https://docs.flutter.dev/get-started/install.

Then navigate to the directory of the application, `code/helping_hand`.
You can now launch the application on your platform of choice, on web for example `flutter run -d chrome`.
To build for other targets, you can follow the standard Flutter building procedures: https://docs.flutter.dev/deployment.

Here are a few pictures of the application interface:

<img src="documentation/application/overview.png" height="400"> <img src="documentation/application/remote_view.png" height="400"> <img src="documentation/application/new_button.png" height="400"> <img src="documentation/application/remote_config.png" height="400"> <img src="documentation/application/add_remote.png" height="400">

#### Arduino

We use the [Arduino IDE](https://www.arduino.cc/en/software) to flash the two ESP-32 boards:

- **ESP-32 Cam** (the automatic configuration module using the camera): flash the `code/esp32-cam/esp32-cam.ino`. For more information about this module, please refer to the [ESP-32 CAM README](code/esp32-cam/README.md).
- **ESP-32 Plotter** (the remote controller): flash the `code/esp32-controller/sketch_webServer/sketch_webServer.ino`. For more information about this module, please refer to the [ESP-32 C6 README](code/esp32-controller/README.md).

#### Computer Vision Server

We used a [Python](https://www.python.org/) web server (running on any computer or in the cloud) powered by the [Flask](https://flask.palletsprojects.com/en/3.0.x/) framework.

Refer to the associated README to setup the python server: [Python CVserver Setup README](code/CVserver/README.md).

## Contributors

- Yoan Giovannini ([@unglazedstamp](https://github.com/unglazedstamp))
- Nour Guermazi ([@nourguermazi](https://github.com/nourguermazi))
- Lucas Jung ([@gruvw](https://github.com/gruvw))
- Pinar Oray ([@pinar-oray](https://github.com/pinar-oray))
- Jonas Sulzer ([@violoncelloCH](https://github.com/violoncelloCH))
