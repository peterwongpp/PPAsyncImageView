Pod::Spec.new do |s|
  s.name         = "PPAsyncImageView"
  s.version      = "0.0.0"

  s.summary      = "A subclass of UIImageView which loads image from URL asynchronously, with activity indicator on top."
  s.description  = <<-DESC
                   A subclass of UIImageView which loads image from URL asynchronously, with activity indicator on top.

                   Why?
                   ----

                   When you need to display many images in a table view, you may want to show a loading indicator on the image and write code for downloading the image and caching it.

                   That involves a lot of code.

                   This subclass of UIImageView, given a image name (either a local image name or a URL), will automatically do all for you: showing the loading indicator, downloading from the Internet and caching it in memory and file system for performance.
                   DESC

  s.homepage     = "https://github.com/peterwongpp/PPAsyncImageView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Peter Wong" => "peter@peterwongpp.com" }

  s.source       = { :git => "https://github.com/peterwongpp/PPAsyncImageView.git", :tag => "v#{s.version}" }
  s.source_files  = 'PPAsyncImageView', 'PPAsyncImageView/**/*.{h,m}'
  s.requires_arc = true
end
