pkgname="tailscale"
pkgver="1.70.0"
source=("https://github.com/tailscale/tailscale/archive/refs/tags/v${pkgver}.tar.gz")
url="https://tailscale.com"
depends=('iptables')
makedepends=('golang-go' 'git')
pkgdesc="Private WireGuard networks made easy"
maintainer=("Nathan <ndowens@artixlinux.org>")
arch=('amd64')
repology=("project: ${pkgname}")
incompatible=('ubuntu:jammy' 'debian:bookworm')
sha256sums=("SKIP")

prepare() {
  cd "${_archive}"
  go mod vendor
  sed -i 's,/usr/sbin,/usr/bin/,g' cmd/tailscaled/tailscaled.service
}

build() {
  export GOPROXY=direct
  cd "${_archive}"
 export GO111MODULE=on
  export GOFLAGS="-buildmode=pie -mod=readonly -modcacherw"
  _GO_LDFLAGS="-compressdwarf=false \
  	-linkmode=external \
	-X tailscale.com/version.longStamp=${pkgver} \
	-X tailscale.com/version.shortStamp=$(cut -d+ -f1 <<< "${pkgver}")"
  for cmd in ./cmd/tailscale ./cmd/tailscaled; do
    go build -v -tags xversion -ldflags "${_GO_LDFLAGS}" "${cmd}"
  done
}

package() {
  cd "${_archive}"
  install -Dm755 tailscale tailscaled -t "${pkgdir}/usr/bin"
  install -Dm644 cmd/tailscaled/tailscaled.defaults "${pkgdir}/etc/default/tailscaled"
  install -Dm644 cmd/tailscaled/tailscaled.service -t "${pkgdir}/usr/lib/systemd/system"
  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${gives}"
}
