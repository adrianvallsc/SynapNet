import argparse
import subprocess


def bet(image_path, dest_path, device):
    command = f"hd-bet -i {image_path} -o {dest_path} -device {device} -mode fast -tta 0"
    run_bash_command(command)


def parse_arguments():
    parser = argparse.ArgumentParser(description="Image segmentation")
    parser.add_argument("--input", required=True, help="Path to the input image")
    parser.add_argument("--output", required=True, help="Path to the output image")
    parser.add_argument("--device", default="cpu", choices=["cpu", "gpu"],
                        help="Device to use for processing (default: cpu)")

    return parser.parse_args()


def run_bash_command(command):
    print(f"Running command: {command}")
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
    return result.stdout


def add_string(path, string):
    if path.endswith('.nii.gz'):
        return path.replace('.nii.gz', f'{string}.nii.gz')
    elif path.endswith('.nii'):
        return path.replace('.nii', f'{string}.nii')
    return path
