# Phoenix Three

[![Hex.pm](https://img.shields.io/hexpm/v/phoenix_three.svg)](https://hex.pm/packages/phoenix_three)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/phoenix_three/)

A Mix task package for easily integrating Three.js into Phoenix projects. Automatically downloads Three.js files from CDN and configures your app.js imports.

## Features

- **One-command setup** - Download and configure Three.js with a single command
- **Version control** - Specify which Three.js version to download
- **Smart imports** - Automatically adds imports to your app.js file
- **Global access** - Makes THREE available globally for LiveView hooks
- **Idempotent** - Safe to run multiple times, won't duplicate imports
- **Phoenix optimized** - Follows Phoenix asset conventions

## Installation

Add `phoenix_three` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_three, "~> 0.1.0", only: :dev, runtime: false}
  ]
end
```

Alternatively, you can install from GitHub for the latest development version:

```elixir
def deps do
  [
    {:phoenix_three, github: "benjaminjacobberg/phoenix_three", only: :dev, runtime: false}
  ]
end
```

Then run:

```bash
mix deps.get
```

## Usage

### Quick Start

Set up Three.js in your Phoenix project with one command:

```bash
mix threejs.setup
```

This will:
1. Download Three.js files to `assets/vendor/three/`
2. Add the import to your `assets/js/app.js`
3. Make THREE available globally for hooks

### Individual Commands

Download Three.js files only:
```bash
mix threejs.download
```

Configure app.js imports only:
```bash
mix threejs.configure
```

### Options

**Version Selection:**
```bash
# Download specific Three.js version
mix threejs.setup --version 0.176.0
```

**Force Overwrite:**
```bash
# Overwrite existing files and imports
mix threejs.setup --force
```

## What Gets Added to Your Project

### Files Downloaded
- `assets/vendor/three/three.module.js` - Main ES6 module
- `assets/vendor/three/three.core.js` - Core library
- `assets/vendor/three/three.webgpu.js` - WebGPU renderer
- `assets/vendor/three/three.webgpu.nodes.js` - WebGPU nodes
- `assets/vendor/three/three.tsl.js` - Three Shading Language

### App.js Modifications

The task adds this import to your `assets/js/app.js`:
```javascript
import * as THREE from "../vendor/three/three.module.js";
```

And this global assignment after your `window.liveSocket = liveSocket` line:
```javascript
// Make THREE.js available globally for hooks
window.THREE = THREE
```

## Using Three.js in LiveView Hooks

After setup, you can use Three.js in your Phoenix LiveView hooks:

```javascript
// assets/js/app.js
let Hooks = {}

Hooks.ThreeScene = {
  mounted() {
    // THREE is available globally
    const scene = new THREE.Scene()
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
    const renderer = new THREE.WebGLRenderer()

    renderer.setSize(this.el.clientWidth, this.el.clientHeight)
    this.el.appendChild(renderer.domElement)

    // Your Three.js code here...
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})
```

In your LiveView template:
```elixir
<div id="three-container" phx-hook="ThreeScene"></div>
```

## Integration with Build Process

Add to your `mix.exs` aliases for automatic setup:

```elixir
defp aliases do
  [
    setup: ["deps.get", "threejs.setup", "assets.setup", "assets.build"],
    "assets.deploy": ["threejs.setup", "assets.deploy"]
  ]
end
```

## Available Three.js Versions

The package downloads from [CDNJS](https://cdnjs.com/libraries/three.js). You can use any version available there:

- Latest: `mix threejs.setup` (currently 0.177.0)
- Specific: `mix threejs.setup --version 0.176.0`
- Legacy: `mix threejs.setup --version 0.150.0`

## Troubleshooting

**"assets/js/app.js not found" error:**
- Make sure you're running the command from your Phoenix project root
- Ensure your Phoenix project has the standard asset structure

**Import conflicts:**
- Use `--force` flag to overwrite existing imports
- Manually check your app.js if imports look incorrect

**Version not found:**
- Check available versions at [CDNJS Three.js](https://cdnjs.com/libraries/three.js)
- Some very new versions might not be available on CDNJS yet

## Links

- [Hex Package](https://hex.pm/packages/phoenix_three)
- [Documentation](https://hexdocs.pm/phoenix_three/)
- [GitHub Repository](https://github.com/benjaminjacobberg/phoenix_three)
- [Three.js Official Site](https://threejs.org)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benjaminjacobberg/phoenix_three.

## License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

- [Three.js](https://threejs.org) - The amazing 3D library
- [CDNJS](https://cdnjs.com) - For hosting the Three.js files
- [Phoenix Framework](https://phoenixframework.org) - The productive web framework
