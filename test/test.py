local itk = require 'torchitk'

local im = itk.Float2D()
im:read("input.nrrd")

print(im:tensor())

local out = im:gaussiansmoothing(10.0)

out:write("foo.nrrd")
print(out:tensor())

out:fromtensor(im:tensor())
print(out:tensor())

local outtensor = torch.FloatTensor()
out:tensor(outtensor)
print(outtensor)


-- TODO: multichannel (not for now

--
--print(out:dim())
--print(out:spacing())
--out:spacing({4,4})
--print(out:spacing())

-- TODO: transform from tensor to itk image and back

--local im = itk.newimage3F32()
---- local im = itk.newimage('3F32')
---- or
---- local im = itk.newimage3F32()
--
--im:read("input.nrrd")
--
----local out = itk.NewImage3F32()
--
----itk.GaussianSmoothing3F32(im,out,1.0)
--
--local out = im:gaussiansmoothing(1.0)
--
---- TODO: this means that in already has information on the type (i.e. the suffix); itk.gaussiansmoothing has to dispatch on the type - how to do it economically?
---- just have a table of tuples to functions, where the tuple of the types of the arguments dispatches (a la Julia); NOPE: equality is just at the object level in Lua;
---- local out = itk.gaussiansmoothing(in,1.0)
--
--print(out:dim())
--print(out:spacing())
--out:spacing({4,4,4})
--print(out:spacing())
--
