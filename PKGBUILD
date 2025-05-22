pkgname="sleex"
pkgver="0.23"
pkgrel="1"
pkgdesc="Third desktop environment for AxOS"
arch=("x86_64")
depends=(
	"sleex-ags"
	"sleex-audio"
	"sleex-backlight"
	"sleex-basic"
	"sleex-bibata-modern-classic-bin"
	"sleex-fonts-themes"
	"sleex-gnome"
	"sleex-gtk"
	"sleex-microtex-git"
	"sleex-oneui4-icons-git"
	"sleex-portal"
	"sleex-pymyc-aur"
	"sleex-python"
	"sleex-screencapture"
	"sleex-widgets"
	"axskel-hypr"
	"axctl"
)
optdepends=(
	"sleex-optional: Optional packages"
)


package() {
        mkdir -p "$pkgdir/usr/"
        cp -r "$srcdir/bin" "$pkgdir/usr/"
        cp -r "$srcdir/share" "$pkgdir/usr/"
}

