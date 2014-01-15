PPAsyncImageView
================

A subclass of UIImageView which loads image from URL asynchronously, with activity indicator on top.

Installation
------------

### Cocoapods

If you are not using cocoapods yet, you may know more at [here](http://cocoapods.org).

If you have already installed, you should have a `Podfile` file at your project's root directory.

Edit it with your favourite text editor to add the following line to the bottom of the Podfile:

    pod 'PPAsyncImageView', '~> 0.0'

Since the versioning is using [Semantic Versioning](http://semver.org), you are safe to use `~>` for backward-compatible changes.

Now you can install the dependencies from your command line:

    $ pod install

Finally, in the file you want to use the `PPAsyncImageView`, add the following import statement:

    #inport "PPAsyncImageView.h"

### Manual

Just copy all the classes from the `/PPAsyncImageView` directory to your project, then add the following to import:

    #inport "PPAsyncImageView.h"

Contribution
------------

- Fork, update and send pull request.
- Leave any comments, improvements, suggestions, ideas etc at to [Issues](https://github.com/peterwongpp/PPAsyncImageView/issues).

License
-------

PPAsyncImageView is made available under the [MIT License](http://opensource.org/licenses/MIT):

<pre>
The MIT License (MIT)

Copyright (c) 2014 Peter Wong

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
</pre>