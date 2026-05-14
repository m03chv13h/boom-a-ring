# Edge Bell – Garmin Connect IQ Bicycle Bell Data Field

A Garmin Connect IQ **data field** that turns your **Edge 530** or **Edge 1040** into a bicycle bell. Add the data field to an activity screen, then trigger the bell with touch or a button press.

## ⚠ Safety Disclaimer

The Garmin Edge beeper is **not** a legal or safe replacement for a physical bicycle bell. Always comply with local traffic laws and use a proper bell or horn when riding in traffic.

## Supported Devices

| Device | Product ID |
|-----------|------------|
| Edge 530  | `edge530`  |
| Edge 1040 | `edge1040` |

## How It Works

1. The data field displays the word **BELL** in the configured field slot.
2. If `Attention.ToneProfile` is available, a bike-bell "tring-tring" pattern is played:
   - 3 200 Hz → 2 800 Hz → 2 500 Hz (first strike with decay), 120 ms silence, then the same strike again.
3. Otherwise it falls back to `Attention.TONE_LOUD_BEEP`.
4. **Edge 1040** (touch screen): touch and hold the data field to ring continuously; release to stop.
5. **Edge 530** (buttons): press and hold the **up** button for ≥ 500 ms to start ringing continuously; release the button to stop.

## Local Development

### Prerequisites

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) installed via the SDK Manager.
- A developer key (`.der` file). Generate one with:

```bash
openssl genrsa -out developer_key.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER \
  -in developer_key.pem -out developer_key.der -nocrypt
```

### Build

```bash
monkeyc -o dist/EdgeBell.prg \
  -f monkey.jungle \
  -y /path/to/developer_key.der \
  -d edge530
```

Replace `edge530` with `edge1040` to target the other device.

### Run in Simulator

```bash
connectiq &                       # start simulator
monkeydo dist/EdgeBell.prg edge530
```

## Sideloading

1. Connect your Garmin Edge to your computer via USB.
2. Copy `dist/EdgeBell.prg` to the device at:
   ```
   /GARMIN/APPS/EdgeBell.prg
   ```
3. Safely eject / disconnect the device.
4. Restart the device if the data field does not appear immediately.
5. Add the **Edge Bell** data field to an activity screen (e.g. Ride) via the device settings.

## GitHub Actions (CI)

The repository includes a workflow (`.github/workflows/build.yml`) that builds the `.prg` on every push to `main`, on pull requests, and on manual dispatch.

### Setup

The workflow automatically downloads the official [Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/) from Garmin and uses it in headless mode to install the SDK and required device files. No repository secrets are required for the build.

By running the workflow, you acknowledge acceptance of the [Garmin Connect IQ SDK License Agreement](https://developer.garmin.com/connect-iq/sdk/).

### Download the Artifact

1. Go to the **Actions** tab in GitHub.
2. Select the latest **Build Garmin PRG** run.
3. Under **Artifacts**, download **EdgeBell-prg**.
4. Extract to get `EdgeBell.prg`.

## Troubleshooting

| Problem | Fix |
|---|---|
| `monkeyc: command not found` | Make sure the Connect IQ SDK `bin` directory is on your `PATH`. |
| Device ID error during build | Ensure device files are installed. The CI workflow uses the official Garmin SDK Manager to download them. Locally, use the Connect IQ SDK Manager to install device files for `edge530` or `edge1040`. |
| Tone does not play | Not all devices/firmware versions support `Attention.playTone`. Update firmware to the latest version. |
| App does not appear after sideloading | Ensure the file is in `/GARMIN/APPS/`. Restart the device. Check that the `.prg` was built for the correct device. |
| CI fails downloading SDK | Check that `developer.garmin.com` is accessible or retry the workflow. |

## Project Structure

```
.
├── README.md
├── manifest.xml
├── monkey.jungle
├── source/
│   ├── BellApp.mc          # Application entry point
│   ├── BellView.mc         # Data field view & tone logic
│   └── BellDelegate.mc     # Touch / button input handler
├── resources/
│   ├── strings/
│   │   └── strings.xml     # App name string
│   └── drawables/
│       ├── launcher_icon.xml
│       └── launcher_icon.png
└── .github/
    └── workflows/
        └── build.yml       # CI workflow
```

## License

This project is provided as-is for personal use. See the repository license file for details.
