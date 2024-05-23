[![lego project](https://img.shields.io/badge/powered%20by-lego-blue?logo=github)](https://github.com/melodysdreamj/lego)
[![pub package](https://img.shields.io/pub/v/chrome_style_browser_lego.svg)](https://pub.dartlang.org/packages/chrome_style_browser_lego)

# chrome_style_browser_lego
Chrome Style Browser View Lego

##  Installation
1. open terminal in the lego project root directory, enter the following command for install cli.
   and create a new lego project if you don't have one.
```bash
flutter pub global activate lego_cli
lego create
```
2. in terminal, enter the following command for add lego to project.
```bash
lego add chrome_style_browser_lego
```
3. add the following code to `web/index.html` file.
```html
<head>
    <!-- ... -->
    <script type="application/javascript" src="/assets/packages/flutter_inappwebview_web/assets/web/web_support.js" defer></script>
    <!-- ... -->
</head>
```

## Usage
if you want a change drag area color, 
