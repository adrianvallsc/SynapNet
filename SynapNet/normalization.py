import nibabel as nib
from intensity_normalization.normalize.nyul import NyulNormalize
import SimpleITK as sitk
import os
import glob


def bias_field_correct(raw_img_sitk: sitk.Image) -> sitk.Image:
    """
    Performs bias field correction on an input image.

    Parameters:
    - raw_img_sitk (sitk.Image): The input image to be corrected.

    Returns:
    - sitk.Image: The bias field corrected image.
    """
    raw_img_sitk_arr = sitk.GetArrayFromImage(raw_img_sitk)
    transformed = sitk.RescaleIntensity(raw_img_sitk, 0, 255)
    transformed = sitk.LiThreshold(transformed, 0, 1)
    head_mask = transformed
    shrinkFactor = 4
    inputImage = raw_img_sitk

    inputImage = sitk.Shrink(raw_img_sitk, [shrinkFactor] * inputImage.GetDimension())
    maskImage = sitk.Shrink(head_mask, [shrinkFactor] * inputImage.GetDimension())
    bias_corrector = sitk.N4BiasFieldCorrectionImageFilter()
    corrected = bias_corrector.Execute(inputImage, maskImage)
    log_bias_field = bias_corrector.GetLogBiasFieldAsImage(raw_img_sitk)
    corrected_image_full_resolution = raw_img_sitk / sitk.Exp(log_bias_field)

    return corrected_image_full_resolution


def IntensityNormalization(image: sitk.Image, model: NyulNormalize) -> sitk.Image:
    """
    Normalizes the intensity of an image using a given model.

    Parameters:
    - image (sitk.Image): The input image.
    - model (NyulNormalize): The normalization model.

    Returns:
    - sitk.Image: The intensity-normalized image.
    """
    image_arr = sitk.GetArrayFromImage(image)
    new_image = model(image_arr)
    new_image = sitk.GetImageFromArray(new_image)
    new_image.CopyInformation(image)
    return new_image


def fit_normalizer(standard_histogram_path: str) -> NyulNormalize:
    """
    Fits a normalizer using the Nyul normalization method.

    Parameters:
    - standard_histogram_path (str): Path to save or load the standard histogram.

    Returns:
    - NyulNormalize: The fitted normalizer.
    """
    normalizer = NyulNormalize()
    if os.path.exists(standard_histogram_path):
        normalizer.load_standard_histogram(standard_histogram_path)
    else:
        images_all = glob.glob(os.path.join(os.environ["base_path"], "FLAIR", "*"))
        images = [nib.load(path).get_fdata() for path in images_all]
        normalizer.fit(images)
        del images
        normalizer.save_standard_histogram(standard_histogram_path)
    return normalizer


def process_image(image_path, output_path):
    image_raw = sitk.ReadImage(image_path, sitk.sitkFloat32)
    image_bias = bias_field_correct(image_raw)
    norm_histo = "./models/standard_histogram.npy"
    normalizer = fit_normalizer(norm_histo)
    image_trans = IntensityNormalization(image_bias, normalizer)
    sitk.WriteImage(image_trans, output_path)
