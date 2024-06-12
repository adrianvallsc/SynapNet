import SimpleITK as sitk



def register_image_rigid(input_img, template_img, output_img):
    """
    Registers the input image to the template image using rigid registration.

    Parameters:
    - input_img (str): Path to the input (moving) image.
    - template_img (str): Path to the template (fixed) image.
    - output_img (str): Path to save the registered image.

    Returns:
    - None
    """
    fixed_image = sitk.ReadImage(template_img, sitk.sitkFloat32)
    moving_image = sitk.ReadImage(input_img, sitk.sitkFloat32)

    initial_transform = sitk.CenteredTransformInitializer(fixed_image,
                                                          moving_image,
                                                          sitk.Euler3DTransform(),
                                                          sitk.CenteredTransformInitializerFilter.GEOMETRY)

    registration_method = sitk.ImageRegistrationMethod()
    registration_method.SetMetricAsMeanSquares()
    registration_method.SetOptimizerAsRegularStepGradientDescent(learningRate=2.0, minStep=1e-4, numberOfIterations=200,
                                                                 gradientMagnitudeTolerance=1e-8)
    registration_method.SetInterpolator(sitk.sitkLinear)
    registration_method.SetInitialTransform(initial_transform, inPlace=False)

    final_transform = registration_method.Execute(sitk.Cast(fixed_image, sitk.sitkFloat32),
                                                  sitk.Cast(moving_image, sitk.sitkFloat32))

    moving_resampled = sitk.Resample(moving_image, fixed_image, final_transform, sitk.sitkLinear, 0.0,
                                     moving_image.GetPixelID())

    sitk.WriteImage(moving_resampled, output_img)


