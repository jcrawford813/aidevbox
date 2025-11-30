# A Distrobox Image for Azure Development

This is a custom distrobox image that comes pre-loaded with Libraries that help to enable running Alpaca and Invoke on my hardware. The current tooling includes:

- FUSE
- ROCM
- Support Libraries to run the Invoke.AI AppImage.

The image is based on Arch Linux.

This repo and image creation is based off of [boxkit](https://github.com/ublue-os/boxkit). It is much simplified.

## Usage
The image may be installed via the distrobox command:
```
distrobox create -i ghcr.io/jcrawford813/aidevbox:latest --pull
distrobox enter aidevbox
```

If desired, shortcuts may be exported for the tools:

```
distrobox-export --app code
distrobox-export --app azuredatastudio
```

## Updating

THe image will rebuild once per week with the latest updates. However, once installed within distrobox, it is suggested that you update via the distrobox command, if you do not want to destroy and pull the latest container:

```
distrobox upgrade --all
```