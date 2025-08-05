pkgname="sleex"
<<<<<<< HEAD
pkgver="1.0"
pkgrel="24"
pkgdesc="Third desktop environment for AxOS"
arch=("x86_64")
depends=(
=======
pkgver="0.31"
pkgrel="1"
pkgdesc="Third desktop environment for AxOS"
arch=("x86_64")
depends=(
	# "sleex-ags"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
	"sleex-audio"
	"sleex-backlight"
	"sleex-basic"
	"sleex-bibata-modern-classic-bin"
	"sleex-fonts-themes"
	"sleex-hyprland"
	"sleex-kde"
	"sleex-microtex-git"
	"sleex-portal"
	"sleex-python"
	"sleex-screencapture"
	"sleex-toolkit"
	"sleex-widgets"
	"sleex-user-config"
)
# optdepends=(
# 	"sleex-optional: Optional packages"
# )


package() {
        mkdir -p "$pkgdir/usr/"
        cp -r "$srcdir/bin" "$pkgdir/usr/"
        cp -r "$srcdir/share" "$pkgdir/usr/"
}

