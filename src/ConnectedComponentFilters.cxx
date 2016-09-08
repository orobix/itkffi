#include "itkImage.h"
#include "itkCastImageFilter.h"
#include "itkConnectedComponentImageFilter.h"

typedef ${PixelType} PixelType;
const unsigned int Dim = ${Dim};
typedef itk::Image<PixelType,Dim> ImageType${Suffix};
typedef long IntegerPixelType;
typedef itk::Image<IntegerPixelType,Dim> IntegerImageType${Suffix};

extern "C"
void ConnectedComponents${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage)
{
  typedef itk::CastImageFilter<ImageType${Suffix},IntegerImageType${Suffix}> InCastFilterType;
  typedef itk::CastImageFilter<IntegerImageType${Suffix},ImageType${Suffix}> OutCastFilterType;
  typedef itk::ConnectedComponentImageFilter<IntegerImageType${Suffix},IntegerImageType${Suffix}> ConnectedComponentFilterType;

  InCastFilterType::Pointer inCastFilter = InCastFilterType::New();
  inCastFilter->SetInput(inputImage);

  ConnectedComponentFilterType::Pointer connectedComponentFilter = ConnectedComponentFilterType::New();
  connectedComponentFilter->SetInput(inCastFilter->GetOutput());
  //connectedComponentFilter->FullyConnectedOn();

  OutCastFilterType::Pointer outCastFilter = OutCastFilterType::New();
  outCastFilter->SetInput(connectedComponentFilter->GetOutput());
  outCastFilter->Update();

  outputImage->Graft(outCastFilter->GetOutput());
}


