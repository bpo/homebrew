require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  version 'weekly'

  url 'http://go.googlecode.com/hg/', :revision => 'weekly'
  head 'http://go.googlecode.com/hg/'

  skip_clean 'bin'

  def options
     [["--run-tests", "Test the new build before installing"]]
  end

  def install
    prefix.install %w[src include test doc api misc lib favicon.ico AUTHORS]
    cd prefix do
      mkdir %w[pkg bin]

      File.open('VERSION', 'w') {|f| f.write(version) }

      cd 'src' do
        if ARGV.include? "--run-tests"
          system "./all.bash"
        else
          system "./make.bash"
        end
      end

      # Don't need the src folder, but do keep the Makefiles as Go projects use these
      Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/(pkg|Make)/) }
      rm_rf %w[include test]
    end
  end
end
