# -*- coding: utf-8 -*-
# Cargamos las librerias requeridas

import os
from tqdm import tqdm
import time
from SynapNet.tools import parse_arguments, bet
from SynapNet.register_images import register_image_rigid
from SynapNet.normalization import process_image
from SynapNet.inference import inference

temp_dir = "./temp_files/"
template = "./models/template.nii.gz"
temp_image = os.path.join(temp_dir, "temp_image.nii.gz")
temp_reg = os.path.join(temp_dir, "Warped.nii.gz")
temp_new = os.path.join(temp_dir, "Warped_0000.nii.gz")

steps = [
        "Processing: Brain extraction",
        "Processing: Image registration",
        "Processing: Intensity normalization",
        "Inference"
    ]


if __name__ == "__main__":

    start_time = time.time()
    args = parse_arguments()
    os.makedirs(temp_dir, exist_ok=True)
    t0 = time.time()

    for step in tqdm(steps, desc="Overall Progress", unit="step"):
        start_time = time.time()
        print(f"\n{'-' * 40}\n{step}")
        if step == "Processing: Brain extraction":
            bet(args.input, temp_image, args.device)
            print(f"Image BET complete")
        elif step == "Processing: Image registration":
            register_image_rigid(temp_image, template, temp_reg)
            print(f"Image registration complete. ")
        elif step == "Processing: Intensity normalization":
            process_image(temp_reg, temp_new)
            print(f"Intensity normalization complete.")
        elif step == "Inference":
            inference(temp_new, args.output, args.device, temp_dir)
            print(f"Inference complete.")

        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"{step} took {elapsed_time/60:.2f} minutes")

    t1 = time.time()
    elapsed2 = t1 - t0
    print(f"f Total execution time: {elapsed2/60:.2f} minutes")
    # Ejecutar brain extraction

