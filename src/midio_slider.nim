import midio_ui
import midio_ui_canvas

proc render(): Element = 
  panel:
    rectangle(color = "blue")

startApp(
  render,
  "rootCanvas",
  "nativeContainer"
)
