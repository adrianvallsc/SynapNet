# SuperSeg Model 3000

SynapNet is an image segmentation model designed to perform accurate segmentation of ischemic stroke in FLAIR images. The model leverages ANTs for image registration and nnU-Net for segmentation, providing state-of-the-art performance.

## Author
Adrián Valls Carbó

## Table of Contents
- [Introduction](#introduction)
- [Performance comparison](#Performance-Comparison)
- [Installation](#installation)
- [Usage](#usage)
  - [Single File Processing](#single-file-processing)
- [Options](#options)
- [Help](#help)
- [Example](#example)

## Introduction
SuperSeg Model 3000 is designed to streamline the process of medical image segmentation. The model performs bias field correction, intensity normalization, image registration using ANTs, and segmentation using nnU-Net. This project includes a Docker and a bash script to run the model with ease. Note that on a CPU, it takes approximately 1 hour to perform inference.

## Performance Comparison

| Model           | DICE Index | Volume Correlation |
|-----------------|------------|--------------------|
| SynapNet (2024) | 0.73       | 0.91               |
| Khamnitsas (2015) | 0.66       | N/A                |
| Cleriguès (2020) | 0.59       | N/A                |
| Khezpour (2022) | 0.89       | N/A                |


## Installation
To set up the environment and install the required dependencies, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Download the models**:
    ```bash
    chmod +x install.sh
    ./install.sh
    ```

3. **Pull the Docker image** (ensure Docker is installed):
    ```bash
    docker pull synapnet:latest
    ```

4. **Make the `run.sh` script executable**:
    ```bash
    chmod +x run.sh
    ```

5. **Run `run.sh`** with the arguments `-i` for the input file and `-o` for the output file, which should be specified without the extensions `.nii.gz` or `.nii`. The file will be saved in the same execution directory:
    ```bash
    ./run.sh -i <input file> -o <output file>
    ```

## Usage
Use the `run.sh` script to process your images. The script supports both single file processing and batch processing from a list.

### Single File Processing
To process a single file, use the `-i` option to specify the input file. The output file will be automatically named by removing the extension `.nii.gz` or `.nii`.

```bash
./run.sh -i input.nii.gz -o output
```


## Options
The `run.sh` script supports the following options:

- `-i <input file>`: Specify the input file for processing.
- `-o <output file>`: Specify the output file (optional). If not provided, the output file will be named the same as the input file but without the extension `.nii.gz` or `.nii`.
- `-h`: Display the help message.

## Help
To display the help message, use the `-h` option:

```bash
./run.sh -h
```

## Example
Here is an example of how to use the script:

```bash
# Process a single file
./run.sh -i input.nii.gz -o output

```
