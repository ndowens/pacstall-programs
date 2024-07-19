# Maintainer: David Runge <dvzrv@archlinux.org>

_name=orjson
pkgname=python3-orjson
pkgver=3.10.6
pkgrel=1
pkgdesc="Fast, correct python3 JSON library supporting dataclasses and datetimes"
arch=(x86_64)
url="https://github.com/ijl/orjson"
license=(
  Apache-2.0
  MIT
)
depends=(
  python3
)
makedepends=(
  python3-maturin
  python3-installer
  rust-all
)
checkdepends=(
  python3-arrow
  python3-pendulum
  python3-psutil
  python3-pytest
  python3-pytzdata
  python3-xxhash
)
source=($url/archive/$pkgver/$_name-$pkgver.tar.gz)
sha512sums=('SKIP')

build() {
  cd $_name-$pkgver
  maturin build --release --strip
}

check() {
  local _site_packages=$(python3 -c "import site; print(site.getsitepackages()[0])")

  cd $_name-$pkgver
  python3 -m installer --destdir=test_dir target/wheels/*.whl
  export python3PATH="test_dir/$_site_packages:$python3PATH"
  pytest -vv
}

package() {
  cd $_name-$pkgver
  python3 -m installer --destdir="$pkgdir" target/wheels/*.whl
  install -vDm 644 {CHANGELOG,README}.md -t "$pkgdir/usr/share/doc/$pkgname/"
  install -vDm 644 LICENSE-* -t "$pkgdir/usr/share/licenses/$pkgname/"
}
