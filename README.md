# Fixes made to this config

1. Split the mashed-together content back into `flake.nix`, `hosts/lyre/configuration.nix`,
   and `home/orpheus/home.nix` (the original zip had everything dumped into `flake.nix`,
   and the other two files were empty).
2. Fixed `home-manager.useUserHomeModules` -> `home-manager.useUserPackages` (the former
   isn't a real option and would fail to evaluate).
3. Merged the duplicate/orphaned Sway keybindings block into `home.nix`'s
   `wayland.windowManager.sway.config`.
4. Wired up `wallpaper.mp4` via `home.file."Pictures/wallpaper.mp4".source = ./wallpaper.mp4;`
   so it actually gets placed in `~/Pictures` on rebuild.

# Still missing / things you must add yourself

- **`hosts/lyre/hardware-configuration.nix`** — this is always machine-specific (disk UUIDs,
  filesystem layout, kernel modules for your exact hardware/VM). It is not something that can
  ship generically; you generate it on the target machine itself with `nixos-generate-config`
  (see setup steps below). Once generated, drop it into `hosts/lyre/`.
- **`home/orpheus/wallpaper.mp4`** — the actual video file isn't in the archive. Put your
  wallpaper file at that path before building, or the `home.file` line above will fail to
  find it.

# Getting this running in a VirtualBox VM

1. **Create the VM in VirtualBox**
   - Download the NixOS minimal or graphical ISO from nixos.org.
   - New VM: Linux / type "Other Linux (64-bit)", at least 4GB RAM, 40GB+ disk
     (Sway + Steam + the app list here isn't tiny), enable EFI in
     Settings -> System -> Motherboard (this config uses `systemd-boot`, which needs EFI).
   - Settings -> Display: enable 3D acceleration and bump video memory, since you're
     running a Wayland compositor.
   - Attach the ISO and boot.

2. **Partition and generate hardware config**
   - Boot the live ISO, partition/format the disk (an EFI partition + root, using your
     preferred tool — `parted`/`gdisk` or the guided `nixos-install` docs), mount it under
     `/mnt`.
   - Run `nixos-generate-config --root /mnt`. This creates a real
     `hardware-configuration.nix` for this VM — copy that over the placeholder path
     `hosts/lyre/hardware-configuration.nix` in your config.

3. **Get your flake onto the VM**
   - Easiest: `git clone` your config repo (push this fixed version to GitHub/GitLab first),
     or `scp`/copy the folder in some other way, into `/mnt/etc/nixos` (or anywhere, then
     symlink `/mnt/etc/nixos` to it).
   - Add your generated `hardware-configuration.nix` into `hosts/lyre/`.
   - Add your `wallpaper.mp4` into `home/orpheus/`.

4. **Enable flakes** (the installer ISO doesn't have flakes on by default)
   ```
   nix-shell -p git --run "nixos-install --flake /mnt/etc/nixos#lyre"
   ```
   or, if using an already-booted live system with flakes enabled via
   `nix.settings.experimental-features = "nix-command flakes"`, just:
   ```
   nixos-install --flake /mnt/etc/nixos#lyre
   ```

5. **Set the password and reboot**
   - `nixos-install` will prompt for a root password; set one for `orpheus` too with
     `nixos-enter --root /mnt -c 'passwd orpheus'`.
   - Reboot, remove the ISO from the virtual optical drive.

6. **Log in**
   - You'll land at a TTY (no display manager is configured here). Log in as `orpheus`
     and run `sway` to start the compositor, or add a display manager
     (e.g. `services.greetd`) to `configuration.nix` if you want a graphical login screen.

A couple of things worth double-checking for a VM specifically:
- `virtualisation.virtualbox.host.enable = true;` sets this machine up to be a
  VirtualBox **host** (i.e. run VMs inside it), not a guest. If you just want this NixOS
  install to run well as a VM *inside* VirtualBox, you likely also want
  `virtualisation.virtualbox.guest.enable = true;` for shared clipboard, better
  video, shared folders, etc. Both can coexist if you genuinely want nested virtualization,
  but it's easy to add the host one by mistake when guest is what's actually needed.
- Steam + `bitwig-studio` + `mathematica` + `vcv-rack` inside a VM will be rough on
  performance (no real GPU passthrough by default) — worth knowing going in if this is meant
  to be a daily driver rather than a config test bed.
# NixOS---test-1
