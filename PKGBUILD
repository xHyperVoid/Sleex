pkgname="sleex"
pkgver="0.18"
pkgrel="1"
pkgdesc="Third desktop environment for AxOS"
arch=("x86_64")
depends=(
	"illogical-impulse-ags"
	"illogical-impulse-audio"
	"illogical-impulse-backlight"
	"illogical-impulse-basic"
	"illogical-impulse-bibata-modern-classic-bin"
	"illogical-impulse-fonts-themes"
	"illogical-impulse-gnome"
	"illogical-impulse-gtk"
	"illogical-impulse-microtex-git"
	"illogical-impulse-oneui4-icons-git"
	"illogical-impulse-portal"
	"illogical-impulse-pymyc-aur"
	"illogical-impulse-python"
	"illogical-impulse-screencapture"
	"illogical-impulse-widgets"
	"axskel-hypr"
)
optdepends=(
	"illogical-impulse-optional: Optional packages"
)


package() {
        mkdir -p "$pkgdir/usr/"
        cp -r "$srcdir/bin" "$pkgdir/usr/"
        cp -r "$srcdir/share" "$pkgdir/usr/"
}

