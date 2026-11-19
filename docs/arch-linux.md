# Arch Linux package management

On Arch Linux, `./mi install` installs only Mi's configured packages with `paru -S --needed --noconfirm`. It does not trigger a full system upgrade or rebuild unrelated installed AUR packages such as `howdy-git`. The initial `paru` bootstrap installs `base-devel` without `-Syu`.

Keep the system reasonably up to date before installing new packages: Arch Linux does not support partial upgrades.

Use `./mi update` for system-wide upgrades, including AUR packages. This still runs `paru -Syu --noconfirm` followed by `checkrebuild`; an unrelated broken AUR package can cause `update` to fail.
