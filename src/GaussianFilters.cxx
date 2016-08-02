#include "itkImage.h"
#include "itkRecursiveGaussianImageFilter.h"
#include "itkLaplacianRecursiveGaussianImageFilter.h"

typedef ${PixelType} PixelType;
const unsigned int Dim = ${Dim};
typedef itk::Image<PixelType,Dim> ImageType${Suffix};

extern "C"
void GaussianSmoothing${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma)
{
  typedef itk::RecursiveGaussianImageFilter<ImageType${Suffix}> RecursiveGaussianFilterType;

  RecursiveGaussianFilterType::Pointer gaussianFilter = RecursiveGaussianFilterType::New();
  gaussianFilter->SetInput(inputImage);
  gaussianFilter->SetSigma(sigma);
  gaussianFilter->Update();

  outputImage->Graft(gaussianFilter->GetOutput());
}

extern "C"
void LaplacianOfGaussian${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma)
{
  typedef itk::LaplacianRecursiveGaussianImageFilter<ImageType${Suffix}> LaplacianRecursiveGaussianFilterType;

  LaplacianRecursiveGaussianFilterType::Pointer laplacianFilter = LaplacianRecursiveGaussianFilterType::New();
  laplacianFilter->SetInput(inputImage);
  laplacianFilter->SetSigma(sigma);
  laplacianFilter->Update();

  outputImage->Graft(laplacianFilter->GetOutput());
}

