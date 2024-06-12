import os
import shutil
from SynapNet.tools import run_bash_command


def inference(image_path, path_output, device, temp_dir):
    path_input = os.path.join(temp_dir, "input")
    path_out = os.path.join(temp_dir, "output")

    os.makedirs(path_out, exist_ok=True)
    os.makedirs(path_input, exist_ok=True)
    shutil.move(image_path, os.path.join(path_input, "Warped_0000.nii.gz"))

    command = f"nnUNetv2_predict -d Dataset001_Stroke -i {path_input} -o {path_out} -f 0 1 2 3 4 -tr nnUNetTrainer -c " \
              f"3d_fullres -p nnUNetResEncUNetLPlans -device {device} "
    run_bash_command(command)

    shutil.move(os.path.join(path_out, "Warped.nii.gz"), os.path.join("./", path_output + "_mask.nii.gz"))
    shutil.move(os.path.join(temp_dir, "Warped.nii.gz"), os.path.join("./", path_output + "_processed.nii.gz"))

    shutil.rmtree(temp_dir)
