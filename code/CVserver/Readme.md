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
    There are other (larger) models available. However note the size and RAM usage requirements for these. 
    The smallest (b) model uses more than 10GB of RAM while analyzing images.
    The biggest one consistently brings my machine into OOM situations after consuming more than 20GB of RAM.  
    Note that if you want to use an other model, you have to specify the correct filename and model type in `sam.py` > `analyse_and_extract_masks()` > `sam_model_registry`





Source for the segmentation framework used: https://github.com/facebookresearch/segment-anything