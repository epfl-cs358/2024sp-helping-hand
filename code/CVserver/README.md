# CV Server

## Setup using python virtual environment

1. Create environment named `env`
    ```
    python -m venv env
    ```

2. activate the `env` environment
    ```
    source env/bin/activate
    ```
    (redo only this step every time you start working on the project)

3. install python (pip) dependencies for the project
    ```
    pip install -r requirements.txt
    ```

4. download model
    ```
    curl https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth > vit_b_model.pth
    ```
    There are other (larger) models available.
    You could change which one is used by changing it in the code of `sam.py`.
    However note the size and RAM usage requirements for these. 
    The smallest (b) model uses more than 10GB of RAM while analyzing images.
    The biggest one consistently brings my machine into OOM situations after consuming more than 20GB of RAM.  
    Note that if you want to use an other model, you have to specify the correct filename and model type in `sam.py` > `analyse_and_extract_masks()` > `sam_model_registry`

5. Calibration
    The mapping of the image coordinates to the plotter steps needs to be done initially once the plotter is set up with the camera.
    For this, take a picture of a flat reference object containing four points in the corners.
    Measure the pixel coordinates for each of the four reference points and enter them into the `parameters.py` file as explained in the comments. 
    Double check using the testing program after having replaced the `calibration_capture.jpg` with your picture:
    ```
    python test_calibration.py
    ```
    It generates a `calibration_result.jpg` with small red markers according to the set constans in `parameter.py`

    Use the same object together with the app to get the plotter step position for the same points and also adapt `parameter.py` accordingly.

6. launch the server
    ```
    python CVserver.py
    ```


Source for the segmentation framework used: https://github.com/facebookresearch/segment-anything