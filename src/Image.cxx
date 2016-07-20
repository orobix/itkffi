#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

typedef ${PixelType} PixelType;
const unsigned int Dim = ${Dim};
typedef itk::Image<PixelType,Dim> ImageType${Suffix};

extern "C"
ImageType${Suffix}* ${Suffix}()
{
  ImageType${Suffix}::Pointer image = ImageType${Suffix}::New();
  image->Register();
  return image;
}

extern "C"
void DeleteImage${Suffix}(ImageType${Suffix}* image)
{
  image->UnRegister();
}

extern "C"
unsigned int GetImageDimension${Suffix}(ImageType${Suffix}* image)
{
  return image->GetImageDimension();
}

extern "C"
void GetSpacing${Suffix}(ImageType${Suffix}* image, double* spacing)
{
  ImageType${Suffix}::SpacingType spacingITK = image->GetSpacing();
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      spacing[i] = spacingITK[i];
    }
}

extern "C"
void SetSpacing${Suffix}(ImageType${Suffix}* image, double* spacing)
{
  image->SetSpacing(spacing);
}

extern "C"
void GetOrigin${Suffix}(ImageType${Suffix}* image, double* origin)
{
  ImageType${Suffix}::PointType originITK = image->GetOrigin();
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      origin[i] = originITK[i];
    }
}

extern "C"
void SetOrigin${Suffix}(ImageType${Suffix}* image, double* origin)
{
  image->SetOrigin(origin);
}

extern "C"
void GetDirection${Suffix}(ImageType${Suffix}* image, double* direction)
{
  ImageType${Suffix}::DirectionType directionITK = image->GetDirection();
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      for (unsigned int j=0; j<dimension; j++)
        {
          direction[i*dimension+j] = directionITK[i][j];
        }
    }
}

extern "C"
void SetDirection${Suffix}(ImageType${Suffix}* image, double* direction)
{
  ImageType${Suffix}::DirectionType directionITK;
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      for (unsigned int j=0; j<dimension; j++)
        {
          directionITK[i][j] = direction[i*dimension+j];
        }
    }
  image->SetDirection(directionITK);
}

extern "C"
int GetBufferSize${Suffix}(ImageType${Suffix}* image)
{
  return image->GetPixelContainer()->Size();
}

extern "C"
void GetBufferedRegionSize${Suffix}(ImageType${Suffix}* image, int* bufferedRegionSize)
{
  ImageType${Suffix}::SizeType sizeITK = image->GetBufferedRegion().GetSize();
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      bufferedRegionSize[i] = sizeITK[i];
    }
}

extern "C"
void SetBufferedRegionSize${Suffix}(ImageType${Suffix}* image, int* bufferedRegionSize)
{
  ImageType${Suffix}::RegionType regionITK;
  ImageType${Suffix}::SizeType sizeITK;
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      sizeITK[i] = bufferedRegionSize[i];
    }
  regionITK.SetSize(sizeITK);
  image->SetBufferedRegion(regionITK);
}

extern "C"
void GetSize${Suffix}(ImageType${Suffix}* image, int* regionSize)
{
  ImageType${Suffix}::SizeType sizeITK = image->GetLargestPossibleRegion().GetSize();
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      regionSize[i] = sizeITK[i];
    }
}

extern "C"
void SetSize${Suffix}(ImageType${Suffix}* image, int* size)
{
  ImageType${Suffix}::RegionType regionITK;
  ImageType${Suffix}::SizeType sizeITK;
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      sizeITK[i] = size[i];
    }
  regionITK.SetSize(sizeITK);
  image->SetRegions(regionITK);
}

extern "C"
PixelType* GetData${Suffix}(ImageType${Suffix}* image)
{
  return image->GetPixelContainer()->GetImportPointer();
}

extern "C"
void SetData${Suffix}(ImageType${Suffix}* image, int* shape, PixelType* data)
{
  unsigned int numberOfElements = 1;
  unsigned int dimension = image->GetImageDimension();
  for (unsigned int i=0; i<dimension; i++)
    {
      numberOfElements *= shape[i];
    }
  SetSize${Suffix}(image,shape);
  PixelType* dataCopy = new PixelType[numberOfElements];
  memcpy(dataCopy,data,numberOfElements*sizeof(PixelType));
  image->GetPixelContainer()->SetImportPointer(dataCopy,numberOfElements,true);
}

extern "C"
void ReadImage${Suffix}(ImageType${Suffix}* image, const char* filename)
{
  typedef itk::ImageFileReader<ImageType${Suffix}> ImageReaderType;
  ImageReaderType::Pointer reader = ImageReaderType::New();
  reader->SetFileName(filename);
  reader->Update();

  image->Graft(reader->GetOutput());
}

extern "C"
void WriteImage${Suffix}(ImageType${Suffix}* image, const char* filename)
{
  typedef itk::ImageFileWriter<ImageType${Suffix}> ImageWriterType;
  ImageWriterType::Pointer writer = ImageWriterType::New();
  writer->SetFileName(filename);
  writer->SetInput(image);
  writer->Update();
}
