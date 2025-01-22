pkgname="sleex"
pkgver="0.3"
pkgrel="2"
pkgdesc="Third desktop environment for AxOS"
arch=("x86_64")
depends=(
	"illogical-impulse-ags"
	"illogical-impulse-audio"
	"illogical-impulse-backlight"
	"illogical-impulse-basic"
	"illogical-impulse-bibata-modern-classic-bin"
	"illogical-impulse-font-themes"
	"illogical-impulse-gnome"
	"illogical-impulse-gtk"
	"illogical-impulse-microtex-git"
	"illogical-impulse-oneui4-icons-git"
	"illogical-impulse-portal"
	"illogical-impulse-pymyc-aur"
	"illogical-impulse-python"
	"illogical-impulse-screencapture"
	"illogical-impulse-widgets"
)


package() {
	mkdir -p "$pkgdir/usr/"
	cp -r "$srcdir/bin" "$pkgdir/usr/"
	cp -r "$srcdir/share" "$pkgdir/usr/"
}
