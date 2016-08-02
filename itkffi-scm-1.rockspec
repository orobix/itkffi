package = "itkffi"
version = "scm-1"

source = {
   url = "git://github.com/orobix/itkffi",
   tag = "master"
}

description = {
   summary = "Interoperate with ITK through FFI",
   detailed = [[]],
   homepage = "https://github.com/orobix/itkffi",
   license = "BSD"
}

dependencies = {
   "torch >= 7.0"
}

build = {
   type = "command",
   build_command = [[
cmake -E make_directory torch-build;
cd torch-build;
cmake ../torch -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)"; 
$(MAKE);
   ]],
   install_command = "cd torch-build && $(MAKE) install"
}
