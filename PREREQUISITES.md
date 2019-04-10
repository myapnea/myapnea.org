# Prerequisites

This file describes some prerequisites that need to be in place to make the web server fully functional.


## Image Upload Resizing

In order to make full use of the `mini_magick` gem, the underlying ImageMagick library and binaries needs to be compiled.

The following instructions are specific to CentOS and macOS.

### Installing ImageMagick

On CentOS:

Installing ImageMagick from source: http://www.imagemagick.org/script/install-source.php

```
sudo yum -y install libjpeg libjpeg-devel libpng libpng-devel
cd ~/code/source
curl http://www.imagemagick.org/download/ImageMagick.tar.gz | tar xvz
cd ImageMagick-*
./configure

  After .configure you should see a line that includes jpeg and png:
  DELEGATES       = mpeg jng jpeg png xml zlib

make
sudo make install
```

Make executables accessible by web server process using symbolic links:

```
sudo ln -s /usr/local/bin/identify /usr/bin/identify
sudo ln -s /usr/local/bin/mogrify /usr/bin/mogrify
```

On macOS:

```
brew install imagemagick
```

### Verifying ImageMagick installation

Type the following to verify that the installation:

```
identify --version

  Version: ImageMagick 6.8.9-7 Q16 x86_64 2014-09-09 http://www.imagemagick.org
  Copyright: Copyright (C) 1999-2014 ImageMagick Studio LLC
  Features: DPC OpenMP
  Delegates: jng jpeg png xml zlib
```

To check that PNG and JPEG support were successfully enabled, run the following command:

```
identify -list format
```

The list should include JPEG and PNG
