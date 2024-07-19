# Maintaner: Francesco Masala <mail@francescomasala.me>
# Contributor: Francesco Masala <mail@francescomasala.me>

pkgname=bottles
pkgver=51.11
pkgrel=2
epoch=2
pkgdesc='Easily manage wine and proton prefix'
arch=('x86_64')
url="https://github.com/bottlesdevs/Bottles"
#license=('GPLv3')
depends=(
  'cabextract'
  'libdconf1'
  'libgtk-4-1'
  'libgtksourceview-5-0'
  'hicolor-icon-theme'
  'icoextract'
  'imagemagick'
  'libgnutls30t64:i386'
  'libadwaitaqt6-1'
  'libhandy-1-0'
  'libportal-gtk4-1'
  'p7zip'
  'patool'
  'python3'
  'python3-chardet'
  'python3-gi'
  'python3-markdown'
  'python3-pathvalidate'
  'python3-pycurl'
  'python3-requests'
  'python3-yaml'
  'libwebkit2gtk-4.1-0'
  'x11-utils'
  'vkbasalt'
)
makedepends=('meson' 'ninja-build' 'blueprint-compiler' 'git')
source=("Bottles::git+https://github.com/bottlesdevs/Bottles/")
sha256sums=('3e438e98fdc3821e250a0c583e74d203e7c05511c0892587a5a29dd886392f3c')

build() {
  cd "Bottles"
  meson --prefix='/usr' build
  ninja -C build
}

package() {
  cd "Bottles"
  DESTDIR="${pkgdir}" ninja -C build install
}
